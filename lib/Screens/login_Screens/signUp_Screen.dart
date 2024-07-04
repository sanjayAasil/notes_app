import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:sanjay_notes/firebase/firebase_auth_manager.dart';
import 'package:sanjay_notes/routes.dart';
import 'package:versatile_dialogs/loading_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conformPasswordController = TextEditingController();
  bool toggleShowPassword = true;
  bool toggleShowConformPassword = true;

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
              padding: EdgeInsets.only(left: 20.0, top: const MediaQueryData().padding.top + 60),
              child: const Text(
                'Create Your\nAccount',
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
              decoration: const BoxDecoration(
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
                    const SizedBox(height: 40),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: 'Enter Mail Id',
                          label: Text(
                            'Email',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                          )),
                    ),
                    StatefulBuilder(builder: (context, setState) {
                      return TextField(
                        obscureText: toggleShowPassword,
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: 'Enter Password',
                          suffixIcon: !toggleShowPassword
                              ? IconButton(
                                  color: Colors.grey,
                                  onPressed: () => setState(() => toggleShowPassword = !toggleShowPassword),
                                  icon: const Icon(Icons.visibility),
                                )
                              : IconButton(
                                  color: Colors.grey,
                                  onPressed: () => setState(() => toggleShowPassword = !toggleShowPassword),
                                  icon: const Icon(Icons.visibility_off),
                                ),
                          label: Text(
                            'Password',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                          ),
                        ),
                      );
                    }),
                    StatefulBuilder(builder: (context, setState) {
                      return TextField(
                        obscureText: toggleShowConformPassword,
                        controller: conformPasswordController,
                        decoration: InputDecoration(
                          hintText: 'Conform Password',
                          suffixIcon: !toggleShowConformPassword
                              ? IconButton(
                                  color: Colors.grey,
                                  onPressed: () =>
                                      setState(() => toggleShowConformPassword = !toggleShowConformPassword),
                                  icon: const Icon(Icons.visibility),
                                )
                              : IconButton(
                                  color: Colors.grey,
                                  onPressed: () =>
                                      setState(() => toggleShowConformPassword = !toggleShowConformPassword),
                                  icon: const Icon(Icons.visibility_off),
                                ),
                          label: Text(
                            'Password',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 35),
                    InkWell(
                      onTap: () async {
                        if (emailController.text.trim().isEmpty ||
                            passwordController.text.trim().isEmpty ||
                            conformPasswordController.text.trim().isEmpty) return;
                        if (passwordController.text.trim() != conformPasswordController.text.trim()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Password should be same')),
                          );
                          return;
                        }

                        await signUp(context, emailController.text, passwordController.text);
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
                        child: const Center(
                          child: Text(
                            'SIGN UP',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
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

signUp(BuildContext context, String email, String password) async {
  LoadingDialog loadingDialog = LoadingDialog(progressbarColor: Colors.blue.shade700, message: 'Verifying')
    ..show(context);

  User? user = await FirebaseAuthManager().signUpWithEmail(email, password, context);
  if (user == null) {
    if (context.mounted) {
      loadingDialog.dismiss(context);
    }
    return null;
  }
  if (context.mounted) {
    loadingDialog.dismiss(context);

    Navigator.of(context).pushNamedAndRemoveUntil(Routes.mainScreen, (route) => false);
  }
  debugPrint(" signUp: signedUp Successfully $user");
}
