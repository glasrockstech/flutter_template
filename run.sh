# flutter pub upgrade
flutter clean
flutter run --flavor development --target lib/main_development.dart --dart-define-from-file=.env.development
# flutter run --flavor staging --target lib/main_staging.dart --dart-define-from-file=.env.staging
# flutter run --flavor production --target lib/main_production.dart --dart-define-from-file=.env.production