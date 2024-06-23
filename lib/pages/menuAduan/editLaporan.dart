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
  String? _judulAduan;
  String? _deskripsiAduan;
  String? _alamatAduan;
  String? _tanggal;

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
        _judulController.text = data['judul_aduan'] ?? '';
        _deskripsiController.text = data['deskripsi_aduan'] ?? '';
        _alamatController.text = data['alamat_aduan'] ?? '';
        _dateController.text = data['tanggal'] ?? '';

        // Initialize _selectedKecamatan and _selectedJenis with existing values
        _selectedKecamatan = data['kecamatan'];
        _selectedJenis = data['jenis_aduan'];

        // If _selectedKecamatan is null or not found in _kecamatanList, default to the first item
        if (_selectedKecamatan == null || !_kecamatanList.contains(_selectedKecamatan)) {
          _selectedKecamatan = _kecamatanList.isNotEmpty ? _kecamatanList.first : null;
        }

        // If _selectedJenis is null or not found in _jenisList, default to the first item
        if (_selectedJenis == null || !_jenisList.contains(_selectedJenis)) {
          _selectedJenis = _jenisList.isNotEmpty ? _jenisList.first : null;
        }

        // Ensure these variables are also updated for displaying hints
        _judulAduan = data['judul_aduan'];
        _deskripsiAduan = data['deskripsi_aduan'];
        _alamatAduan = data['alamat_aduan'];
        _tanggal = data['tanggal'];
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

    print('Judul Laporan: ${_judulController.text}');
    print('Deskripsi Laporan: ${_deskripsiController.text}');
    print('Alamat Lengkap Kejadian: ${_alamatController.text}');
    print('ID Kecamatan: $idKecamatan');
    print('Jenis Laporan: $idJenis');
    if (_pickedImage != null) {
      print('Bukti Laporan: ${_pickedImage!.path}');
    }

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

    final apiUrl = '${ApiUrl.apiUrl}update_laporan.php';
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
