import 'package:flutter/material.dart';
import 'package:reminderwater_apss/db/database_service.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late DatabaseHelper database;
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    database = DatabaseHelper.instance; // Inisialisasi variabel database
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await database.getAllHistory();
    setState(() {
      _history = history;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _history.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _history[index];
          final date = item['date'];
          final count = item['count'];

          return ListTile(
            title: Text('Tanggal: $date'),
            subtitle: Text('Jumlah: $count'),
          );
        },
      ),
    );
  }
}
