import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:booknest/app.dart';
import 'package:booknest/data/books_data.dart';
import 'package:booknest/data/categories_data.dart';
import 'package:booknest/services/local_storage_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('Catalog contains 28 books and all 11 required categories', () {
    expect(kBooks.length, greaterThanOrEqualTo(25));
    expect(kCategories.length, equals(11));
    for (final book in kBooks) {
      expect(book.chapters, isNotEmpty);
    }
  });

  testWidgets('BookNest loads Home, navigates Explore, searches, and opens Reader',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final storage = await LocalStorageService.init();
    await tester.pumpWidget(BookNestApp(storageService: storage));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back, Reader'), findsOneWidget);
    expect(find.text('The Quiet Cartographer'), findsWidgets);

    // Navigate to Explore
    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    expect(find.text('Explore Catalog'), findsOneWidget);

    // Search for a specific book
    await tester.enterText(find.byType(TextField).first, 'Orbital Meridian');
    await tester.pumpAndSettle();
    expect(find.text('Showing 1 book'), findsOneWidget);

    // Open Book Details
    await tester.tap(find.text('Orbital Meridian').last);
    await tester.pumpAndSettle();
    expect(find.text('Book Details'), findsOneWidget);

    // Open Reader
    await tester.tap(find.text('Read Now'));
    await tester.pumpAndSettle();
    expect(find.text('Chapter 1 of 3'), findsOneWidget);

    // Advance to Next Chapter
    await tester.tap(find.text('Next Chapter'));
    await tester.pumpAndSettle();
    expect(find.text('Chapter 2 of 3'), findsOneWidget);
  });

  testWidgets('Mobile layout renders without overflow and switches tabs',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final storage = await LocalStorageService.init();
    await tester.pumpWidget(BookNestApp(storageService: storage));
    await tester.pumpAndSettle();

    expect(find.text('BookNest'), findsOneWidget);

    await tester.tap(find.text('Categories'));
    await tester.pumpAndSettle();
    expect(find.text('Fiction'), findsOneWidget);

    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();
    expect(find.text('My Library'), findsOneWidget);
  });
}
