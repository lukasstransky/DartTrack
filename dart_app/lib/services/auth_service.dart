import 'package:dart_app/models/user.dart';
import 'package:dart_app/models/user_p.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/utils/utils.dart';

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
    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      return;
    }

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> postUserToFirestore(String email, String username) async {
    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      return;
    }

    final UserModel newUser = UserModel(
        uid: _firebaseAuth.currentUser!.uid, email: email, username: username);

    await _firestore.collection('users').doc(newUser.uid).set(newUser.toMap());
  }

  Future<void> login(email, password) async {
    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      return;
    }

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> logout(BuildContext context) async {
    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      return;
    }

    final String username = getUsernameFromSharedPreferences() ?? '';

    if (username == 'Guest') {
      await context.read<FirestoreServiceGames>().deleteAllOpenGames();
      await _firebaseAuth.currentUser!.delete();
      deleteUserData();
    }

    await _firebaseAuth.signOut();
  }

  Future<void> setAdsEnabledFlagToFalse(BuildContext context) async {
    final bool isConnected = await Utils.hasInternetConnection();
    final User_P user = context.read<User_P>();
    if (!isConnected) {
      user.setAdsEnabled = false;
      return;
    }

    try {
      await _firestore
          .collection('users')
          .doc(getCurrentUserUid)
          .update({'adsEnabled': false});
      user.setAdsEnabled = false;
      print(
          'Ads have been successfully disabled for user with uid: $getCurrentUserUid');
    } catch (e) {
      print('Error disabling ads for user: $e');
    }
  }

  Future<void> getAdsEnabledFlag(BuildContext context) async {
    final bool isConnected = await Utils.hasInternetConnection();
    final User_P user = context.read<User_P>();
    if (!isConnected) {
      user.setAdsEnabled = false;
      return;
    }

    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: getCurrentUserUid)
          .get();

      bool adsEnabled = true;

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot userDoc = querySnapshot.docs.first;
        final data = userDoc.data();
        if (data is Map<String, dynamic>) {
          adsEnabled = data['adsEnabled'] as bool? ?? true;
        }
      } else {
        print(
            'Failed to fetch "adsEnabled" flag, user with uid "${getCurrentUserUid}" was not found');
      }
      user.setAdsEnabled = adsEnabled;
    } catch (e) {
      print('An error occurred while fetching "adsEnabled" flag: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      return;
    }

    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> loginAnonymously() async {
    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      return;
    }

    await _firebaseAuth.signInAnonymously();
  }

  Future<void> storeUsernameInSharedPreferences(String email) async {
    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      return;
    }

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
    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      return;
    }

    await _firebaseAuth.authStateChanges().firstWhere((user) => user != null);

    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null && currentUser.isAnonymous) {
      final String uid = currentUser.uid;
      await _firestore.collection('users').doc(uid).delete();
    }
  }

  Future<void> updateEmailInFirestore(String newEmail) async {
    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      return;
    }

    await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .update({
      'email': newEmail,
    });
  }

  Future<bool> updateEmail(
      String newEmail, BuildContext context, double fontSize) async {
    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      return false;
    }

    final User? user = _firebaseAuth.currentUser;

    try {
      await user?.updateEmail(newEmail);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: 'Error, email is already in use!',
          toastLength: Toast.LENGTH_LONG,
          fontSize: fontSize,
        );
      } else if (e.code == 'requires-recent-login') {
        Fluttertoast.showToast(
          msg: 'Please logout/login again to update the email!',
          toastLength: Toast.LENGTH_LONG,
          fontSize: fontSize,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An unexpected error occurred. Please try again later.',
        toastLength: Toast.LENGTH_LONG,
        fontSize: fontSize,
      );
    }
    return false;
  }

  Future<void> deleteAccount(BuildContext context) async {
    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      return;
    }

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
