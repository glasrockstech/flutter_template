// Ignore for testing purposes
// ignore_for_file: prefer_const_constructors

import 'package:flutter_template/app/app.dart';
import 'package:flutter_template/features/splash/view/splash_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('renders SplashPage', (tester) async {
      await tester.pumpWidget(App());
      expect(find.byType(SplashPage), findsOneWidget);
    });
  });
}
