import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';
import 'cart_screen.dart';
import '../utils/app_styles.dart';

class MainNavigation extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const MainNavigation({super.key, this.userData});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(userData: widget.userData ?? {"id": 1}),
      OrdersScreen(userData: widget.userData ?? {"id": 1}),
      ProfileScreen(userData: widget.userData ?? {"id": 1, "nama": "Guest", "email": "-", "profile_pic": ""}),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _screens[_selectedIndex],
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              decoration: AppStyles.bottomNavDecoration,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.home_rounded, 0),
                    _buildNavItem(Icons.receipt_long_rounded, 1),
                    _buildNavItem(Icons.person_rounded, 2),
                  ],
                ),
              ),
            ),
          ),
          
          (_selectedIndex == 0 || _selectedIndex == 1) ? 
            Positioned(
              right: 16,
              bottom: 100, // Di atas nav bar bawah
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen(userData: widget.userData ?? {"id": 1})),
                  );
                },
                backgroundColor: AppStyles.primaryColor, // <-- DARI CSS
                elevation: 4,
                child: const Icon(Icons.shopping_cart, color: AppStyles.whiteColor),
              ),
            ) : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(8),
        decoration: isSelected ? AppStyles.bottomNavItemDecorationActive : AppStyles.bottomNavItemDecorationInactive, // <-- DARI CSS
        child: Icon(
          icon,
          size: 28,
          color: isSelected ? Colors.blue.shade800 : Colors.grey.shade400,
        ),
      ),
    );
  }
}

