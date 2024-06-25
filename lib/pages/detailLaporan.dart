import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:laporyuk/component/url.dart';
import 'package:laporyuk/pages/menuAduan/editLaporan.dart';

class DetailLaporan extends StatefulWidget {
  final int idAduan;

  const DetailLaporan({Key? key, required this.idAduan}) : super(key: key);

  @override
  _DetailLaporanState createState() => _DetailLaporanState();
}

class _DetailLaporanState extends State<DetailLaporan> {
  late Future<Map<String, dynamic>> futureDetailLaporan;

  @override
  void initState() {
    super.initState();
    futureDetailLaporan = fetchDetailLaporan(widget.idAduan);
  }

  Future<Map<String, dynamic>> fetchDetailLaporan(int idAduan) async {
    final response = await http.get(
      Uri.parse(ApiUrl.apiUrl + 'Mobilelaporan/detail_laporan?id=$idAduan'),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> detailLaporan = jsonDecode(response.body);
      return detailLaporan;
    } else {
      throw Exception('Failed to load detail laporan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Laporan'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureDetailLaporan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          Map<String, dynamic> detailLaporan = snapshot.data!;
          bool allowEdit = detailLaporan['status_aduan'] == '1';

          // Tentukan URL gambar untuk ditampilkan atau gunakan gambar default jika tidak ada
          String imageUrl = detailLaporan['foto_aduan'] != null &&
                  detailLaporan['foto_aduan'].isNotEmpty
              ? '${ApiUrl.baseUrl}assets/berita/${detailLaporan['foto_aduan']}'
              : '${ApiUrl.baseUrl}assets/berita/600x400.png';

            return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                color: Colors.white, // Set the background color of the card to white
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                    detailLaporan['judul_aduan'],
                    style: TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text(
                    'Kecamatan : '+detailLaporan['nama_kecamatan'],
                    style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8),
                    Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                      '${ApiUrl.baseUrl}assets/berita/600x400.png',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      );
                    },
                    ),
                    SizedBox(height: 8),
                    Text(
                    'Jenis: ${getJenisText(detailLaporan['jenis_aduan'])}',
                    style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                    'Alamat: ${detailLaporan['alamat_aduan']}',
                    style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                    'Tanggal: ${detailLaporan['tanggal']}',
                    style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                    'Deskripsi: ${detailLaporan['deskripsi_aduan']}',
                    style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    if (allowEdit)
                    Center(
                      child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditLaporan(
                          detailLaporan: detailLaporan,
                          idAduan: widget
                            .idAduan, // Menambahkan idAduan ke halaman EditLaporan
                          ),
                        ),
                        );
                      },
                      child: Text('Edit Laporan'),
                      ),
                    ),
                  ],
                  ),
                ),
                ),
              ],
              ),
            ),
            );
        },
      ),
    );
  }

  String getJenisText(String jenis) {
    switch (jenis) {
      case '1':
        return 'Fasilitas Umum';
      case '2':
        return 'Pelayanan Publik';
      case '3':
        return 'Pelayanan Kesehatan';
      case '4':
        return 'Pelayanan Kebersihan';
      default:
        return 'Tidak diketahui';
    }
  }
}
