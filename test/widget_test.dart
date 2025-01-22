import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shopeasy/main.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(MyApp()); // Убедитесь, что здесь нет 'const'

    // Verify the app starts with the login screen.
    expect(find.text('Login'), findsOneWidget);
  });
}
