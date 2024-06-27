import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:laporyuk/component/imgPicker.dart';
import 'package:laporyuk/component/url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TambahLaporanScreen(jenisLaporan: 1), // Ubah sesuai jenis aduan
    );
  }
}

class TambahLaporanScreen extends StatefulWidget {
  final int jenisLaporan;

  TambahLaporanScreen({required this.jenisLaporan});

  @override
  _TambahLaporanScreenState createState() => _TambahLaporanScreenState();
}

class _TambahLaporanScreenState extends State<TambahLaporanScreen> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final List<Map<String, dynamic>> _kecamatanList = [];
  File? _pickedImage;
  String? _selectedKecamatan;
  String? _userId;
  String jenis_laporan = '';

  @override
  void initState() {
    super.initState();
    _loadKecamatan();
    _loadUserId();
    _initJenisLaporan(widget.jenisLaporan);
  }
  

  Future<void> _loadKecamatan() async {
    final response = await http.get(Uri.parse(ApiUrl.apiUrl+'/mobilelaporan/get_kecamatan'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _kecamatanList.addAll(data.map((item) {
          return {
            'idKecamatan': item['idKecamatan'],
            'nama_kecamatan': item['nama_kecamatan']
          };
        }).toList());
      });
    }
  }

  Future<void> _loadUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    _userId = prefs.getString('idUser');
  });
}


  Future<void> _pickImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    setState(() {
      _pickedImage = File(pickedFile.path);
      String fileName = path.basename(pickedFile.path); 
      print('Picked image file name: $fileName');
    });
  }
}

  Future<void> _submitForm() async {
  if (_userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User ID not found. Please login again.')),
    );
    return;
  }
  if (_judulController.text.isEmpty ||
      _deskripsiController.text.isEmpty ||
      _dateController.text.isEmpty ||
      _alamatController.text.isEmpty ||
      _selectedKecamatan == null ||
      _pickedImage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill all fields')),
    );
    return;
  }

  var uri = Uri.parse(ApiUrl.apiUrl + 'mobilelaporan/upload_aduan');
  var request = http.MultipartRequest('POST', uri);
  request.fields['judul_aduan'] = _judulController.text;
  request.fields['deskripsi_aduan'] = _deskripsiController.text;
  request.fields['tanggal'] = _dateController.text;
  request.fields['alamat_aduan'] = _alamatController.text;
  request.fields['idKecamatan'] = _selectedKecamatan!;
  request.fields['idUser'] = _userId.toString();
  request.fields['status_aduan'] = '1';
  request.fields['jenis_aduan'] = widget.jenisLaporan.toString();
  request.files.add(await http.MultipartFile.fromPath('foto_aduan', _pickedImage!.path));

  try {
    var response = await request.send();
    
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Laporan berhasil ditambahkan')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan laporan')),
      );
    }
  
    // Read response from server
    var responseData = await response.stream.bytesToString();
    print('Server Response: $responseData');
  } catch (e) {
    print('Error during HTTP request: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
  // Debugging: Print request data to console
  print('=======================');
  print('Request Data:');
  print('judul_aduan: ${request.fields['judul_aduan']}');
  print('deskripsi_aduan: ${request.fields['deskripsi_aduan']}');
  print('tanggal: ${request.fields['tanggal']}');
  print('alamat_aduan: ${request.fields['alamat_aduan']}');
  print('idKecamatan: ${request.fields['idKecamatan']}');
  print('idUser: ${request.fields['idUser']}');
  print('status_aduan: ${request.fields['status_aduan']}');
  print('jenis_aduan: ${request.fields['jenis_aduan']}');
  print('foto_aduan: ${_pickedImage!.path}');
  print('=======================');
}
void _initJenisLaporan(int jenisLaporan) {
  switch (jenisLaporan) {
    case 1:
      jenis_laporan = 'Fasilitas Umum';
      break;
    case 2:
      jenis_laporan = 'Pelayanan Publik';
      break;
    case 3:
      jenis_laporan = 'Pelayanan Kesehatan';
      break;
    case 4:
      jenis_laporan = 'Pelayanan Kebersihan';
      break;
    default:
      jenis_laporan = 'Laporan Tidak Valid';
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Aduan '+jenis_laporan),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white,
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
              child: TextFormField(
            controller: _dateController,
            decoration: InputDecoration(
              labelText: 'Tanggal Kejadian',
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                setState(() {
              _dateController.text = pickedDate.toString().substring(0, 10);
                });
              }
            },
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
            items: _kecamatanList.map((kecamatan) {
              return DropdownMenuItem<String>(
                value: kecamatan['idKecamatan'].toString(),
                child: Text(kecamatan['nama_kecamatan']),
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
              child: ElevatedButton(
            onPressed: _submitForm,
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
}
