import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:versatile_dialogs/loading_dialog.dart';

import '../../common/utils.dart';
import '../../database/data_manager.dart';
import '../../firebase/firebase_auth_manager.dart';
import '../../routes.dart';

class PhoneNumberLoginScreen extends StatefulWidget {
  const PhoneNumberLoginScreen({super.key});

  @override
  State<PhoneNumberLoginScreen> createState() => _PhoneNumberLoginScreenState();
}

class _PhoneNumberLoginScreenState extends State<PhoneNumberLoginScreen> {
  bool otpSent = false;
  TextEditingController phoneNumberController = TextEditingController(text: '+91');
  TextEditingController otpController = TextEditingController();
  String verificationId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.yellow.shade700,
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, top: const MediaQueryData().padding.top + 60),
              child: const Text('Sign In with\nMobile Number!', style: TextStyle(fontSize: 30, color: Colors.white)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerLeft,
                      child:
                          otpSent
                              ? Text(
                                'OTP',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.yellow.shade700),
                              )
                              : Text(
                                'Phone Number',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                              ),
                    ),
                    if (otpSent)
                      TextField(
                        textInputAction: TextInputAction.next,
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter OTP',
                          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
                        ),
                      )
                    else
                      TextField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Enter Mobile Number',
                          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
                        ),
                      ),
                    const SizedBox(height: 70),
                    if (otpSent)
                      InkWell(
                        onTap: () async {
                          debugPrint("_PhoneNumberLoginScreenState build: check init submit");
                          LoadingDialog loadingDialog = LoadingDialog(
                            message: 'Signing In',
                            progressbarColor: Colors.yellow.shade700,
                          )..show(context);
                          User? user = await FirebaseAuthManager().signInWithOtp(
                            context,
                            otpController.text.trim(),
                            verificationId,
                          );
                          Utils.clearDataManagerData();
                          if (context.mounted) {
                            DataManager().user = user;
                            loadingDialog.dismiss(context);
                            Navigator.of(context).pushNamedAndRemoveUntil(Routes.mainScreen, (route) => false);
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 300,
                          color: Colors.yellow.shade700,
                          child: const Center(
                            child: Text(
                              'Submit',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    else
                      InkWell(
                        onTap: () async {
                          if (phoneNumberController.text.trim().isEmpty ||
                              phoneNumberController.text.trim().length < 13) {
                            return;
                          }
                          LoadingDialog loadingDialog = LoadingDialog(
                            message: 'Verifying',
                            progressbarColor: Colors.yellow.shade700,
                          )..show(context);

                          await FirebaseAuthManager().requestOTP(context, phoneNumberController.text.trim(), (
                            verificationId,
                            forceResendingToken,
                          ) {
                            this.verificationId = verificationId;
                          });
                          setState(() => otpSent = true);
                          if (context.mounted) {
                            loadingDialog.dismiss(context);
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 300,
                          color: Colors.yellow.shade700,
                          child: const Center(
                            child: Text(
                              'Send OTP',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
