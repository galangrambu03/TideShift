import 'package:ecomagara/presentation/pages/auth/authController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Page')),
      body: Center(
        child: ElevatedButton(
          child: Text('Logout'),
          onPressed: () {
            _authController.logout();
          },
        ),
      ),
    );
  }
}
