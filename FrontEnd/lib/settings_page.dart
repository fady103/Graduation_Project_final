import 'package:flutter/material.dart';
import 'login_page.dart'; // تأكد إن الملف موجود

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFE3F2FD),
        automaticallyImplyLeading: false,
        title: Container(
          padding: const EdgeInsets.only(bottom: 10, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF0D47A1)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const Text(
                "Settings",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Color(0xFF0D47A1),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            leading: Icon(Icons.info),
            title: Text("About App"),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "The application is designed to provide patients with an early disease-detection service, assist physicians, and reduce diagnostic time by generating a concise that supports medical staff.",
              style: TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 20),
          const ListTile(
            leading: Icon(Icons.email),
            title: Text("Contact Emails"),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("support@medapp.com"),
                SizedBox(height: 5),
                Text("developer@medapp.com"),
              ],
            ),
          ),
          const SizedBox(height: 40),
          const SizedBox(height: 30),
          Center(
            child: SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text("تسجيل الخروج"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[200],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
