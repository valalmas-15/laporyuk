import 'dart:io';

import 'package:flutter/material.dart';
import 'package:laporyuk/component/datePicker.dart';
import 'package:laporyuk/component/descTxt.dart';
import 'package:laporyuk/component/dropDown.dart';
import 'package:laporyuk/component/imgPicker.dart';
import 'package:laporyuk/component/judulLaporan.dart';

class DetailLaporan extends StatefulWidget {
  @override
  DetailLaporanPage createState() => DetailLaporanPage();

  final String judul;
  final String jenis;
  final String tanggal;
  final String status;
  final String deskripsi;

  DetailLaporan({
    required this.judul,
    required this.jenis,
    required this.tanggal,
    required this.status,
    required this.deskripsi,
  });
}

class DetailLaporanPage extends State<DetailLaporan> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _judulController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  File? _pickedImage;
  List<String> _dropdownItems = ['Layanan Medis 1', 'Layanan Medis 2', 'Layanan Medis 3'];
  String? _selectedDropdownItem;
  bool _showSubmitButton = true; // Flag to control submit button visibility

  @override
  void initState() {
    super.initState();
    _judulController.text = widget.judul;
    _dateController.text = widget.tanggal;
    _deskripsiController.text = widget.deskripsi;
    // Initialize other controllers as needed
    _checkStatus(); // Check initial status
  }

  void _checkStatus() {
    // Check if status is "Selesai", then hide the submit button
    if (widget.status == 'Selesai') {
      setState(() {
        _showSubmitButton = false;
      });
    } else {
      setState(() {
        _showSubmitButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Laporan'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Judul laporan
            JudulLaporan(
              controller: _judulController,
              hintText: 'Judul Laporan',
            ),

            // Deskripsi laporan
            DescriptionTextField(
              controller: _deskripsiController,
              hintText: 'Deskripsi Laporan',
              prefixIcon: Icons.description,
            ),

            // Tanggal laporan
            DatePickerWidget(controller: _dateController),

            // Dropdown untuk layanan medis
            DropdownWidget(
              items: _dropdownItems,
              onChanged: (value) {
                setState(() {
                  _selectedDropdownItem = value;
                });
              },
            ),

            // Alamat kejadian
            DescriptionTextField(controller: _alamatController, hintText: 'Alamat Kejadian'),

            // Bukti laporan
            ImagePickerWidget(
              onImageSelected: (File pickedImage) {
                setState(() {
                  _pickedImage = pickedImage;
                });
              },
            ),

            SizedBox(height: 60),

            // Tombol submit (ditampilkan hanya jika status tidak "Selesai")
            if (_showSubmitButton)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                child: ElevatedButton(
                  onPressed: () {
                    _submitForm();
                  },
                  child: Text('Kirim Laporan'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    // Implement form submission logic here
    String judul = _judulController.text.trim();
    String deskripsi = _deskripsiController.text.trim();
    String tanggal = _dateController.text.trim();
    String alamat = _alamatController.text.trim();
    // Perform validation and submission
    // Example validation: Ensure all fields are filled
    if (judul.isEmpty || deskripsi.isEmpty || tanggal.isEmpty || alamat.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please fill in all fields.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    // Once validated, proceed with submission
    // Here you can send the data to your backend or perform any required actions
  }
}
