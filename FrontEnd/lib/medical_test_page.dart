// medical_test_page.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'api.dart';
import 'results_page.dart';

class MedicalTestPage extends StatefulWidget {
  final String title;
  const MedicalTestPage({Key? key, required this.title}) : super(key: key);

  @override
  _MedicalTestPageState createState() => _MedicalTestPageState();
}

class _MedicalTestPageState extends State<MedicalTestPage> {
  late List<String> fields;
  bool requiresGender = false;
  int genderValue = 0;
  final Map<String, TextEditingController> controllers = {};
  final Api api = Api(dio: Dio(), apiKey: "");

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    switch (widget.title) {
      case "Diabetes":
        requiresGender = false;
        fields = [
          "Pregnancies", "Glucose", "BloodPressure", "SkinThickness",
          "Insulin", "BMI", "DiabetesPedigreeFunction", "Age"
        ];
        break;
      case "Liver Disease":
        requiresGender = true;
        fields = [
          "Age", "BMI", "AlcoholConsumption", "Smoking", "GeneticRisk",
          "PhysicalActivity", "Diabetes", "Hypertension", "LiverFunctionTest"
        ];
        break;
      case "Anemia":
        requiresGender = true;
        fields = ["Hemoglobin", "MCH", "MCHC", "MCV"];
        break;
      case "Viral infection":
        requiresGender = false;
        fields = [
          "WBCS", "RBCs", "Haemoglobin", "Hematocrit (PCV)", "M.C.V", "M.C.H",
          "M.C.H.C", "RDW", "Platelets Count", "MPV", "Neutrophils%",
          "Neutrophils#", "Lymphocytes%", "Lymphocytes#", "Monocyte%",
          "Monocyte#", "Eosinophils%", "Eosinophils#", "Basophils%",
          "Basophils#", "Large Unstained Cells%", "Large Unstained Cells#"
        ];
        break;
      case "Parkinsons":
        requiresGender = true;
        fields = [
          "Age", "Ethnicity", "EducationLevel", "BMI", "Smoking",
          "AlcoholConsumption", "PhysicalActivity", "DietQuality", "SleepQuality",
          "FamilyHistoryParkinsons", "TraumaticBrainInjury", "Hypertension",
          "Diabetes", "Depression", "Stroke", "SystolicBP", "DiastolicBP",
          "CholesterolTotal", "CholesterolLDL", "CholesterolHDL",
          "CholesterolTriglycerides", "UPDRS", "MoCA", "FunctionalAssessment",
          "Tremor", "Rigidity", "Bradykinesia", "PosturalInstability",
          "SpeechProblems", "SleepDisorders", "Constipation"
        ];
        break;
      default:
        requiresGender = false;
        fields = ["Value 1", "Value 2"];
    }

    for (var field in fields) {
      controllers[field] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Map<String, dynamic> _formatDataForModule(String testType) {
    Map<String, dynamic> values = {};
    for (var field in fields) {
      values[field] = double.tryParse(controllers[field]?.text ?? '') ?? 0.0;
    }

    if (requiresGender) {
      if (testType == "Anemia") {
        values["Gender"] = genderValue == 0 ? 1 : 0;
      } else {
        values["Gender"] = genderValue;
      }
    }

    return {"data": values};
  }

  Future<void> _sendDataToBackend() async {
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> data = _formatDataForModule(widget.title);

    String diagnosis = await api.sendMedicalReport(
      data.map((key, value) => MapEntry(key, value.toString())),
      widget.title,
    );

    setState(() {
      _isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsPage(
          data: {
            "testType": widget.title,
            "values": Map<String, String>.from(
              data["data"].map((key, value) => MapEntry(key, value.toString())),
            ),
            "diagnosis": diagnosis,
          },
          title: widget.title,
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
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
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (requiresGender) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text("Male"),
                      selected: genderValue == 0,
                      onSelected: (_) {
                        setState(() {
                          genderValue = 0;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text("Female"),
                      selected: genderValue == 1,
                      onSelected: (_) {
                        setState(() {
                          genderValue = 1;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              Expanded(
                child: ListView.builder(
                  itemCount: fields.length,
                  itemBuilder: (context, index) {
                    final field = fields[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              field,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: controllers[field],
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+\.?[0-9]*')),
                              ],
                              decoration: InputDecoration(
                                hintText: "Enter value",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _sendDataToBackend,
                icon: _isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.send),
                label: Text(_isLoading ? "Sending..." : "Send"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade300,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
