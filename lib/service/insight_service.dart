import 'package:exam_prep/model/model.dart';
import 'package:exam_prep/service/api_service.dart';

class InsightService {
  final ApiService apiService;

  const InsightService({required this.apiService});

  Future<List<MapEntry<String, int>>> getTopCategories() async {
    try {
      List<Payment> allTickets = await apiService.getAllPayments();

      Map<String, int> categoryTotals = {};
      for (var ticket in allTickets) {
        categoryTotals[ticket.category] =
            (categoryTotals[ticket.category] ?? 0) + ticket.amount;
      }

      var sorted = categoryTotals.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return sorted.take(3).toList();
    } catch (e) {
      throw Exception("Failed to load insights");
    }
  }
}
