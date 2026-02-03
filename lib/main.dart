import 'package:exam_prep/repository/repository.dart';
import 'package:exam_prep/screens/master.dart';
import 'package:exam_prep/service/api_service.dart';
import 'package:exam_prep/service/insight_service.dart';
import 'package:exam_prep/service/report_service.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Repository repository = Repository();
    final ApiService apiService = ApiService();
    final ReportService reportService = ReportService(apiService: apiService);
    final InsightService insightService = InsightService(
      apiService: apiService,
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Master(
        title: 'Flutter Demo Home Page',
        repository: repository,
        apiService: apiService,
        reportService: reportService,
        insightService: insightService,
      ),
    );
  }
}
