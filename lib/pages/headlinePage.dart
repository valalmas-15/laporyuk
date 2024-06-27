import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:laporyuk/component/url.dart';

class HeadlinePage extends StatefulWidget {
  final String idBerita;

  const HeadlinePage({Key? key, required this.idBerita}) : super(key: key);

  @override
  _HeadlinePageState createState() => _HeadlinePageState();
}

class _HeadlinePageState extends State<HeadlinePage> {
  late String imageUrl;
  late String title;
  late String description;
  late String date;
  bool isLoading = true; // State untuk menandai status loading

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final Uri url = Uri.parse(
        ApiUrl.apiUrl + 'mobileheadline/berita_detail/${widget.idBerita}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          imageUrl = data['data']['foto_berita'] != null &&
                  data['data']['foto_berita'].isNotEmpty
              ? ApiUrl.assetsUrl + 'laporan/' + data['data']['foto_berita']
              : ApiUrl.assetsUrl +
                  'laporan/default-image.jpg'; // Ganti dengan URL default jika foto tidak tersedia
          title = data['data']['judul_berita'] ??
              'No Title'; // Menambahkan default jika title kosong
          description = data['data']['deskripsi_berita'] ??
              'No Description'; // Menambahkan default jika deskripsi kosong
          date = data['data']['tanggal_berita'] ??
              'No Date'; // Menambahkan default jika tanggal kosong
          isLoading =
              false; // Set loading menjadi false setelah data berhasil diambil
        });
      } else {
        print('Failed to load data. Error: ${response.statusCode}');
        setState(() {
          isLoading = false; // Set loading menjadi false dalam kasus error juga
        });
      }
    } catch (e) {
      print('Error occurred: $e');
      setState(() {
        isLoading = false; // Set loading menjadi false dalam kasus error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: isLoading
            ? Text('Loading...')
            : Text(
                title,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? Center(
                child:
                    CircularProgressIndicator()) // Tampilkan indikator loading jika isLoading true
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                  // Deskripsi berita
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 20),
                    child: Column(
                      children: [Text(
                          date,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          description,
                          style: TextStyle(fontSize: 16),
                        ),
                        
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
