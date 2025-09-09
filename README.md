# Flutter Template

Starter template based on the Very Good Ventures style, updated for:

- Firebase Auth (email/password) behind repositories and Cubit
- go_router for centralized, auth‑aware routing
- FlexColorScheme (M3) with a ThemeController and Settings page
- Google Mobile Ads (adaptive anchored banner)
- Bloc/Cubit state management, feature‑first structure
- i18n with `flutter gen-l10n` (en, es)
- Flavors (development, staging, production)
- Strict .gitignore for secrets and Firebase configs

---

## Getting Started 🚀

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

_\*Template works on iOS and Android by default; other platforms are scaffolded._

---

## Tech Stack

- Routing: `go_router` with auth redirects
- Auth: `firebase_auth` via `AuthRepository` + `AuthCubit`
- Theming: `flex_color_scheme` + `ThemeController` (system/light/dark)
- State: `flutter_bloc`
- Ads: `google_mobile_ads` (adaptive banner widget)
- Env: `flutter_dotenv` (per‑flavor)
- Lint: `very_good_analysis`
- L10n: `flutter_localizations` + gen‑l10n

## Structure

```
lib/
  app/
    router/app_router.dart         # go_router config
    view/app.dart                  # DI + MaterialApp.router
  features/
    splash/view/splash_page.dart
    auth/
      cubit/                       # AuthCubit + state
      view/                        # SignIn UI, AuthGate
    home/view/home_page.dart       # Bottom nav (Home/Account/Settings)
    settings/view/settings_page.dart
  repositories/
    auth_repository.dart           # FirebaseAuth mapping to AuthFailure
    user_repository.dart
  theme/
    app_theme.dart                 # FlexColorScheme
    theme_controller.dart          # Persisted ThemeMode
    theme_controller_provider.dart # InheritedNotifier wrapper
  ads/
    banner_ad_widget.dart          # Adaptive anchored banner
  l10n/
    arb/                           # en/es ARB files
    gen/                           # generated (ignored on commit)
```

---

## Environment & Config

- Copy `.env.example` to per‑flavor files:
  - `.env.development`, `.env.staging`, `.env.production`
- Keys used (examples):
  - `ADMOB_IOS_APP_ID`, `ADMOB_ANDROID_APP_ID`
  - `ADMOB_BANNER_IOS`, `ADMOB_BANNER_ANDROID`
- Env files are already included under `flutter.assets` and loaded in `bootstrap()`.

### Firebase (Auth)

1) Configure once per machine:

```
dart pub global activate flutterfire_cli
flutterfire configure
```

This creates `lib/firebase_options.dart` and platform configs (do not commit:
`google-services.json`, `GoogleService-Info.plist`).

2) iOS

- Minimum iOS: 15.0 (Podfile + Xcode project configured)

3) Android

- App id is set per flavor in Gradle. Place `google-services.json` under the app module if you commit privately; otherwise keep local.

### AdMob

- iOS: `GADApplicationIdentifier` is set in `ios/Runner/Info.plist`.
- Android: application id via Gradle `manifestPlaceholders`.
- Banner unit ids read from env; widget falls back to Google test units.

---

## Routing

- See `lib/app/router/app_router.dart`
  - Routes: `/` (splash), `/auth`, `/home`
  - Redirects based on `AuthCubit.state.status`
- Use `context.go(AppRoutes.home)` and constants from `AppRoutes`.

---

## Theming

- `AppTheme.light/dark()` via FlexColorScheme
- `ThemeController` persists `ThemeMode` (system/light/dark)
- Settings page exposes theme toggle

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ very_good test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:flutter_template/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb` (example)

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb` (example)

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

### Generating Translations

To use the latest translations changes, you will need to generate them:

1. Generate localizations for the current project:

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

Alternatively, run `flutter run` and code generation will take place automatically.

---
## Further Development

1) Add data
- Introduce Firestore and a `ProfileRepository` with DTOs/mappers.
- Add rules + emulator config; avoid committing project configs.

2) Expand routing
- Consider `ShellRoute` for deep‑linkable tabs.
- Add a RouteObserver for analytics.

3) Observability
- Integrate Crashlytics/Analytics with a small logging facade.

4) Testing
- Add golden tests for primary screens (light/dark).
- Add integration smoke test (launch → sign in mock → home).

5) CI
- Add GitHub Actions to run analyze + test on PRs.

6) Theming
- Add ThemeExtensions for spacing/semantic colors; keep widgets free of magic numbers.

---

## Git Hygiene / Secrets

This repo ignores platform Firebase configs and keystores. Keep these local per developer or inject via CI:

- Android: `**/android/**/google-services.json`
- iOS/macOS: `**/(ios|macos)/**/GoogleService-Info*.plist`
- FlutterFire app id file: `**/firebase_app_id_file.json`

Env files:
- `.env.*` are ignored by default; `.env.example` and placeholder envs are tracked. Populate your own `.env.development` locally.

[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[coverage_badge]: coverage_badge.svg
create policy "Read own" on public.todo
  for select using (auth.uid() = user_id);
```

2) Query from Flutter:
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

final db = Supabase.instance.client;
final rows = await db.from('todo').select().eq('user_id', db.auth.currentUser!.id);
```

3) Suggested organization:
- Create a small data layer per feature (e.g., `lib/todo/data/todo_api.dart`) to wrap Supabase queries.
- Keep auth calls in `lib/auth/` and database calls per feature.



[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
