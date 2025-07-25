import 'package:flutter/material.dart';

class DiyPage extends StatelessWidget {
  const DiyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DIY Page'),
      ),
      body: Center(
        child: Text(
          'This is the DIY Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}