import 'dart:convert';

import 'package:d3_express/UI/Add.dart';
import 'package:d3_express/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  String userId = "";
  List<dynamic> data = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // autoLogIn();
    retrieveLocalData();
    fetch();
  }

  void fetch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getString('address')!;
    });
    return;
  }

  Future<void> fetchDataAndStoreLocally() async {
    final apiUrl =
        'http://d3shop.pythonanywhere.com/orders/$userId'; // Replace with your API URL

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final datas = json.decode(response.body);

        // Store the data locally using SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('dataKey', json.encode(datas));
        print(334);
        // print(json.decode(datas));
        print(prefs.getString('dataKey'));
        setState(() {
          data = json.decode(prefs.getString('dataKey')!);
        });
        // print(data);
        // You can also parse the data into Dart objects and use it in your app
        // final myData = MyData.fromJson(data);
        // Use myData in your app
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> Status_Updater(waybill, status) async {
    print(waybill);
    print(status);
    final apiUrl =
        'https://d3Shop.pythonanywhere.com/order/stat/$waybill/$status'; // Replace with your API URL

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        fetchDataAndStoreLocally();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> retrieveLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString('dataKey');

    if (storedData != null) {
      setState(() {
        data = json.decode(prefs.getString('dataKey')!);
      });
      // data = json.decode(storedData);
      // Process and use the data as needed
    }
    print(data);
  }

  autoLogOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('address', "");
    print(prefs.getString('address'));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth > 600 ? 20.0 : 18.0;
    final additionalInfoFontSize = screenWidth > 600 ? 16.0 : 14.0;
    final cardWidth = screenWidth > 600 ? 600.0 : screenWidth;
    final da = {0: "Pending", 1: "Arrived", 2: "Delivered"};
    return Scaffold(
        appBar: AppBar(
            title: Text('D3 Express $userId '),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
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
                    setState(() {
                      isLoading = true;
                    });
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
            ]),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(), // Display a loading indicator
              )
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = data[index];
                  final ty = item["status"]; 
                  if (_currentIndex == 3 && userId == item["SenderAddress"]) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 3, // Adds a shadow to the card
                      margin: const EdgeInsets.all(
                          10), // Adds margin around the card
                      child: Container(
                        width: cardWidth,
                        padding: const EdgeInsets.all(16.0),
                        // Adds padding inside the card
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // Align items to the left
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 28),
                                Icon(Icons.star,
                                    size: screenWidth > 600 ? 25.0 : 15.0),
                                // Icon at the start of the card
                                const SizedBox(width: 8),
                                // Add spacing between icon and text
                                Text(
                                  'Sender', // Card title
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: titleFontSize,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Name     :- ${item["SenderName"]}', // Card title
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: additionalInfoFontSize,
                              ),
                            ),
                            Text(
                              'Address :- ${item["SenderAddress"]}', // Card title
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: additionalInfoFontSize,
                              ),
                            ),
                            Text(
                              'Telephone :- ${item["SenderPhone"]}', // Card title
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: additionalInfoFontSize,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const SizedBox(width: 28),
                                Icon(Icons.star,
                                    size: screenWidth > 600 ? 25.0 : 15.0),
                                // Icon at the start of the card
                                const SizedBox(width: 8),
                                // Add spacing between icon and text
                                Text(
                                  'Receiver', // Card title
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: titleFontSize,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Name     :- ${item["receiverName"]}', // Card title
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: additionalInfoFontSize,
                              ),
                            ),
                            Text(
                              'Address :- ${item["receiverAddress"]}', // Card title
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: additionalInfoFontSize,
                              ),
                            ),
                            Text(
                              'Telephone :- ${item["receiverPhone"]}', // Card title
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: additionalInfoFontSize,
                              ),
                            ),
                            Text(
                              'Payment Way :- ${item["payment_way"]}', // Card title
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: additionalInfoFontSize,
                              ),
                            ),
                            Text(
                              'WayBill No :- ${item["waybillno"]}', // Card title
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: additionalInfoFontSize,
                              ),
                            ),
                            Text(
                              'Price :- ${item["price"]}', // Card title
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: additionalInfoFontSize,
                              ),
                            ),

                            // Add spacing between title and subtitle

                            const SizedBox(height: 10),
                            // Add spacing between subtitle and icon
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Current Location :- ${item["curr_location"]}',
                                  style: TextStyle(
                                    fontSize: additionalInfoFontSize,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (ty == da[_currentIndex] &&
                      userId != item["SenderAddress"]) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 3, // Adds a shadow to the card
                      margin: const EdgeInsets.all(
                          10), // Adds margin around the card
                      child: Container(
                        width: cardWidth,
                        padding: const EdgeInsets.all(16.0),
                        // Adds padding inside the card
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // Align items to the left
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 28),
                                Icon(Icons.star,
                                    size: screenWidth > 600 ? 25.0 : 15.0),
                                // Icon at the start of the card
                                const SizedBox(width: 8),
                                // Add spacing between icon and text
                                Text(
                                  'Sender', // Card title
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: titleFontSize,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Name     :- ${item["SenderName"]}', // Card title
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: additionalInfoFontSize,
                              ),
                            ),
                            Text(
                              'Address :- ${item["SenderAddress"]}', // Card title
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: additionalInfoFontSize,
                              ),
                            ),
                            Text(
                              'Telephone :- ${item["SenderPhone"]}', // Card title
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: additionalInfoFontSize,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const SizedBox(width: 28),
                                Icon(Icons.star,
                                    size: screenWidth > 600 ? 25.0 : 15.0),
                                // Icon at the start of the card
                                const SizedBox(width: 8),
                                // Add spacing between icon and text
                                Text(
                                  'Receiver', // Card title
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: titleFontSize,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Name     :- ${item["receiverName"]}', // Card title
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: additionalInfoFontSize,
                              ),
                            ),
                            Text(
                              'Address :- ${item["receiverAddress"]}', // Card title
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: additionalInfoFontSize,
                              ),
                            ),
                            Text(
                              'Telephone :- ${item["receiverPhone"]}', // Card title
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: additionalInfoFontSize,
                              ),
                            ),
                            Text(
                              'Payment Way :- ${item["payment_way"]}', // Card title
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: additionalInfoFontSize,
                              ),
                            ),
                            Text(
                              'WayBill No :- ${item["waybillno"]}', // Card title
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: additionalInfoFontSize,
                              ),
                            ),
                            Text(
                              'Price :- ${item["price"]}', // Card title
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: additionalInfoFontSize,
                              ),
                            ),

                            // Add spacing between title and subtitle

                            const SizedBox(height: 10),
                            // Add spacing between subtitle and icon
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Current Location :- ${item["curr_location"]}',
                                  style: TextStyle(
                                    fontSize: additionalInfoFontSize,
                                  ),
                                ),
                                _currentIndex != 2
                                    ? IconButton(
                                        icon:
                                            const Icon(Icons.verified_rounded),
                                        onPressed: () {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          Status_Updater(item["waybillno"],
                                              da[_currentIndex + 1]);
                                        },
                                      )
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
        bottomNavigationBar: TitledBottomNavigationBar(
            currentIndex: _currentIndex,
            activeColor: Colors.red,
            inactiveColor: Colors.blueGrey,
            indicatorHeight: 2,
            curve: Curves.easeInBack,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              TitledNavigationBarItem(
                  title: const Text('Pending'),
                  icon: const Icon(Icons.pending_actions)),
              TitledNavigationBarItem(
                title: const Text('Arrived'),
                icon: const Icon(
                  Icons.store,
                ),
              ),
              TitledNavigationBarItem(
                  title: const Text('Delivered'),
                  icon: const Icon(Icons.verified)),
              TitledNavigationBarItem(
                  title: const Text('Mine'), icon: const Icon(Icons.verified)),
            ]));
  }
}

class MyTextSample {
  static TextStyle? display4(BuildContext context) {
    return Theme.of(context).textTheme.displayLarge;
  }

  static TextStyle? display3(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium;
  }

  static TextStyle? display2(BuildContext context) {
    return Theme.of(context).textTheme.displaySmall;
  }

  static TextStyle? display1(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium;
  }

  static TextStyle? headline(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall;
  }

  static TextStyle? title(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge;
  }

  static TextStyle medium(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          fontSize: 18,
        );
  }

  static TextStyle? subhead(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium;
  }

  static TextStyle? body2(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge;
  }

  static TextStyle? body1(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium;
  }

  static TextStyle? caption(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall;
  }

  static TextStyle? button(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(letterSpacing: 1);
  }

  static TextStyle? subtitle(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall;
  }

  static TextStyle? overline(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall;
  }
}
