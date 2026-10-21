# fcm_notifications_mobile

WTC-AGHNQZ2B

# Firebase Cloud Messaging App (Track 2)

This is the Track 2 submission for the Flutter & Dart mobile development elective. It demonstrates the integration of a Flutter frontend with Firebase Cloud Messaging (FCM) to handle real-time push notifications.

## Features
* Scaffolded using the official FlutterFire CLI.
* Dynamically requests OS notification permissions and generates the device's FCM token.
* Implements `FirebaseMessaging.onMessage` for foreground notification interception and UI updates.
* Includes a Web Service Worker (`firebase-messaging-sw.js`) and VAPID key integration to fully support Chrome browser testing.
* Extracts custom UI components (`TokenMonitor`, `MessageDisplay`) for clean architecture.

## Proof of Work
![FCM Push Notification Proof](assets/notification_proof.png)

## Setup Instructions
1. Clone this repository.
2. Ensure you have an active Firebase project with Web/Android applications registered.
3. Run `flutter pub get` to install the `firebase_core` and `firebase_messaging` dependencies.
4. To test on the Web, run: `flutter run -d chrome`.
5. Grant the browser permission to show notifications, copy the generated FCM token, and dispatch a test message via the Firebase Console.
