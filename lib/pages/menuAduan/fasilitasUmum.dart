import 'dart:io';

import 'package:flutter/material.dart';
import 'package:laporyuk/component/descTxt.dart';
import 'package:laporyuk/component/dropDown.dart';
import 'package:laporyuk/component/judulLaporan.dart';
import 'package:location/location.dart' as location;

import 'package:laporyuk/component/datePicker.dart';
import 'package:laporyuk/component/locationPicker.dart';
import 'package:laporyuk/component/imgPicker.dart';

class FasilitasUmum extends StatefulWidget {
  @override
  _FasilitasUmum createState() => _FasilitasUmum();
}

class _FasilitasUmum extends State<FasilitasUmum> {
  location.Location _locationService = location.Location();

  TextEditingController _dateController = TextEditingController();
  TextEditingController _judulController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  File? _pickedImage;
  location.LocationData? _locationData;
  List<String> _dropdownItems = ['Layanan Medis 1', 'Layanan Medis 2', 'Layanan Medis 3'];
  String? _selectedDropdownItem;


  @override
  void initState() {
    super.initState();
    _checkLocationService();
  }

  Future<void> _checkLocationService() async {
    bool _serviceEnabled = await _locationService.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationService.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    location.PermissionStatus _permissionGranted = await _locationService.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      _permissionGranted = await _locationService.requestPermission();
      if (_permissionGranted != location.PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await _locationService.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaduan Fasilitas Umum'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // judul laporan
            JudulLaporan(
              controller: _judulController,
              hintText: 'Judul Laporan',
            ),

            // deskripsi laporan
            DescriptionTextField(
              controller: _deskripsiController,
              hintText: 'Deskripsi Laporan',
              prefixIcon: Icons.description,
            ),

            // tanggal laporan
            DatePickerWidget(controller: _dateController),

            // lokasi laporan
            DropdownWidget(
              items: _dropdownItems,
              onChanged: (value) {
                setState(() {
                  _selectedDropdownItem = value;
                });
              },
            ),
            DescriptionTextField(controller: _alamatController, hintText: 'Alamat Lengkap Kejadian'),


            // bukti laporan
            ImagePickerWidget(
              onImageSelected: (File pickedImage) {
                setState(() {
                  _pickedImage = pickedImage;
                });
              },
            ),

            SizedBox(height: 60,),

            // tombol submit
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
              child: ElevatedButton(
                onPressed: () {
                  // Handle submit logic here
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
    // Implement logic to submit the form data
    // Here you can use _judulController.text, _dateController.text, _locationData, _selectedDropdownItem, _pickedImage, etc.
    // Example:
    print('Judul Laporan: ${_judulController.text}');
    print('Tanggal: ${_dateController.text}');
    if (_locationData != null) {
      print('Latitude: ${_locationData!.latitude}, Longitude: ${_locationData!.longitude}');
    }
    if (_pickedImage != null) {
      print('Bukti Laporan: ${_pickedImage!.path}');
    }
    // Add your submission logic here
  }
}
