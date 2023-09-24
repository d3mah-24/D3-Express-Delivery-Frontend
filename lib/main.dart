import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'UI/Add.dart';
import 'UI/login.dart';

void main() {
  runApp(const MyApp());
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String type;
  final String address;
  String userId = "";

  autoLogOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('address', "");
    print(prefs.getString('address'));
  }

 

  Future<void> fetchDataAndStoreLocally() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    userId = prefs.getString('address')!;

    try {
      final response = await http
          .get(Uri.parse('http://d3shop.pythonanywhere.com/orders/$userId'));
      print(8988766);
      print(userId);
      print("http://d3shop.pythonanywhere.com/orders/$userId");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Store the data locally using SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('dataKey', json.encode(data));
        print(12);
        print(json.encode(data));
        // You can also parse the data into Dart objects and use it in your app
        // final myData = MyData.fromJson(data);
        // Use myData in your app
      } else {
        throw Exception('Failed to n data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  CustomAppBar({required this.type, required this.address});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // address=fetch();
    return AppBar(
      title: Text('D3 Express $address '),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,

      actions: type == "0"
          ? [
              IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const Add_order();
                        },
                      ),
                    );
                  }),
              IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: () {
                    fetchDataAndStoreLocally();
                  }),
              IconButton(
                  icon: Icon(Icons.logout_rounded),
                  onPressed: () {
                    autoLogOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const MyApp();
                        },
                      ),
                    );
                  }),
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
