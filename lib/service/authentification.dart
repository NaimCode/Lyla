import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import '../body.dart';
import '../home.dart';

//import 'package:flutter_facebook_login_web/flutter_facebook_login_web.dart';

final firestoreinstance = FirebaseFirestore.instance;

//final facebookSignIn = FacebookLoginWeb();

class Authentification {
  FirebaseAuth _firebaseAuth;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  Authentification(this._firebaseAuth);
  deconnection() async {
    await _firebaseAuth.signOut();
  }

  currentUser() {
    return _firebaseAuth.currentUser!.isAnonymous;
  }

  connection(String mail, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail, password: password);
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Not Exist';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password';
      }
    }
  }
}
