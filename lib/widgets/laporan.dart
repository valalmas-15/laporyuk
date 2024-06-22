import 'package:flutter/material.dart';
import 'package:laporyuk/pages/detailLaporan.dart';

class LaporanCard extends StatelessWidget {
  final String judul;
  final String jenis;
  final String tanggal;
  final String status;

  const LaporanCard({
    Key? key,
    required this.judul,
    required this.jenis,
    required this.tanggal,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailLaporan(
              judul: 'Banjir di Selokan Mataram',
              jenis: 'Kebersihan',
              tanggal: '20/02/2004',
              status: 'Selesai',
              deskripsi: 'Banjir di selokan mataram sudah selesai',
            ), // Ganti dengan halaman tujuan yang diinginkan
          ),
        );
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
                        '$jenis',
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
                    color: getStatusColor(status),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '$status',
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
      case 'Proses':
        return Colors.blue;
      case 'Selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}


