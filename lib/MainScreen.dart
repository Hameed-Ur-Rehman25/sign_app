import 'dart:async';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sign_language_master/asl/text_to_video.dart';
import 'package:sign_language_master/settings_screen.dart';
import 'package:sign_language_master/utils/border_radius.dart';
import 'package:sign_language_master/utils/colors.dart';
import 'package:sign_language_master/utils/text_styles.dart';
import 'HomeScreen.dart';
// Import routes configuration

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Track the selected tab.

  // Method to handle bottom navigation tab taps
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // Update selected index to switch tabs
    });
  }
  // Callback to switch to the Translate tab
  void switchToTranslateTab() {
    setState(() {
      _currentIndex = 1; // Set the index to 'Translate' tab
    });
  }
  void minimizeApp() {
    // Optional: Add a delay for smoother transition
    Timer(const Duration(milliseconds: 100), () {
      const intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: 'android.intent.category.HOME',
        flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      intent.launch();
    });
  }

  // Handle the back button to prompt user for app exit
  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      // If not on the Home tab, switch to Home tab instead of exiting
      setState(() {
        _currentIndex = 0;
      });
      return Future.value(false); // Prevent app exit
    }

    // Show confirmation dialog for exit when on the Home tab
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Stay in app
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => minimizeApp(), // Minimize the app properly //SystemNavigator.pop(), // Minimize the app
            child: const Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Handle back button
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          title: const Text(
            'SignMate',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.search, color: Colors.black),
          //     onPressed: () {
          //       // Action for search button
          //     },
          //   ),
          // ],
        ),
        body: SafeArea(
          child: IndexedStack(
            index: _currentIndex, // Display the selected tab
            children: [
              HomeScreen(onTranslatePressed: switchToTranslateTab), // Home tab content
              TextToVideo(), // Temporary widget for 'Translate' (replace with your page)
              SettingsPage()
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: AppBorderRadius.topRounded,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppBorderRadius.topRounded,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.primaryColor,
          selectedItemColor: AppColors.accentColor,
          unselectedItemColor: AppColors.unselectedItemColor,
          showUnselectedLabels: true,

          // Apply text styles for selected and unselected labels
          selectedLabelStyle: AppTextStyles.mediumHeading,
          unselectedLabelStyle: AppTextStyles.mediumHeading,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.translate),
              label: 'Translate',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
