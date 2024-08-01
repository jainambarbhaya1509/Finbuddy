import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bobhack/constants.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  static final WebSocketManager _instance = WebSocketManager._internal();
  factory WebSocketManager() => _instance;
  WebSocketManager._internal() {
    _initializeWebSocket();
  }

  WebSocketChannel? _channel;
  final String _webSocketUrl = 'ws://app-server.livelycliff-707ceb90.eastus.azurecontainerapps.io';

  WebSocketChannel? get channel => _channel;

  void _initializeWebSocket() {
    _connectWebSocket();
  }

  void _connectWebSocket() async {
    _channel = WebSocketChannel.connect(Uri.parse(_webSocketUrl));
    _channel!.stream.listen(
      (message) {
        final data = jsonDecode(message);
        final notificationService = NotificationService();
        notificationService.showNotification(data['data']);
      },
      onError: (error) {},
      onDone: () {},
    );
  }

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
      ),
    );
    service.startService();
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    return true;
  }

  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance service) async {
    final webSocketManager = WebSocketManager();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('sessionCookie');
    try {
      final payload = {
        'eventName': "message",
        'data': {'event': "AddNewUser", 'data': token},
      };
      final jsonPayload = jsonEncode(payload);
      webSocketManager.channel?.sink.add(jsonPayload);
      // ignore: empty_catches
    } catch (e) {
      rethrow;
    }
  }
}

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalPlugin =
      FlutterLocalNotificationsPlugin();

  final RxInt notificationIdCounter = 0.obs;

  static const AndroidNotificationChannel _notificationChannel =
      AndroidNotificationChannel(
    "bob_hackathon_channel",
    "BOB Hackathon Channel",
    description: "Channel for BOB Hackathon",
    importance: Importance.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('notification_sound'),
  );

  NotificationService() {
    _initializeNotifications();
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      var status = await Permission.notification.status;
      if (!status.isGranted) {
        await Permission.notification.request();
      }
    } else if (Platform.isIOS) {
      await flutterLocalPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  void _initializeNotifications() {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalPlugin.initialize(initializationSettings);
    flutterLocalPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_notificationChannel);
  }

  void showNotification(String message) {
    int notificationId = notificationIdCounter.value;
    notificationIdCounter.value++;

    flutterLocalPlugin.show(
      notificationId,
      "BOB Hackathon",
      message,
      const NotificationDetails(
        android: AndroidNotificationDetails(
            "bob_hackathon_channel", "BOB Hackathon Channel",
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            showProgress: true),
      ),
    );
  }
}
