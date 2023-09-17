import 'package:flutter/material.dart';

import 'UI/Add.dart';
import 'UI/login.dart';

void main() {
  runApp(const MyApp());
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String type;

  CustomAppBar({required this.type});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('D3 Express'),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,

      actions: type == "0"
          ? [
              IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const Add_order();
                        },
                      ),
                    );
                  }),
              IconButton(
                  icon: const Icon(Icons.refresh_rounded), onPressed: () {}),
            ]
          : [],

      // Add other AppBar properties as needed
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'D3 Express',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Login(),
    );
  }
}
