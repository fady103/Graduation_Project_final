import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'app_const.dart';
import 'report_store.dart'; 
import 'pdf_preview_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List operations = [];
  List<Map<String, dynamic>> localReports = [];
  bool isLoading = true;

  Future<void> fetchOperations() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://kemetgamesg.com/medical_test/get_operations.php',
        queryParameters: {'user_id': kUserId},
      );
      setState(() {
        operations = response.data;
        operations.sort((a, b) => b['operation_date'].compareTo(a['operation_date']));
      });
    } catch (e) {
      print('Error fetching operations: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOperations();
    localReports = ReportStore.getReports(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFE3F2FD),
        automaticallyImplyLeading: false,
        title: Container(
          padding: const EdgeInsets.only(bottom: 10),
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
                "الملف الشخصي",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Color(0xFF0D47A1),
                ),
              ),
              const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/image/download.png'),
                backgroundColor: Colors.transparent,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🆔 المعرف: $kUserId", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("👤 الاسم: $kUserName", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("📧 البريد الإلكتروني: $kUserEmail", style: const TextStyle(fontSize: 16)),
            const Divider(height: 32),

            const Text("📋 التقارير المحلية", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            if (localReports.isEmpty)
              const Text("لا توجد تقارير محلية.")
            else
              SizedBox(
                height: 150,
                child: ListView.builder(
                  itemCount: localReports.length,
                  itemBuilder: (context, index) {
                    final report = localReports[index];
                    return Card(
                      child: ListTile(
                        title: Text(report['testType']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("📅 التاريخ: ${report['date']}"),
                            Text("📄 التشخيص: ${report['diagnosis']}"),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PdfPreviewPage(
                                testType: report["testType"],
                                values: Map<String, String>.from(report["values"]),
                                diagnosis: report["diagnosis"], name: 'ابرام', age: '24',
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

            const Divider(height: 32),
            const Text("📝 العمليات الطبية", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
              child: operations.isEmpty
                  ? const Text("لا توجد عمليات مسجلة.")
                  : ListView.builder(
                itemCount: operations.length,
                itemBuilder: (context, index) {
                  final op = operations[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.medical_services),
                      title: Text(op['disease_name']),
                      subtitle: Text("النتيجة: ${op['result']}"),
                      trailing: Text(op['operation_date']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
