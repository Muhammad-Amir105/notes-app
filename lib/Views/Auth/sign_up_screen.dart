import 'dart:developer';
import 'login_screen.dart';
import '../../JsonModels/user.dart';
import '../../Custom/validation.dart';
import 'package:ndialog/ndialog.dart';
import 'package:flutter/material.dart';
import 'package:note_app/SQLite/sqlite.dart';
import 'package:fluttertoast/fluttertoast.dart';
// ignore_for_file: use_build_context_synchronously

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TextEditingController username;
  late TextEditingController password;
  late TextEditingController email;
  late TextEditingController confirmpassword;

  final formKey = GlobalKey<FormState>();
  bool isVisible = false;

  final DatabaseHelper helper = DatabaseHelper();

  @override
  void initState() {
    username = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    confirmpassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    username.dispose();
    password.dispose();
    confirmpassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ListTile(
                    title: Text(
                      "Register New Account",
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.deepPurple.withOpacity(.2)),
                    child: TextFormField(
                      controller: username,
                      validator: (value) {
                        return FieldValidator.validateName(value.toString());
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        hintText: "User full name",
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.deepPurple.withOpacity(.2)),
                    child: TextFormField(
                      controller: email,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return FieldValidator.validateEmail(value.toString());
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email_outlined),
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

                  //Confirm Password field

                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.deepPurple.withOpacity(.2)),
                    child: TextFormField(
                      controller: confirmpassword,
                      validator: (value) {
                        return FieldValidator.validatePasswordMatch(
                            confirmpassword.text.toString(), value.toString());
                      },
                      obscureText: !isVisible,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.lock),
                          border: InputBorder.none,
                          hintText: "Confirmed Password",
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
                                  'Signing Up',
                                  style: TextStyle(color: Color(0xffFFB900)),
                                ),
                                message: const Text(
                                  'Please Wait...',
                                  style: TextStyle(color: Color(0xffFFB900)),
                                ));
                            progress.show();
                            try {
                              var response = await helper.signUpUser(Users(
                                  usrFullName: username.text,
                                  usrEmail: email.text.trim(),
                                  usrPassword: password.text));
                              progress.dismiss();
                              if (response == true) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                    (route) => false);
                                Fluttertoast.showToast(
                                    msg: 'SignUp Successfully!');
                              }
                            } catch (e) {
                              log("Signup Error : $e");
                            }
                          }
                        },
                        child: const Text(
                          "SIGN UP",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Color(0xff734a34)),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
