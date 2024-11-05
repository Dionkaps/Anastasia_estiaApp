import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:estia_app/pages/cards_page.dart';
import 'package:estia_app/pages/info_page.dart';
import 'package:estia_app/pages/menu_page.dart';
import 'package:estia_app/mealPages/loading_widget.dart'; // Import the LoadingWidget

void main() => runApp(const MyAppApp());

class MyAppApp extends StatelessWidget {
  const MyAppApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Lock the orientation to portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Outfit', // Set your font family here
        primarySwatch: Colors.red,
        primaryColor: const Color(0xFF9F1005),
      ),
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  // Added _isLoading variable to control the loading animation
  bool _isLoading = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _widgetOptions = const [
      MenuPage(),
      CardsPage(),
      MapPage(), // Assuming MapPage is imported from info_page.dart
    ];

    // Start a timer to simulate loading for 2 seconds
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false; // Stop loading after 2 seconds
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // If still loading, show the loading animation
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF9F1005), // Same background color as MenuPage
        body: Center(
          child: LoadingWidget(), // Show the loading animation
        ),
      );
    }

    // Main UI after loading is complete
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/plate.svg",
              height: 35.0,
              width: 35.0,
            ),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/idCard.svg",
              height: 35.0,
              width: 35.0,
            ),
            label: 'Cards',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/info.svg",
              height: 30.0,
              width: 30.0,
            ),
            label: 'Other',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(125, 159, 15, 5),
        unselectedFontSize: 12,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Comfortaa',
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Comfortaa',
        ),
        selectedFontSize: 12,
        elevation: 0,
      ),
    );
  }
}
