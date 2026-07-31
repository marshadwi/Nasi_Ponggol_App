import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../../config.dart';
import '../../utils/app_styles.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  bool _isLoading = true;
  List<dynamic> _orders = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
    // Auto-refresh setiap 5 detik untuk kesan real-time
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
    if (!silent) setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(Config.adminGetOrdersUrl));
      final data = jsonDecode(response.body);
      if (mounted) {
        if (data['status'] == 'success') {
          setState(() {
            _orders = data['data'];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateStatus(String id, String status) async {
    try {
      final response = await http.post(
        Uri.parse(Config.updateOrderUrl),
        body: {'id': id, 'status': status},
      );
      final data = jsonDecode(response.body);
      if (mounted && data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status diubah menjadi $status'), backgroundColor: Colors.green),
        );
        _fetchOrders();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengubah status'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showReceipt(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bukti transfer tidak tersedia'), backgroundColor: Colors.orange),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bukti Transfer'),
        content: Image.network(
          '${Config.baseUrl}/uploads/$imageUrl',
          errorBuilder: (context, error, stackTrace) => const Text('Gagal memuat gambar. Gambar mungkin rusak atau tidak ditemukan di server.'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.whiteColor,
      appBar: AppBar(
        title: const Text('Kelola Pesanan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppStyles.whiteColor,
        foregroundColor: AppStyles.appBarForegroundColor,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? const Center(child: Text("Belum ada pesanan"))
              : RefreshIndicator(
                  onRefresh: _fetchOrders,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _orders.length,
                    itemBuilder: (context, index) {
                      final order = _orders[index];
                      return _buildOrderCard(order);
                    },
                  ),
                ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    Color statusColor = Colors.orange;
    if (order['status'] == 'Diproses') statusColor = Colors.blue;
    if (order['status'] == 'Selesai') statusColor = Colors.green;
    if (order['status'] == 'Ditolak') statusColor = Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pesanan #${order['id']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(order['status'], style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const Divider(height: 24),
          Text('Penerima: ${order['nama_penerima']}', style: const TextStyle(fontWeight: FontWeight.w600)),
          Text('Telepon: ${order['phone_penerima']}'),
          Text('Total: Rp ${order['total_harga']}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.receipt, size: 18),
                  label: const Text('Bukti Bayar'),
                  onPressed: () => _showReceipt(order['payment_proof']),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (order['status'] == 'Selesai')
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              child: const Text('Pesanan ini telah selesai', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            )
          else if (order['status'] == 'Ditolak')
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              child: const Text('Pesanan ini telah ditolak', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            )
          else
            Wrap(
              spacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _statusBtn('Diproses', order['id'].toString(), Colors.blue),
                _statusBtn('Selesai', order['id'].toString(), Colors.green),
                _statusBtn('Ditolak', order['id'].toString(), Colors.red),
              ],
            )
        ],
      ),
    );
  }

  Widget _statusBtn(String status, String id, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.symmetric(horizontal: 12)),
      onPressed: () => _updateStatus(id, status),
      child: Text(status, style: const TextStyle(fontSize: 12, color: Colors.white)),
    );
  }
}
