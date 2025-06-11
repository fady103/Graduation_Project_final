import 'package:flutter/material.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  String? _emailError;
  String? _passwordError;


  bool _validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }


  bool _validatePassword(String password) {
    return password.length >= 6;
  }


  bool _validateFields() {
    setState(() {
      _emailError = _emailController.text.isEmpty
          ? 'Please enter your email'
          : !_validateEmail(_emailController.text)
          ? 'Please enter a valid email'
          : null;

      _passwordError = _passwordController.text.isEmpty
          ? 'Please enter your password'
          : !_validatePassword(_passwordController.text)
          ? 'Password must be at least 6 characters'
          : null;
    });

    return _emailError == null && _passwordError == null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Positioned(
            top: -100,
            left: -100,
            child: Transform.rotate(
              angle: -3,
              child: Image.asset(
                'assets/image/login_image.jpeg',
                width: 250,
                height: 250,
              ),
            ),
          ),


          Positioned(
            bottom: -100,
            right: -100,
            child: Image.asset(
              'assets/image/login_image.jpeg',
              width: 250,
              height: 250,
            ),
          ),


          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D3FD3),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Sign in to Continue",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 32),


                  Container(
                    width: 300,
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Please enter Email",
                        labelStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        errorText: _emailError,
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 16),


                  Container(
                    width: 300,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Please enter Password",
                        labelStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        errorText: _passwordError,
                        errorStyle: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),


                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_validateFields()) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const MyApp()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5D3FD3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 16),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Color(0xFF5D3FD3),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),


                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => RegistrationPage()));
                    },
                    child: const Text("Don't have an account? Register Now"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}