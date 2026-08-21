import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:versatile_dialogs/loading_dialog.dart';

import '../../common/responsive.dart';
import '../../common/utils.dart';
import '../../database/data_manager.dart';
import '../../firebase/firebase_auth_manager.dart';
import '../../routes.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    final bool isTablet = Responsive.isTablet(context);
    final bool isLargeScreen = isDesktop || isTablet;

    return Scaffold(
      backgroundColor: Colors.yellow.shade700,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: isDesktop ? 1000 : 600),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isLargeScreen)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Keep Notes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isDesktop ? 48 : 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: isDesktop ? 60 : 40),
                              Icon(
                                Icons.lightbulb_outline_rounded,
                                size: isDesktop ? 200 : 150,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Welcome Back !',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isDesktop ? 40 : 32,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          flex: 4,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildActionButtons(),
                              const SizedBox(height: 40),
                              _buildAlternativeLogins(),
                              const SizedBox(height: 32),
                              _buildSkipButton(),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        Text(
                          'Keep Notes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Icon(
                          Icons.lightbulb_outline_rounded,
                          size: 150,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Welcome Back !',
                          style: TextStyle(color: Colors.white, fontSize: 35),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 48),
                        _buildActionButtons(),
                        const SizedBox(height: 32),
                        _buildAlternativeLogins(),
                        const SizedBox(height: 24),
                        _buildSkipButton(),
                      ],
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildButton(
          text: 'SIGN IN',
          onTap: () => Navigator.of(context).pushNamed(Routes.signInScreen),
          isOutlined: true,
        ),
        const SizedBox(height: 20),
        _buildButton(
          text: 'SIGN UP',
          onTap: () => Navigator.of(context).pushNamed(Routes.signUpScreen),
          isOutlined: false,
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onTap,
    required bool isOutlined,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        height: 56,
        width: 320,
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : Colors.white,
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isOutlined ? Colors.white : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlternativeLogins() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async => await signInGoogle(context),
          borderRadius: BorderRadius.circular(45),
          child: const Icon(
            Icons.g_mobiledata_rounded,
            color: Colors.white,
            size: 90,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '-- OR --',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        InkWell(
          onTap:
              () => Navigator.of(
                context,
              ).pushNamed(Routes.phoneNumberLoginScreen),
          borderRadius: BorderRadius.circular(25),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.phone_outlined, color: Colors.white, size: 45),
          ),
        ),
      ],
    );
  }

  Widget _buildSkipButton() {
    return TextButton(
      onPressed: _onSkipPressed,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Skip",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
          Icon(Icons.arrow_right, color: Colors.white),
        ],
      ),
    );
  }

  Future<void> _onSkipPressed() async {
    try {
      LoadingDialog loadingDialog = LoadingDialog(
        progressbarColor: Colors.yellow,
      )..show(context);
      final User? user = await FirebaseAuthManager().anonymousLogin();

      if (mounted) {
        loadingDialog.dismiss(context);
      }
      if (user == null) return;

      DataManager().user = user;
      Utils.clearDataManagerData();
      DataManager().notify();

      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(Routes.mainScreen, (route) => false);
      }
    } catch (e, stack) {
      debugPrint("_WelcomeScreenState _onSkipPressed error: $e");
      debugPrintStack(stackTrace: stack);
    }
  }

  Future<void> signInGoogle(BuildContext context) async {
    try {
      LoadingDialog loadingDialog = LoadingDialog(
        progressbarColor: Colors.yellow,
      )..show(context);
      final User? user = await FirebaseAuthManager().signInWithGoogle();

      if (context.mounted) {
        loadingDialog.dismiss(context);
      }
      if (user == null) return;

      DataManager().user = user;
      Utils.clearDataManagerData();
      DataManager().notify();

      if (context.mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(Routes.mainScreen, (route) => false);
      }
    } catch (e, stack) {
      debugPrint("_WelcomeScreenState signInGoogle error: $e");
      debugPrintStack(stackTrace: stack);
    }
  }
}
