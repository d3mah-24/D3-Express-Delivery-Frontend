import 'package:d3_express/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:d3_express/UI/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodePassword = FocusNode();
  bool _isPasswordVisible = false;
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    autoLogIn();
  }
  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('username');
    if (userId != null) {
      setState(() {
        isLoggedIn = true;
      });
      return;
    }
  }
  Future<void> _handleLogin() async {
    final username = _controllerUsername.text;
    final password = _controllerPassword.text;
    try {
      final response = await http.post(
        Uri.parse('127.0.0.1/login/'), // Replace with your login API endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        print(username);
        print(password);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', "True");
        setState(() {
          isLoggedIn = true;
        });
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: CustomAppBar( type: '1'),
      body:
      isLoggedIn ?   MyHomePage()  :

      Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 150),
              Text(
                "Welcome back",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              Text(
                "Login to your account",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 60),
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
                onEditingComplete: () => _focusNodePassword.requestFocus(),
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
