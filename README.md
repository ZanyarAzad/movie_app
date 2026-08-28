# TMDB Movie Application

A production-grade, 3-screen Flutter application powered by the **TMDB API** that allows users to browse trending movies, search for titles, and manage an offline-persistent watchlist with dynamic Light, Dark, and System theme switching.

---

## 📱 Features

- **Trending Movies Screen (Tab 1)**:
  - Daily & weekly trending movies with pull-to-refresh.
  - Featured hero banner with backdrop, poster thumbnail, and rating badge.
  - Infinite scroll pagination (`ListView.builder`).
  - Shimmer loading skeletons, empty states, and network error handling with retry.

- **Search Screen (Tab 2)**:
  - Debounced real-time movie search (500ms debounce interval).
  - Clear button and keyboard actions.
  - Dynamic results list using `ListView.builder` with pagination.
  - Empty search state, no-results state, and error state handling.

- **Offline Watchlist Screen (Tab 3)**:
  - Local offline persistence powered by `shared_preferences`.
  - Saved titles remain 100% accessible when the device is completely offline.
  - Swipe-to-dismiss deletion with undo action.

- **Movie Detail Screen**:
  - Full lifecycle controller management (`initState` & `dispose` for `ScrollController`).
  - Hardware notch/cutout safety with adaptive `SafeArea` back button.
  - Hero animations for poster thumbnails.
  - Rich metadata: Release date, runtime (`2h 28m`), rating, budget, revenue, and tagline.
  - Horizontal `ListView.builder` for Top Cast avatars and character names.
  - Integrated YouTube trailer player via `url_launcher`.
  - Watchlist bookmark toggle button with instant persistence.

- **Dynamic Theme Engine**:
  - Supports **Light Theme**, **Dark Theme**, and **System Default**.
  - Persisted user preference across app restarts.
  - Accessible via the palette icon in the top App Bar.

- **Connectivity Awareness**:
  - Live network monitoring via `connectivity_plus` displaying an offline banner when disconnected.

---

## 🏛️ State Management Architecture

This application utilizes the **Provider Pattern** (`ChangeNotifier` + `MultiProvider`) following a **Feature-First Architecture**:

### Why Provider?
1. **Clean Separation of Concerns**: Decouples UI rendering from business logic, network requests, and persistence.
2. **Deterministic State Lifecycle**: Explicit state machines (`initial`, `loading`, `loaded`, `empty`, `error`) for bulletproof UI state rendering.
3. **High Performance & Granular Rebuilds**: Uses `context.watch()`, `context.read()`, and `context.select()` to rebuild only the widgets that depend on updated state slices.
4. **Testability**: Facilitates dependency injection, unit testing, and mock integration without complex boilerplate.

### Core Providers:
- **`TrendingMoviesProvider`**: Manages trending & popular movies feed, time window selection, pagination, and refresh.
- **`SearchMoviesProvider`**: Handles search query debouncing, result pagination, and empty result handling.
- **`WatchlistProvider`**: Manages local reactive watchlist state and synchronization with `StorageService`.
- **`ThemeProvider`**: Manages runtime `ThemeMode` selection and user preference persistence.
- **`ConnectivityProvider`**: Monitors network connectivity state in real time.
- **`MovieDetailProvider`**: Fetches detailed movie metadata, credits, and trailer videos.

---

## 📂 Project Directory Structure

```text
lib/
├── core/                           # Application core infrastructure
│   ├── constants/                  # API endpoints, image URLs, storage keys
│   │   ├── api_constants.dart
│   │   └── app_constants.dart
│   ├── errors/                     # Structured API exceptions & error handling
│   │   └── api_exception.dart
│   ├── providers/                  # Application-wide global providers
│   │   ├── connectivity_provider.dart
│   │   ├── theme_provider.dart
│   │   └── watchlist_provider.dart
│   ├── router/                     # Declarative GoRouter navigation
│   │   └── app_router.dart
│   └── services/                   # Singletons & external integrations
│       ├── api_service.dart        # TMDB Dio HTTP client with interceptors
│       ├── genre_service.dart      # In-memory genre dictionary & cache
│       └── storage_service.dart    # SharedPreferences local storage
│
├── data/                           # Data models & serialization
│   └── models/
│       ├── cast_model.dart
│       ├── genre_model.dart
│       ├── movie_detail_model.dart
│       ├── movie_model.dart
│       ├── movie_response.dart
│       └── video_model.dart
│
├── features/                       # Feature-based modular code
│   ├── movie_detail/               # Detail screen & cast/trailer widgets
│   ├── search/                     # Search screen & debounced provider
│   ├── shell/                      # Bottom NavigationBar shell
│   ├── trending/                   # Trending feed & banner
│   └── watchlist/                  # Offline watchlist & swipe-to-dismiss
│
├── utilities/                      # Design tokens, extensions, and helper tools
│   ├── extention.dart              # BuildContext extensions
│   ├── themes/                     # Design tokens & dynamic Theme engine
│   │   ├── app_colors.dart
│   │   ├── app_radii.dart
│   │   ├── app_spacing.dart
│   │   ├── app_text_styles.dart
│   │   └── theme.dart
│   └── util.dart                   # Currency, date, and safe URL launcher helpers
│
├── widgets/                        # Modular reusable atomic UI design system
│   ├── buttons/                    # WatchlistToggleButton
│   ├── cards/                      # MovieListTile, MovieCard, TrendingBannerCard, CastCard
│   ├── dialogs/                    # ThemeSelectionDialog
│   ├── inputs/                     # AppSearchBar
│   ├── layout/                     # CustomAppBar, SafeScaffold
│   ├── media/                      # CachedMoviePoster, CachedBackdropImage, CastAvatar
│   ├── misc/                       # RatingBadge, GenreChip, OfflineBanner
│   └── states/                     # LoadingSpinnerView, MovieShimmerList, EmptyStateView, ErrorStateView
│
└── main.dart                       # App initialization & root MultiProvider binding
```

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: `3.32.0` or higher
- **Dart SDK**: `3.8.0` or higher

### 1. Clone the Repository
```bash
git clone https://github.com/ZanyarAzad/movie_app.git
cd movie_app
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run the Application
The application includes a working default TMDB development token. You can run the app directly:

```bash
flutter run
```

To run with your own custom TMDB API Read Access Token:
```bash
flutter run --dart-define=TMDB_API_TOKEN="YOUR_TMDB_READ_ACCESS_TOKEN"
```

### 4. Run Unit & Widget Tests
```bash
flutter test
```

### 5. Run Static Analysis
```bash
flutter analyze
```

---

## 📋 Requirements Compliance Matrix

| # | Requirement | Implementation Details |
|---|---|---|
| 1 | **Null Safety** | Full Dart null safety enabled across 100% of models, services, and widgets. |
| 2 | **ListView.builder** | Used in `TrendingScreen`, `SearchScreen`, `WatchlistScreen`, and the cast carousel in `MovieDetailScreen`. |
| 3 | **Controller Lifecycle** | Proper initialization and disposal of all `ScrollController` and `TextEditingController` instances. |
| 4 | **Hardware Notches / Cutouts** | Handled with `SafeArea` across screens and notch-safe back buttons. |
| 5 | **UI States** | Explicit handling of **Loading** (shimmer), **Empty** (`EmptyStateView`), and **Network Error** (`ErrorStateView` with retry). |
| 6 | **README.md** | Complete run instructions and state management rationale provided. |
| 7 | **Version Control** | Clean, modular commits on public GitHub repository. |
| 8 | **Flutter 3.32+ & Dart 3.8+** | Compatible and verified with Flutter 3.44+ and Dart 3.12+. |
| 9 | **Code Formatting & Linting** | Formatted code with `analysis_options.yaml` enforcing strict linter rules (**0 analyzer issues**). |
| 10 | **Offline Watchlist** | Persisted using `shared_preferences` for 100% offline availability. |
| 11 | **Dark, Light & System Theme** | Dynamic theme engine with live user switching dialog and persistence. |
