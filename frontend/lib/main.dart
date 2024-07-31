import 'dart:ui';
import 'package:bobhack/constants.dart';
import 'package:bobhack/controllers/services.dart';
import 'package:bobhack/pages/login/bob_login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  final notificationService = NotificationService();
  await notificationService.requestPermissions();
  
  runApp(MyApp(notificationService: notificationService));
}

class MyApp extends StatelessWidget {
  final NotificationService notificationService;

  const MyApp({super.key, required this.notificationService});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BOB Hackathon',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(bgColor.value)),
        useMaterial3: true,
      ),
      home: BobLogin(),
    );
  }
}
