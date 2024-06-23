import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
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
  String? _selectedKecamatan;
  List<String> _kecamatanList = [];
  String? _selectedJenis;
  List<String> _jenisList = [
    'Fasilitas Umum',
    'Pelayanan Publik',
    'Pelayanan Kesehatan',
    'Pelayanan Kebersihan'
  ];

  @override
  void initState() {
    super.initState();
    _fetchLaporanData();
    _fetchKecamatanData();
  }

  Future<void> _fetchLaporanData() async {
    final apiUrl = ApiUrl.apiUrl + 'detail_laporan.php?id=${widget.idAduan}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _judulController.text = data['judul'] ?? '';
          _deskripsiController.text = data['deskripsi'] ?? '';
          _alamatController.text = data['alamat'] ?? '';
          _dateController.text = data['tanggal'] ?? '';
          _selectedKecamatan = data['kecamatan'] ?? null;
          _selectedJenis = data['jenis'] ?? null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load laporan data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    }
  }

  Future<void> _fetchKecamatanData() async {
    final apiUrl = ApiUrl.apiUrl + 'kecamatan.php';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _kecamatanList =
              data.map((item) => item['nama_kecamatan'].toString()).toList();
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
        title: Text('Edit Laporan'),
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
                          labelText: ,
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
                        value: _selectedKecamatan,
                        items: _kecamatanList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedKecamatan = value;
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
                        value: _selectedJenis,
                        items: _jenisList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedJenis = value;
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

  void _submitForm() async {
    final kecamatanMap = {
      'Berbah': '1',
      'Cangkringan': '2',
      'Depok': '3',
      'Gamping': '4',
      'Godean': '5',
      'Kalasan': '6',
      'Minggir': '7',
      'Mlati': '8',
      'Moyudan': '9',
      'Ngaglik': '10',
      'Ngemplak': '11',
      'Pakem': '12',
      'Prambanan': '13',
      'Seyegan': '14',
      'Sleman': '15',
      'Tempel': '16',
      'Turi': '17'
    };

    final jenisMap = {
      'Fasilitas Umum': '1',
      'Pelayanan Publik': '2',
      'Pelayanan Kesehatan': '3',
      'Pelayanan Kebersihan': '4'
    };

    final idKecamatan = kecamatanMap[_selectedKecamatan] ?? '';
    final idJenis = jenisMap[_selectedJenis] ?? '';

    // Log the selected values
    print('Judul Laporan: ${_judulController.text}');
    print('Deskripsi Laporan: ${_deskripsiController.text}');
    print('Alamat Lengkap Kejadian: ${_alamatController.text}');
    print('ID Kecamatan: $idKecamatan');
    print('Jenis Laporan: $idJenis');
    if (_pickedImage != null) {
      print('Bukti Laporan: ${_pickedImage!.path}');
    }

    // Prepare data to be sent
    final data = {
      'judul': _judulController.text,
      'deskripsi': _deskripsiController.text,
      'alamat': _alamatController.text,
      'id_kecamatan': idKecamatan,
      'id_jenis': idJenis,
      'tanggal': _dateController.text,
      'image': _pickedImage != null
          ? base64Encode(_pickedImage!.readAsBytesSync())
          : '',
    };

    // Send data to API
    final apiUrl =
        '${ApiUrl.apiUrl}update_laporan.php'; // Replace with your update API URL
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      final message = response.statusCode == 200
          ? 'Laporan berhasil diperbarui'
          : 'Gagal memperbarui laporan';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    }
  }
}
