import 'package:flutter/material.dart';

class AppBarComponent extends StatelessWidget {
  final VoidCallback onRefresh;
  const AppBarComponent({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        shadowColor: Colors.transparent,
        actions: [
          IconButton(onPressed: onRefresh, icon: const Icon(Icons.refresh))
        ],
        backgroundColor: Colors.transparent,
        title: const Text(
          'Weather App',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ));
  }
}
