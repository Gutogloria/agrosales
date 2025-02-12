import 'package:agro_sales/src/pages/profile/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:agro_sales/src/pages/auth/home/home_tab.dart';
import 'package:agro_sales/src/pages/dashboard/dashboard_tab.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int currentIndex = 0;
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: const [
          HomeTab(),
          ProfileTab(),
          DashboardTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            pageController.jumpToPage(index);
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey.shade800,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.white.withAlpha(150),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        showUnselectedLabels: true,
        elevation: 10,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: currentIndex == 0 ? 28 : 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outlined,
              size: currentIndex == 1 ? 28 : 24,
            ),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.graphic_eq,
              size: currentIndex == 2 ? 28 : 24,
            ),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }
}
