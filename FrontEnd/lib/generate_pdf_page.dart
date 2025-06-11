// generate_pdf_page.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;


class GeneratePdfPage extends StatefulWidget {
  final String testType;
  final Map<String, String> values;
  final String diagnosis;
  final String? imagePath;


  const GeneratePdfPage({
    super.key,
    required this.testType,
    required this.values,
    required this.diagnosis,
    this.imagePath,
  });

  @override
  State<GeneratePdfPage> createState() => _GeneratePdfPageState();
}

class Question {
  final String question;
  final List<String> options;
  final bool multiSelect;
  List<String> selectedAnswers = [];

  Question({
    required this.question,
    required this.options,
    this.multiSelect = false,
  });
}

class _GeneratePdfPageState extends State<GeneratePdfPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController glucoseController = TextEditingController();
  final TextEditingController medicationController = TextEditingController();
  final TextEditingController viralPcrResultController = TextEditingController();
  final TextEditingController viralVaccineDoseController = TextEditingController();
  final TextEditingController parkinsonsMedController = TextEditingController();
  final TextEditingController liverAlcoholController = TextEditingController();
  final TextEditingController anemiaDoseController = TextEditingController();
  final Map<String, bool> chronicConditions = {
    'سكري (Diabetes)': false,
    'ارتفاع ضغط دم (Hypertension)': false,
    'أمراض قلبية (Cardiovascular Disease)': false,
    'أمراض كبدية سابقة (Liver Disease)': false,
    'فقر دم (Anemia)': false,
    'اضطرابات الغدة الدرقية': false,
    'حساسية موسمية أو دوائية': false,
    'تدخين (تدخن حاليًا/تدخنت سابقًا)': false,
    'حالات أخرى': false,
  };
  final TextEditingController chronicOtherController = TextEditingController();
  final TextEditingController freeTextController = TextEditingController();
  String gender = 'ذكر';

  final Map<String, List<Question>> questionsMap = {
    'Diabetes': [
      Question(
        question: 'اختر من الأعراض (يمكن اختيار أكثر من عرض):',
        options: [
          'عطش زائد (Polydipsia)',
          'جوع زائد (Polyphagia)',
          'تبول متكرر (Polyuria)',
          'تعب/إرهاق غير مبرر',
          'فقدان الوزن غير مفسَّر',
          'خدر أو تنميل في الأطراف (قدمين/يدين)',
        ],
        multiSelect: true,
      ),
      Question(
        question: 'هل قمت بقياس السكر بالمنزل (Glucometer) اليوم؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تتناول الأنسولين أو أدوية فموية (مثل: ميتفورمين، جليمبريد)؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تعاني من تشققات أو تقرحات في القدمين؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تشعر بضعف في النظر أو رؤية ضبابية؟',
        options: ['نعم', 'لا'],
      ),
    ],
    'Viral infection': [
      Question(
        question: 'اختر من الأعراض (يمكن اختيار أكثر من عرض):',
        options: [
          'حمى (Fever)',
          'سعال (Dry Cough أو productive cough)',
          'رشح أو انسداد أنفي (Nasal Congestion)',
          'التهاب في الحلق (Sore Throat)',
          'ألم خلف العين أو صداع خلفي',
          'آلام في العضلات والمفاصل (Myalgia/Arthralgia)',
          'قشعريرة ورعشة (Chills)',
        ],
        multiSelect: true,
      ),
      Question(
        question: 'هل قمت بفحص PCR أو مسحة اختبار سريع للفيروس في آخر 72 ساعة؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تلقيت لقاحًا ضد الفيروس (إذا كان متوفرًا)؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تعاني من ضيق تنفس مفاجئ عند بذل مجهود خفيف؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تعيش أو تلتقي مع شخصٍ تأكدت إصابته بالعدوى مؤخرًا؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل لديك تاريخ أمراض رئوية مزمنة (مثل الربو أو الانسداد الرئوي المزمن)؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل استخدمت أي أدوية مضادة للفيروسات (مثل Remdesivir, Favipiravir) أو مضادات حيوية دون وصف الطبيب؟',
        options: ['نعم', 'لا'],
      ),
    ],
    'Parkinsons': [
      Question(
        question: 'اختر من الأعراض (يمكن اختيار أكثر من عرض):',
        options: [
          'رعشة (Tremor) في اليد أو القدم أثناء الراحة',
          'بطء في الحركة (Bradykinesia)',
          'تصلب في العضلات (Muscle Rigidity)',
          'صعوبة في المشي أو توازن غير ثابت (Postural Instability)',
          'تعابير وجه “ثابتة” (Hypomimia)',
          'بطء الكلام (Hypophonia)',
        ],
        multiSelect: true,
      ),
      Question(
        question: 'هل تأخذ حاليًا أدوية مثل Levodopa أو Dopamine agonists؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل لاحظت زحف القدمين أو سحب الأقدام أثناء المشي؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تعاني من صعوبة في الكتابة (خط يد صغير أو متقطع)؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تشعر ببطء في الأكل أو بحة في البلع؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل لديك مشاكل في النوم (مثل الحركة المفرطة أو الكوابيس المتكررة)؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل شعرت بقيامك بحركات لا إرادية (Dyskinesia) بعد أوقات محددة من الجرعات الدوائية؟',
        options: ['نعم', 'لا'],
      ),
    ],
    'Liver Disease': [
      Question(
        question: 'اختر من الأعراض (يمكن اختيار أكثر من عرض):',
        options: [
          'اصفرار العين/الجلد (Jaundice)',
          'ألم أو انزعاج في الجانب الأيمن العلوي للبطن',
          'حكة متكررة في الجلد',
          'براز فاتح اللون (Clay-colored stool)',
          'بول داكن اللون',
          'تعب شديد/إعياء عام',
        ],
        multiSelect: true,
      ),
      Question(
        question: 'هل تشرب الكحول حاليًا أو كنت تشرب بكثرة في السابق؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل لديك تضخم أو ألم في البطن عند الجهة اليمنى مباشرة؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل فقدت شهيتك أو لاحظت فقدان وزن ملحوظ في الأسابيع الماضية؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تتناول أي أدوية تابعة دون وصفة (وخاصة مسكنات من نوع باراسيتامول بجرعات عالية)؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تقوم بغسيل الكلى أو سبق وأن أجريت عملية زرع كبد؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تعرضت للإصابة بنقص أو فيروسات الكبد (مثل فيروس بي أو سي) سابقًا؟',
        options: ['نعم', 'لا'],
      ),
    ],
    'Anemia': [
      Question(
        question: 'اختر من الأعراض (يمكن اختيار أكثر من عرض):',
        options: [
          'تعب مستمر/ضعف عام',
          'دوخة عند الوقوف أو المشي',
          'جلد شاحب أو مخاطية شاحبة',
          'ضيق في التنفس عند بذل أقل جهد',
          'خفقان القلب (Palpitations)',
          'صداع خفيف دائم',
        ],
        multiSelect: true,
      ),
      Question(
        question: 'هل لديك تاريخ نزيف (مثل دورة شهرية غزيرة في الإناث أو نزيف من جيوب أنفية)؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تتناول مكملات حديد أو فيتامين ب12؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تعاني من آلام في الصدر عند بذل مجهود خفيف؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل لاحظت بحة في الصوت أو جفاف في الفم عند بذل جهد؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل لديك تاريخ مرضي ينقص فيه امتصاص الحديد (مثل قرحة معدة أو استئصال جزء من المعدة)؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تتناول غذاء غني بالحديد (لحوم حمراء/بقوليات) بانتظام؟',
        options: ['نعم', 'لا'],
      ),
    ],
    'Covid-19': [
      Question(
        question: 'اختر من الأعراض (يمكن اختيار أكثر من عرض):',
        options: [
          'سعال جاف',
          'حمى خفيفة أو مرتفعة',
          'فقدان حاستي الشم أو التذوق (Anosmia/Ageusia)',
          'ضيق تنفس خفيف إلى متوسط',
          'تعب عام وآلام عضلية',
          'صداع خفيف',
          'التهاب الحلق',
        ],
        multiSelect: true,
      ),
      Question(
        question: 'هل ظهرت لديك أعراض “فقدان الشم أو التذوق”؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل لديك تاريخ احتكاك بشخص مُثبت إيجابيًّا لكوفيد في الأيام السبعة الماضية؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تلقيت كامل جرعات اللقاح (ثلاث جرعات مثلاً)؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تعاني من أمراض مزمنة مثل ضغط وسكري أو ربو؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تشعر بضغط أو ألم خلف القرن (Retro-orbital pain)؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تناولت أي أدوية مضادة للفيروسات (Remdesivir/Favipiravir) بدون وصفة طبية؟',
        options: ['نعم', 'لا'],
      ),
    ],
    'Pneumonia': [
      Question(
        question: 'اختر من الأعراض (يمكن اختيار أكثر من عرض):',
        options: [
          'سعال مصحوب ببلغم أخضر أو أصفر',
          'حمى مرتفعة (> 38.5°C)',
          'ألم في الصدر يزداد مع التنفس أو السعال',
          'ضيق في التنفس (Dyspnea)',
          'تعرق ليلي (Night Sweats)',
          'تعب شديد وإعياء عام',
        ],
        multiSelect: true,
      ),
      Question(
        question: 'هل لديك تاريخ أمراض صدرية مزمنة (مثل الربو أو الانسداد الرئوي المزمن)؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل صاحب السعال بلغم ملون (أخضر/أصفر)؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تشعر بألم حاد في جنب الصدر عند السعال أو التنفس العميق؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل لديك صعوبة في التنفس حتى أثناء الراحة؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تناولت مضادًا حيويًا قبل الفحص ولم يكُن هناك تحسن؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تعاني من أمراض مزمنة مثل السكري أو أمراض القلب؟',
        options: ['نعم', 'لا'],
      ),
    ],
    'Tuberculosis': [
      Question(
        question: 'اختر من الأعراض (يمكن اختيار أكثر من عرض):',
        options: [
          'سعال مستمر لأكثر من 3 أسابيع',
          'سعال مصحوب بدم (Hemoptysis)',
          'تعرق ليلي مفرط',
          'فقدان وزن ملحوظ في الأسابيع الأخيرة',
          'حمى خفيفة/متقطعة (Low-grade Fever)',
          'تعب وضعف عام',
        ],
        multiSelect: true,
      ),
      Question(
        question: 'هل لاحظت فقدان وزن أكثر من 5 كجم في الشهر الأخير؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تعاني من تعرق ليلي يفوق درجتين؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل كان لديك تعرض مباشر لشخص مصاب بالسل في الأسابيع/الأشهر الماضية؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تلقيت لقاح BCG (البنسلين) أثناء الطفولة؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل سبق أن أُجريت لك فحص Mantoux (Tuberculin Skin Test)؟',
        options: ['نعم', 'لا'],
      ),
      Question(
        question: 'هل تناولت أي مضاد للداء السل (مثل Isoniazid, Rifampin) سابقًا؟',
        options: ['نعم', 'لا'],
      ),
    ],
    };

  late List<Question> questions;

  @override
  void initState() {
    super.initState();
    questions = questionsMap[widget.testType] ?? [];
  }

  void generatePdf() async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load('assets/Fonts/Cairo-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    final arabicStyle = pw.TextStyle(font: ttf, fontSize: 14);
    final boldStyle = pw.TextStyle(font: ttf, fontSize: 14, fontWeight: pw.FontWeight.bold);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) => [
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'تقرير الفحص الطبي',
                    style: pw.TextStyle(font: ttf, fontSize: 22, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(height: 24),
                pw.Text('بيانات المريض:', style: boldStyle),
                pw.SizedBox(height: 8),
                pw.Text('الاسم: ${nameController.text}', style: arabicStyle),
                pw.Text('العمر: ${ageController.text}', style: arabicStyle),
                pw.Text('الجنس: $gender', style: arabicStyle),
                pw.Text('نوع الفحص: ${_translate(widget.testType)}', style: arabicStyle),
                pw.SizedBox(height: 20),
                if (widget.values.isNotEmpty) ...[
                  pw.Text('Medical Results:', style: boldStyle),
                  pw.SizedBox(height: 8),
                  pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: {
                      0: const pw.FlexColumnWidth(2),
                      1: const pw.FlexColumnWidth(3),
                    },
                    children: [
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                        children: [
                          pw.Container(
                            alignment: pw.Alignment.center,
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('Value', style: boldStyle.copyWith(color: PdfColors.black)),
                          ),
                          pw.Container(
                            alignment: pw.Alignment.center,
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('Item', style: boldStyle.copyWith(color: PdfColors.black)),
                          ),
                        ],
                      ),
                      ...widget.values.entries.map(
                            (entry) => pw.TableRow(
                          children: [
                            pw.Container(
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(entry.value, style: arabicStyle),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(_translate(entry.key), style: arabicStyle),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                  ,
                ] else if (widget.imagePath != null) ...[ 
                  pw.Text('X-ray Image:', style: boldStyle),
                  pw.SizedBox(height: 8),
                  pw.Image(
                    pw.MemoryImage(File(widget.imagePath!).readAsBytesSync()),
                    fit: pw.BoxFit.none,
                  ),
                ],

                pw.SizedBox(height: 20),
                pw.Text('التشخيص النهائي:', style: boldStyle),
                pw.Text(
                    widget.diagnosis.isNotEmpty ? widget.diagnosis : 'لا يوجد تشخيص مسجّل.',
                    style: arabicStyle
                ),
                pw.SizedBox(height: 20),

                pw.SizedBox(height: 12),
                pw.Text(
                  'التاريخ المرضي والظروف الصحية المزمنة (Medical History):',
                  style: boldStyle,
                ),

                ...(() {
                  final chronicWidgets = chronicConditions.entries.map((e) {
                    if (e.key == 'حالات أخرى' && e.value && chronicOtherController.text.isNotEmpty) {
                      return pw.Text('• ${e.key}: ${chronicOtherController.text}', style: arabicStyle);
                    }
                    if (e.value) {
                      return pw.Text('• ${e.key}', style: arabicStyle);
                    }
                    return null; 
                  }).whereType<pw.Widget>().toList(); 

                  return chronicWidgets.isNotEmpty
                      ? chronicWidgets
                      : [pw.Text('لا يوجد حالات مزمنة.', style: arabicStyle)];
                })(),


                pw.SizedBox(height: 20),

                pw.Text('الإجابات على الأسئلة التشخيصية:', style: boldStyle),
                pw.SizedBox(height: 8),
                ...questions.map((q) {
                  String ans = q.selectedAnswers.isEmpty ? 'لم يتم الإجابة' : q.selectedAnswers.join(', ');
                  if (q.question.contains('Glucometer') && glucoseController.text.isNotEmpty) {
                    ans += ' (قيمة الصائم: ${glucoseController.text})';
                  }
                  if (q.question.contains('أدوية فموية') && medicationController.text.isNotEmpty) {
                    ans += ' (${medicationController.text})';
                  }
                  if (q.question.contains('PCR') && viralPcrResultController.text.isNotEmpty) {
                    ans += ' (النتيجة: ${viralPcrResultController.text})';
                  }
                  if (q.question.contains('لقاح') && viralVaccineDoseController.text.isNotEmpty) {
                    ans += ' (جرعات: ${viralVaccineDoseController.text})';
                  }
                  if (q.question.contains('Levodopa') && parkinsonsMedController.text.isNotEmpty) {
                    ans += ' (أسماء وجرعات: ${parkinsonsMedController.text})';
                  }
                  if (q.question.contains('الكحول') && liverAlcoholController.text.isNotEmpty) {
                    ans += ' (التفاصيل: ${liverAlcoholController.text})';
                  }
                  if (q.question.contains('مكملات حديد') && anemiaDoseController.text.isNotEmpty) {
                    ans += ' (الجرعة: ${anemiaDoseController.text})';
                  }
                  return pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 8),
                    child: pw.Text('${q.question}: $ans', style: arabicStyle),
                  );
                }),
                pw.SizedBox(height: 12),

                pw.Text(
                  '"هل هناك ما تشكو منه ايضا؟”',
                  style: boldStyle,
                ),
                pw.Text(
                  freeTextController.text.isNotEmpty
                      ? freeTextController.text
                      : 'لا توجد ملاحظات إضافية.',
                  style: arabicStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  String _translate(String key) {
    const translations = {
      'Diabetes': 'السكري',
      'Viral infection': 'عدوى فيروسية',
      'Parkinsons': 'باركنسون',
      'Liver Disease': 'مرض الكبد',
      'Anemia': 'فقر الدم',
      'Tuberculosis': 'السل',
      'Covid-19': 'كوفيد-19',
      'Pneumonia': 'التهاب رئوي',
      'Glucose': 'الجلوكوز',
      'Blood Pressure': 'ضغط الدم',
      'Heart Rate': 'معدل ضربات القلب',
      'Temperature': 'درجة الحرارة',
    };
    return translations[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إنشاء ملف PDF"),
        backgroundColor: Colors.blue[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "الاسم"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "العمر"),
              ),
              const SizedBox(height: 24),
              const Text("النوع:", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => gender = 'ذكر'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: gender == 'ذكر' ? Colors.blue[100] : Colors.white,
                          border: Border.all(color: gender == 'ذكر' ? Colors.blue : Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(child: Text("ذكر")),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => gender = 'أنثى'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: gender == 'أنثى' ? Colors.pink[100] : Colors.white,
                          border: Border.all(color: gender == 'أنثى' ? Colors.pink : Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(child: Text("أنثى")),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const SizedBox(height: 24),
              const Text(
                'التاريخ المرضي والظروف الصحية المزمنة (Medical History)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ...chronicConditions.keys.map((key) {
                return CheckboxListTile(
                  title: Text(key),
                  value: chronicConditions[key],
                  onChanged: (v) {
                    setState(() => chronicConditions[key] = v!);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }).toList(),
              if (chronicConditions['حالات أخرى'] == true)
                TextField(
                  controller: chronicOtherController,
                  decoration: const InputDecoration(
                    labelText: 'أدخل الحالة الأخرى',
                  ),
                ),
              if (questions.isEmpty)
                const Text('لا توجد أسئلة لهذا التحليل.', style: TextStyle(fontSize: 16, color: Colors.red))
              else ...[
                const Text("الأسئلة:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...questions.map((q) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(q.question, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      ...q.options.map((option) {
                        final isSelected = q.selectedAnswers.contains(option);
                        return CheckboxListTile(
                          title: Text(option),
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              if (q.multiSelect) {
                                if (value == true) {
                                  q.selectedAnswers.add(option);
                                } else {
                                  q.selectedAnswers.remove(option);
                                }
                              } else {
                                q.selectedAnswers = [option];
                              }
                            });
                          },
                        );
                      }).toList(),

                      if (q.question.contains('PCR') && q.selectedAnswers.contains('نعم'))
                        Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text('النتيجة: '),
                                  Radio<String>(
                                    value: 'إيجابي',
                                    groupValue: viralPcrResultController.text,
                                    onChanged: (v) => setState(() { viralPcrResultController.text = v!; }),
                                  ),
                                  const Text('إيجابي'),
                                  Radio<String>(
                                    value: 'سلبي',
                                    groupValue: viralPcrResultController.text,
                                    onChanged: (v) => setState(() { viralPcrResultController.text = v!; }),
                                  ),
                                  const Text('سلبي'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      if (q.question.contains('تلقيت لقاح') && q.selectedAnswers.contains('نعم'))
                        Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 8),
                          child: TextField(
                            controller: viralVaccineDoseController,
                            decoration: const InputDecoration(labelText: 'كم جرعة ومتى كانت آخر جرعة؟'),
                          ),
                        ),
                      if (q.question.contains('Levodopa') && q.selectedAnswers.contains('نعم'))
                        Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 8),
                          child: TextField(
                            controller: parkinsonsMedController,
                            decoration: const InputDecoration(labelText: 'اذكر الأسماء والجرعات وعدد المرات يوميًا'),
                          ),
                        ),

                      if (q.question.contains('الكحول') && q.selectedAnswers.contains('نعم'))
                        Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 8),
                          child: TextField(
                            controller: liverAlcoholController,
                            decoration: const InputDecoration(labelText: 'اذكر نوع المشروب وعدد مرات الأسبوع'),
                          ),
                        ),

                      if (q.question.contains('مكملات حديد') && q.selectedAnswers.contains('نعم'))
                        Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 8),
                          child: TextField(
                            controller: anemiaDoseController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(labelText: 'ما الجرعة اليومية؟'),
                          ),
                        ),
                      const Divider(),
                    ],
                  );
                }).toList(),
              ],
              const SizedBox(height: 24),
              const Text(
                '"هل هناك ما تشكو منه ايضا؟"',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: freeTextController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'اكتب هنا وصفًا مفصّلاً...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("إنشاء PDF"),
                  onPressed: () {
                    if (nameController.text.isEmpty || ageController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("يرجى إدخال الاسم والعمر")),
                      );
                      return;
                    }
                    generatePdf();
                  },
                ),),
            ],
          ),
        ),
      ),
    );
  }
}