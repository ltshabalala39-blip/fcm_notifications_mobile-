import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FCMApp());
}

class FCMApp extends StatelessWidget {
  const FCMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FCM notifications ',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String? _token;

  @override
  void initState() {
    super.initState();
    _setupFCM();
  }

  Future<void> _setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission from the OS (Required for iOS/Web, recommended for Android)
    await messaging.requestPermission();

    // Fetch the unique device token
    String? token = await messaging.getToken();
    setState(() {
      _token = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Notifications'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: TokenMonitor(fcmToken: _token),
      ),
    );
  }
}

// Extracted Widget for Clean Architecture (and to pass our test)
class TokenMonitor extends StatelessWidget {
  final String? fcmToken;

  const TokenMonitor({super.key, this.fcmToken});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('FCM Token:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          // SelectableText allows you to copy the token to your clipboard!
          SelectableText(
            fcmToken ?? 'Waiting for token...',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class MessageDisplay extends StatelessWidget {
  final String? title;
  final String? body;

  const MessageDisplay({super.key, this.title, this.body});

  @override
  Widget build(BuildContext context) {
    if (title == null && body == null) {
      return const Text('No messages received yet.', style: TextStyle(fontStyle: FontStyle.italic));
    }

    return Column(
      children: [

        const Text('Latest Message', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: ListTile(
            leading: const Icon(Icons.notifications_active, color: Colors.deepPurple),
            title: Text(title ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(body ?? ''),
          ),
        ),
      ],
    );
  }
}