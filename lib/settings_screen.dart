import 'dart:async';
import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sign_language_master/routes.dart';
import 'package:sign_language_master/utils/colors.dart';
import 'package:sign_language_master/utils/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  // Clear cache and delete the "Sign_Videos" directory
  Future<void> _clearCacheAndDirectory(BuildContext context) async {
    try {
      // Clear the app cache
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
        print('App cache cleared.');
      }

      // Define the path for the "Sign_Videos" directory
      Directory publicDir = Directory('/storage/emulated/0/Movies/Sign_Videos');
      if (publicDir.existsSync()) {
        publicDir.deleteSync(recursive: true);
        print('Sign_Videos directory deleted.');
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Cache and Sign_Videos deleted successfully!')),
      );
    } catch (e) {
      print('Error clearing cache or deleting directory: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to clear cache or delete directory.')),
      );
    }
  }

  // Show confirmation dialog before clearing cache and deleting directory
  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cache'),
          content: const Text(
              'Are you sure you want to clear cache and delete local Sign_Videos?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearCacheAndDirectory(context);
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: AppTextStyles.mainHeading),
          content: SingleChildScrollView(
            // Make content scrollable
            child: Text(content),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
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
            onPressed: () =>
                minimizeApp(), // Minimize the app properly //SystemNavigator.pop(), // Minimize the app
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final TextEditingController _commentController = TextEditingController();
    double _rating = 0.0;
    bool _isLoading = false; // Track loading state

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Send Feedback'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Rate your experience:'),
                    const SizedBox(height: 8),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                      itemSize: 30,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      onRatingUpdate: (rating) {
                        _rating = rating;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        labelText: 'Your Comments',
                        hintText: 'Write your feedback here...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          String comment = _commentController.text;
                          if (_rating == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please provide a rating.')),
                            );
                          } else if (comment.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please add a comment.')),
                            );
                          } else {
                            setState(() {
                              _isLoading = true; // Start loading
                              // Hide the keyboard
                              FocusScope.of(context).unfocus();
                            });

                            try {
                              await FirebaseFirestore.instance
                                  .collection('feedbacks')
                                  .add({
                                'rating': _rating,
                                'comment': comment,
                                'feedbackSubmitDate': Timestamp.now(),
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Thanks for Submitting  Feedback !')),
                              );
                              Navigator.of(context).pop();
                            } catch (e) {
                              print('Error saving feedback: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Error submitting feedback.')),
                              );
                            } finally {
                              setState(() {
                                _isLoading = false; // Stop loading
                                _commentController
                                    .clear(); // Clear the text after sending
                                FocusScope.of(context).unfocus();
                              });
                            }
                          }
                        },
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Send'),
                ),
              ],
            );
          },
        );
      },
    );
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

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkModeEnabled = false; // Example state for dark mode

    String about =
        "This app is designed for the students that are unable to hear or they have less hearing problem. This problem create problem for them to communicate easily with the hearing people. To overcome this issue different apps are designed that help them. To use those app and communicate with the people but those apps may have some usability issue. This app reduces the usability problem and the students easily gain knowledge from this app. By the use of this app they get to know about the different things like english alphabets, name of colors and many more.\n\nThis app contains 2 features text and speech. When students enter the text system shows an avatar then shows that text in the form of signs for deaf student.\n\nIf a normal people want to communicate with the deaf students and they are not aware about the signs they may put speech or text in the app and they may get signs from them. This help them in understanding and learning sign language as well.\n\nThis app is easy to use for all age groups if the students wants to repeat the videos related to any word or sentences they may repeatedly watch that videos.";

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Info Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft:
                      Radius.circular(20.0), // Adjust the radius as needed
                  bottomRight: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    spreadRadius: 1, // Spread radius of the shadow
                    blurRadius: 5, // Blur radius of the shadow
                    offset: const Offset(
                        0, 3), // Changes the position of the shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        Colors.black45, // Optional: Adjust background color
                    child: ClipOval(
                      child: Image.asset(
                        'assets/banner_avatar.png',
                        fit: BoxFit
                            .contain, // Ensures the image covers the entire circle
                        width: 56, // Adjust size to fit within the avatar
                        height: 56,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'SignMate',
                    style: AppTextStyles.mainHeading,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Settings List
            _buildSettingTile(
              context,
              title: 'Enhance App Performance',
              subtitle: 'Clear app cache and delete local Sign_Videos',
              icon: Icons.color_lens,
              onTap: () {
                _showClearCacheDialog(context);
              },
            ),
            _buildSettingTile(
              context,
              title: 'Privacy',
              subtitle: 'Lock SignMate\'App to improve your privacy',
              icon: Icons.lock,
              onTap: () => _showDialog(context, 'Privacy',
                  'SignMate respects your privacy and is committed to protecting your personal information. We collect minimal data, such as device and usage information, to improve the app’s performance and usability. Any media access or permissions requested are solely for providing educational content and enhancing user experience. Your data is not shared with third parties, except for essential services like Firebase. We prioritize security, and you can manage permissions through your device settings.'),
            ),
            // SwitchListTile(
            //   value: isDarkModeEnabled,
            //   onChanged: (value) {},
            //   title: const Text('Dark mode'),
            //   subtitle: const Text('Automatic'),
            //   secondary: const Icon(Icons.dark_mode),
            // ),
            _buildSettingTile(
              context,
              title: 'About',
              subtitle: 'Learn more about SignMate\'App',
              icon: Icons.info,
              onTap: () => _showDialog(context, 'About', about),
            ),
            _buildSettingTile(
              context,
              title: 'Send Feedback',
              subtitle: 'Let us know how we can make SignMate\'App better',
              icon: Icons.feedback,
              onTap: () => _showFeedbackDialog(context),
            ),
            _buildSettingTile(
              context,
              title: 'Logout',
              subtitle: 'Sign out of your account',
              icon: Icons.logout,
              onTap: () => _handleLogout(context),
            ),

            const SizedBox(height: 32),
            const Divider(),

            // Account Section
            _buildSettingTile(context,
                title: 'Close The App',
                icon: Icons.logout,
                onTap: () => {_showExitDialog(context)}),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(
        title,
        style: AppTextStyles.mediumHeading,
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: AppTextStyles.smallText)
          : null,
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.primaryColor,
      ),
      onTap: onTap,
    );
  }
}
