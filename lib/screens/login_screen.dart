import 'package:flutter/material.dart';
import 'package:sign_language_master/services/auth_services.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import '../routes.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameOrEmailController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void login() async {
    setState(() {
      isLoading = true;
    });

    final authService = AuthService();
    final error = await authService.login(
      usernameOrEmail: usernameOrEmailController.text,
      password: passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (error == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.root);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
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
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Log in to your account",
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
                      CustomTextField(
                        hintText: "Username or Email",
                        controller: usernameOrEmailController,
                        prefixIcon: Icons.person,
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
                              text: "Login",
                              onPressed: login,
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(color: Colors.white),
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
