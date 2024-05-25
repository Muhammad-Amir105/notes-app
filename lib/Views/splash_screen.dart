import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:note_app/Views/main_screen.dart';
import 'package:note_app/Views/Auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? user_id;
  String? user_email;

  @override
  void initState() {
    super.initState();
    getUserId().then(
      (value) {
        user_id = value;
        log("user_id in main:$user_id");
      },
    );
    getUserEmail().then(
      (value) {
        user_email = value;
        log("user_email in main:$user_email");
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (user_id == null && user_id!.isEmpty) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(
              userName: user_email.toString(),
            ),
          ),
          (route) => false,
        );
      }
    });
  }

  Future<String?> getUserId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? user_id1 = sp.getString('user_id');

    return user_id1;
  }

  Future<String?> getUserEmail() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? user_email1 = sp.getString('user_email');

    return user_email1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Image.asset("assets/amir1.png"),
        ),
      ),
    );
  }
}
