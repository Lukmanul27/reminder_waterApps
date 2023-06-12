import 'package:flutter/material.dart';
import 'package:reminderwater_apss/theme/interval.dart';
import 'package:reminderwater_apss/theme/mode.dart';
import 'package:reminderwater_apss/theme/onoff.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Aktifkan Notifikasi'),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AktifKanPage()),
                );
              },
              child: const Text('Aktifkan'),
            ),
          ),
          ListTile(
            title: const Text('Mode Notifikasi'),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ModePage()),
                );
              },
              child: const Text('Pilih Mode'),
            ),
          ),
          ListTile(
            title: const Text('Interval Notifikasi'),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IntervalPage()),
                );
              },
              child: const Text('Atur Interval'),
            ),
          ),
        ],
      ),
    );
  }
}
