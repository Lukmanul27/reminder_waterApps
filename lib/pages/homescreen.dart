import 'package:flutter/material.dart';

import '../db/database_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalDrinks = 0; // Menambahkan variabel totalDrinks

  @override
  void initState() {
    super.initState();
    _loadTotalDrinks(); // Memuat total minuman saat halaman dimuat
  }

  Future<void> _loadTotalDrinks() async {
    final database = DatabaseHelper.instance;
    int drinks = await database.getTotalDrinks();
    setState(() {
      totalDrinks = drinks;
    });
  }

  void _incrementDrinks(BuildContext context) async {
    final database = DatabaseHelper.instance;
    totalDrinks++;

    await database.updateTotalDrinks(totalDrinks);
    await database.insertHistory(DateTime.now().toString(), totalDrinks);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data berhasil disimpan!')),
    );

    _loadTotalDrinks(); // Memuat ulang total minuman setelah data diperbarui
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Halaman Home',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _incrementDrinks(context);
            },
            child: Text('Minum'),
          ),
          SizedBox(height: 20),
          Text('Total Minuman: $totalDrinks'),
        ],
      ),
    );
  }
}
