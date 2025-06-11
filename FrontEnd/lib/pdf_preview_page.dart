// pdf_preview_page.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';

class PdfPreviewPage extends StatelessWidget {
  final String testType;
  final Map<String, String> values;
  final String diagnosis;
  final String name; 
  final String age;  

  const PdfPreviewPage({
    super.key,
    required this.testType,
    required this.values,
    required this.diagnosis,
    required this.name,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('معاينة التقرير PDF'),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: PdfPreview(
        build: (format) => buildPdf(),
        allowSharing: true,
        canChangePageFormat: false,
        canChangeOrientation: false,
      ),
    );
  }

  Future<Uint8List> buildPdf() async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/Fonts/Cairo-Regular.ttf');
    final cairoFont = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(24),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(
                    child: pw.Text(
                      'تقرير طبي',
                      style: pw.TextStyle(
                        font: cairoFont,
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text("📋 نوع التحليل: $testType", style: pw.TextStyle(font: cairoFont, fontSize: 18)),
                  pw.SizedBox(height: 10),
                  pw.Text("👤 الاسم: $name", style: pw.TextStyle(font: cairoFont, fontSize: 16)),
                  pw.Text("🎂 العمر: $age سنة", style: pw.TextStyle(font: cairoFont, fontSize: 16)),
                  pw.Divider(thickness: 1.2),
                  pw.SizedBox(height: 10),
                  pw.Text("🔍 النتائج:", style: pw.TextStyle(font: cairoFont, fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),
                  pw.Table(
                    border: pw.TableBorder.all(),
                    children: values.entries.map(
                          (entry) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(entry.value, style: pw.TextStyle(font: cairoFont, fontSize: 14)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(entry.key, style: pw.TextStyle(font: cairoFont, fontSize: 14)),
                          ),
                        ],
                      ),
                    ).toList(),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text("🧠 التشخيص:", style: pw.TextStyle(font: cairoFont, fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),
                  pw.Text(diagnosis, style: pw.TextStyle(font: cairoFont, fontSize: 14)),
                ],
              ),
            ),
          );
        },
      ),
    );

    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final reportsDir = Directory('${dir.path}/reports');
    if (!await reportsDir.exists()) {
      await reportsDir.create(recursive: true);
    }

    final fileName = '${DateTime.now().millisecondsSinceEpoch}_$testType.pdf';
    final file = File('${reportsDir.path}/$fileName');
    await file.writeAsBytes(bytes);

    return Uint8List.fromList(bytes);
  }

}
