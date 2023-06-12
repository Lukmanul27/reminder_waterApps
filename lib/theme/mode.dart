import 'package:flutter/material.dart';
import 'package:reminderwater_apss/db/mode_db.dart';

enum Mode { Suara, Getar }

class ModePage extends StatefulWidget {
  @override
  _ModePageState createState() => _ModePageState();
}

class _ModePageState extends State<ModePage> {
  Mode selectedMode = Mode.Suara;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mode Notifikasi'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Mode Suara'),
            leading: Radio<Mode>(
              value: Mode.Suara,
              groupValue: selectedMode,
              onChanged: (Mode? value) {
                setState(() {
                  selectedMode = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Mode Getar'),
            leading: Radio<Mode>(
              value: Mode.Getar,
              groupValue: selectedMode,
              onChanged: (Mode? value) {
                setState(() {
                  selectedMode = value!;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _saveMode();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _saveMode() {
    // Simpan perubahan ke database
    String modeString = selectedMode == Mode.Suara ? 'Suara' : 'Getar';
    DatabaseHelper.instance.insertMode(modeString);

    // Tampilkan snackbar sebagai konfirmasi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('Perubahan disimpan')),
    );
  }
}
