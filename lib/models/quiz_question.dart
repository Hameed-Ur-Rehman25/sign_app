class QuizQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String videoPath;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.videoPath,
  });
}
