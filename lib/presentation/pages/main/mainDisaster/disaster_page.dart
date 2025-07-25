import 'package:flutter/material.dart';

class DisasterPage extends StatelessWidget {
  const DisasterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disaster Page'),
      ),
      body: Center(
        child: Text(
          'This is the Disaster Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}