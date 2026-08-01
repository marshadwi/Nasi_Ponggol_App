import 'package:flutter/material.dart';
import '../config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../utils/app_styles.dart'; // <--- MENGHUBUNGKAN KE "CSS"

class OrdersScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const OrdersScreen({super.key, required this.userData});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) _fetchOrders(silent: true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchOrders({bool silent = false}) async {
    if (!silent) setState(() => isLoading = true);
    try {
      final String userId = widget.userData['id'].toString();
      final response = await http.get(Uri.parse(Config.getOrdersUrl + "?user_id=$userId"))
                                 .timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            orders = List<Map<String, dynamic>>.from(data['data']);
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Gagal mengambil data pesanan: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeOrders = orders.where((o) => o['status'] != 'Selesai' && o['status'] != 'Ditolak').toList();
    final historyOrders = orders.where((o) => o['status'] == 'Selesai' || o['status'] == 'Ditolak').toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppStyles.backgroundColor,
        appBar: AppBar(
          title: const Text("Pesanan Saya", style: AppStyles.appBarTitleStyle),
          centerTitle: true,
          backgroundColor: AppStyles.whiteColor,
          foregroundColor: Colors.black87,
          elevation: 0.5,
          bottom: const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: "Status Pesanan"),
              Tab(text: "Riwayat"),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildOrderList(activeOrders, isActive: true),
                  _buildOrderList(historyOrders, isActive: false),
                ],
              ),
      ),
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orderList, {required bool isActive}) {
    if (orderList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_rounded, size: 80, color: Colors.blue.shade100),
            const SizedBox(height: 20),
            Text(isActive ? "Belum ada pesanan aktif" : "Belum ada riwayat", style: AppStyles.headerTextStyle),
            const SizedBox(height: 8),
            const Text("Ayo pesan makanan favoritmu sekarang!", style: AppStyles.subtitleTextStyle),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchOrders,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: orderList.length,
        itemBuilder: (context, index) {
          final order = orderList[index];
          final items = List<Map<String, dynamic>>.from(order['items'] ?? []);
          final status = order['status'] ?? 'Menunggu';
          
          Color statusColor = Colors.orange;
          if (status == 'Diproses') statusColor = Colors.blue;
          if (status == 'Selesai') statusColor = Colors.green;
          if (status == 'Ditolak') statusColor = Colors.red;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: AppStyles.cardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: AppStyles.orderHeaderDecoration,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.shopping_bag_outlined, size: 18, color: AppStyles.secondaryColor),
                          const SizedBox(width: 8),
                          Text("Order #${order['id']}", style: AppStyles.titleTextStyle),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                        child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${item['jumlah']}x ", style: AppStyles.orderQuantityTextStyle),
                              Expanded(
                                child: Text("${item['nama_makanan']}", style: AppStyles.orderItemNameTextStyle),
                              ),
                              const SizedBox(width: 8),
                              Text("Rp ${item['harga']}", style: AppStyles.orderItemPriceTextStyle),
                            ],
                          ),
                        );
                      }).toList(),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Total Belanja", style: AppStyles.orderTotalLabelTextStyle),
                              const SizedBox(height: 4),
                              Text("Rp ${order['total_harga']}", style: AppStyles.priceTextStyle),
                            ],
                          ),
                          Text(order['created_at'].toString().substring(0, 10), style: AppStyles.timeTextStyle),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

