import 'package:flutter/material.dart';

class HeadlinesSection extends StatelessWidget {
  const HeadlinesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<HeadlineData> headlines = [
      HeadlineData(
        imageUrl: 'assets/images/60bb4a2e143f632da3e56aea_Flutter-app-development-2.png',
        title: 'Headline 1',
      ),
      HeadlineData(
        imageUrl: 'assets/images/60bb4a2e143f632da3e56aea_Flutter-app-development-2.png',
        title: 'Headline 2',
      ),
      HeadlineData(
        imageUrl: 'assets/images/60bb4a2e143f632da3e56aea_Flutter-app-development-2.png',
        title: 'Headline 3',
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: headlines.map((headline) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: HeadlineWidget(
              headlineData: headline,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class HeadlineWidget extends StatelessWidget {
  final HeadlineData headlineData;

  const HeadlineWidget({Key? key, required this.headlineData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
            child: Image.asset(
              headlineData.imageUrl,
              width: 250,
            ),
          ),
          Text(
            headlineData.title,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class HeadlineData {
  final String imageUrl;
  final String title;

  HeadlineData({required this.imageUrl, required this.title});
}
