import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:laporyuk/component/url.dart';
import 'package:laporyuk/widgets/drawer.dart';
import 'package:laporyuk/widgets/laporan.dart';

class RiwayatLaporan extends StatefulWidget {
  const RiwayatLaporan({Key? key}) : super(key: key);

  @override
  _RiwayatLaporanState createState() => _RiwayatLaporanState();
}

class _RiwayatLaporanState extends State<RiwayatLaporan> {
  late Future<List<Map<String, dynamic>>> _futureRiwayatLaporan;

  @override
  void initState() {
    super.initState();
    _futureRiwayatLaporan = fetchRiwayatLaporan();
  }

  Future<List<Map<String, dynamic>>> fetchRiwayatLaporan() async {
    final response = await http.get(
      Uri.parse(ApiUrl.apiUrl+'riwayat_laporan.php'),
    );
    if (response.statusCode == 200) {
      // Jika request sukses, parse JSON response
      List<dynamic> data = jsonDecode(response.body);
      // Konversi list dynamic menjadi list Map<String, dynamic>
      List<Map<String, dynamic>> riwayatLaporan = data.map((e) {
        return {
          'id': e['idAduan'],
          'judul': e['judul_aduan'],
          'jenis': e['jenis_aduan'],
          'tanggal': e['tanggal'],
          'status': e['status_aduan'],
        };
      }).toList();
      return riwayatLaporan;
    } else {
      throw Exception('Failed to load riwayat laporan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: const Text('Riwayat Laporan'),
      ),
      drawer: const AppDrawer(), // Gunakan widget drawer yang sudah dibuat
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureRiwayatLaporan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            // Data berhasil diambil
            List<Map<String, dynamic>> listLaporan = snapshot.data!;
            return ListView.builder(
              itemCount: listLaporan.length,
              itemBuilder: (context, index) {
                return LaporanCard(
                  id: int.parse(listLaporan[index]['id']),
                  judul: listLaporan[index]['judul']!,
                  jenis: listLaporan[index]['jenis']!,
                  tanggal: listLaporan[index]['tanggal']!,
                  status: listLaporan[index]['status']!,
                );
              },
            );
          }
        },
      ),
    );
  }
}
