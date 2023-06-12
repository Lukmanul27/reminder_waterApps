import 'package:flutter/material.dart';
import 'package:reminderwater_apss/db/interval_db.dart';

class IntervalPage extends StatefulWidget {
  @override
  _IntervalPageState createState() => _IntervalPageState();
}

class _IntervalPageState extends State<IntervalPage> {
  int selectedInterval = 60; // Interval notifikasi default

  @override
  void initState() {
    super.initState();
    _loadInterval(); // Memuat interval dari database saat halaman dimuat
  }

  Future<void> _loadInterval() async {
    final interval = await inDb.instance.getInterval();
    setState(() {
      selectedInterval = interval;
    });
  }

  Future<void> _saveInterval() async {
    await inDb.instance.saveInterval(selectedInterval);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Interval disimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interval Notifikasi'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Interval'),
            trailing: DropdownButton<int>(
              value: selectedInterval,
              onChanged: (int? value) {
                setState(() {
                  selectedInterval = value!;
                });
              },
              items: [
                DropdownMenuItem<int>(
                  value: 30,
                  child: const Text('30 Menit'),
                ),
                DropdownMenuItem<int>(
                  value: 60,
                  child: const Text('1 Jam'),
                ),
                DropdownMenuItem<int>(
                  value: 120,
                  child: const Text('2 Jam'),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _saveInterval,
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
