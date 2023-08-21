import 'package:dart_app/models/user.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  late SharedPreferences prefs;

  String get getCurrentUserUid => this._firebaseAuth.currentUser!.uid;
  String? get getCurrentUserEmail => this._firebaseAuth.currentUser!.email;
  User? get getCurrentUser => this._firebaseAuth.currentUser!;

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
    if (_firebaseAuth.currentUser == null) {
      return '';
    }

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

  Future<void> changeUsernameInFirestore(String newUsername) async {
    await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .update({
      'username': newUsername,
      'usernameUpdated': true,
    });
  }

  Future<bool> isUsernameUpdated() async {
    bool usernameUpdated = false;
    final DocumentSnapshot snapshot = await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('usernameUpdated')) {
        usernameUpdated = true;
      }
    }

    return usernameUpdated;
  }

  Future<void> updateEmailInFirestore(String newEmail) async {
    await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .update({
      'email': newEmail,
    });
  }

  Future<void> updateEmail(String newEmail, BuildContext context) async {
    final User? user = _firebaseAuth.currentUser;

    try {
      await user?.updateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        Fluttertoast.showToast(
          msg: 'Please logout/login again to update the email!',
          toastLength: Toast.LENGTH_LONG,
          fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An unexpected error occurred. Please try again later.',
        toastLength: Toast.LENGTH_LONG,
        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
      );
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      await _firestore.collection('users').doc(getCurrentUserUid).delete();
      await getCurrentUser!.delete();
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        Fluttertoast.showToast(
          msg: 'Please logout/login again!',
          toastLength: Toast.LENGTH_LONG,
          fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An unexpected error occurred. Please try again later.',
        toastLength: Toast.LENGTH_LONG,
        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
      );
    }
  }
}
