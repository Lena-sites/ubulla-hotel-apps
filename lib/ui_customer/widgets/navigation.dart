import 'package:flutter/material.dart';
import 'package:hotelapps/ui_customer/screens/home.dart';
import 'package:hotelapps/ui_customer/screens/search.dart';
import 'package:hotelapps/ui_customer/screens/booking.dart';
import 'package:hotelapps/ui_customer/screens/profile.dart';

class BottomNavigation extends StatelessWidget{
  final int currentIndex;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context){
    //dark atau light mode
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).cardColor,
      selectedItemColor: const Color(0xFF10B981),
      unselectedItemColor: isDark ? Colors.white60 : Colors.grey,
      onTap: (index) {
        if(index == 0){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else if (index == 1){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()),
          );
        } else if (index == 2){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingPage()),
          );
        } else if (index == 3){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Booking'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}