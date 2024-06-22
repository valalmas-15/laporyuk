import 'package:flutter/material.dart';
import 'package:laporyuk/theme.dart';

class MenuAduan extends StatelessWidget {

  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback? onTap;
  const MenuAduan({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: blackTextStyle.copyWith(
            color: textColor3,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    );
  }
}

