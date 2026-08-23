import 'package:final_project/model/property.dart';
import 'package:final_project/view/home_screen.dart';
import 'package:final_project/view/interested_sent_screen.dart';
import 'package:final_project/view/map_screen.dart';
import 'package:final_project/view/properties_detail_screen.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  final List<Property> properties;

  const BottomNav({
    super.key,
    required this.properties,
  });

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        properties: widget.properties,
      ),
      MapScreen(),
      FavoriteScreen(),
      PropertyScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: screens[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            selectedIcon: Icon(
              Icons.home,
              color: Colors.green,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.map),
            selectedIcon: Icon(
              Icons.map,
              color: Colors.green,
            ),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            selectedIcon: Icon(
              Icons.favorite,
              color: Colors.green,
            ),
            label: 'Save',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            selectedIcon: Icon(
              Icons.person,
              color: Colors.green,
            ),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}