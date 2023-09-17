import 'package:d3_express/main.dart';
import 'package:flutter/material.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth > 600 ? 20.0 : 18.0;
    final additionalInfoFontSize = screenWidth > 600 ? 16.0 : 14.0;
    final cardWidth = screenWidth > 600 ? 600.0 : screenWidth;
    return Scaffold(
        appBar: CustomAppBar(type: '0'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: ListView.builder(
          itemCount: 3, // Replace with the number of cards you want
          itemBuilder: (BuildContext context, int index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 3, // Adds a shadow to the card
              margin: const EdgeInsets.all(10), // Adds margin around the card
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
                        Icon(Icons.star, size: screenWidth > 600 ? 25.0 : 15.0),
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
                      'Name     :- $index iofgh dvs s fsvf d j', // Card title
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: additionalInfoFontSize,
                      ),
                    ),
                    Text(
                      'Address :- $index iofghj', // Card title
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: additionalInfoFontSize,
                      ),
                    ),
                    Text(
                      'Telephone :- $index 4322443', // Card title
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: additionalInfoFontSize,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const SizedBox(width: 28),
                        Icon(Icons.star, size: screenWidth > 600 ? 25.0 : 15.0),
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
                      'Name     :- $index iofgh dvs s fsvf d j', // Card title
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: additionalInfoFontSize,
                      ),
                    ),
                    Text(
                      'Address :- $index iofghj', // Card title
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: additionalInfoFontSize,
                      ),
                    ),
                    Text(
                      'Telephone :- $index 4322443', // Card title
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: additionalInfoFontSize,
                      ),
                    ),
                    Text(
                      'Payment Way :- $index', // Card title
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: additionalInfoFontSize,
                      ),
                    ),
                    Text(
                      'WayBill No :- $index', // Card title
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: additionalInfoFontSize,
                      ),
                    ),
                    Text(
                      'Price :- 3$index', // Card title
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
                          'Current Location :- $_currentIndex',
                          style: TextStyle(
                            fontSize: additionalInfoFontSize,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.verified_rounded),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
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
