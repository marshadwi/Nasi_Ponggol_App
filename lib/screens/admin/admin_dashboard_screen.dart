import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../../config.dart';
import '../../utils/app_styles.dart';

class AdminDashboardScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const AdminDashboardScreen({super.key, required this.userData});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _stats = {};
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchStats();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) _fetchStats(silent: true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchStats({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(Config.adminStatsUrl));
      final data = jsonDecode(response.body);
      if (mounted) {
        if (data['status'] == 'success') {
          setState(() {
            _stats = data['data'];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.whiteColor,
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppStyles.whiteColor,
        foregroundColor: AppStyles.appBarForegroundColor,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () {
            setState(() => _isLoading = true);
            _fetchStats();
          })
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : RefreshIndicator(
            onRefresh: _fetchStats,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildStatCard('Total Pendapatan', 'Rp ${_stats["pendapatan"] ?? 0}', Icons.monetization_on, Colors.green),
                const SizedBox(height: 16),
                _buildStatCard('Pesanan Masuk (Total)', '${_stats["pesanan_total"] ?? 0} Pesanan', Icons.shopping_bag, Colors.blue),
                const SizedBox(height: 16),
                _buildStatCard('Menunggu Proses', '${_stats["pesanan_menunggu"] ?? 0} Pesanan', Icons.pending_actions, Colors.orange),
                const SizedBox(height: 16),
                _buildStatCard('Total Pengguna', '${_stats["pengguna"] ?? 0} Orang', Icons.people, Colors.purple),
              ],
            ),
          ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppStyles.cardDecoration,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, size: 36, color: color),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
