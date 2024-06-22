import 'package:flutter/material.dart';
import 'package:laporyuk/widgets/drawer.dart';
import 'package:laporyuk/widgets/laporan.dart';

class RiwayatLaporan extends StatelessWidget {
  RiwayatLaporan({Key? key}) : super(key: key);

  final List<Map<String, String>> listLaporan = [
    {
      'judul': 'Laporan Banjir di Jalan Utama',
      'jenis': 'Banjir',
      'tanggal': '10 Juni 2024',
      'status': 'Terkirim',
    },
    {
      'judul': 'Laporan Sampah Berserakan di Taman',
      'jenis': 'Kebersihan',
      'tanggal': '12 Juni 2024',
      'status': 'Proses',
    },
    {
      'judul': 'Laporan Gangguan pada Jaringan Listrik',
      'jenis': 'Listrik',
      'tanggal': '15 Juni 2024',
      'status': 'Selesai',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: const Text('Riwayat Laporan'),
      ),
      drawer: const AppDrawer(), // Gunakan widget drawer yang sudah dibuat
      body: ListView.builder(
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
    );
  }
}
