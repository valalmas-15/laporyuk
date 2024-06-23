import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:laporyuk/component/datePicker.dart';
import 'package:laporyuk/component/imgPicker.dart';
import 'package:laporyuk/component/url.dart';

class EditLaporan extends StatefulWidget {
  final int idAduan;

  const EditLaporan({Key? key, required this.idAduan}) : super(key: key);

  @override
  _EditLaporanState createState() => _EditLaporanState();
}

class _EditLaporanState extends State<EditLaporan> {
  TextEditingController _judulController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  File? _pickedImage;
  List<String> _dropdownItemsKecamatan = [
    'Layanan Medis 1',
    'Layanan Medis 2',
    'Layanan Medis 3'
  ];
  String? _selectedDropdownItem;
  List<String> _dropdownItemsJenis = [
    '1',
    '2',
    '3'
  ];

  @override
  void initState() {
    super.initState();
    _fetchLaporanData();
  }

  Future<void> _fetchLaporanData() async {
    final apiUrl = ApiUrl.baseUrl+'detail_laporan.php?id=${widget.idAduan}'; // Ganti dengan URL API Anda

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _judulController.text = data['judul'] ?? '';
          _deskripsiController.text = data['deskripsi'] ?? '';
          _alamatController.text = data['alamat'] ?? '';
          _dateController.text = data['tanggal'] ?? ''; // Sesuaikan dengan nama field tanggal dari API
          _selectedDropdownItem = data['kecamatan'] ?? null; // Sesuaikan dengan nama field kecamatan dari API
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data laporan')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Laporan'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Judul Laporan
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
                          labelText: 'Alamat Lengkap Kejadian',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        value: _selectedDropdownItem,
                        items: _dropdownItemsKecamatan.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedDropdownItem = value;
                          });
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
                      child: DropdownButtonFormField<String>(
                        value: _selectedDropdownItem,
                        items: _dropdownItemsJenis.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedDropdownItem = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Jenis Laporan',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle submit logic here
                          _submitForm();
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

  void _submitForm() {
    // Implement logic to submit the form data
    // Here you can use _judulController.text, _deskripsiController.text, _alamatController.text,
    // _selectedDropdownItem, _pickedImage, etc.
    print('Judul Laporan: ${_judulController.text}');
    print('Deskripsi Laporan: ${_deskripsiController.text}');
    print('Alamat Lengkap Kejadian: ${_alamatController.text}');
    print('Status: $_selectedDropdownItem');
    if (_pickedImage != null) {
      print('Bukti Laporan: ${_pickedImage!.path}');
    }
    // Add your submission logic here
  }
}
