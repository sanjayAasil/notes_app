import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthManager {
  signInWithGoogle() async {
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
    var user = await FirebaseAuth.instance.signInWithCredential(credential);

    debugPrint("FirebaseAuthManager signInWithGoogle: user $user and ${FirebaseAuth.instance.currentUser}");
  }
}
