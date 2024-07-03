import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthManager {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      debugPrint("FirebaseAuthManager signInWithGoogle: ");

      //Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      //obtain the auth details from request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      if (googleAuth == null) return null;

      //create new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      //once signedIn, return the UserCredential
      UserCredential userCredential = await auth.signInWithCredential(credential);
      debugPrint("FirebaseAuthManager signInWithGoogle: user ${userCredential.user} and ${auth.currentUser}");

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: SnackBar(
            content: Text(' ${e.message}'),
          )),
        );
      }

      return null;
    }
  }

  Future<void> requestOTP(
    BuildContext context,
    String phoneNumber,
    Function(String verificationId, int? forceResendingToken) onCodeSent,
  ) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          //Auto-retrieved verification completed
          await auth.signInWithCredential(phoneAuthCredential);
          debugPrint("FirebaseAuthManager requestOTP: verificationCompleted");
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: SnackBar(
              content: Text(' ${e.message}'),
            )),
          );
        },
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          debugPrint("FirebaseAuthManager requestOTP: codeAutoRetrieval Timedout");
          //timeout for auto phone resolution
        },
      );
    } catch (e) {
      debugPrint("FirebaseAuthManager requestOTP: $e");
    }
  }

  Future<User?> signInWithOtp(String otp, String verificationId) async {
    try {
      debugPrint("FirebaseAuthManager signInWithOtp: check $verificationId");
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      debugPrint("FirebaseAuthManager signInWithOtp: chec");

      final UserCredential userCredential = await auth.signInWithCredential(credential);
      debugPrint("FirebaseAuthManager signInWithOtp: $credential");
      return userCredential.user;
    } catch (e) {
      debugPrint("FirebaseAuthManager signInWithOtp: $e");
      return null;
    }
  }

  Future<User?> signUpWithEmail(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
          ),
        );
      }
      return null;
    }
  }

  Future<User?> signInWithEmail(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
          ),
        );
      }
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
      await googleSignIn.signOut();
      debugPrint("FirebaseAuthManager signOut: signedOut successfully");
    } catch (e) {
      debugPrint("FirebaseAuthManager signOut: $e");
    }
  }
}
