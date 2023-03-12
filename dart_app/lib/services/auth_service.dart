import 'package:dart_app/models/user.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  late SharedPreferences prefs;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  AuthService(this._firebaseAuth, this._firestore) {
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> register(email, password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> postUserToFirestore(String email, String username) async {
    final UserModel newUser = UserModel(
        uid: _firebaseAuth.currentUser!.uid, email: email, username: username);

    await _firestore.collection('users').doc(newUser.uid).set(newUser.toMap());
  }

  Future<void> login(email, password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> logout(BuildContext context) async {
    final String username = getUsernameFromSharedPreferences() ?? '';
    if (username == 'Guest') {
      await context.read<FirestoreServiceGames>().deleteAllOpenGames();
      await _firebaseAuth.currentUser!.delete();
      deleteUserData();
    }

    await _firebaseAuth.signOut();
  }

  Future<bool> usernameValid(String usernameToVerify) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: usernameToVerify)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return false;
    }
    return true;
  }

  Future<bool> emailAlreadyExists(String emailToVerify) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: emailToVerify)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> loginAnonymously() async {
    await _firebaseAuth.signInAnonymously();
  }

  Future<void> storeUsernameInSharedPreferences(String email) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    final String username =
        (querySnapshot.docs.first.data() as Map<String, dynamic>)['username'];

    await prefs.setString('username', username);
  }

  String? getUsernameFromSharedPreferences() {
    if (_firebaseAuth.currentUser!.isAnonymous) {
      return 'Guest';
    }

    return prefs.getString('username');
  }

  Future<void> deleteUserData() async {
    await _firebaseAuth.authStateChanges().firstWhere((user) => user != null);

    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null && currentUser.isAnonymous) {
      final String uid = currentUser.uid;
      await _firestore.collection('users').doc(uid).delete();
    }
  }
}
