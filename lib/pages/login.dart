import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:laporyuk/component/loginReg/acc_textfield.dart';
import 'package:laporyuk/component/textbutton.dart';
import 'package:laporyuk/component/url.dart';
import 'package:laporyuk/pages/dashboard.dart';
import 'package:laporyuk/pages/register.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  final usernameController = TextEditingController();
  final numberController = TextEditingController();

  void login(BuildContext context) async {
  final username = usernameController.text;
  final number = numberController.text;

  final url = ApiUrl.apiUrl + 'mobileuser/login'; // replace with your CI3 backend URL

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Username': username,
        'noHP': number,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success') {
        // Handle successful login
        print('Login successful');
        // Save session information using SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('idUser', responseData['idUser']); // Store as String
        prefs.setString('Username', responseData['Username']);
        prefs.setString('Nama', responseData['Nama']);
        prefs.setString('noHP', responseData['noHP']);

        // Navigate to Dashboard
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      } else {
        // Handle login failure
        print('Login failed: ${responseData['message']}');
        // Show error message to the user if needed
      }
    } else {
      print(
          'Failed to login. Status code: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to login');
    }
  } catch (e) {
    print('An error occurred: $e');
    // Show error message to the user if needed
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
                'Sign In',
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
                  height: screenHeight * 0.491,
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
                // Login button
                TextButton(
                  onPressed: () {
                    login(context);
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 35.0),
                        child: Text(
                          'Login',
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
                        text: 'Daftar',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
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
                    bottom: MediaQuery.of(context).viewInsets.bottom))
          ],
        ),
      ),
    );
  }
}
