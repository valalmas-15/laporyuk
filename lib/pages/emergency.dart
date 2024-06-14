import 'package:flutter/material.dart';

class Emergency extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: InkWell(
              onTap: () {},
              child: Opacity(
                opacity: 1,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 82, 82),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.sos_rounded, // Icon "keadaan darurat" (warning)
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                ),
              ),
            ),
          ),
            SizedBox(height: 30),
            Text(
              'Tekan & Tahan Tombol Selama 2 Detik',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
