import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sign_language_master/MainScreen.dart';
import 'package:sign_language_master/routes.dart';
import 'package:sign_language_master/screens/login_screen.dart';
import 'package:sign_language_master/utils/colors.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    MediaKit.ensureInitialized();
  } catch (e) {
    print('MediaKit initialization error: $e');
  }

  // Initialize Firebase services
  await _initializeFirebase();

  // Request storage and photo permissions
  if (!await _requestPhotoAndStoragePermissions()) {
    exit(0); // Exit the app if permissions are denied
  }

  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stackTrace) {
    print('Uncaught error: $error\nStack trace: $stackTrace');
  });
}

// Firebase initialization with App Check
Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Configure Firestore settings
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    // Initialize App Check with a provider
    await FirebaseAppCheck.instance.activate(
      // Use debug provider for development
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
    );

    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
    throw Exception('Failed to initialize Firebase: $e');
  }
}

// Request storage and photo permissions
Future<bool> _requestPhotoAndStoragePermissions() async {
  if (Platform.isAndroid) {
    var manageStatus = await Permission.manageExternalStorage.request();
    var storageStatus = await Permission.storage.request();
    return manageStatus.isGranted || storageStatus.isGranted;
  }
  return true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SignMate',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: AppColors.primaryColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryColor,
          titleTextStyle: TextStyle(color: AppColors.textColor, fontSize: 20),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return MainScreen();
          }

          return LoginScreen();
        },
      ),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
