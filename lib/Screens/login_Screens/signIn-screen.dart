import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sanjay_notes/routes.dart';
import 'package:versatile_dialogs/loading_dialog.dart';

import '../../firebase/firebase_auth_manager.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool toggleShowPassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                'Hello,\nSign In!',
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
                    const SizedBox(height: 30),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.check,
                            color: Colors.grey,
                          ),
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
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) return;

                        await _signIn(context, emailController.text.trim(), passwordController.text.trim());
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
                            'SIGN IN',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () => Navigator.of(context).popAndPushNamed(Routes.signUpScreen),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ],
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

_signIn(BuildContext context, String email, String password) async {
  LoadingDialog loadingDialog = LoadingDialog(progressbarColor: Colors.blue.shade700, message: 'Verifying')
    ..show(context);

  User? user = await FirebaseAuthManager().signInWithEmail(context, email, password);
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
