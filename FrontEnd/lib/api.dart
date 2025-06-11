// api. dart
import 'package:dio/dio.dart';

class Api {
  final Dio dio;
  final String apiKey;

  Api({required this.dio, required this.apiKey});

  final Map<String, String> medicalEndpoints = {
    "Diabetes": "https://medical-diagnosis-api.onrender.com/predict/data/diapetes",
    "Liver Disease": "https://medical-diagnosis-api.onrender.com/predict/data/liver",
    "Anemia": "https://medical-diagnosis-api.onrender.com/predict/data/anemia",
    "Viral infection": "https://medical-diagnosis-api.onrender.com/predict/data/viral",
    "Parkinsons": "https://medical-diagnosis-api.onrender.com/predict/data/parkinsons",
  };

  final Map<String, String> xrayEndpoints = {
    "Pneumonia": "https://medical-diagnosis-api.onrender.com/predict/image/pneumonia",
    "Covid-19": "https://medical-diagnosis-api.onrender.com/predict/image/covid",
    "Tuberculosis": "https://medical-diagnosis-api.onrender.com/predict/image/tuberculosis",
  };

  Future<String> sendMedicalReport(Map<String, String> data, String testType) async {
    final url = medicalEndpoints[testType];
    if (url == null) return "Unsupported test type";

    try {
      final response = await dio.post(
        url,
        data: {
          'testType': testType,
          'data': data,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.data['diagnosis'] ?? "No diagnosis received";
    } catch (e) {
      print("Error sending medical report: $e");
      return "Error occurred";
    }
  }

  Future<String> predictXray(String imagePath, String type) async {
    final url = xrayEndpoints[type];
    if (url == null) return "Unsupported X-ray type";

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imagePath, filename: 'xray.jpg',contentType: DioMediaType("image", "jpeg"),),
      });

      final response = await dio.post(
        url,
        data: formData,
          options: Options(
              headers: {
                "Content-Type": "multipart/form-data",
              },
              sendTimeout: Duration(seconds: 10),
              receiveTimeout: Duration(seconds: 30))
      );

      return response.data['diagnosis'] ?? "No diagnosis received";
    } catch (e) {
      print("Error predicting X-ray: $e");
      return "Error occurred";
    }
  }
}
