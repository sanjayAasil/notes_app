import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthManager {
  static const clientId =
      "1003473576371-t46btsb406aobc9i5t7auktkmsqjseam.apps.googleusercontent.com";

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(clientId: clientId);

  /// ---------------- GOOGLE SIGN IN ----------------
  Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();

        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithPopup(googleProvider);

        return userCredential.user;
      }

      // Android / iOS
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      return userCredential.user;
    } catch (e, stack) {
      debugPrint('signInWithGoogle error: $e');
      debugPrintStack(stackTrace: stack);
      return null;
    }
  }

  /// ---------------- PHONE AUTH ----------------
  Future<void> requestOTP(
    BuildContext context,
    String phoneNumber,
    Function(String verificationId, int? forceResendingToken) onCodeSent,
  ) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),

        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto sign-in if OTP auto-retrieved
          await auth.signInWithCredential(credential);
        },

        verificationFailed: (FirebaseAuthException e) {
          debugPrint("Phone Verification Failed: ${e.message}");
        },

        codeSent: onCodeSent,

        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("Request OTP Error: ${e.message}");
    }
  }

  Future<User?> signInWithOtp(
    BuildContext context,
    String otp,
    String verificationId,
  ) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      final UserCredential userCredential = await auth.signInWithCredential(
        credential,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint("OTP Sign In Error: ${e.message}");
      return null;
    }
  }

  /// ---------------- EMAIL SIGN UP ----------------
  Future<User?> signUpWithEmail(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);
      debugPrint("signUpWithEmail success");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint("Email Sign Up Error: ${e.message}");
      return null;
    }
  }

  /// ---------------- EMAIL SIGN IN ----------------
  Future<User?> signInWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential = await auth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint("Email Sign In Error: ${e.message}");
      return null;
    }
  }

  /// ---------------- ANONYMOUS LOGIN ----------------
  Future<User?> anonymousLogin() async {
    try {
      final UserCredential userCredential = await auth.signInAnonymously();

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint("Anonymous Login Error: ${e.message}");
      return null;
    }
  }

  /// ---------------- SIGN OUT ----------------
  Future<void> signOut() async {
    try {
      await auth.signOut();
      await googleSignIn.signOut();
    } catch (e) {
      debugPrint("Sign Out Error: $e");
    }
  }
}
