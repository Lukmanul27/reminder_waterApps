import 'package:flutter/material.dart';
import 'package:reminderwater_apss/db/database_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _numberOfDrinks = 0;

  @override
  void initState() {
    super.initState();
    _loadTotalDrinks();
  }

  Future<void> _loadTotalDrinks() async {
    final totalDrinks = await DatabaseHelper.instance.getTotalDrinks();
    setState(() {
      _numberOfDrinks = totalDrinks;
    });
  }

  void _incrementDrinks() async {
    setState(() {
      _numberOfDrinks++;
    });
    await DatabaseHelper.instance.updateTotalDrinks(_numberOfDrinks);
  }

  void _decrementDrinks() async {
    setState(() {
      if (_numberOfDrinks > 0) {
        _numberOfDrinks--;
      }
    });
    await DatabaseHelper.instance.updateTotalDrinks(_numberOfDrinks);
  }

  Future<void> _saveData(BuildContext context) async {
    int totalDrinks = _numberOfDrinks;

    // Menyimpan data ke database
    await DatabaseHelper.instance.saveData(totalDrinks);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notification'),
          content: Text('Data berhasil disimpan!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Reminder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You have consumed $_numberOfDrinks glasses of water.',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _incrementDrinks,
                  color: Colors.blue,
                  splashColor: Color.fromARGB(255, 48, 224, 218),
                  highlightColor: Color.fromARGB(226, 30, 15, 15),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _saveData(context),
        child: Icon(Icons.save),
      ),
    );
  }
}
