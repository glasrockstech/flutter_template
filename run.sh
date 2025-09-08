# flutter pub upgrade
flutter clean
flutter run --flavor development --target lib/main_development.dart --dart-define-from-file=.env.development
# flutter
# flutter run --flavor production --target lib/main_production.dart --dart-define-from-file=.env.production