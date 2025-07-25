import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Page'),
      ),
      body: Center(
        child: Text(
          'This is the Shop Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}