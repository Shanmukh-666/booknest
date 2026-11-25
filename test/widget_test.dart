import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:booknest/app.dart';
import 'package:booknest/data/books_data.dart';
import 'package:booknest/data/categories_data.dart';
import 'package:booknest/models/book.dart';
import 'package:booknest/services/api/api_client.dart';
import 'package:booknest/services/api/book_repository.dart';
import 'package:booknest/services/api/google_books_service.dart';
import 'package:booknest/services/api/gutendex_service.dart';
import 'package:booknest/services/api/open_library_service.dart';
import 'package:booknest/services/local_storage_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('Catalog contains 28 offline sample books and all 11 categories', () {
    expect(kBooks.length, greaterThanOrEqualTo(25));
    expect(kCategories.length, equals(11));
    for (final book in kBooks) {
      expect(book.chapters, isNotEmpty);
    }
  });

  test('BookRepository parses and deduplicates Google Books, Open Library, and Gutendex',
      () async {
    final mockClient = MockClient((request) async {
      final url = request.url.toString();
      if (url.contains('googleapis.com/books')) {
        return http.Response(
          jsonEncode({
            'totalItems': 1,
            'items': [
              {
                'id': 'abc123',
                'volumeInfo': {
                  'title': 'Clean Architecture',
                  'authors': ['Robert C. Martin'],
                  'description': 'Software structure guide.',
                  'categories': ['Programming'],
                  'pageCount': 432,
                  'publishedDate': '2017-09-20',
                  'publisher': 'Pearson',
                  'averageRating': 4.8,
                  'previewLink': 'http://books.google.com/preview',
                },
                'accessInfo': {'publicDomain': false},
              }
            ],
          }),
          200,
        );
      }
      if (url.contains('openlibrary.org/search.json')) {
        return http.Response(
          jsonEncode({
            'numFound': 2,
            'docs': [
              {
                'key': '/works/OL1W',
                'title': 'Clean Architecture',
                'author_name': ['Robert C. Martin'],
                'first_publish_year': 2017,
              },
              {
                'key': '/works/OL2W',
                'title': 'The Pragmatic Programmer',
                'author_name': ['Andrew Hunt'],
                'first_publish_year': 1999,
                'cover_i': 8225261,
              },
            ],
          }),
          200,
        );
      }
      if (url.contains('gutendex.com/books')) {
        return http.Response(
          jsonEncode({
            'next': null,
            'results': [
              {
                'id': 1342,
                'title': 'Pride and Prejudice',
                'authors': [
                  {'name': 'Austen, Jane'}
                ],
                'subjects': ['Fiction'],
                'formats': {
                  'text/plain; charset=utf-8':
                      'https://www.gutenberg.org/ebooks/1342.txt.utf-8',
                  'text/html': 'https://www.gutenberg.org/ebooks/1342.html.images',
                },
                'download_count': 50000,
              }
            ],
          }),
          200,
        );
      }
      return http.Response('Not found', 404);
    });

    final apiClient = ApiClient(client: mockClient);
    final repo = BookRepository(
      googleBooks: GoogleBooksService(apiClient),
      openLibrary: OpenLibraryService(apiClient),
      gutendex: GutendexService(apiClient),
    );

    final combined = await repo.searchCombined(query: 'architecture');
    // 'Clean Architecture' from Open Library should be deduplicated against Google Books
    expect(combined.books.length, equals(2));
    expect(combined.books[0].source, equals(BookSource.googleBooks));
    expect(combined.books[0].previewLink, startsWith('https://'));
    expect(combined.books[1].source, equals(BookSource.openLibrary));
    expect(
      combined.books[1].coverImageUrl,
      equals('https://covers.openlibrary.org/b/id/8225261-L.jpg'),
    );

    final pd = await repo.fetchPublicDomain(query: 'pride');
    expect(pd.books.length, equals(1));
    expect(pd.books.first.source, equals(BookSource.gutendex));
    expect(pd.books.first.isPublicDomain, isTrue);
  });

  testWidgets('Desktop layout (1440x900) renders without overflow and navigates',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final storage = await LocalStorageService.init();
    await tester.pumpWidget(BookNestApp(storageService: storage));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Welcome back, Reader'), findsOneWidget);
    expect(find.text('The Quiet Cartographer'), findsWidgets);

    await tester.tap(find.text('Explore'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Explore Catalog'), findsOneWidget);

    await tester.tap(find.text('Offline Shelf'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.enterText(find.byType(TextField).first, 'Orbital Meridian');
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Showing 1 book (Offline Shelf)'), findsOneWidget);

    await tester.tap(find.text('Orbital Meridian').last);
    await tester.pumpAndSettle();
    expect(find.text('Book Details'), findsOneWidget);

    await tester.tap(find.text('Read Now'));
    await tester.pumpAndSettle();
    expect(find.text('Section 1 of 3'), findsOneWidget);
  });

  testWidgets('Tablet layout (768x1024) renders NavigationRail without overflow',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(768, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final storage = await LocalStorageService.init();
    await tester.pumpWidget(BookNestApp(storageService: storage));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(NavigationRail), findsOneWidget);

    await tester.tap(find.text('Categories'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Fiction'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Reader Font Size'), findsOneWidget);
  });

  testWidgets('Mobile layout (390x844) renders BottomNav without overflow',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final storage = await LocalStorageService.init();
    await tester.pumpWidget(BookNestApp(storageService: storage));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('BookNest'), findsOneWidget);

    await tester.tap(find.text('Library'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('My Library'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Reader Profile'), findsOneWidget);
  });
}
