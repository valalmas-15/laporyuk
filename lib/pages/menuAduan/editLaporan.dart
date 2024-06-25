import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:laporyuk/component/datePicker.dart';
import 'package:laporyuk/component/imgPicker.dart';
import 'package:laporyuk/component/url.dart';
import 'package:laporyuk/pages/riwayatLaporan.dart';

class EditLaporan extends StatefulWidget {
  final Map<String, dynamic> detailLaporan;
  final int idAduan;

  const EditLaporan({Key? key, required this.detailLaporan, required this.idAduan}) : super(key: key);

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
  String? idAduan;
  String? _judulAduan;
  String? _deskripsiAduan;
  String? _alamatAduan;
  String? _tanggal;

  final Map<String, String> jenisMap = {
    'Fasilitas Umum': '1',
    'Pelayanan Publik': '2',
    'Pelayanan Kesehatan': '3',
    'Pelayanan Kebersihan': '4'
  };

  @override
  void initState() {
    super.initState();
    idAduan = widget.idAduan.toString();
    _initValues();
    _fetchKecamatanData();
  }

  void _initValues() {
    _judulController.text = widget.detailLaporan['judul_aduan'] ?? '';
    _deskripsiController.text = widget.detailLaporan['deskripsi_aduan'] ?? '';
    _alamatController.text = widget.detailLaporan['alamat_aduan'] ?? '';
    _dateController.text = widget.detailLaporan['tanggal'] ?? '';
    _selectedKecamatan = widget.detailLaporan['nama_kecamatan'];
    _selectedJenis = _getJenisFromValue(widget.detailLaporan['jenis_aduan']);
    _judulAduan = widget.detailLaporan['judul_aduan'];
    _deskripsiAduan = widget.detailLaporan['deskripsi_aduan'];
    _alamatAduan = widget.detailLaporan['alamat_aduan'];
    _tanggal = widget.detailLaporan['tanggal'];
  }

  String? _getJenisFromValue(String? value) {
    return jenisMap.keys.firstWhere((k) => jenisMap[k] == value, orElse: () => "");
  }

  Future<void> _fetchKecamatanData() async {
    final apiUrl = ApiUrl.apiUrl + 'mobilelaporan/get_kecamatan';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _kecamatanList = data.map((item) => item['nama_kecamatan'].toString()).toList();
          if (_selectedKecamatan != null && !_kecamatanList.contains(_selectedKecamatan)) {
            _selectedKecamatan = _kecamatanList.isNotEmpty ? _kecamatanList.first : null;
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
    debugPrint('Nilai selectedKecamatan saat build: $_selectedKecamatan');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Laporan'),
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
                          hintText: _judulAduan,
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
                          hintText: _deskripsiAduan,
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
                          hintText: _alamatAduan,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        value: _kecamatanList.contains(_selectedKecamatan) ? _selectedKecamatan : null,
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
                        value: _jenisList.contains(_selectedJenis) ? _selectedJenis : null,
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
    final idKecamatan = _kecamatanList.indexOf(_selectedKecamatan!) + 1;
    final idJenis = jenisMap[_selectedJenis] ?? '';

    final data = {
      'idAduan': int.parse(idAduan!),
      'judul': _judulController.text,
      'deskripsi': _deskripsiController.text,
      'alamat': _alamatController.text,
      'id_kecamatan': idKecamatan,
      'jenis': idJenis,
      'tanggal': _dateController.text,
      'image': _pickedImage != null ? base64Encode(_pickedImage!.readAsBytesSync()) : '',
    };

    print('Data yang dikirim: $data');

    final apiUrl = '${ApiUrl.apiUrl}mobilelaporan/update_laporan/${data['idAduan']}';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.body.trim() == 'NULL') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unexpected server response')));
        return;
      }

      dynamic responseBody;
      try {
        responseBody = jsonDecode(response.body);
      } catch (e) {
        print('Error decoding response body: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unexpected server response')));
        return;
      }

      if (response.statusCode == 200) {
        if (responseBody != null && responseBody['message'] != null) {
          final message = responseBody['message'];
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RiwayatLaporan()),
          );
        } else if (responseBody != null && responseBody['error'] != null) {
          final errorMessage = responseBody['error'];
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unknown response format')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update data')));
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    }
  }
}
