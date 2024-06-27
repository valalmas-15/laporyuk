import 'package:flutter/material.dart';

class DescriptionTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;

  const DescriptionTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
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
