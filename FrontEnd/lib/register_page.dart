import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  bool isLoading = false;
  String message = '';


  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> registerUser() async {
    setState(() {
      isLoading = true;
      message = '';
    });

    try {
      var dio = Dio();
      var response = await dio.post(
        'https://kemetgamesg.com/medical_test/register.php',
        data: {
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      setState(() {
        message = response.data['message'] ?? response.data['error'] ?? 'Something went wrong';
      });
    } catch (e) {
      setState(() {
        message = 'Failed to register: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {

    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تسجيل مستخدم جديد')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'الاسم'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'البريد الإلكتروني'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'كلمة المرور'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            if (isLoading)
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: registerUser,
                child: Text('تسجيل'),
              ),
            if (message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(message),
              ),
          ],
        ),
      ),
    );
  }
}