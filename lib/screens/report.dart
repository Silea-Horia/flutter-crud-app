import 'package:exam_prep/service/report_service.dart';
import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  final ReportService service;

  const Report({super.key, required this.service});

  @override
  State<StatefulWidget> createState() => ReportState();
}

class ReportState extends State<Report> {
  late Future<List<MapEntry<String, int>>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.service.getMonthlyTotals().catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $error")));
      }
      throw error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report')),
      body: FutureBuilder<List<MapEntry<String, int>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data available"));
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final entry = data[index];
              return ListTile(
                title: Text(
                  entry.key,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  "\$${entry.value}",
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
                leading: Icon(Icons.calendar_month),
              );
            },
          );
        },
      ),
    );
  }
}
