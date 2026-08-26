# Pinspire — Pexels-powered Pinterest-style Flutter app

Pinspire is a Pinterest-inspired mobile application built with Flutter. The project focuses on recreating the modern Pinterest experience with a clean, responsive UI, smooth animations, image-based content discovery, saving Pins, search, profile management, and notifications.

## 1. Install dependencies

```bash
flutter clean
flutter pub get
```

## 2. Add your Pexels key

The app reads the key from the Dart define `PEXELS_API_KEY`.

### VS Code

Open `.vscode/launch.json` and replace:

```text
PASTE_YOUR_PEXELS_KEY_HERE
```

with your own Pexels API key.

Then select **Pinspire - Pexels** in Run & Debug and press F5.

### Terminal

```bash
flutter run --dart-define=PEXELS_API_KEY=YOUR_PEXELS_KEY
```

Do not commit your real API key to a public Git repository.

## 3. What the live feed does

The Home feed does NOT use Pexels `/curated`, because curated results can be dominated by one visual topic. It requests two different discovery topics per page and combines/shuffles them:

- fashion
- travel
- cars
- food
- nature
- architecture
- technology
- art

Search uses the Pexels `/search` endpoint directly, so typing `car`, `fashion`, `travel`, etc. returns matching images.

## 4. Demo mode

If no API key is supplied, the app intentionally uses demo images. This proves the UI works but search cannot return live Pexels results.

## 5. Android internet permission

For Android debug/release builds, make sure your app has internet permission in:

`android/app/src/main/AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

## Architecture

- Riverpod 3
- GoRouter
- Dio
- CachedNetworkImage
- Shimmer
- Flutter Staggered Grid View
- Feature-first clean structure
- PexelsApi

 ## Features
🏠 Home Feed – Pinterest-style masonry Pin layout
🔍 Search – Search Pins by keywords
📌 Pin Details – View individual Pins
❤️ Save Pins – Save and manage Pins
👤 Profile – Profile information and saved Pins
📥 Inbox – Messages and activity updates
➕ Create – Create new Pins
🌐 Pexels API – Fetch free image content dynamically
⚡ Cached Images – Faster image loading
✨ Shimmer Loading – Smooth loading experience
🎨 Pinterest-inspired UI – Modern cards, rounded corners and animations
📱 Android optimized – Designed for mobile screens