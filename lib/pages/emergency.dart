import 'package:flutter/material.dart';

class Emergency extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Emergency"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
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
            SizedBox(height: 30),
            Text(
              'Tekan & Tahan Tombol Selama 2 Detik',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Untuk Memanggil Bantuan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Text(
              'Lokasi Anda Akan Diteruskan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, 
              ),
            ),
            Text(
              'Ke Instansi Terkait Terdekat',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
