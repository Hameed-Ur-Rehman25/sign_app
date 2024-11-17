import 'package:flutter/material.dart';
import 'package:sign_language_master/MainScreen.dart';
import 'package:sign_language_master/screens/login_screen.dart';
import 'package:sign_language_master/screens/sign_up_screen.dart';
import 'HomeScreen.dart';
import 'asl/text_to_video.dart';
import 'screens/quiz_screen.dart';
// Import all necessary pages

class AppRoutes {
  static const root = '/';
  static const home = 'home';
  static const translate = '/translate';
  static const setting = '/setting';
  static const englishAlphabets = '/english_alphabets';
  static const numberAlphabets = '/number_Alphabets';
  static const urduAlphabets = '/urdu_Alphabets';
  static const categoryAlphabets = '/category_Alphabets';
  static const login = '/login';
  static const signup = '/signup';
  static const quiz = '/quiz';

  // Add routes for individual categories
  static const String animals = '/animals';
  static const String fruits = '/fruits';
  static const String colors = '/colors';
  static const String days = '/days';

  // Route Generator (maps route names to widgets)
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
        return MaterialPageRoute(builder: (context) => MainScreen());
      case home:
        return MaterialPageRoute(
            builder: (context) => HomeScreen(onTranslatePressed: () {}));
      case translate:
        return MaterialPageRoute(builder: (context) => TextToVideo());
      case setting:
        return MaterialPageRoute(
            builder: (context) => const Center(
                child: Text('Settings Page', style: TextStyle(fontSize: 24))));
      case englishAlphabets:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  appBar: AppBar(title: const Text('English Alphabets')),
                  body: const Center(child: Text('English Alphabets Content')),
                ));
      case login:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (context) => SignUpScreen());
      case quiz:
        return MaterialPageRoute(builder: (context) => QuizScreen());
      default:
        return MaterialPageRoute(
            builder: (context) => const Scaffold(
                  body: Center(child: Text('404 Page Not Found')),
                ));
    }
  }
}
