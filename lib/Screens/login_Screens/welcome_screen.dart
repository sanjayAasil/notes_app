import 'package:flutter/material.dart';
import 'package:sanjay_notes/routes.dart';

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
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 60),
                child: Text(
                  'Keep Notes',
                  style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 100),
            Icon(
              Icons.lightbulb_outline_rounded,
              size: 150,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              'Welcome Back !',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35,
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () => Navigator.of(context).pushNamed(Routes.signInScreen),
              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                    child: Text(
                  'SIGN IN',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                )),
              ),
            ),
            SizedBox(height: 20),
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
                child: Center(
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.g_mobiledata_rounded,
                    color: Colors.white,
                    size: 90,
                  ),
                ),
                Text(
                  '--OR--',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Icon(
                      Icons.phone_outlined,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
