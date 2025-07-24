import 'package:ecomagara/datasource/repositories/auth_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FirebaseAuthService extends GetxService {
  final AuthRepositoryImpl _authRepository;

  FirebaseAuthService({AuthRepositoryImpl? authRepository})
      : _authRepository = authRepository ?? AuthRepositoryImpl();

  /// Sign up a new user and send a verification email
  Future<void> signUp(String email, String password) async {
    return await _authRepository.signUp(email: email, password: password);
  }

  /// Login only if the email has been verified
  Future<void> login(String email, String password) async {
    return await _authRepository.login(email: email, password: password);
  }

  /// Logout the current user
  Future<void> logout() async {
    await _authRepository.logout();
  }

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    return await _authRepository.resetPassword(email: email);
  }

  /// Get the current Firebase user
  User? get currentUser => _authRepository.getCurrentUser();

  // Force reload the user from Firebase
  // Future<void> reloadUser() async {
  //   await _authRepository.reloadUser();
  // }

  /// Check if a user is currently logged in
  bool get isLoggedIn => currentUser != null;
}
