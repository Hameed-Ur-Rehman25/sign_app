import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ResultScreen({
    Key? key,
    required this.score,
    required this.totalQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz Completed!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Score: $score / $totalQuestions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
