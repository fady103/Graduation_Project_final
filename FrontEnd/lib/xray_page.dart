import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api.dart';
import 'results_page.dart';

class XRayPage extends StatefulWidget {
  final String title;
  const XRayPage({Key? key, required this.title}) : super(key: key);

  @override
  State<XRayPage> createState() => _XRayPageState();
}

class _XRayPageState extends State<XRayPage> {
  final Api api = Api(dio: Dio(), apiKey: ""); 
  XFile? _selectedImage;
  String _diagnosis = "";
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
        _diagnosis = "";
      });
    }
  }

  Future<void> _sendXray() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String diagnosis = await api.predictXray(_selectedImage!.path, widget.title);

      setState(() {
        _diagnosis = diagnosis;
        _isLoading = false;
      });

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsPage(
              data: {
                "testType": widget.title,
                "diagnosis": diagnosis,
                "values": {},
                "imagePath": _selectedImage!.path,
              },
              title: widget.title,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send X-ray: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFCE4EC),
              Color(0xFFF8BBD0),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text("Choose Image"),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: _selectedImage != null
                        ? Image.file(
                      File(_selectedImage!.path),
                      fit: BoxFit.contain,
                      width: double.infinity,
                    )
                        : const Text(
                      "NO IMAGE YET",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _sendXray,
                  icon: _isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                      : const Icon(Icons.send),
                  label: Text(_isLoading ? "Sending..." : "Send"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFCE4EC),
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
