import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Background message received: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Register the background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const FCMApp());
}

class FCMApp extends StatelessWidget {
  const FCMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FCM notifications',
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

  // NEW: Variables to hold the incoming message text
  String? _messageTitle;
  String? _messageBody;

  @override
  void initState() {
    super.initState();
    _setupFCM();
    _listenForMessages(); // NEW: Trigger the listener when app opens
  }

  Future<void> _setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission();

    String? token = await messaging.getToken(
      vapidKey: "BASggtFbna3BoHCtkR2Vsu2AgWvnMRyVkok_2jyhJSYvwyul4UcvEbVW2dkVw4jfEkYXf2UVsjJco6GPYe4MulU",
    );

    setState(() {
      _token = token;
    });
  }

  // NEW: Listen for messages in the foreground
  void _listenForMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("🔥 BINGO! MESSAGE CAUGHT: ${message.notification?.title}");

      setState(() {
        _messageTitle = message.notification?.title;
        _messageBody = message.notification?.body;
      });
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
        // NEW: Column holds both the token and the message display
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TokenMonitor(fcmToken: _token),
            const SizedBox(height: 20),
            MessageDisplay(title: _messageTitle, body: _messageBody),
          ],
        ),
      ),
    );
  }
}

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