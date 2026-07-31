import 'package:flutter/material.dart';
import '../../utils/app_styles.dart';
import 'admin_dashboard_screen.dart';
import 'admin_orders_screen.dart';
import 'admin_menus_screen.dart';
import 'admin_profile_screen.dart';

class AdminMainNavigation extends StatefulWidget {
  final Map<String, dynamic> userData;
  const AdminMainNavigation({super.key, required this.userData});

  @override
  State<AdminMainNavigation> createState() => _AdminMainNavigationState();
}

class _AdminMainNavigationState extends State<AdminMainNavigation> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      AdminDashboardScreen(userData: widget.userData),
      const AdminOrdersScreen(),
      const AdminMenusScreen(),
      AdminProfileScreen(userData: widget.userData),
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.whiteColor,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppStyles.primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
