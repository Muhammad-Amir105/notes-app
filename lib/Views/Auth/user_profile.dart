import '../../Custom/constant.dart';
import '../../JsonModels/user.dart';
import 'package:flutter/material.dart';
import 'package:note_app/widgets/custom_button.dart';

class Profile extends StatelessWidget {
  final Users? profile;
  const Profile({super.key, this.profile});

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
                profile!.usrFullName ?? "",
                style: const TextStyle(fontSize: 28, color: primaryColor),
              ),
              Text(
                profile!.usrEmail,
                style: const TextStyle(fontSize: 17, color: Colors.grey),
              ),
              ListTile(
                leading: const Icon(Icons.person, size: 30),
                subtitle: Text(profile!.usrFullName ?? " "),
                title: const Text("Full Name"),
              ),
              ListTile(
                leading: const Icon(Icons.email, size: 30),
                subtitle: Text(
                  profile!.usrEmail,
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
    );
  }
}
