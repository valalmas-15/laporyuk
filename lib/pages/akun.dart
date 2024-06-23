import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:laporyuk/component/acc_textfield.dart';
import 'package:laporyuk/component/url.dart';
import 'package:laporyuk/widgets/drawer.dart';

class Akun extends StatefulWidget {
  final int userId; // Tambahkan userId sebagai parameter

  Akun({Key? key, required this.userId}) : super(key: key);

  @override
  _AkunState createState() => _AkunState();
}

class _AkunState extends State<Akun> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  late Future<Map<String, dynamic>> futureUserData;
  Map<String, dynamic>? originalData;

  @override
  void initState() {
    super.initState();
    futureUserData = fetchUserData(widget.userId);
  }

  Future<Map<String, dynamic>> fetchUserData(int userId) async {
    final response = await http.get(
      Uri.parse(ApiUrl.apiUrl + 'get_user_data.php?id=$userId'),
    );

    if (response.statusCode == 200) {
      originalData = json.decode(response.body);
      return originalData!;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> _updateAccount() async {
    final String apiUrl = ApiUrl.apiUrl + 'update_akun.php';

    try {
      final Map<String, String> updatedData = {
        'idUser': widget.userId.toString(),
        'username': _userNameController.text.isEmpty
            ? originalData!['Username']
            : _userNameController.text,
        'nama': _nameController.text.isEmpty
            ? originalData!['Nama']
            : _nameController.text,
        'noHP': _phoneNumberController.text.isEmpty
            ? originalData!['noHP']
            : _phoneNumberController.text,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        body: updatedData,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data akun berhasil diperbarui')),
        );
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Text('Nama', style: TextStyle(fontSize: 18)),
                      ),
                      AccTextField(
                        controller: _nameController,
                        hintText: userData['Nama'] ?? 'Nama',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Text('Username', style: TextStyle(fontSize: 18)),
                      ),
                      AccTextField(
                        controller: _userNameController,
                        hintText: userData['Username'] ?? 'Username',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Text('Nomor Telepon', style: TextStyle(fontSize: 18)),
                      ),
                      AccTextField(
                        controller: _phoneNumberController,
                        hintText: userData['noHP'] ?? 'Nomor Telepon',
                      ),
                    ],
                  ),
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
