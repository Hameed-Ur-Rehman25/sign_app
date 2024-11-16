import 'package:flutter/material.dart';
import 'package:sign_language_master/services/auth_services.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

import '../routes.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedGender;
  final List<String> genders = ["Male", "Female", "Other"];
  bool isLoading = false;

  void signUp() async {
    if (!mounted) return;

    try {
      if (selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a gender')),
        );
        return;
      }

      setState(() {
        isLoading = true;
      });

      final authService = AuthService();
      final error = await authService.signUp(
        username: usernameController.text.trim(),
        userClass: classController.text.trim(),
        gender: selectedGender!,
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;

      if (error == null) {
        Navigator.pushReplacementNamed(context, AppRoutes.root);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firebase Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/banner_avatar.png',
                  height: 150,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Sign up to get started",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedGender,
                        items: genders
                            .map((gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Gender",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: "Class",
                        controller: classController,
                        prefixIcon: Icons.class_,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: "Username",
                        controller: usernameController,
                        prefixIcon: Icons.person,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: "Email",
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: "Password",
                        controller: passwordController,
                        obscureText: true,
                        prefixIcon: Icons.lock,
                      ),
                      const SizedBox(height: 30),
                      isLoading
                          ? const CircularProgressIndicator()
                          : CustomButton(
                              text: "Sign Up",
                              onPressed: signUp,
                            ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.login);
                        },
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
