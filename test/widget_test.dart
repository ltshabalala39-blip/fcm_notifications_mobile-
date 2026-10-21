import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fcm_notifications_mobile/main.dart'; // Ensure this matches your project name

void main() {
  testWidgets('TokenMonitor displays default loading state', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TokenMonitor(fcmToken: null),
        ),
      ),
    );

    expect(find.text('FCM Token:'), findsOneWidget);
    expect(find.text('Waiting for token...'), findsOneWidget);
  });
}