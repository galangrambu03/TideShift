import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl {
  final FirebaseAuth _auth;

  AuthRepositoryImpl({FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? FirebaseAuth.instance;

  /// SIGN UP 
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      // FIREBASE AUTH - Create a new user with email and password
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  /// LOGIN 
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      // FIREBASE AUTH - Sign in the user with email and password
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    try {
      // FIREBASE AUTH - Sign out the current user
      await _auth.signOut();
    } catch (e) {
      throw Exception("Logout failed: $e");
    }
  }

  /// RESET PASSWORD
  Future<void> resetPassword({required String email}) async {
    try {
      // FIREBASE AUTH - Send a password reset email
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  /// GET CURRENT USER
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // RELOAD / REFRESH USER
  // Future<void> reloadUser() async {
  //   try {
  //     await _auth.currentUser?.reload();
  //   } catch (e) {
  //     throw Exception("Failed to reload user: $e");
  //   }
  // }
}
