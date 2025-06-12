import 'package:flutter/material.dart';
import 'package:mobile_aula_inteligente/providers/profesor_provider.dart';
import 'package:provider/provider.dart';
import 'package:mobile_aula_inteligente/providers/auth_provider.dart';
import 'package:mobile_aula_inteligente/pages/splash_screen.dart';
import 'package:mobile_aula_inteligente/pages/login_page.dart';
import 'package:mobile_aula_inteligente/pages/profesor_materias_page.dart';
import 'package:mobile_aula_inteligente/providers/alumno_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_aula_inteligente/providers/padre_provider.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _initLocalNotifications();
  runApp(const MainApp());
}

Future<void> _initLocalNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // 👈 mismo ID que en el Manifest
    'Notificaciones Importantes',
    description: 'Este canal es usado para notificaciones críticas.',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);
}

void showLocalNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'default_channel',
    'Notificaciones',
    channelDescription: 'Canal para notificaciones push',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    message.notification?.title ?? 'Notificación',
    message.notification?.body ?? '',
    platformDetails,
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfesorProvider()),
        ChangeNotifierProvider(create: (_) => AlumnoProvider()),
        ChangeNotifierProvider(create: (_) => PadreProvider()),
      ],
      child: Builder(
        // Usamos Builder para acceder al contexto interno
        builder: (context) {
          Future.microtask(() async {
            await setupFirebaseMessaging(context);
          });

          return MaterialApp(
            title: 'Aula Inteligente App',
            theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
            home: const SplashScreen(),
            routes: {
              '/login': (_) => const LoginPage(),
              '/materias': (_) => const ProfesorMateriasPage(),
            },
          );
        },
      ),
    );
  }
}

Future<void> setupFirebaseMessaging(BuildContext context) async {
  await messaging.requestPermission();
  String? token = await messaging.getToken();
  print('FCM Token: $token');

  if (token != null) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.enviarFcmToken(token);
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Mensaje recibido en foreground: ${message.notification?.title}');

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel', // 👈 debe coincidir
            'Notificaciones Importantes',
            channelDescription:
                'Este canal es usado para notificaciones críticas.',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
          ),
        ),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Abrió app desde notificación');
    // Podés redirigir al usuario a una página específica si querés
  });
}
