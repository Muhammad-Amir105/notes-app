import 'package:flutter/material.dart';
import 'package:note_app/Views/main_screen.dart';
import 'package:note_app/Views/Auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore_for_file: non_constant_identifier_names

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
    loadUserData();
  }

  Future<void> loadUserData() async {
    user_id = await getUserId();
    user_email = await getUserEmail();

    Future.delayed(const Duration(seconds: 2), () {
      if (user_id == null || user_id!.isEmpty) {
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
    return sp.getString('user_id');
  }

  Future<String?> getUserEmail() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('user_email');
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
