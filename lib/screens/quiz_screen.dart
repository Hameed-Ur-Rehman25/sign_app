import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sign_language_master/asl/custom_video_player.dart';
import 'package:sign_language_master/models/quiz_question.dart';
import 'package:video_player/video_player.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late VideoPlayerController _controller;
  int currentQuestionIndex = 0;
  int timeLeft = 50;
  late Timer _timer;
  String? selectedAnswer;
  int score = 0;

  final List<QuizQuestion> questions = [
    QuizQuestion(
      question: "Water boils at which degrees Celsius.",
      options: ["100", "50", "150"],
      correctAnswer: "100",
      videoPath: "assets/Videos/water.mp4",
    ),
    QuizQuestion(
      question: "What is the sign for 'Thank You'?",
      options: ["Touch chest", "Wave hand", "Tap head"],
      correctAnswer: "Touch chest",
      videoPath: "assets/Videos/thankyou.mp4",
    ),
    QuizQuestion(
      question: "Which sign represents 'Family'?",
      options: ["Circle motion", "F letter motion", "Hug motion"],
      correctAnswer: "F letter motion",
      videoPath: "assets/Videos/family.mp4",
    ),
    QuizQuestion(
      question: "What is the correct sign for number '5'?",
      options: ["Open palm", "Closed fist", "Peace sign"],
      correctAnswer: "Open palm",
      videoPath: "assets/Videos/5.mp4",
    ),
    QuizQuestion(
      question: "How do you sign 'Good Morning'?",
      options: ["M to forehead", "Wave up", "Touch lips"],
      correctAnswer: "M to forehead",
      videoPath: "assets/Videos/goodmorning.mp4",
    ),
    QuizQuestion(
      question: "Which motion represents 'Happy'?",
      options: ["Circular chest motion", "Head tap", "Hand wave"],
      correctAnswer: "Circular chest motion",
      videoPath: "assets/Videos/happy.mp4",
    ),
    QuizQuestion(
      question: "What's the sign for 'Friend'?",
      options: ["Linked fingers", "Wave", "Thumbs up"],
      correctAnswer: "Linked fingers",
      videoPath: "assets/Videos/friend.mp4",
    ),
    QuizQuestion(
      question: "How do you sign 'Please'?",
      options: ["Circular chest motion", "Flat hand on chest", "Wave hand"],
      correctAnswer: "Circular chest motion",
      videoPath: "assets/Videos/please.mp4",
    ),
    QuizQuestion(
      question: "What's the correct sign for 'Food'?",
      options: ["Fingers to mouth", "Hand wave", "Tap head"],
      correctAnswer: "Fingers to mouth",
      videoPath: "assets/Videos/food.mp4",
    ),
    QuizQuestion(
      question: "Which sign means 'Home'?",
      options: ["Roof motion", "Wave hand", "Point down"],
      correctAnswer: "Roof motion",
      videoPath: "assets/Videos/home.mp4",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header with Quiz title and Timer
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quiz',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${timeLeft ~/ 60}:${(timeLeft % 60).toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Video Player
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: _controller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          )
                        : Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                // Video Controls
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.replay),
                          label: Text('Replay'),
                          onPressed: () {
                            _controller.seekTo(Duration.zero);
                            _controller.play();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue[900],
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.skip_next),
                          label: Text('Next'),
                          onPressed: goToNextQuestion,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue[900],
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Question
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    questions[currentQuestionIndex].question,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),

                // Options
                ...questions[currentQuestionIndex].options.map((option) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.blue[900],
                          backgroundColor: selectedAnswer == option
                              ? Colors.blue[100]
                              : Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedAnswer = option;
                          });
                        },
                        child: Text(
                          option,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    startTimer();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.asset(
      questions[currentQuestionIndex].videoPath,
    )..initialize().then((_) {
        setState(() {});
        _controller.play();
      }).catchError((error) {
        print('Video initialization error: $error');
      });
    // _controller = CustomVideoPlayer(player: player, videoName: videoName, onDispose: onDispose)
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        goToNextQuestion();
      }
    });
  }

  void goToNextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        timeLeft = 50;
        _initializeVideo();
      });
    } else {
      // Quiz completed
      _timer.cancel();
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }
}

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
