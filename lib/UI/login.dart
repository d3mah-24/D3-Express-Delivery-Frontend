import 'dart:convert';

import 'package:d3_express/UI/Home.dart';
import 'package:d3_express/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String errorMsg = "";
  final FocusNode _focusNodePassword = FocusNode();
  bool _isPasswordVisible = false;
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool isLoggedIn = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    autoLogIn();
    fetch();
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('address');
    if (userId != "") {
      setState(() {
        isLoggedIn = true;
      });
      return;
    }
  }

  Future<void> fetchDataAndStoreLocally() async {
    try {
      final response = await http
          .get(Uri.parse('http://d3shop.pythonanywhere.com/orders/$userId'));

      if (response.statusCode == 200) {
        print(8988766);

        final data = json.decode(response.body);

        // Store the data locally using SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('dataKey', json.encode(data));
        print(8988766);
        print(json.encode(data));
        // You can also parse the data into Dart objects and use it in your app
        // final myData = MyData.fromJson(data);
        // Use myData in your app
      } else {
        throw Exception('Failed to load  l');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _handleLogin() async {
    setState(() {
      isLoading = true;
    });
    final username = _controllerUsername.text;
    final password = _controllerPassword.text;
    print(username);

    final response = await http.get(Uri.parse(
        'https://d3Shop.pythonanywhere.com/login/$username/$password'));
    // print(username);
    // print(jsonEncode({'username': username, 'password': password}));
    // print(response.statusCode);
    // print(password);
    if (response.statusCode == 200) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('address', response.body);
      print(response.body);
      print(8786);
      fetchDataAndStoreLocally();
      setState(() {
        isLoggedIn = true;
      });
    } else {
      setState(() {
        errorMsg = "Wrong Pass Or Username";
      });
      // throw Exception('Login failed');
    }
    setState(() {
      isLoading = false;
    });
  }

  String userId = "";

  void fetch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getString('address')!;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    // address = fetch() ?? "Null";
    if (isLoggedIn) {
      return MyHomePage();
    } else {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        appBar: CustomAppBar(
          type: '1',
          address: userId,
        ),
        body: isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(), // Display a loading indicator
              )
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      Text(
                        "Welcome back",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Login to your account",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 50),
                      Text(
                        errorMsg,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _controllerUsername,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "Username",
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onEditingComplete: () =>
                            _focusNodePassword.requestFocus(),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter username.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _controllerPassword,
                        focusNode: _focusNodePassword,
                        obscureText: !_isPasswordVisible,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.password_outlined),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              icon: _isPasswordVisible
                                  ? const Icon(Icons.visibility_outlined)
                                  : const Icon(Icons.visibility_off_outlined)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter password.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 60),
                      Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: _handleLogin,
                            // () {
                            // if (_controllerUsername.text.isNotEmpty){
                            //   Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) {
                            //         return const MyHomePage();
                            //       },
                            //     ),
                            //   );
                            // },

                            // },
                            child: const Text("Login"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      );
    }
  }
}
