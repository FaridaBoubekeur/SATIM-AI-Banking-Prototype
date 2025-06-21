import 'dart:async';
import 'package:flutter/material.dart';

// Your reusable logo widget
import 'widgets/logo_widget.dart';
// Your dashboard/home page
import 'screens/home_screen.dart';
import 'screens/card_details.dart';
import 'screens/money_transfer.dart';
import 'screens/ATM_centers.dart';
import 'screens/recharge_mobile.dart';
import 'screens/verif_method.dart';
import 'screens/profile_page.dart';
import 'screens/chatbot.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SATIM Virtual Assistant',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// SplashScreen shows the logo for 2 seconds, then navigates to HomeScreen
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // After a delay, replace this page with HomeScreen
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: LogoWidget(width: 180, height: 180),
      ),
    );
  }
}
