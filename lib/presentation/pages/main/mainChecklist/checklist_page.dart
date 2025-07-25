import 'package:flutter/material.dart';

class ChecklistPage extends StatelessWidget {
  const ChecklistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checklist Page'),
      ),
      body: Center(
        child: Text(
          'This is the Checklist Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}