import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminderwater_apss/db/mode_db.dart';
import 'package:reminderwater_apss/db/interval_db.dart';

class AktifKanPage extends StatefulWidget {
  @override
  _AktifKanPageState createState() => _AktifKanPageState();
}

class _AktifKanPageState extends State<AktifKanPage> {
  bool isAktif = false;

  @override
  void initState() {
    super.initState();
    _loadMode();
  }

  Future<void> _loadMode() async {
    final savedMode = await DatabaseHelper.instance.getMode();
    setState(() {
      isAktif = (savedMode == 'Aktif');
    });
  }

  Future<void> _updateMode(String newMode) async {
    await DatabaseHelper.instance.updateMode(newMode);
    setState(() {
      isAktif = (newMode == 'Aktif');
    });

    if (isAktif) {
      _scheduleNotifications();
    } else {
      _cancelNotifications();
    }
  }

  void _scheduleNotifications() {
    // Ambil nilai interval dari database
    inDb.instance.getInterval().then((interval) {
      // Schedule notifikasi dengan interval yang ditentukan
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      // Konfigurasi notifikasi
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'reminder_water_apps',
        'the_reminder_water',
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      // Batasi jumlah notifikasi yang akan dijadwalkan
      final numberOfNotifications = 10;
      for (int i = 0; i < numberOfNotifications; i++) {
        final scheduledTime =
            DateTime.now().add(Duration(minutes: interval * (i + 1)));
        flutterLocalNotificationsPlugin.schedule(
          i,
          'Reminder',
          'Waktunya minum air!',
          scheduledTime,
          platformChannelSpecifics,
        );
      }
    });
  }

  void _cancelNotifications() {
    // Batal jadwalkan notifikasi
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    final numberOfNotifications = 10;
    for (int i = 0; i < numberOfNotifications; i++) {
      flutterLocalNotificationsPlugin.cancel(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aktifkan Notifikasi'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Aktifkan Notifikasi'),
                content:
                    const Text('Apakah Anda ingin mengaktifkan notifikasi?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup dialog
                      _updateMode('Aktif'); // Update mode menjadi "Aktif"
                    },
                    child: const Text('Ya'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup dialog
                      _updateMode('Nonaktif'); // Update mode menjadi "Nonaktif"
                    },
                    child: const Text('Tidak'),
                  ),
                ],
              ),
            );
          },
          child: Text(isAktif ? 'Nonaktifkan' : 'Aktifkan'),
        ),
      ),
    );
  }
}
