# Pinspire — Pexels-powered Pinterest-style Flutter app

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
