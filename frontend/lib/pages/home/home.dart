import 'package:bobhack/constants.dart';
import 'package:bobhack/pages/home/dashboard/dashboard.dart';
import 'package:bobhack/pages/home/goal_tracking/goal_tracking.dart';
import 'package:bobhack/pages/home/investment/investment.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class BobHome extends StatefulWidget {
  const BobHome({super.key});

  @override
  State<BobHome> createState() => _BobHomeState();
}

class _BobHomeState extends State<BobHome> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const BobDashboard(),
    const BobInvestment(),
    const BobGoalTracking()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: bgColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.house,
              size: 20,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.handHoldingDollar, size: 20),
            label: 'Investment',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.bullseye, size: 20),
            label: 'Goals',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: subTextColor,
        onTap: _onItemTapped,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Get.to(() => FinBuddyBot());
      //   },
      //   backgroundColor: overlayColor,
      //   tooltip: "FinBuddy",
      //   child: const FaIcon(
      //     FontAwesomeIcons.gem,
      //     color: subTextColor,
      //     size: 20,
      //   ),
      // ),
    );
  }
}