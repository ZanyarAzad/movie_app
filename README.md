# 🎬 TMDB Movie Application

[![Flutter](https://img.shields.io/badge/Flutter-3.32%2B-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.8%2B-0175C2?logo=dart)](https://dart.dev)
[![Null Safety](https://img.shields.io/badge/Null%20Safety-100%25-brightgreen)](https://dart.dev/null-safety)
[![State Management](https://img.shields.io/badge/State-Provider-blue)](https://pub.dev/packages/provider)
[![API](https://img.shields.io/badge/TMDB-v3-01b4e4?logo=themoviedatabase)](https://developer.themoviedb.org/reference/intro/getting-started)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A production-ready, feature-complete Flutter movie application powered by the **TMDB (The Movie Database) API**. Built with clean architecture, strict null safety, reactive state management using **Provider**, offline persistence with `shared_preferences`, dynamic theme switching (Dark, Light, System), and comprehensive error and connectivity handling.

---

## 📸 Key Application Screens & Features

| 1. Trending & Popular (Tab 1) | 2. Real-Time Search (Tab 2) | 3. Offline Watchlist (Tab 3) | 4. Movie Details & Cast |
| :---: | :---: | :---: | :---: |
| Daily/Weekly feeds, featured hero banner, infinite scroll pagination | 500ms debounced search, clear actions, empty/error state handling | Local JSON storage with `shared_preferences`, swipe-to-remove, undo | Hero animations, runtime, budget/revenue, cast carousel, trailers |

### 🌟 Screen-by-Screen Breakdown

#### 1. Trending Movies Feed (`TrendingScreen`)
- **Daily & Weekly Switching**: Seamless animated pill toggle between `/trending/movie/day` and `/trending/movie/week`.
- **Featured Hero Banner**: Prominent top banner with backdrop image, poster thumbnail overlap, rating badge, and genre chips.
- **Infinite Scrolling**: Powered by `ListView.builder` with automatic threshold detection (`300px` before list bottom).
- **Pull-to-Refresh**: Native `RefreshIndicator` resetting pagination and updating cache.
- **Robust UI States**: Shimmer skeleton placeholder ([movie_shimmer_list.dart](lib/widgets/states/movie_shimmer_list.dart)), empty state, and network error state with retry.

#### 2. Real-Time Movie Search (`SearchScreen`)
- **Debounced Input (500ms)**: Optimizes network usage and prevents rate limiting by debouncing keystrokes.
- **Clear Action**: Instant reset of search query and results.
- **Infinite Scroll Results**: Paginated search results rendered with `ListView.builder`.
- **Controller Lifecycle**: Explicit initialization and disposal of `TextEditingController` and `ScrollController`.
- **States Handled**:
  - *Initial / Idle*: Helpful exploration prompt.
  - *Loading*: Animated shimmer list.
  - *Empty*: "No movies found for '{query}'" with friendly suggestion.
  - *Error*: User-friendly error message with retry button.

#### 3. Offline Watchlist (`WatchlistScreen`)
- **100% Offline Resilience**: Powered by `shared_preferences` local JSON serialization; saved titles remain accessible without any network connection.
- **Swipe-to-Dismiss**: Swipe left on any item to delete with red feedback background.
- **SnackBar Undo Action**: Reversible deletion restoring movie position and state instantly.
- **Empty State**: Friendly illustration and a direct "Explore Trending" navigation button.

#### 4. Movie Detail Screen (`MovieDetailScreen`)
- **Rich Movie Details**: High-res backdrop with gradient shadow overlay, poster hero animation, title, tagline, release date, formatted runtime (`2h 28m`), rating badge, and story overview.
- **Box Office Stats**: Formatted budget and revenue using compact currency formatters (`$160.0M`, `$839.0M`).
- **Top Cast Carousel**: Horizontal `ListView.builder` displaying actor avatars, real names, and character roles.
- **Official Trailer Launcher**: Integrated "Play Trailer" action launching official YouTube trailers via `url_launcher`.
- **Watchlist Toggle**: Reactive bookmark action with instant local persistence.
- **Hardware Notch & Cutout Handling**: Custom floating back button safely placed within `SafeArea` padding.
- **Controller Lifecycle**: `ScrollController` initialized in `initState()` and cleaned up in `dispose()`.

#### 5. Appearance & Theming
- **Dynamic Theme Mode**: Instant switching between **Light Theme**, **Dark Theme**, and **System Default**.
- **User Preference Persistence**: Theme selection stored in `SharedPreferences` across app restarts.
- **Accessible Everywhere**: Palette icon in the top AppBar opens the theme selection dialog on any screen.

#### 6. Live Connectivity Monitoring
- Live status updates via `connectivity_plus` displaying an [OfflineBanner](lib/widgets/misc/offline_banner.dart) when the device goes offline.

---

## 🏛️ Architecture & State Management

This application follows a **Feature-First Clean Architecture** with **Provider** (`ChangeNotifier` + `MultiProvider`):

```
                       ┌─────────────────────────┐
                       │     Presentation UI     │
                       │ (Screens, Cards, Tiles) │
                       └────────────┬────────────┘
                                    │ consumes / dispatches
                                    ▼
                       ┌─────────────────────────┐
                       │    State Providers      │
                       │ (ChangeNotifier Models) │
                       └────────────┬────────────┘
                                    │ calls
                                    ▼
       ┌────────────────────────────┴───────────────────────────┐
       │                                                        │
       ▼                                                        ▼
┌──────────────┐                                         ┌──────────────┐
│  ApiService  │ (TMDB Dio HTTP Client + Interceptors)   │StorageService│ (SharedPreferences)
└──────┬───────┘                                         └──────┬───────┘
       │ Network JSON                                           │ Local JSON
       ▼                                                        ▼
┌──────────────┐                                         ┌──────────────┐
│ Data Models  │ (MovieModel, Detail, Cast, Video)       │ Local Cache  │ (Watchlist & Theme)
└──────────────┘                                         └──────────────┘
```

### Core Providers:
| Provider | File | Responsibility |
|---|---|---|
| `TrendingMoviesProvider` | `lib/features/trending/controllers/` | Trending feed, daily/weekly switch, pagination, pull-to-refresh |
| `SearchMoviesProvider` | `lib/features/search/controllers/` | 500ms debounced search, query results pagination, state transitions |
| `WatchlistProvider` | `lib/core/providers/` | Offline watchlist state, local add/remove/toggle, JSON synchronization |
| `ThemeProvider` | `lib/core/providers/` | Dynamic runtime `ThemeMode` (System, Light, Dark) and storage persistence |
| `ConnectivityProvider` | `lib/core/providers/` | Live connectivity streaming (`connectivity_plus`) |
| `MovieDetailProvider` | `lib/features/movie_detail/controllers/` | Movie details, credits, and videos via `append_to_response` |

---

## 📂 Project Structure

```text
lib/
├── core/                                 # Core application infrastructure
│   ├── constants/                        # API endpoints, image URLs, storage keys
│   │   ├── api_constants.dart
│   │   └── app_constants.dart
│   ├── errors/                           # Structured API exceptions & error handling
│   │   └── api_exception.dart
│   ├── providers/                        # Application-wide state providers
│   │   ├── connectivity_provider.dart
│   │   ├── theme_provider.dart
│   │   └── watchlist_provider.dart
│   ├── router/                           # Declarative GoRouter configuration
│   │   └── app_router.dart
│   └── services/                         # Singletons & service layer
│       ├── api_service.dart              # TMDB Dio HTTP client with interceptors
│       ├── genre_service.dart            # In-memory genre dictionary & cache
│       └── storage_service.dart          # SharedPreferences persistence
│
├── data/                                 # Data layer & model serialization
│   └── models/
│       ├── cast_model.dart               # Cast & crew models
│       ├── genre_model.dart              # TMDB genre representation
│       ├── movie_detail_model.dart       # Extended detail model (credits, videos)
│       ├── movie_model.dart              # Core Movie entity
│       ├── movie_response.dart           # Paginated API response wrapper
│       └── video_model.dart              # YouTube trailer & video model
│
├── features/                             # Feature-based modular presentation
│   ├── movie_detail/                     # Movie detail screen & providers
│   │   ├── controllers/movie_detail_provider.dart
│   │   └── views/movie_detail_screen.dart
│   ├── search/                           # Search screen & debounced controller
│   │   ├── controllers/search_movies_provider.dart
│   │   └── views/search_screen.dart
│   ├── shell/                            # Bottom NavigationBar shell
│   │   └── views/main_shell_screen.dart
│   ├── trending/                         # Trending feed & banner
│   │   ├── controllers/trending_movies_provider.dart
│   │   └── views/trending_screen.dart
│   └── watchlist/                        # Offline watchlist & swipe-to-dismiss
│       └── views/watchlist_screen.dart
│
├── utilities/                            # Design system, extensions, and utilities
│   ├── extention.dart                    # BuildContext & string helper extensions
│   ├── themes/                           # Design tokens & Material 3 theme configurations
│   │   ├── app_colors.dart
│   │   ├── app_radii.dart
│   │   ├── app_spacing.dart
│   │   ├── app_text_styles.dart
│   │   └── theme.dart
│   └── util.dart                         # Currency formatters, date formatters, URL launcher
│
├── widgets/                              # Modular reusable atomic UI widgets
│   ├── buttons/                          # WatchlistToggleButton
│   ├── cards/                            # MovieListTile, MovieCard, TrendingBannerCard, CastCard
│   ├── dialogs/                          # ThemeSelectionDialog
│   ├── inputs/                           # AppSearchBar
│   ├── layout/                           # CustomAppBar, SafeScaffold
│   ├── media/                            # CachedMoviePoster, CachedBackdropImage, CastAvatar
│   ├── misc/                             # RatingBadge, GenreChip, OfflineBanner
│   └── states/                           # LoadingSpinnerView, MovieShimmerList, EmptyStateView, ErrorStateView
│
└── main.dart                             # App entrypoint, services init, and root MultiProvider
```

---

## 🛠️ TMDB API Integration

The app connects to the **The Movie Database (TMDB) API v3**:
- **Base URL**: `https://api.themoviedb.org/3`
- **Image Base URL**: `https://image.tmdb.org/t/p/` (`w185`, `w342`, `w500`, `w780`, `w1280`, `original`)
- **Endpoints Used**:
  - `GET /trending/movie/{time_window}` (Trending movies feed)
  - `GET /search/movie` (Debounced query search)
  - `GET /movie/{id}?append_to_response=credits,videos` (Details, cast & YouTube trailers)
  - `GET /genre/movie/list` (Genre metadata mapped synchronously)

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: `>=3.32.0`
- **Dart SDK**: `>=3.8.0`

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
The application includes a built-in TMDB API Bearer token for immediate local testing:

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

### 5. Run Static Code Analysis
```bash
flutter analyze
```

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
