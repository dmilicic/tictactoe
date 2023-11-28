import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class GameInfoRepository {

  static const String VICTORIES_DOCUMENT_NAME = "victories";
  static const String FIELD_COUNT = "count";

  GameInfoRepository._privateConstructor();
  static final GameInfoRepository _instance = GameInfoRepository._privateConstructor();

  static GameInfoRepository get instance => _instance;

  DocumentSnapshot? _documentCache;

  Stream getVictoryStream() {
    return FirebaseFirestore.instance.collection(VICTORIES_DOCUMENT_NAME).snapshots();
  }

  /// Reactive getter for victory count
  int getVictoryCount(AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.hasData) {
      _documentCache = _getDocument(snapshot.requireData);
      final data = _documentCache?.data() as Map<String, dynamic>;
      return int.parse(data[FIELD_COUNT].toString());
    }

    return -1;
  }

  /// Async setter for adding the victory count
  void addVictory() async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      final reference = _documentCache?.reference;
      if (reference == null) return;

      final docSnapshot = await transaction.get(reference);

      if (docSnapshot.exists) {
        final updatedCount = docSnapshot[FIELD_COUNT] + 1;
        transaction.update(reference, {FIELD_COUNT: updatedCount});
      }
    });
  }

  DocumentSnapshot _getDocument(QuerySnapshot snapshot) {
    return snapshot.docs.first; // first and only document
  }
}