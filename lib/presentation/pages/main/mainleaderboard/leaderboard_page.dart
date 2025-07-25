import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard Page'),
      ),
      body: Center(
        child: Text(
          'This is the Leaderboard Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}