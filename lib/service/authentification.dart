import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:social_message/data/internal.dart';
import 'package:social_message/model/class.dart';

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

  enregistrementAuth(
      String mail, String password, String nom, var image) async {
    try {
      var imageUrl;
      if (image != null) {
        var ref =
            FirebaseStorage.instance.ref().child('collection/${image['path']}');

        await ref.putData(image['uint8List']).whenComplete(() async {
          imageUrl = await ref.getDownloadURL();
        });
      }
      var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mail,
        password: password,
      );

      var utilisateurs = {
        'nom': nom,
        'email': user.user!.email,
        'password': password,
        'image': imageUrl,
        'admin': false,
        'uid': user.user!.uid,
      };
      await firestoreinstance
          .collection('Utilisateur')
          .doc(user.user!.uid)
          .set(utilisateurs);
      sendMessage(user.user!.uid);
      print('reussi');
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'Exist';
      }
    }
  }
}

sendMessage(String uid) async {
  await firestoreinstance
      .collection('Utilisateur')
      .doc(uid)
      .collection('Correspondant')
      .doc(naimUid)
      .set({'email': 'naimdevelopper@gmail.com', 'uid': naimUid});
  var message1 = {
    'sender': naimUid,
    'response': null,
    'vu': false,
    'attachmentType': 'URL',
    'attachment': 'https://github.com/NaimCode',
    'date': Timestamp.now(),
    'content':
        "Salut! Je suis NAIM Abdelkerim, un développeur fullstack axé sur les nouvelles technologie (Flutter, ReactJS, NextJS, NodeJS, Express, MongoDB...) pour créer des web app et des applications avancées et intuitives.",
  };
  await firestoreinstance
      .collection('Utilisateur')
      .doc(uid)
      .collection('Correspondant')
      .doc(naimUid)
      .collection('Discussion')
      .add(message1);
  message1 = {
    'sender': naimUid,
    'response': null,
    'vu': false,
    'attachmentType': null,
    'attachment': null,
    'date': Timestamp.now(),
    'content': "Pour plus d'informations, veuillez démarrer une conversation",
  };
  await firestoreinstance
      .collection('Utilisateur')
      .doc(uid)
      .collection('Correspondant')
      .doc(naimUid)
      .collection('Discussion')
      .add(message1);
  message1 = {
    'sender': naimUid,
    'response': null,
    'vu': false,
    'attachmentType': 'URL',
    'attachment': 'https://github.com/NaimCode',
    'date': Timestamp.now(),
    'content':
        "Hi! I am NAIM Abdelkerim, a fullstack developer focused on new technologies (Flutter, ReactJS, NextJS, NodeJS, Express, MongoDB ...) to create advanced and intuitive web apps and applications.",
  };
  await firestoreinstance
      .collection('Utilisateur')
      .doc(uid)
      .collection('Correspondant')
      .doc(naimUid)
      .collection('Discussion')
      .add(message1);
  message1 = {
    'sender': naimUid,
    'response': null,
    'vu': false,
    'date': Timestamp.now(),
    'content': "For more information, please start a conversation",
  };

  await firestoreinstance
      .collection('Utilisateur')
      .doc(uid)
      .collection('Correspondant')
      .doc(naimUid)
      .collection('Discussion')
      .add(message1);
  //* Rana
  await firestoreinstance
      .collection('Utilisateur')
      .doc(uid)
      .collection('Correspondant')
      .doc(ranaUid)
      .set({'email': 'ranaa.hachim@gmail.com', 'uid': ranaUid});
  message1 = {
    'sender': ranaUid,
    'response': null,
    'vu': false,
    'attachmentType': null,
    'attachment': null,
    'date': Timestamp.now(),
    'content':
        "Salut! Je suis Rana Hachim, une conceptrice (designer UX/UI) axé sur la création d'expériences Web exceptionnelles. La conception et le codage sont  ma passion depuis que j'ai commencé à travailler avec des ordinateurs. J'aime créer des sites Web magnifiquement conçus, intuitifs et fonctionnels.",
  };
  await firestoreinstance
      .collection('Utilisateur')
      .doc(uid)
      .collection('Correspondant')
      .doc(ranaUid)
      .collection('Discussion')
      .add(message1);
  message1 = {
    'sender': ranaUid,
    'response': null,
    'vu': false,
    'attachmentType': null,
    'attachment': null,
    'date': Timestamp.now(),
    'content':
        "Hi! I am Rana Hachim, a designer (UX / UI) focused on creating exceptional web experiences. Designing and coding have been my passion since I started working with computers. I love to create beautifully designed, intuitive and functional websites.",
  };
  await firestoreinstance
      .collection('Utilisateur')
      .doc(uid)
      .collection('Correspondant')
      .doc(ranaUid)
      .collection('Discussion')
      .add(message1);
}
