import 'dart:convert';

import 'package:exam_prep/model/model.dart';
import 'package:exam_prep/repository/repository.dart';
import 'package:exam_prep/screens/detail.dart';
import 'package:exam_prep/screens/report.dart';
import 'package:exam_prep/service/api_service.dart';
import 'package:exam_prep/service/insight_service.dart';
import 'package:exam_prep/service/report_service.dart';
import 'package:flutter/material.dart';

import 'insight.dart';

class Master extends StatefulWidget {
  const Master({
    super.key,
    required this.title,
    required this.repository,
    required this.apiService,
    required this.reportService,
    required this.insightService,
  });

  final String title;
  final Repository repository;
  final ApiService apiService;
  final ReportService reportService;
  final InsightService insightService;

  @override
  State<Master> createState() => _MasterState();
}

class _MasterState extends State<Master> {
  int _selectedId = -1;
  late Repository repository;

  @override
  void initState() {
    super.initState();
    repository = widget.repository;
    _initWebSocketListener();
  }

  void _initWebSocketListener() {
    widget.apiService.ticketStream.listen((message) {
      if (!mounted) return;

      try {
        final Map<String, dynamic> data = json.decode(message);
        final Payment item = Payment.fromJson(data);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("New Item Added: ${item.toString()}"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
            action: SnackBarAction(
              label: "Refresh",
              textColor: Colors.white,
              onPressed: () {
                repository.getAll();
              },
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
        debugPrint("WebSocket Error: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Items")),
      drawer: drawer(context),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: repository.itemsById,
              builder: (context, Map<int, Payment>? currentItems, child) {
                if (currentItems == null) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Fetching data...'),
                      ],
                    ),
                  );
                }
                if (currentItems.isEmpty) {
                  return Center(child: Text('Empty list'));
                }
                var items = currentItems.values.toList();
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) => items[index].toListTile(
                    _selectedId,
                    () {
                      setState(() {
                        _selectedId = items[index].id;
                      });
                    },
                    _selectedId == items[index].id
                        ? Theme.of(context).colorScheme.tertiaryContainer
                        : Theme.of(context).colorScheme.primaryContainer,
                  ),
                );
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: repository.itemsById,
            builder: (context, Map<int, Payment>? currentItems, child) {
              var isOnline = currentItems != null;
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    retryButton(context),
                    createButton(isOnline, context),
                    viewButton(context),
                    deleteButton(context),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Drawer drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Navigation Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Report'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Report(service: widget.reportService),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.insights),
            title: Text('Insight'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Insight(service: widget.insightService),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  ElevatedButton retryButton(BuildContext context) {
    return ElevatedButton(onPressed: repository.getAll, child: Text('Refresh'));
  }

  ElevatedButton createButton(bool isOnline, BuildContext context) {
    return ElevatedButton(
      onPressed: isOnline
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Detail(item: Payment.empty(), repository: repository),
                ),
              );
              setState(() {
                _selectedId = -1;
              });
            }
          : null,
      child: Text("Create"),
    );
  }

  ElevatedButton viewButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _selectedId != -1
          ? () {
              var ticket = repository.itemsById.value?[_selectedId];
              if (ticket != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Detail(item: ticket, repository: repository),
                  ),
                );
              }
            }
          : null,
      child: Text('View'),
    );
  }

  ElevatedButton deleteButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _selectedId != -1
          ? () async {
              var ticket = repository.itemsById.value?[_selectedId];
              if (ticket != null) {
                try {
                  await repository.delete(_selectedId);
                  setState(() {
                    _selectedId = -1;
                  });
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              }
            }
          : null,
      child: Text('Delete'),
    );
  }
}
