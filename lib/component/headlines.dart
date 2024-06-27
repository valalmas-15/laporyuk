import 'package:flutter/material.dart';
import 'package:laporyuk/pages/headlinePage.dart';

class Headline extends StatelessWidget {
  final String imageUrl;
  final String title;

  const Headline({
    Key? key,
    required this.imageUrl,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HeadlinePage(
          idBerita: '1', // Ganti dengan ID berita yang diinginkan
        )));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: Colors.white,
            width: 5,
          ),
        ),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: 250,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
