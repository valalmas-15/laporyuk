import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:laporyuk/component/url.dart';
import 'package:laporyuk/pages/emergency.dart';
import 'package:laporyuk/pages/headlinePage.dart';
import 'package:laporyuk/pages/login.dart';
import 'package:laporyuk/pages/menuAduan/fasilitasUmum.dart';
import 'package:laporyuk/pages/menuAduan/pelayananKebersihan.dart';
import 'package:laporyuk/pages/menuAduan/pelayananKesehatan.dart';
import 'package:laporyuk/pages/menuAduan/pelayananPublik.dart';
import 'package:laporyuk/pages/tambahLaporan.dart';
import 'package:laporyuk/theme.dart';
import 'package:laporyuk/widgets/drawer.dart';
import 'package:laporyuk/widgets/laporan.dart';
import 'package:laporyuk/widgets/menu_aduan.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late List<Map<String, dynamic>> headlineSliders = [];

  late Future<List<Map<String, dynamic>>> riwayatLaporan;

  @override
  void initState() {
    super.initState();
    riwayatLaporan = fetchDashboardLaporan();
    fetchData();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('idUser');
    // Misalnya, cek apakah idUser (atau data session lainnya) sudah ada
    if (idUser == null) {
      // Jika tidak ada session, arahkan ke halaman login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
    // Jika session ada, lanjutkan ke halaman dashboard
    // Anda bisa tambahkan logika atau pengambilan data dashboard di sini
  }

  Future<void> fetchData() async {
    try {
      final Uri url =
          Uri.parse(ApiUrl.apiUrl + 'mobilelaporan/dashboard_berita');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          headlineSliders = data.map((item) {
            String imageUrl =
                item['foto_berita'] != null && item['foto_berita'].isNotEmpty
                    ? ApiUrl.assetsUrl + 'laporan/${item['foto_berita']}'
                    : ApiUrl.assetsUrl + 'laporan/600x400.png';

            return {
              'imageUrl': imageUrl,
              'title': item['judul_berita'],
              'idBerita': item['idBerita'],
            };
          }).toList();
        });
      } else {
        print('Failed to load data. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchDashboardLaporan() async {
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getString('idUser');

    if (idUser == null || idUser.isEmpty) {
      throw Exception('idUser is null or empty');
    }
    final response = await http.get(
      Uri.parse(
          ApiUrl.apiUrl + 'Mobilelaporan/dashboard_laporan?idUser=$idUser'),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Map<String, dynamic>> dashboardLaporan = data.map((e) {
        return {
          'id': e['idAduan'],
          'judul': e['judul_aduan'],
          'jenis': e['jenis_aduan'],
          'tanggal': e['tanggal'],
          'status': e['status_aduan'],
        };
      }).toList();
      return dashboardLaporan;
    } else {
      throw Exception('Failed to load dashboard laporan');
    }
  }

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

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
                  items: headlineSliders.map((item) {
                    return GestureDetector(
                      onTap: () {
                        // Navigasi ke halaman headline detail saat headline ditekan
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HeadlinePage(
                              idBerita: item['idBerita'],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 5,),
                            Text(
                              item['title'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: 
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    item['imageUrl'],
                                    width: 350,
                                    height:
                                        150, // Set a fixed height for the image to avoid overflow
                                    fit: BoxFit
                                        .cover, // Use BoxFit.cover to clip and scale the image
                                  ),
                                ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 200,
                    aspectRatio: MediaQuery.of(context).size.width / 180,
                    viewportFraction: 1.0,
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
                    color: textColor3,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
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
                              builder: (context) => TambahLaporanScreen(
                                jenisLaporan: 1,
                              ),
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
                              builder: (context) => TambahLaporanScreen(jenisLaporan: 2,),
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
                              builder: (context) => TambahLaporanScreen(jenisLaporan: 3,),
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
                              builder: (context) => TambahLaporanScreen(jenisLaporan: 4,),
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
                  height: 340, // Adjust this height as needed
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
                            child: FutureBuilder<List<Map<String, dynamic>>>(
                              future: riwayatLaporan,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasData &&
                                    snapshot.data!.isNotEmpty) {
                                  return ScrollablePositionedList.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      return LaporanCard(
                                        id: int.parse(
                                            snapshot.data![index]['id']),
                                        judul: snapshot.data![index]['judul']!,
                                        jenis: snapshot.data![index]['jenis']!,
                                        tanggal: snapshot.data![index]
                                            ['tanggal']!,
                                        status: snapshot.data![index]
                                            ['status']!,
                                      );
                                    },
                                    itemScrollController: itemScrollController,
                                    itemPositionsListener:
                                        itemPositionsListener,
                                    scrollDirection: Axis.vertical,
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                      'Belum ada laporan yang selesai',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }
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
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 45,
            bottom: 4,
            child: Opacity(
              opacity: 1,
              child: Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 40,
            bottom: 8,
            child: InkWell(
              onTap: () {
                // Navigasi ke halaman SOS saat tombol ditekan
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Emergency()),
                );
              },
              child: Opacity(
                opacity: 1,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.red, // Change the color to red
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
