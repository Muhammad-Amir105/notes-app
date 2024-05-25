import '../../Custom/constant.dart';
import '../../JsonModels/user.dart';
import 'package:flutter/material.dart';
import 'package:note_app/widgets/custom_button.dart';
import 'package:note_app/Views/Auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final Users? profile;
  const Profile({super.key, this.profile});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<bool> remove() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove('user_id');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 45.0, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundColor: primaryColor,
                radius: 77,
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/no_user.jpg"),
                  radius: 75,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.profile!.usrFullName ?? "",
                style: const TextStyle(fontSize: 28, color: primaryColor),
              ),
              Text(
                widget.profile!.usrEmail,
                style: const TextStyle(fontSize: 17, color: Colors.grey),
              ),
              ListTile(
                leading: const Icon(Icons.person, size: 30),
                subtitle: Text(widget.profile!.usrFullName ?? " "),
                title: const Text("Full Name"),
              ),
              ListTile(
                leading: const Icon(Icons.email, size: 30),
                subtitle: Text(
                  widget.profile!.usrEmail,
                ),
                title: const Text("Email"),
              ),
              CustomButton(
                  title: "Go Back",
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xff734a34),
          onPressed: () {
            remove().then(
              (value) {
                if (value == true) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Some thing went wrong.Try Again")));
                }
              },
            );
          },
          label: const Row(
            children: [
              Icon(
                Icons.logout,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Logout",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )
            ],
          )),
    );
  }
}
