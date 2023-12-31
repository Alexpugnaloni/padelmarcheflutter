import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GestioneFirebase {
  /// Riferimento per *Firestore*
  final firestore = FirebaseFirestore.instance;

  /// Riferimento per *FirebaseAuth*
  final auth = FirebaseAuth.instance;

  /// Lo *storage* di *Firebase*
  final storage = FirebaseStorage.instance;

  void initGestioneFirebase() async {
    await Firebase.initializeApp();
  }

  bool checkState() {
    if (auth.currentUser == null)
      return false;
    return true;
  }

  String getUserId() {
    return auth.currentUser!.uid;
  }


  /// Funzione per recuperare le informazioni di un account
  leggiInfo() async {
    var id = auth.currentUser!.uid;
    var acc = HashMap();
    var risultato = await firestore.collection('Accounts')
        .doc(id)
        .get(); //.then((risultato) async {
    acc['id'] = id;
    acc['cellulare'] = risultato.data()!['cellulare'].toString();
    acc['cognome'] = risultato.data()!['cognome'].toString();
    acc['dataDiNascita'] = risultato.data()!['dataDiNascita'].toString();
    acc['nome'] = risultato.data()!['nome'].toString();
    acc['sesso'] = risultato.data()!['nome'].toString();
    try {
      acc['img'] =
      await storage.ref().child("Foto profilo/" + acc['id']).getDownloadURL();
    }
    catch (e) {
      acc['img'] =
      await storage.ref().child("Foto profilo/0.png").getDownloadURL();
    }
    return acc;
  }

}