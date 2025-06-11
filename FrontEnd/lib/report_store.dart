// report_store.dart

class ReportStore {
  static final List<Map<String, dynamic>> _reports = [];

  static void addReport(Map<String, dynamic> report) {
    _reports.add(report);
  }

  static List<Map<String, dynamic>> getReports() {
    return List.from(_reports);
  }
}