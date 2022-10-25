import 'package:dart_app/models/game_settings/default_settings_x01.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirestoreServiceDefaultSettings {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  FirestoreServiceDefaultSettings(this._firestore, this._firebaseAuth);

  Future<void> postDefaultSettingsX01(BuildContext context) async {
    final defaultSettingsX01 = context.read<DefaultSettingsX01>();
    final CollectionReference ref = await _firestore.collection(
        'users/' + _firebaseAuth.currentUser!.uid + '/defaultSettingsX01');
    final QuerySnapshot<Object?> result = await ref.get();

    if (result.docs.isNotEmpty) {
      await ref.doc(defaultSettingsX01.id).delete();
    }

    await ref
        .add(defaultSettingsX01.toMap())
        .then((value) => defaultSettingsX01.id = value.id);
    await ref.doc(defaultSettingsX01.id).update({'id': defaultSettingsX01.id});
  }

  Future<void> getDefaultSettingsX01(BuildContext context) async {
    final defaultSettingsX01 = context.read<DefaultSettingsX01>();
    final QuerySnapshot<Object?> result = await _firestore
        .collection(
            'users/' + _firebaseAuth.currentUser!.uid + '/defaultSettingsX01')
        .get();

    defaultSettingsX01.playersNames = [];
    if (result.docs.isNotEmpty) {
      defaultSettingsX01.fromMap(result.docs[0].data());
    }
  }
}
