// tips_page.dart
import 'package:flutter/material.dart';
import 'medical_advice_page.dart';

class TipsPage extends StatelessWidget {
  final String diagnosis;
  final String title;

  const TipsPage({Key? key, required this.diagnosis, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> tips = MedicalAdvicePage.getTips(title);

    return Scaffold(
      appBar: AppBar(
        title: const Text("نصائح طبية"),
        backgroundColor: Colors.green[100],
        foregroundColor: Colors.green[900],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                tips[index],
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}
