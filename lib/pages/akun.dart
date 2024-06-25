import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:laporyuk/component/acc_textfield.dart';
import 'package:laporyuk/component/url.dart';
import 'package:laporyuk/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Akun extends StatefulWidget {
  final int userId;

  Akun({Key? key, required this.userId}) : super(key: key);

  @override
  _AkunState createState() => _AkunState();
}

class _AkunState extends State<Akun> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  late Future<Map<String, dynamic>> futureUserData;

  @override
  void initState() {
    super.initState();
    futureUserData = fetchUserData();
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('Username') ?? '';
      final nama = prefs.getString('Nama') ?? '';
      final noHP = prefs.getString('noHP') ?? '';

      _nameController.text = nama;
      _userNameController.text = username;
      _phoneNumberController.text = noHP;

      return {
        'Username': username,
        'Nama': nama,
        'noHP': noHP,
      };
    } catch (e) {
      print('Error fetching user data: $e');
      return {}; // Return an empty map if fetch fails
    }
  }

  Future<void> _updateAccount() async {
  final String apiUrl = ApiUrl.apiUrl + 'Mobileuser/update_akun';

  try {
    final Map<String, String> updatedData = {
      'idUser': widget.userId.toString(),
      'username': _userNameController.text,
      'nama': _nameController.text,
      'noHP': _phoneNumberController.text,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      body: updatedData,
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data akun berhasil diperbarui')),
      );

      final prefs = await SharedPreferences.getInstance();
      // Clear existing session data except idUser
      final idUser = prefs.getString('idUser'); // Preserve idUser
      await prefs.clear(); // Clear all existing session data
      // Set new session data
      prefs.setString('idUser', idUser ?? ''); // Set idUser back

      // Set new session data from updated values
      prefs.setString('Username', _userNameController.text);
      prefs.setString('Nama', _nameController.text);
      prefs.setString('noHP', _phoneNumberController.text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui data akun')),
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
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: const Text('Akun'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureUserData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            Map<String, dynamic> userData = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AccTextField(
                    title: 'Nama',
                    initialValue: userData['Nama'],
                    controller: _nameController,
                  ),
                  AccTextField(
                    title: 'Username',
                    initialValue: userData['Username'],
                    controller: _userNameController,
                  ),
                  AccTextField(
                    title: 'Nomor Handphone',
                    initialValue: userData['noHP'],
                    controller: _phoneNumberController,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateAccount,
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
