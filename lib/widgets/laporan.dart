import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:laporyuk/pages/detailLaporan.dart';

class LaporanCard extends StatelessWidget {
  final int id;
  final String judul;
  final String jenis;
  final String tanggal;
  final String status;

  const LaporanCard({
    Key? key,
    required this.id,
    required this.judul,
    required this.jenis,
    required this.tanggal,
    required this.status,
  }) : super(key: key);

  @override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () async {
      print('Card tapped');
      try {
  // Navigasi ke halaman DetailLaporan dengan data yang diambil dari API
  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailLaporan(idAduan: id),
  ),
);

} catch (e) {
  print('Error fetching detail laporan: $e');
  // Handle error jika gagal mengambil data dari API
}

    },
    child: Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$judul',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${getJenisText(jenis)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$tanggal',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
                Card(
                  color: getStatusColor(getStatusText(status)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${getStatusText(status)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}


  Color getStatusColor(String status) {
    switch (status) {
      case 'Belum Ditanggapi':
        return Colors.red;
      case 'Diproses':
        return Colors.grey;
      case 'Selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<Map<String, dynamic>> fetchDetailLaporan(int idLaporan) async {
    final response = await http.get(
      Uri.parse('http://192.168.1.10/laporyuk_backend/detail_laporan.php?id=$idLaporan'),
    );
    if (response.statusCode == 200) {
      // Jika request sukses, parse JSON response
      Map<String, dynamic> detailLaporan = jsonDecode(response.body);

      return detailLaporan;
    } else {
      throw Exception('Failed to load detail laporan');
    }
  }
  
  getJenisText(String jenis) {
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
  
  getStatusText(String status) {
    switch (status) {
      case '1':
        return 'Belum Ditanggapi';
      case '2':
        return 'Diproses';
      case '3':
        return 'Selesai';
      default:
        return 'Tidak diketahui';
    }
  }
}
