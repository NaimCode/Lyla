import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Utilisateur {
  String? image;
  String? numero;
  String? uid;
  String? nom;
  String? email;
  bool? admin;
  Utilisateur({
    this.image,
    this.numero,
    this.uid,
    this.nom,
    this.email,
    this.admin,
  });

  Utilisateur copyWith({
    String? image,
    String? numero,
    String? uid,
    String? nom,
    String? email,
    bool? admin,
  }) {
    return Utilisateur(
      image: image ?? this.image,
      numero: numero ?? this.numero,
      uid: uid ?? this.uid,
      nom: nom ?? this.nom,
      email: email ?? this.email,
      admin: admin ?? this.admin,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'numero': numero,
      'uid': uid,
      'nom': nom,
      'email': email,
      'admin': admin,
    };
  }

  factory Utilisateur.fromMap(Map<String, dynamic> map) {
    return Utilisateur(
      image: map['image'],
      numero: map['numero'],
      uid: map['uid'],
      nom: map['nom'],
      email: map['email'],
      admin: map['admin'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Utilisateur.fromJson(String source) =>
      Utilisateur.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Utilisateur(image: $image, numero: $numero, uid: $uid, nom: $nom, email: $email, admin: $admin)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Utilisateur &&
        other.image == image &&
        other.numero == numero &&
        other.uid == uid &&
        other.nom == nom &&
        other.email == email &&
        other.admin == admin;
  }

  @override
  int get hashCode {
    return image.hashCode ^
        numero.hashCode ^
        uid.hashCode ^
        nom.hashCode ^
        email.hashCode ^
        admin.hashCode;
  }
}

class Message {
  String? sender;
  String? uid;
  String? content;
  bool? vuMe;
  bool? vuHe;
  Timestamp? date;
  String? response;
  Map<String, String>? attachment;
  Message({
    this.sender,
    this.uid,
    this.content,
    this.vuMe,
    this.vuHe,
    this.date,
    this.response,
    this.attachment,
  });

  Message copyWith({
    bool? mine,
    String? uid,
    String? content,
    bool? vuMe,
    bool? vuHe,
    Timestamp? date,
    String? response,
    Map<String, String>? attachment,
  }) {
    return Message(
      sender: sender ?? this.sender,
      uid: uid ?? this.uid,
      content: content ?? this.content,
      vuMe: vuMe ?? this.vuMe,
      vuHe: vuHe ?? this.vuHe,
      date: date ?? this.date,
      response: response ?? this.response,
      attachment: attachment ?? this.attachment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mine': sender,
      'uid': uid,
      'content': content,
      'vuMe': vuMe,
      'vuHe': vuHe,
      'date': date,
      'response': response,
      'attachment': attachment,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      sender: map['sender'],
      uid: map['uid'],
      content: map['content'],
      vuMe: map['vuMe'],
      vuHe: map['vuHe'],
      date: map['date'],
      response: map['response'],
      attachment: Map<String, String>.from(map['attachment']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Message(mine: $sender, uid: $uid, content: $content, vuMe: $vuMe, vuHe: $vuHe, date: $date, response: $response, attachment: $attachment)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message &&
        other.sender == sender &&
        other.uid == uid &&
        other.content == content &&
        other.vuMe == vuMe &&
        other.vuHe == vuHe &&
        other.date == date &&
        other.response == response &&
        mapEquals(other.attachment, attachment);
  }

  @override
  int get hashCode {
    return sender.hashCode ^
        uid.hashCode ^
        content.hashCode ^
        vuMe.hashCode ^
        vuHe.hashCode ^
        date.hashCode ^
        response.hashCode ^
        attachment.hashCode;
  }

//? To know if this message is from the current user
  bool isMine(Utilisateur? user) {
    if (user!.uid == sender)
      return true;
    else
      return false;
  }
}
