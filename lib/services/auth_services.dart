import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sign_language_master/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  // Modified constructor to handle initialization
  AuthService()
      : _auth = FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance {
    if (!Firebase.apps.isNotEmpty) {
      throw Exception('Firebase not initialized');
    }
  }

  // Sign Up Method
  Future<String?> signUp({
    required String email,
    required String password,
    required String username,
    required String userClass,
    required String gender,
  }) async {
    try {
      // First check if email is already registered
      final emailQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (emailQuery.docs.isNotEmpty) {
        return 'Email is already registered';
      }

      // Then check username availability
      final usernameQuery = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (usernameQuery.docs.isNotEmpty) {
        return 'Username is already taken';
      }

      // Create auth user first
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCred.user == null) {
        return 'Failed to create user authentication';
      }

      try {
        // Then create the user document
        await _firestore.collection('users').doc(userCred.user!.uid).set({
          'uid': userCred.user!.uid,
          'username': username,
          'email': email,
          'userClass': userClass,
          'gender': gender,
          'createdAt': FieldValue.serverTimestamp(),
          'recentTranslations': [],
        });

        print('User document created successfully');
        return null;
      } catch (e) {
        // If Firestore fails, delete the auth user
        await userCred.user?.delete();
        print('Firestore error: $e');
        return 'Failed to create user profile';
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth error: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'email-already-in-use':
          return 'Email is already registered';
        case 'invalid-email':
          return 'Invalid email address';
        case 'operation-not-allowed':
          return 'Email/password accounts are not enabled';
        case 'weak-password':
          return 'Password is too weak';
        default:
          return e.message ?? 'An error occurred during sign up';
      }
    } catch (e) {
      print('Unexpected error: $e');
      return 'An unexpected error occurred';
    }
  }

  // Login Method
  Future<String?> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      String email;

      // Check if input is email or username
      if (usernameOrEmail.contains('@')) {
        email = usernameOrEmail;
      } else {
        // Find email by username
        final userDoc = await _firestore
            .collection('users')
            .where('username', isEqualTo: usernameOrEmail)
            .limit(1)
            .get();

        if (userDoc.docs.isEmpty) {
          return 'User not found';
        }
        email = userDoc.docs.first.get('email') as String;
      }

      // Attempt login
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update last login timestamp
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .update({
        'lastLogin': FieldValue.serverTimestamp(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
