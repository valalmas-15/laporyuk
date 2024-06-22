import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laporyuk/component/headlines.dart';
import 'package:laporyuk/pages/emergency.dart';
import 'package:laporyuk/pages/menuAduan/fasilitasUmum.dart';
import 'package:laporyuk/pages/menuAduan/pelayananKebersihan.dart';
import 'package:laporyuk/pages/menuAduan/pelayananKesehatan.dart';
import 'package:laporyuk/pages/menuAduan/pelayananPublik.dart';
import 'package:laporyuk/widgets/drawer.dart';
import 'package:laporyuk/widgets/laporan.dart';
import 'package:laporyuk/widgets/menu_aduan.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key);

  final List<Widget> headlineSliders = [
    Headline(
      imageUrl:
          'https://miro.medium.com/v2/resize:fit:828/format:webp/1*vgN2zojqiIYu23JPVuaSiA.jpeg',
      title: 'Headline',
    ),
    Headline(
      imageUrl:
          'https://miro.medium.com/v2/resize:fit:828/format:webp/1*vgN2zojqiIYu23JPVuaSiA.jpeg',
      title: 'Headline',
    ),
    Headline(
      imageUrl:
          'https://miro.medium.com/v2/resize:fit:828/format:webp/1*vgN2zojqiIYu23JPVuaSiA.jpeg',
      title: 'Headline',
    ),
  ];

  final List<Map<String, String>> listLaporan = [
    {
      'judul': 'Banjir di Jalan Utama',
      'jenis': 'Banjir',
      'tanggal': '10 Juni 2024',
      'status': 'Selesai',
    },
    {
      'judul': 'Sampah Berserakan di Taman',
      'jenis': 'Kebersihan',
      'tanggal': '12 Juni 2024',
      'status': 'Selesai',
    },
    {
      'judul': 'Gangguan pada Jaringan Listrik',
      'jenis': 'Listrik',
      'tanggal': '15 Juni 2024',
      'status': 'Selesai',
    },
  ];

  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();

  void callbackFunction(int index, CarouselPageChangedReason reason) {
    // Callback function implementation here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: const Text('LaporYuk!'),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CarouselSlider(
                  items: headlineSliders
                      .map((item) => Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Card(
                              color: Colors.blue,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                child: item,
                              ),
                            ),
                          ))
                      .toList(),
                  options: CarouselOptions(
                    height: 180,
                    aspectRatio: MediaQuery.of(context).size.width /
                        180, // Menyesuaikan aspect ratio agar lebar penuh
                    viewportFraction:
                        1.0, // Mengatur agar item memenuhi viewport
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: false,
                    enlargeFactor: 0.3,
                    onPageChanged: callbackFunction,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Menu Aduan',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MenuAduan(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FasilitasUmum(),
                            ),
                          );
                        },
                        icon: Icons.house_outlined,
                        title: 'Fasilitas\nUmum',
                        color: Colors.blue,
                      ),
                      MenuAduan(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PelayananPublik(),
                            ),
                          );
                        },
                        icon: Icons.menu_book_outlined,
                        title: 'Pelayanan\nPublik',
                        color: Colors.blue,
                      ),
                      MenuAduan(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PelayananKesehatan(),
                            ),
                          );
                        },
                        icon: Icons.health_and_safety_outlined,
                        title: 'Pelayanan\nKesehatan',
                        color: Colors.blue,
                      ),
                      MenuAduan(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PelayananKebersihan(),
                            ),
                          );
                        },
                        icon: Icons.cleaning_services_outlined,
                        title: 'Pelayanan\nKebersihan',
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 360, // Adjust this height as needed
                  child: Card(
                    color: Colors.white, // Set the background color of the Card
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Laporan Selesai',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: listLaporan.length,
                              itemBuilder: (context, index) {
                                return LaporanCard(
                                  judul: listLaporan[index]['judul']!,
                                  jenis: listLaporan[index]['jenis']!,
                                  tanggal: listLaporan[index]['tanggal']!,
                                  status: listLaporan[index]['status']!,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Opacity(
              opacity: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50, // Tinggi sesuai kebutuhan Anda
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20)), // Melengkungkan hanya di atas
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: 1,
              child: Container(
                width: 100,
                height: 90,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: 1,
              child: Container(
                width: 100,
                height: 90,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 5,
            child: InkWell(
              onTap: () {
                // Navigasi ke halaman SOS saat tombol ditekan
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Emergency()));
              },
              child: Opacity(
                opacity: 1,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 57, 57),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.sos_rounded, // Icon "keadaan darurat" (warning)
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}