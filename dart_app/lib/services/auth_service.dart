import 'package:dart_app/models/player_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  Player? _player;

  //reason why its loaded here -> gamesettings tab looks laggy when the player is loaded there in the initstate method
  Player? get getPlayer => _player;

  AuthService(this._firebaseAuth, this._firestore);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> register(email, password) async {
    try {
      await this
          ._firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> postUserToFirestore(String email, String username) async {
    UserModel newUser = UserModel(
        uid: _firebaseAuth.currentUser!.uid, email: email, username: username);

    await this
        ._firestore
        .collection("users")
        .doc(newUser.uid)
        .set(newUser.toMap());
  }

  Future<void> login(email, password) async {
    try {
      await this
          ._firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> usernameValid(String usernameToVerify) async {
    final querySnapshot = await this
        ._firestore
        .collection('users')
        .where('username', isEqualTo: usernameToVerify)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return false;
    }
    return true;
  }

  Future<void> resetPassword(String email) async {
    await this._firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> loginAnonymously() async {
    await _firebaseAuth.signInAnonymously();
  }

  Future<void> createPlayerOfCurrentUser() async {
    String uuid = _firebaseAuth.currentUser!.uid;
    var snapshot = await _firestore.collection("users").doc(uuid).get();
    var data = snapshot.data();
    this._player = new Player(name: data!["username"]);
  }
}
