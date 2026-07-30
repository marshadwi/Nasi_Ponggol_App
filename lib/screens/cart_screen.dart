import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import 'checkout_screen.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';
import '../utils/app_styles.dart'; // <--- IMPORT "CSS"

class CartScreen extends StatefulWidget {
  final Map<String, dynamic> userData; 
  const CartScreen({super.key, required this.userData});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> _cartItems = [];
  int _totalHarga = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() => _isLoading = true);
    try {
      final String userId = widget.userData['id'].toString();
      final response = await http.get(Uri.parse(Config.cartGetUrl + "?user_id=$userId"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(data['data']);
          int total = 0;
          for (var item in items) {
            total += int.parse(item['harga'].toString()) * int.parse(item['jumlah'].toString());
          }
          setState(() {
            _cartItems = items;
            _totalHarga = total;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print("Gagal fetch cart: $e");
    }
  }

  Future<void> _updateQuantity(int id, int jumlahSekarang, int perubahan) async {
    int jumlahBaru = jumlahSekarang + perubahan;
    try {
      await http.post(
        Uri.parse(Config.cartUpdateUrl),
        body: {
          "id": id.toString(),
          "jumlah": jumlahBaru.toString(),
        },
      );
      _loadCart();
    } catch (e) {
      print("Gagal update cart: $e");
    }
  }

  Future<void> _deleteItem(int id) async {
    try {
      await http.post(
        Uri.parse(Config.cartDeleteUrl),
        body: {
          "id": id.toString(),
        },
      );
      _loadCart();
    } catch (e) {
      print("Gagal delete item: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor, // <-- DARI CSS
      appBar: AppBar(
        title: const Text('Keranjang Belanja', style: AppStyles.appBarTitleStyle), // <-- DARI CSS
        backgroundColor: AppStyles.whiteColor,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.remove_shopping_cart, size: 80, color: AppStyles.cartEmptyIconColor), // <-- DARI CSS
                      const SizedBox(height: 16),
                      const Text('Keranjang Anda kosong', style: AppStyles.cartEmptyTextStyle), // <-- DARI CSS
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) {
                          final item = _cartItems[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: AppStyles.cardDecoration, // <-- DARI CSS
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: AppStyles.cartImageDecoration, // <-- DARI CSS
                                  child: const Icon(Icons.fastfood, color: AppStyles.cartIconColor), // <-- DARI CSS
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item['nama_makanan'], style: AppStyles.cartItemNameTextStyle), // <-- DARI CSS
                                      const SizedBox(height: 4),
                                      Text("Rp ${item['harga']}", style: AppStyles.cartItemPriceTextStyle), // <-- DARI CSS
                                    ],
                                  ),
                                ),
                                // Kontrol Jumlah
                                Row(
                                  children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, color: AppStyles.cartRemoveIconColor), // <-- DARI CSS
                                        onPressed: () => _updateQuantity(item['id'], item['jumlah'], -1),
                                      ),
                                      Text('${item['jumlah']}', style: AppStyles.cartQuantityTextStyle), // <-- DARI CSS
                                      IconButton(
                                        icon: Icon(Icons.add_circle_outline, color: AppStyles.cartAddIconColor), // <-- DARI CSS
                                        onPressed: () => _updateQuantity(item['id'], item['jumlah'], 1),
                                      ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: AppStyles.bottomSheetDecoration, // <-- DARI CSS
                      child: SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total Pembayaran', style: AppStyles.cartTotalLabelTextStyle), // <-- DARI CSS
                                Text('Rp $_totalHarga', style: AppStyles.cartTotalPriceTextStyle), // <-- DARI CSS
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: AppStyles.primaryButtonStyle, // <-- DARI CSS
                                onPressed: _cartItems.isEmpty ? null : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => CheckoutScreen(
                                      userData: widget.userData ?? {'id': 1}, 
                                      cartItems: _cartItems
                                    )),
                                  );
                                },
                                child: const Text('Checkout Sekarang', style: AppStyles.cartCheckoutButtonTextStyle), // <-- DARI CSS
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
    );
  }
}

