import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  final StreamController<String> _logStreamController = StreamController.broadcast();

  Stream<String> get logStream => _logStreamController.stream;
  User? get user => _user;
  bool get isAuthenticated => _user != null;

  Future<void> initializeUser() async {
    _user = _auth.currentUser;
    notifyListeners();
  }

  Future<bool> register(String email, String password) async {
    try {
      print('Attempting to register user...');
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      print('User registered successfully: UID=${_user!.uid}');

      // Добавление данных в Firestore
      print('Attempting to add document to Firestore...');
      await _firestore.collection('users').doc(_user!.uid).set({
        'email': email,
        'createdAt': DateTime.now(),
      }).then((value) {
        print('User data written to Firestore successfully.');
      }).catchError((error) {
        print('Failed to write user data to Firestore: $error');
        throw Exception('Firestore write failed: $error');
      });

      _logActivity(email, 'register');
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: Code=${e.code}, Message=${e.message}');
      if (e.code == 'email-already-in-use') {
        print('The email is already in use.');
      } else if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      }
      return false;
    } catch (e, stackTrace) {
      print('Unexpected Error: $e');
      print('Stack Trace: $stackTrace');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;

      _logActivity(email, 'login');
      notifyListeners();
      return true;
    } catch (e) {
      print('Login Error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _logActivity(_user?.email ?? 'Unknown', 'logout');
      _user = null;
      notifyListeners();
    } catch (e) {
      print('Logout Error: $e');
    }
  }

  void _logActivity(String email, String action) async {
    final logEntry = '${DateTime.now().toIso8601String()} | $email | $action';
    _logStreamController.add(logEntry);
  }

  @override
  void dispose() {
    _logStreamController.close();
    super.dispose();
  }
}