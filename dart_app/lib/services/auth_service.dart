import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/user.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  Player? _player;

  // reason why its loaded here -> gamesettings tab looks laggy when the player is loaded there in the initstate method
  Player? get getPlayer => _player;

  AuthService(this._firebaseAuth, this._firestore);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

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
    await createPlayerOfCurrentUser();
  }

  Future<void> login(email, password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> logout() async {
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

  Future<void> createPlayerOfCurrentUser() async {
    if (_firebaseAuth.currentUser!.email == null) {
      // guest
      return;
    }

    final String currentUserUid = _firebaseAuth.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(currentUserUid)
        .get()
        .then((value) => {
              _player = new Player(name: value.data()!['username']),
            });
  }
}
