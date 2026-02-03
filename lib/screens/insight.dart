import 'package:exam_prep/service/insight_service.dart';
import 'package:flutter/material.dart';

class Insight extends StatefulWidget {
  final InsightService service;

  const Insight({super.key, required this.service});

  @override
  State<Insight> createState() => _InsightState();
}

class _InsightState extends State<Insight> {
  late Future<List<MapEntry<String, int>>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.service.getTopCategories().catchError((error) {
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
      appBar: AppBar(title: Text('Insight')),
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
                leading: CircleAvatar(child: Text("${index + 1}")),
                title: Text(
                  entry.key,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  "\$${entry.value}",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
