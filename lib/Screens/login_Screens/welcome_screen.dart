import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/Database/data_manager.dart';
import 'package:sanjay_notes/firebase/firebase_auth_manager.dart';
import 'package:sanjay_notes/routes.dart';
import 'package:versatile_dialogs/loading_dialog.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, top: 60),
                child: Text(
                  'Keep Notes',
                  style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 100),
            const Icon(
              Icons.lightbulb_outline_rounded,
              size: 150,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            const Text(
              'Welcome Back !',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35,
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => Navigator.of(context).pushNamed(Routes.signInScreen),
              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Center(
                    child: Text(
                  'SIGN IN',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                )),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => Navigator.of(context).pushNamed(Routes.signUpScreen),
              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Center(
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    await signInGoogle(context);
                  },
                  child: const Icon(
                    Icons.g_mobiledata_rounded,
                    color: Colors.white,
                    size: 90,
                  ),
                ),
                const Text(
                  '--OR--',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pushNamed(Routes.phoneNumberLoginScreen),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Icon(
                      Icons.phone_outlined,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  signInGoogle(BuildContext context) async {
    try {
      debugPrint("_WelcomeScreenState signIn: ");
      LoadingDialog loadingDialog = LoadingDialog(progressbarColor: Colors.blue.shade700)..show(context);
      final User? user = await FirebaseAuthManager().signInWithGoogle(context);
      if (context.mounted) {
        loadingDialog.dismiss(context);
        Navigator.of(context).popAndPushNamed(Routes.mainScreen);
      }
      if (user == null) return null;
      DataManager().user = user;

      if (context.mounted) {
        loadingDialog.dismiss(context);
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.mainScreen, (route) => false);
      }
    } catch (e, stack) {
      debugPrint("_WelcomeScreenState signIn: error occurred $e, $stack");
    }
  }
}
