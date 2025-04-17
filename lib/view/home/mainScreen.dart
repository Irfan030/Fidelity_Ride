import 'package:fidelityride/theme/colors.dart';
import 'package:fidelityride/view/account/accountScreen.dart';
import 'package:fidelityride/view/activity/activityScreen.dart';
import 'package:fidelityride/view/home/home.dart';
import 'package:fidelityride/view/service/serviceScreen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    HomeScreen(),
    ServicesScreen(),
    ActivityScreen(),
    AccountScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody:
          true, // This prevents the bottom navigation bar from overlapping content

      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColor.secondaryColor,
        unselectedItemColor: Colors.grey.withOpacity(0.6),
        selectedFontSize: 12, // Slightly larger font for selected
        unselectedFontSize: 11, // Slightly smaller font for unselected
        selectedIconTheme: IconThemeData(size: 28), // Larger icon when selected
        unselectedIconTheme: IconThemeData(
          size: 24,
        ), // Smaller icon when unselected
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        elevation: 8, // Add subtle shadow
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: "Services",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: "Activity",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Account",
          ),
        ],
      ),
    );
  }
}
