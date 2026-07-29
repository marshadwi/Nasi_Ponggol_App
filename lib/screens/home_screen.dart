import 'package:flutter/material.dart';
import '../config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../database/db_helper.dart';
import 'cart_screen.dart';
import 'menu_detail_screen.dart';
import 'notifications_screen.dart';
import '../utils/app_styles.dart'; // <--- IMPORT "CSS"

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> userData; const HomeScreen({super.key, required this.userData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> menuItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMenus();
  }

  Future<void> _fetchMenus() async {
    try {
      final response = await http.get(Uri.parse(Config.getMenusUrl))
                                 .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          if (mounted) {
            setState(() {
              // Kita perlu memastikan datanya cocok dengan tipe yang kita pakai
              menuItems = List<Map<String, dynamic>>.from(data['data']);
              isLoading = false;
            });
          }
        }
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      print("Gagal mengambil data menu: $e");
    }
  }

  final List<String> categories = ["Semua", "Terlaris", "Lauk", "Pedas", "Opor", "Minuman", "Pendamping"];
  String selectedCategory = "Semua";
  String searchQuery = "";

  void _addToCart(BuildContext context, Map<String, dynamic> item) async {
    try {
      final response = await http.post(
        Uri.parse(Config.cartAddUrl),
        body: {
          "user_id": widget.userData['id'].toString(),
          "nama_makanan": item['nama'],
          "harga": item['harga'].toString(),
          "jumlah": "1",
        },
      ).timeout(const Duration(seconds: 10));

      if (mounted && response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.black87,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.greenAccent),
                const SizedBox(width: 10),
                Expanded(child: Text('${item['nama']} masuk keranjang!')),
              ],
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal terhubung ke server.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  List<Map<String, dynamic>> get filteredMenuItems {
    List<Map<String, dynamic>> filtered = menuItems;
    
    // 1. Filter by category
    if (selectedCategory != "Semua") {
      filtered = filtered.where((item) => item['kategori'] == selectedCategory).toList();
    }
    
    // 2. Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((item) => 
        item['nama'].toString().toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final currentMenu = filteredMenuItems;
    
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor, // <-- DARI CSS
      body: SafeArea(
        child: Column(
          children: [
            // MODERN HEADER (Fixed at top)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: AppStyles.homeHeaderDecoration, // <-- DARI CSS
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Selamat Datang, ${widget.userData['nama'] ?? 'Guest'} 🍽️", style: const TextStyle(color: Colors.white70, fontSize: 14)),
                          const SizedBox(height: 4),
                          const Text("Lapar? Pesan Sekarang!", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.notifications_outlined, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  // SEARCH BAR WITH GLASSMORPHISM FEEL
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    decoration: AppStyles.searchBarDecoration, // <-- DARI CSS
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Cari menu favoritmu...",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: InputBorder.none,
                        icon: const Icon(Icons.search, color: Colors.orangeAccent),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // REFRESHABLE CONTENT
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 1));
                  setState(() {});
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  slivers: [
                    // KATEGORI HORIZONTAL
                    SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 16),
                child: SizedBox(
                  height: 45,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      bool isSelected = selectedCategory == categories[index];
                      return GestureDetector(
                        onTap: () => setState(() => selectedCategory = categories[index]),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: isSelected 
                            ? AppStyles.categoryActiveDecoration // <-- DARI CSS (Active)
                            : AppStyles.categoryInactiveDecoration, // <-- DARI CSS (Inactive)
                          child: Center(
                            child: Text(
                              categories[index],
                              style: TextStyle(
                                color: isSelected ? AppStyles.whiteColor : Colors.black87,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // JUDUL DAFTAR MENU
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedCategory == "Semua" ? "Rekomendasi Menu" : "Kategori: $selectedCategory", 
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF2D3142))
                    ),
                  ],
                ),
              ),
            ),

            // GRID MENU MAKANAN
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              sliver: currentMenu.isEmpty 
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          Icon(Icons.fastfood_outlined, size: 60, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text("Menu belum tersedia", style: TextStyle(color: Colors.grey.shade500)),
                        ],
                      ),
                    )
                  )
                )
              : SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.58,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = currentMenu[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: AppStyles.homeGridItemDecoration, // <-- DARI CSS
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MenuDetailScreen(item: item, allMenus: menuItems, userData: widget.userData)),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // GAMBAR MAKANAN
                              AspectRatio(
                                aspectRatio: 1.1,
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: AppStyles.homeImageDecoration.copyWith( // <-- DARI CSS
                                    image: DecorationImage(
                                      image: item['image'].toString().startsWith('http')
                                          ? NetworkImage(item['image']) as ImageProvider
                                          : AssetImage('assets/images/${item['image']}'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: AppStyles.homeRatingDecoration, // <-- DARI CSS
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                                              const SizedBox(width: 4),
                                              Text(item['rating'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber)),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              // INFO MAKANAN
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item['nama'],
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, height: 1.2),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Rp ${item['harga']}",
                                              style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w900, fontSize: 14),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => _addToCart(context, item),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: AppStyles.homeAddToCartDecoration, // <-- DARI CSS
                                              child: const Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 16),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: currentMenu.length,
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 100)), // Ruang untuk bottom nav & FAB
          ],
        ),
      ),
    ),
  ],
  ),
  ),
  );
  }
}
