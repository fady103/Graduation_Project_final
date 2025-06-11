// view_local_pdf_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class ViewLocalPdfPage extends StatelessWidget {
  final String filePath;
  const ViewLocalPdfPage({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    final bytes = File(filePath).readAsBytesSync();
    return Scaffold(
      appBar: AppBar(
        title: const Text('معاينة التقرير PDF'),
        backgroundColor: const Color(0xFF0D47A1),
      ),
      body: PdfPreview(
        build: (format) async => bytes,
        allowPrinting: true,
        allowSharing: true,
      ),
    );
  }
}