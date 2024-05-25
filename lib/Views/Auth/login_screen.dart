import 'dart:developer';
import 'package:note_app/Views/main_screen.dart';

import 'sign_up_screen.dart';
import '../../JsonModels/user.dart';
import '../../Custom/validation.dart';
import 'package:ndialog/ndialog.dart';
import 'package:flutter/material.dart';
import 'package:note_app/SQLite/sqlite.dart';
import 'package:fluttertoast/fluttertoast.dart';
// ignore_for_file: use_build_context_synchronously

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController username;
  late TextEditingController password;
  final DatabaseHelper helper = DatabaseHelper();

  bool isVisible = false;

  bool isLoginTrue = false;

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    username = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Image.asset(
                    "assets/login.png",
                    width: 210,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.deepPurple.withOpacity(.2)),
                    child: TextFormField(
                      controller: username,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return FieldValidator.validateEmail(value.toString());
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: "User email",
                      ),
                    ),
                  ),

                  //Password field
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.deepPurple.withOpacity(.2)),
                    child: TextFormField(
                      controller: password,
                      validator: (value) {
                        return FieldValidator.validatePassword(
                            value.toString());
                      },
                      obscureText: !isVisible,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.lock),
                          border: InputBorder.none,
                          hintText: "Password",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              icon: Icon(isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                    ),
                  ),

                  const SizedBox(height: 10),
                  //Login button
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xff734a34)),
                    child: TextButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            ProgressDialog progress = ProgressDialog(context,
                                title: const Text(
                                  'Signing In',
                                  style: TextStyle(color: Color(0xffFFB900)),
                                ),
                                message: const Text(
                                  'Please Wait...',
                                  style: TextStyle(color: Color(0xffFFB900)),
                                ));
                            progress.show();
                            try {
                              var response = await helper.loginUser(Users(
                                  usrEmail: username.text,
                                  usrPassword: password.text));
                              progress.dismiss();
                              if (response == true) {
                                if (!mounted) return;
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainScreen(
                                            userName:
                                                username.text.toString(),
                                            )),
                                    (route) => false);
                                Fluttertoast.showToast(
                                    msg: 'Login Successfully!');
                              } else {
                                setState(() {
                                  isLoginTrue = true;
                                });
                              }
                            } catch (e) {
                              log("Login Error : $e");
                            }
                          }
                        },
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),

                  //Sign up button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUp()));
                          },
                          child: const Text(
                            "SIGN UP",
                            style: TextStyle(color: Color(0xff734a34)),
                          ))
                    ],
                  ),

                  isLoginTrue
                      ? const Text(
                          "Username or passowrd is incorrect",
                          style: TextStyle(color: Colors.red),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
