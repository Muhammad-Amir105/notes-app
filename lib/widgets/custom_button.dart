import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// ignore_for_file: must_be_immutable

class CustomButton extends StatelessWidget {
  String title;
  void Function() onTap;
  CustomButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        minSize: 0,
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
              color: const Color(0xff734a34),
              borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: Text(title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
          ),
        ));
  }
}
