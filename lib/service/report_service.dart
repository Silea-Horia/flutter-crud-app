import 'package:exam_prep/service/api_service.dart';
import 'package:intl/intl.dart';

import '../model/model.dart';

class ReportService {
  final ApiService apiService;

  const ReportService({required this.apiService});

  Future<List<MapEntry<String, int>>> getMonthlyTotals() async {
    try {
      List<Payment> allTickets = await apiService.getAllPayments();

      Map<String, int> totals = {};

      for (var ticket in allTickets) {
        DateTime date = DateTime.parse(ticket.date);
        String monthKey = DateFormat('yyyy-MM').format(date);

        totals[monthKey] = (totals[monthKey] ?? 0) + ticket.amount;
      }

      var sortedEntries = totals.entries.toList()
        ..sort((a, b) => b.key.compareTo(a.key));

      return sortedEntries;
    } catch (e) {
      throw Exception("Failed to load report data");
    }
  }
}
