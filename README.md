# Food Munch: Customer App

The customer-facing app. Browse stores and items, order, pay, track deliveries live and chat with stores and riders.

| | |
|---|---|
| Package | `com.foodmunch.customer` |
| Version | 1.0.0+1 |
| Flutter / Dart | Flutter 3.41+ (stable), Dart `^3.10.0` |
| Backend | `https://foodmunch.com` |

## Features

- **Auth:** phone/OTP, Google, Facebook and Apple sign-in, Firebase Auth
- **Shopping:** home feed, banners, categories, brands, search (with voice search), flash sales, offers, coupons
- **Modules:** food, grocery, pharmacy, e-commerce, parcel, rental
- **Cart and checkout:** addresses, online payment, wallet, loyalty points, refer and earn
- **Orders:** live tracking on Google Maps, order history, reviews, favourites
- **Communication:** in-app chat, push notifications, support
- **Other:** multi-language (EN, AR, BN, ES), deep links, local database (Drift), PDF and QR support

## Folder structure

```
lib/
├── api/          # API client and endpoints
├── common/       # Shared widgets and models
├── features/     # One folder per feature (controllers / domain / screens / widgets)
│   ├── address, auth, cart, checkout, home, item, order, store
│   ├── wallet, loyalty, refer_and_earn, chat, notification
│   └── ...
├── helper/       # Routing, dependency injection, utilities
├── interfaces/   # Repository interfaces
├── local/        # Local database (Drift)
├── theme/        # Light and dark themes
├── util/         # Constants, dimensions, styles
└── main.dart
```

## Run and build

```bash
flutter pub get
flutter run
flutter build apk --release --split-per-abi
```

If you change Drift tables, regenerate code with `dart run build_runner build --delete-conflicting-outputs`.

## Configuration

- App name and backend URL: `lib/util/app_constants.dart`
- Firebase: `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`
- Google Maps key: `AndroidManifest.xml` (`com.google.android.geo.API_KEY`)
- Signing: see the [root README](../README.md#release-signing)

## Contributing notes

Coding conventions (class widgets instead of builder functions, constructor formatting, folder rules) are in [`CLAUDE.md`](CLAUDE.md).

## CI

Built automatically as `customer-apk` by the [root workflow](../.github/workflows/build-apk.yml).