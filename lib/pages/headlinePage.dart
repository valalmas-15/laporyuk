import 'package:flutter/material.dart';

class HeadlinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Card(
          child: Column(
            children: [
        Text('Headline', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, ),),
              Image.network(
                  'https://miro.medium.com/v2/resize:fit:828/format:webp/1*vgN2zojqiIYu23JPVuaSiA.jpeg'),
            ],
          ),
        ),
        // text deskripsi headline
        Container(
            color: Color.fromARGB(255, 255, 255, 255),
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque vel urna ut libero lacinia auctor. Phasellus auctor, arcu nec fringilla volutpat, erat purus vehicula justo, nec feugiat tortor arcu nec nunc. Integer efficitur leo et sem consequat, sit amet egestas eros facilisis. Sed a felis vitae erat varius vestibulum. Nam euismod augue et sem tincidunt, id cursus lectus pharetra. Nullam consequat diam vitae ligula fermentum, a dictum magna vulputate. In hac habitasse platea dictumst. Ut volutpat bibendum diam, sit amet ullamcorper nulla viverra ac. Donec suscipit, magna sit amet scelerisque aliquet, turpis felis efficitur turpis, sed tristique elit leo sit amet risus. Praesent euismod turpis id magna tincidunt, in fringilla eros interdum. Nulla facilisi. Maecenas consequat, lacus ac consequat pharetra, nisl eros consectetur magna, in laoreet turpis neque eget lorem. Donec varius finibus augue vel fringilla.',
              style: TextStyle(fontSize: 16),
            ),
          ),
      ],
    ));
  }
}
