import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  late SharedPreferences _prefs;

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> get isLoggedIn async {
    return _prefs.getBool('isLoggedIn') ?? false;
  }

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      final isFirstLogin = await isLoggedIn;
      if (isFirstLogin) {
        await saveUser(googleUser);
        await _prefs.setBool('isLoggedIn', true);
      }
    } catch (e) {
      print("Error: $e");
    }

    notifyListeners();
  }

  Future<void> saveUser(GoogleSignInAccount googleUser) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(googleUser.displayName)
        .set({
      "email": googleUser.email,
      "name": googleUser.displayName,
      "profilepic": googleUser.photoUrl,
      "shared": [],
    });
  }

  Future logout() async {
    await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    await _prefs.setBool('isLoggedIn', false);
  }
}
