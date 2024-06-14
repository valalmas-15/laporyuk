import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double fontsize;

  const MyTextButton({super.key, required this.text, required this.onPressed, required this.fontsize});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:onPressed,
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: fontsize),),
    );
  }
}