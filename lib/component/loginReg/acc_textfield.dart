import 'package:flutter/material.dart';

class AccTextField extends StatelessWidget {
  final controller;
  final String hintText;

  const AccTextField({super.key, required this.controller, required this.hintText,});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Color.fromARGB(255, 91, 90, 90),
            fontSize: 24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
          filled: true, // Set filled to true
          fillColor: Colors.white, // Set the background color
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFF8F8F8),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}