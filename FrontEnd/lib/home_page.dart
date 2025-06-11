import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'profile_page.dart';
import 'medical_test_page.dart';
import 'xray_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xFFE3F2FD),
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.settings, color: Color(0xFF0D47A1)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsPage()),
                      );
                    },
                  ),
                ),

                const Text(
                  "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Color(0xFF0D47A1),
                  ),
                ),

                
                Builder(
                  builder: (context) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/image/download.png'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
            bottom: const TabBar(
              indicatorColor: Color(0xFF0D47A1),
              labelColor: Color(0xFF0D47A1),
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: "Medical Reports"),
                Tab(text: "X-Rays"),
              ],
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF1F8E9),
                  Color(0xFFE8F5E9),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: TabBarView(
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      buildCategoryCard(Icons.monitor_heart, "Diabetes", const Color(0xFF64B5F6), context, const MedicalTestPage(title: "Diabetes")),
                      buildCategoryCard(Icons.local_drink, "Liver Disease", const Color(0xFF81C784), context, const MedicalTestPage(title: "Liver Disease")),
                      buildCategoryCard(Icons.favorite, "Anemia", const Color(0xFFFF8A65), context, const MedicalTestPage(title: "Anemia")),
                      buildCategoryCard(Icons.coronavirus, "Viral infection", const Color(0xFFBA68C8), context, const MedicalTestPage(title: "Viral infection")),
                      buildCategoryCard(Icons.elderly, "Parkinsons", const Color(0xFF90A4AE), context, const MedicalTestPage(title: "Parkinsons")),
                    ],
                  ),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      buildCategoryCard(Icons.air, "Pneumonia", const Color(0xFF4FC3F7), context, const XRayPage(title: "Pneumonia")),
                      buildCategoryCard(Icons.coronavirus, "Covid-19", const Color(0xFFE57373), context, const XRayPage(title: "Covid-19")),
                      buildCategoryCard(Icons.biotech, "Tuberculosis", const Color(0xFFAED581), context, const XRayPage(title: "Tuberculosis")),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCategoryCard(IconData icon, String title, Color color, BuildContext context, Widget page) {
    return Builder(
      builder: (BuildContext innerContext) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              innerContext,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          child: Container(
            width: 110,
            height: 110,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: color),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
