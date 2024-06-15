import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laporyuk/component/headlines.dart';
import 'package:laporyuk/pages/emergency.dart';
import 'package:laporyuk/pages/headlinePage.dart';
import 'package:laporyuk/pages/menuAduan/fasilitasUmum.dart';
import 'package:laporyuk/pages/menuAduan/pelayananKebersihan.dart';
import 'package:laporyuk/pages/menuAduan/pelayananKesehatan.dart';
import 'package:laporyuk/pages/menuAduan/pelayananPublik.dart';
import 'package:laporyuk/widgets/drawer.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(57, 167, 255, 1),
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
                Text(
                  'Dashboard',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      3,
                      (index) => Headline(
                        imageUrl:
                            'https://miro.medium.com/v2/resize:fit:828/format:webp/1*vgN2zojqiIYu23JPVuaSiA.jpeg',
                        title: 'Headline ${index + 1}',
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HeadlinePage()));
                        },
                      ),
                    ).map((headline) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: headline,
                      );
                    }).toList(),
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
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GridView.count(
                      crossAxisCount: 2,
                      padding: const EdgeInsets.all(20),
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      children: [
                        _buildMenuAduanItem(
                          icon: Icons.house_siding_rounded,
                          title: 'Fasilitas Umum',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FasilitasUmum()));
                          },
                        ),
                        _buildMenuAduanItem(
                          icon: Icons.cleaning_services_rounded,
                          title: 'Pelayanan Kebersihan',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PelayananKebersihan()));
                          },
                        ),
                        _buildMenuAduanItem(
                          icon: Icons.public,
                          title: 'Pelayanan Publik',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PelayananPublik()));
                          },
                        ),
                        _buildMenuAduanItem(
                          icon: Icons.health_and_safety_rounded,
                          title: 'Pelayanan Kesehatan',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PelayananKesehatan()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff87c4ff),
                        Color(0xff6498af),
                      ],
                      stops: [0.485, 1],
                    ),
                  ),
                  child: const Center(),
                ),
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
                decoration: BoxDecoration(
                  color: Color(0xFF39A7FF),
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
                decoration: BoxDecoration(
                  color: Color(0xFF39A7FF),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: InkWell(
              onTap: () {
                // Navigasi ke halaman SOS saat tombol ditekan
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Emergency()));
              },
              child: Opacity(
                opacity: 1,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 57, 57),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
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

  Widget _buildMenuAduanItem(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: const Color.fromRGBO(57, 167, 255, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 100.0, color: Colors.white),
            const SizedBox(height: 10.0),
            Text(
              title,
              style: const TextStyle(fontSize: 15.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
