import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:laporyuk/component/loginReg/acc_textfield.dart';
import 'package:laporyuk/component/textbutton.dart';
import 'package:laporyuk/component/url.dart';
import 'package:laporyuk/pages/login.dart';
import 'package:http/http.dart' as http;

class Register extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  void register(BuildContext context) async {
    final username = usernameController.text;
    final number = numberController.text;
    final name = nameController.text;

    final url = ApiUrl.apiUrl + 'mobileuser/register'; // replace with your CI3 backend URL

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'Username': username,
          'noHP': number,
          'Nama': name,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          // Handle successful login
          print('Login successful');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        } else {
          // Handle login failure
          print('Login failed: ${responseData['message']}');
        }
      } else {
        print('Failed to login. Status code: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(135, 196, 255, 1),
      body: SingleChildScrollView(
        reverse: true,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: -42,
              top: -80,
              child: Container(
                width: 566,
                height: screenHeight, // Use screenHeight here
                child: Stack(
                  children: [
                    Positioned(
                      left: 290,
                      top: 266,
                      child: Container(
                        width: 276,
                        height: 234,
                        decoration: ShapeDecoration(
                          color: Color(0xFFE0F4FF),
                          shape: OvalBorder(),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Opacity(
                        opacity: 0.70,
                        child: Container(
                          width: 508,
                          height: 429,
                          decoration: ShapeDecoration(
                            color: Color(0xFF39A7FF),
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 317,
                        height: 276,
                        decoration: ShapeDecoration(
                          color: Color(0xFFE0F4FF),
                          shape: OvalBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 38,
              top: 221,
              child: Text(
                'Sign Up',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  height: 0,
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.410,
                ),
                // Nama textfield
                AccTextField(
                  controller: nameController,
                  hintText: 'Nama',
                ),
                // Username textfield
                AccTextField(
                  controller: usernameController,
                  hintText: 'Username',
                ),
                // Number textfield
                AccTextField(
                  controller: numberController,
                  hintText: 'Nomor HandPhone',
                ),
                // Register button
                TextButton(
                  onPressed: () {
                    register(context);
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 35.0),
                        child: Text(
                          'Buat Akun',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                            height: 0,
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Icon(
                          Icons.arrow_circle_right,
                          size: 60.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.070,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: MyTextButton(
                        text: 'Login',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        fontsize: 20.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
            )
          ],
        ),
      ),
    );
  }
}
