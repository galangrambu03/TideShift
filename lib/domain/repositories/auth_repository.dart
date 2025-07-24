// domain/repositories/auth_repository.dart
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<void> signUp({required String email, required String password});
  Future<void> login({required String email, required String password});
  Future<void> logout();
  Future<void> resetPassword({required String email});
  User? getCurrentUser();
  // Future<void> reloadUser();
}
