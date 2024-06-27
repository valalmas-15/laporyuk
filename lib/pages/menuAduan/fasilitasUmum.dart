import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:laporyuk/component/datePicker.dart';
import 'package:laporyuk/component/imgPicker.dart';
import 'package:laporyuk/component/url.dart';
import 'package:laporyuk/pages/riwayatLaporan.dart';

class FasilitasUmum extends StatefulWidget {
  @override
  _FasilitasUmumState createState() => _FasilitasUmumState();
}

class _FasilitasUmumState extends State<FasilitasUmum> {
  TextEditingController _judulController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  File? _pickedImage;
  String? _selectedKecamatan;
  List<String> _kecamatanList = [];

  @override
  void initState() {
    super.initState();
    _fetchKecamatanData();
  }

  Future<void> _fetchKecamatanData() async {
    final apiUrl = ApiUrl.apiUrl + 'mobilelaporan/get_kecamatan';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _kecamatanList = data.map((item) => item['nama_kecamatan'].toString()).toList();

          // Atur _selectedKecamatan jika _kecamatanList tidak kosong
          if (_kecamatanList.isNotEmpty) {
            _selectedKecamatan = _kecamatanList.first;
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load kecamatan data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Tambah Laporan Fasilitas Umum'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _judulController,
                        decoration: InputDecoration(
                          labelText: 'Judul Laporan',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _deskripsiController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Deskripsi Laporan',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DatePickerWidget(
                        controller: _dateController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _alamatController,
                        decoration: InputDecoration(
                          labelText: 'Alamat Kejadian',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        items: _kecamatanList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                        },
                        decoration: InputDecoration(
                          labelText: 'Kecamatan',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    ImagePickerWidget(
                      onImageSelected: (File pickedImage) {
                        setState(() {
                          _pickedImage = pickedImage;
                        });
                      },
                    ),
                    if (_pickedImage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(_pickedImage!),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _submitForm();
                          
                        },
                        child: Text('Tambah Laporan'),
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
  }

  void _submitForm() async {
    final idKecamatan = _kecamatanList.indexOf(_selectedKecamatan!) + 1;
    final jenisAduan = '1'; // Nilai jenis aduan untuk fasilitas umum

    final data = {
      'idKecamatan': idKecamatan.toString(),
      'judul_aduan': _judulController.text,
      'alamat_aduan': _alamatController.text,
      'id_user': '1', // You might need to replace this with the actual user ID
      'tanggal': _dateController.text,
      'deskripsi_aduan': _deskripsiController.text,
      'foto_aduan': 'afsd',
      // 'foto_aduan': _pickedImage != null ? base64Encode(_pickedImage!.readAsBytesSync()) : '',
      'jenis_aduan': jenisAduan,
    };
    print(data);

    final apiUrl = '${ApiUrl.apiUrl}mobilelaporan/insert_laporan';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final message = 'Laporan berhasil ditambahkan';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RiwayatLaporan()),
        );
      } else {
        final message = 'Gagal menambahkan laporan. Response: ${response.body}';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      print('Error: $e'); // Log error yang terjadi
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    }
  }

}
