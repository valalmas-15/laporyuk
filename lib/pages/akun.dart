import 'package:flutter/material.dart';
import 'package:laporyuk/component/acc_textfield.dart';
import 'package:laporyuk/widgets/drawer.dart'; // Import drawer widget

class Akun extends StatelessWidget {
  Akun({Key? key}) : super(key: key);

  // Controllers for the text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(57, 167, 255, 1),
        title: const Text('Akun'),
      ),
      drawer: const AppDrawer(), // Gunakan widget drawer yang sudah dibuat
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            AccTextField(
              controller: _nameController,
              hintText: 'Nama',
            ),
            AccTextField(
              controller: _phoneNumberController,
              hintText: 'Nomor Telepon',
            ),
            ElevatedButton(
              onPressed: () {
                // Handle save button pressed
                // Example: saveData(_nameController.text, _phoneNumberController.text);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
