# BookNest – Online Book Library

BookNest is a modern, responsive Flutter digital book library application with an editorial aesthetic. Users can explore a curated catalog of books, search and filter by genre, inspect book details, save favourites and bookmarks, and read multi-chapter sample editions with persistent reading progress.

> **Note:** BookNest is a **100% frontend-only application** with no custom backend or external database. It integrates **Google Books API**, **Open Library API**, and **Gutendex (Project Gutenberg)** directly from the client, keeps a **28-book local sample catalog** as an offline fallback, and persists user preferences (favourites, bookmarks, reading progress, theme, and reader font size) locally on the browser/device using `SharedPreferences`.

---

## Live Website

- **GitHub Pages:** https://Shanmukh-666.github.io/booknest/

---

## External Book API Integrations

| API | Role | Documentation & Endpoint |
|---|---|---|
| **Google Books API** | Primary catalog search, descriptions, covers, categories, page counts, and preview links | [Docs](https://developers.google.com/books/docs/v1/using) • `https://www.googleapis.com/books/v1/volumes` |
| **Open Library API** | Supplementary search, metadata, edition years, and cover images (deduplicated against Google Books) | [Docs](https://openlibrary.org/developers/api) • `https://openlibrary.org/search.json` |
| **Gutendex / Project Gutenberg** | Free public-domain books, ebook formats, in-app text reading, and official reading links | [Docs](https://gutendex.com/) • `https://gutendex.com/books/` |

---

## Features

- **Home Dashboard:** BookNest branding, search bar, featured book showcase, Continue Reading shelf, category quick-chips, Trending, Popular, and Recently Added carousels.
- **Explore Catalog:** Live search by title, author, or category; genre filtering across 11 categories; sorting by popularity, rating, or title (A–Z); empty state with quick filter reset.
- **Book Details:** Editorial layout with cover artwork, rating, page count, publication year, description, Favourite & Bookmark toggles, and clickable chapter index.
- **Sample Book Reader:** Distraction-free multi-chapter reader with Previous/Next Chapter navigation, reading progress indicator, adjustable font size, and Light/Dark reader themes.
- **My Library:** Personal bookshelf organized into *Reading*, *Favourites*, *Bookmarked*, and *Completed* tabs with persistent progress.
- **Categories:** Dedicated browsing view for all 11 genres (*Fiction, Science Fiction, Technology, Programming, Business, History, Biography, Self Development, Psychology, Mystery, Education*).
- **Reader Profile:** Local demo profile displaying reading statistics and recent reading activity.
- **Settings:** Persistent Light/Dark app theme, default reader preferences with live typography preview, and application info.
- **Responsive Adaptive UI:** Persistent sidebar on Desktop (`>= 1024px`), compact navigation rail on Tablet (`600px–1023px`), and compact header + bottom navigation bar on Mobile (`< 600px`).

---

## Technology Stack

- **Framework:** Flutter (Material 3)
- **Language:** Dart
- **State Management:** Provider (`provider`)
- **Local Persistence:** `shared_preferences`
- **Typography:** `google_fonts` (Playfair Display, Plus Jakarta Sans, Lora)
- **CI/CD & Hosting:** GitHub Actions + GitHub Pages

---

## Project Architecture & Folder Structure

```text
lib/
├── main.dart                         # App bootstrap & SharedPreferences init
├── app.dart                          # Root MaterialApp & MultiProvider setup
├── data/
│   ├── books_data.dart               # 28 curated sample books with 3 chapters each
│   └── categories_data.dart          # 11 genre definitions with visual identity
├── models/
│   ├── book.dart                     # Book & BookChapter models
│   └── category.dart                 # BookCategory model
├── providers/
│   ├── book_provider.dart            # Search, category filter, and sorting state
│   ├── reading_provider.dart         # Favourites, bookmarks, and reading progress
│   └── theme_provider.dart           # App theme and reader typography settings
├── services/
│   └── local_storage_service.dart    # SharedPreferences persistence wrapper
├── theme/
│   ├── app_colors.dart               # Editorial Navy, Cream, and Amber palette
│   ├── app_text_styles.dart          # Typography scale
│   └── app_theme.dart                # Light and Dark Material 3 ThemeData
├── widgets/
│   ├── app_shell.dart                # Adaptive Desktop/Tablet/Mobile navigation
│   ├── book_card.dart                # Animated reusable book card
│   ├── book_cover.dart               # Editorial generated cover with asset fallback
│   ├── category_card.dart            # Category tile with icon and book count
│   ├── featured_book_banner.dart     # Hero featured book showcase
│   └── search_bar_widget.dart        # Search input with clear action
└── screens/
    ├── home/home_screen.dart
    ├── explore/explore_screen.dart
    ├── book_details/book_details_screen.dart
    ├── reader/reader_screen.dart
    ├── library/library_screen.dart
    ├── categories/categories_screen.dart
    ├── profile/profile_screen.dart
    └── settings/settings_screen.dart
```

---

## Installation & Running Locally

### Prerequisites
- Flutter SDK (`3.x` stable) with Web/Android support enabled

### Run Locally
```bash
git clone https://github.com/Shanmukh-666/booknest.git
cd booknest
flutter pub get
flutter run -d chrome
```

### Run Quality Checks
```bash
flutter analyze
flutter test
```

### Build Flutter Web (Release)
```bash
flutter build web --release --base-href "/booknest/"
```

---

## GitHub Pages Deployment

Deployment is automated via [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml):
1. Every push to `main` triggers the workflow.
2. GitHub Actions runs `flutter pub get`, `flutter analyze`, and `flutter test`.
3. It builds the web bundle in release mode with `--base-href "/${{ github.event.repository.name }}/"`.
4. The `build/web` artifact is uploaded and deployed to GitHub Pages via `actions/deploy-pages@v4`.

---

## Screenshots

*Desktop, Tablet, and Mobile views can be previewed directly on the [live GitHub Pages site](https://Shanmukh-666.github.io/booknest/).*

---

## Limitations & Browser CORS Notes

- **Frontend-only:** No cloud sync, user accounts, or custom backend server; user data is stored per browser/device in `SharedPreferences`.
- **Google Books Rate Limits:** Unauthenticated requests to `googleapis.com/books/v1/volumes` can occasionally return HTTP `429 Too Many Requests` on shared IPs. BookNest caches responses and automatically falls back to Open Library and the offline shelf.
- **Project Gutenberg CORS:** While `gutendex.com` metadata and `covers.openlibrary.org` images support browser access, direct `.txt` downloads from `www.gutenberg.org` may be blocked by browser CORS or return `503` under load. When direct text fetch is unavailable in the browser, BookNest provides legitimate external reading links (`text/html`, `EPUB`, and Project Gutenberg book pages).
- **Copyrighted Books:** BookNest never fabricates chapters for copyrighted books; Google Books and Open Library entries clearly distinguish official preview/info links from full public-domain texts.
