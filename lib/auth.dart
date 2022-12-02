import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'database.dart';
import 'home.dart';

class AuthService {
  Future<User?> signInWithGoogle(BuildContext context) async {
    // Create instance to sign in with Google
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = new GoogleSignIn();

    // Sign in with authentication
    final GoogleSignInAccount? _googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await _googleSignInAccount!.authentication;

    // Auth credentials needed: idToken and accessToken
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    final UserCredential result = await _firebaseAuth.signInWithCredential(
        credential);

    //  User details of user (userName)
    final User? userDetails = result.user;

    // If user exists, upload user information into Firebase and login to home page
    if (result == null) {}
    else {
      Map<String, dynamic> userMap = {
        "userName": userDetails!.displayName,
      };

      DatabaseServices().uploadUserInfo(userDetails.uid, userMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) =>
              Home(
                userName: userDetails.displayName!,
              )
      ));
    }

    // Return user information
    return userDetails;
  }
}