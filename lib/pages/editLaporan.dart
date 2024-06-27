import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:laporyuk/component/imgPicker.dart';
import 'package:laporyuk/component/url.dart';
import 'package:laporyuk/theme.dart';
import 'package:path/path.dart' as path;
import 'package:laporyuk/pages/riwayatLaporan.dart';

class EditLaporan extends StatefulWidget {
  final Map<String, dynamic> detailLaporan;

  EditLaporan({required this.detailLaporan});

  @override
  _EditLaporanState createState() => _EditLaporanState();
}

class _EditLaporanState extends State<EditLaporan> {
  TextEditingController _judulController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  String _selectedKecamatan = '';
  List<Map<String, dynamic>> _kecamatanList = [];
  File? _pickedImage;
  String _selectedJenis = '';

  @override
  void initState() {
    super.initState();
    _initializeFields();
    _fetchKecamatanFromDatabase();
  }

  void _initializeFields() {
    _judulController.text = widget.detailLaporan['judul_aduan'];
    _deskripsiController.text = widget.detailLaporan['deskripsi_aduan'];
    _dateController.text = widget.detailLaporan['tanggal'];
    _alamatController.text = widget.detailLaporan['alamat_aduan'];
    _selectedKecamatan = widget.detailLaporan['idKecamatan'].toString();
    _selectedJenis =
        _getJenisLabel(int.parse(widget.detailLaporan['jenis_aduan']));
  }

  String _getJenisLabel(int jenisAduan) {
    switch (jenisAduan) {
      case 1:
        return 'Fasilitas Umum';
      case 2:
        return 'Pelayanan Publik';
      case 3:
        return 'Pelayanan Kesehatan';
      case 4:
        return 'Pelayanan Kebersihan';
      default:
        return '';
    }
  }

  Future<void> _fetchKecamatanFromDatabase() async {
    try {
      final response = await http
          .get(Uri.parse(ApiUrl.apiUrl + 'mobilelaporan/get_kecamatan'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> kecamatanList =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          _kecamatanList = kecamatanList;
        });
      } else {
        throw Exception('Failed to load kecamatan');
      }
    } catch (e) {
      print('Error fetching kecamatan: $e');
      // Handle error fetching data
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        String fileName = path.basename(pickedFile.path);
        print('Picked image file name: $fileName');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Edit Laporan'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white, // Set card background color to white
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
            controller: _judulController,
            decoration: InputDecoration(
              hintText: 'Judul Aduan',
              border: OutlineInputBorder(),
              filled: true, // Set text field background color to white
              fillColor: Colors.white, // Set text field background color to white
            ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
            controller: _deskripsiController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Deskripsi Aduan',
              border: OutlineInputBorder(),
              filled: true, // Set text field background color to white
              fillColor: Colors.white, // Set text field background color to white
            ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
            controller: _dateController,
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              ).then((selectedDate) {
                if (selectedDate != null) {
              setState(() {
                _dateController.text =
                selectedDate.toString().split(' ')[0];
              });
                }
              });
            },
            decoration: InputDecoration(
              hintText: 'Tanggal',
              border: OutlineInputBorder(),
              filled: true, // Set text field background color to white
              fillColor: Colors.white, // Set text field background color to white
            ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
            controller: _alamatController,
            decoration: InputDecoration(
              hintText: 'Alamat Aduan',
              border: OutlineInputBorder(),
              filled: true, // Set text field background color to white
              fillColor: Colors.white, // Set text field background color to white
            ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
            value: _selectedKecamatan,
            items: _kecamatanList.map((kecamatan) {
              return DropdownMenuItem<String>(
                value: kecamatan['idKecamatan'].toString(),
                child: Text(kecamatan['nama_kecamatan']),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                _selectedKecamatan = value!;
              });
            },
            decoration: InputDecoration(
              labelText: 'Kecamatan',
              border: OutlineInputBorder(),
              filled: true, // Set dropdown button background color to white
              fillColor: Colors.white, // Set dropdown button background color to white
            ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
            value: _selectedJenis,
            items: [
              'Fasilitas Umum',
              'Pelayanan Publik',
              'Pelayanan Kesehatan',
              'Pelayanan Kebersihan',
            ].map((jenis) {
              return DropdownMenuItem<String>(
                value: jenis,
                child: Text(jenis),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                _selectedJenis = value!;
              });
            },
            decoration: InputDecoration(
              labelText: 'Jenis Laporan',
              border: OutlineInputBorder(),
              filled: true, // Set dropdown button background color to white
              fillColor: Colors.white, // Set dropdown button background color to white
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
              // Implement update function
              updateLaporan();
            },
            child: Text('Update Laporan'),
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
void updateLaporan() async {
  // Memastikan semua field telah diisi
  if (_judulController.text.isEmpty ||
      _deskripsiController.text.isEmpty ||
      _dateController.text.isEmpty ||
      _alamatController.text.isEmpty ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill all fields')),
    );
    return;
  }

  var uri = Uri.parse(ApiUrl.apiUrl + 'mobilelaporan/update_laporan');
  var request = http.MultipartRequest('POST', uri);

  // Memastikan semua field yang digunakan tidak null
  request.fields['idAduan'] = widget.detailLaporan['idAduan']?.toString() ?? '';
  request.fields['judul_aduan'] = _judulController.text;
  request.fields['deskripsi_aduan'] = _deskripsiController.text;
  request.fields['tanggal'] = _dateController.text;
  request.fields['alamat_aduan'] = _alamatController.text;
  request.fields['idKecamatan'] = _selectedKecamatan?.toString() ?? '';

  request.fields['jenis_aduan'] = _getJenisValue(_selectedJenis)?.toString() ?? '';

  // Memastikan _pickedImage bukan null sebelum digunakan
  if (_pickedImage != null) {
    request.files.add(await http.MultipartFile.fromPath(
      'foto_aduan',
      _pickedImage!.path,
      filename: path.basename(_pickedImage!.path),
    ));
  }
  

  // Debug: Print request data to console
  print('=======================');
 print(request.fields);
 print(request.files);
  print('=======================');

  try {
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = utf8.decode(responseData);

    // Debug: Print server response to console
    print('=======================');
    print('Server Response:');
    print(responseString);
    print('=======================');

    var jsonResponse = json.decode(responseString);

    if (jsonResponse['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Laporan berhasil diupdate')),
      );
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RiwayatLaporan(),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengupdate laporan')),
      );
    }
  } catch (e) {
    print('Error updating laporan: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Terjadi kesalahan. Silakan coba lagi nanti')),
    );
  }
}


  String _getJenisValue(String jenisLabel) {
    switch (jenisLabel) {
      case 'Fasilitas Umum':
        return '1';
      case 'Pelayanan Publik':
        return '2';
      case 'Pelayanan Kesehatan':
        return '3';
      case 'Pelayanan Kebersihan':
        return '4';
      default:
        return '';
    }
  }
}