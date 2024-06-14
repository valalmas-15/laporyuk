import 'package:flutter/material.dart';
import 'package:laporyuk/component/acc_textfield.dart';

class isiLogin extends StatelessWidget {
  final usernameController = TextEditingController();
  final numberController = TextEditingController();

  
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(135, 196, 255, 1),
      body: Stack(
        children: [
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
          Positioned(
            left: screenWidth * 0.730,
            top: screenHeight * 0.90, // Use screenHeight here
            child: Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
          ),
          Positioned(
            left: screenWidth * 0.065,
            top: screenHeight * 0.740, // Use screenHeight here
            child: Text(
              'Buat Akun',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 450,
              ),
              //Username textfield
              AccTextField(
                controller: usernameController,
                hintText: 'Username',
              ),

              //Number textfield
              AccTextField(
                controller: numberController,
                hintText: 'Nomor HandPhone',
              ),
              
            ],
          ),
        ],
      ),
    );
  }
}
