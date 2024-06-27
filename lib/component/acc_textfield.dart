import 'package:flutter/material.dart';

class AccTextField extends StatelessWidget {
  final TextEditingController controller;
  final String initialValue;
  final String title;

  const AccTextField({
    Key? key,
    required this.title,
    required this.controller,
    required this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set initial value to the controller
    controller.text = initialValue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
