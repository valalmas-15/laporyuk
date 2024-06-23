import 'package:flutter/material.dart';

class AccTextField extends StatelessWidget {
  final controller;
  final String hintText;

  const AccTextField({super.key, required this.controller, required this.hintText,});
  @override
  Widget build(BuildContext context) {
    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: hintText,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    );
  }
}