import 'package:flutter/material.dart';

class PhoneNumberLoginScreen extends StatefulWidget {
  const PhoneNumberLoginScreen({super.key});

  @override
  State<PhoneNumberLoginScreen> createState() => _PhoneNumberLoginScreenState();
}

class _PhoneNumberLoginScreenState extends State<PhoneNumberLoginScreen> {
  bool otpSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade700,
                  Colors.black,
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, top: MediaQueryData().padding.top + 60),
              child: Text(
                'Sign In with\nMobile Number!',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: otpSent
                          ? Text(
                              'OTP',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                            )
                          : Text(
                              'Phone Number',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                            ),
                    ),
                    otpSent
                        ? TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter OTP',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 15,
                              ),
                            ),
                          )
                        : TextField(
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Enter Mobile Number',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                    SizedBox(height: 70),
                    if (otpSent)
                      Container(
                        height: 50,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.black,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    else
                      InkWell(
                        onTap: () {
                          setState(() {
                            otpSent = true;
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [
                                Colors.blue,
                                Colors.black,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Send OTP',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
