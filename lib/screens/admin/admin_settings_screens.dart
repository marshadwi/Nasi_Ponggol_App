import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart';
import '../../utils/app_styles.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// 1. Pengaturan Toko
class StoreSettingsScreen extends StatefulWidget {
  const StoreSettingsScreen({super.key});
  @override
  State<StoreSettingsScreen> createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends State<StoreSettingsScreen> {
  bool isStoreOpen = true;
  TextEditingController hoursCtrl = TextEditingController(text: '08:00 - 22:00');

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isStoreOpen = prefs.getBool('isStoreOpen') ?? true;
      hoursCtrl.text = prefs.getString('storeHours') ?? '08:00 - 22:00';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isStoreOpen', isStoreOpen);
    await prefs.setString('storeHours', hoursCtrl.text);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pengaturan Toko Berhasil Disimpan!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        title: const Text('Pengaturan Toko'), 
        backgroundColor: AppStyles.whiteColor, 
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Status Toko', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(isStoreOpen ? 'Toko Buka (Menerima Pesanan)' : 'Toko Tutup', style: TextStyle(color: isStoreOpen ? Colors.green : Colors.red)),
            value: isStoreOpen,
            onChanged: (val) {
              setState(() => isStoreOpen = val);
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Jam Operasional', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          TextField(controller: hoursCtrl, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Contoh: 08:00 - 22:00')),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: const Size(double.infinity, 50)),
            onPressed: _saveSettings,
            child: const Text('Simpan Pengaturan', style: TextStyle(color: Colors.white, fontSize: 16)),
          )
        ],
      ),
    );
  }
}

// 2. Laporan Penjualan
class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({super.key});
  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  bool _isLoading = true;
  List<dynamic> _salesData = [];
  int _totalIncome = 0;

  @override
  void initState() {
    super.initState();
    _fetchSales();
  }

  Future<void> _fetchSales() async {
    try {
      final response = await http.get(Uri.parse(Config.adminGetOrdersUrl));
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        final allOrders = data['data'] as List;
        final completedOrders = allOrders.where((o) => o['status'] == 'Selesai').toList();
        
        int income = 0;
        for (var o in completedOrders) {
          income += int.parse(o['total_harga'].toString());
        }

        setState(() {
          _salesData = completedOrders;
          _totalIncome = income;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(title: const Text('Rekap Penjualan', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: AppStyles.whiteColor, foregroundColor: Colors.black, elevation: 0),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.green.shade700, Colors.green.shade400]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Pendapatan', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    SizedBox(height: 4),
                    Text('Pesanan Selesai', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                Text('Rp $_totalIncome', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(alignment: Alignment.centerLeft, child: Text('Rincian Riwayat Transaksi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey))),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _salesData.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder: (context, index) {
                final order = _salesData[index];
                final items = order['items'] as List? ?? [];
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                        child: const Icon(Icons.receipt_long, color: Colors.green),
                      ),
                      title: Text('Order #${order["id"]}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('${order["nama_penerima"]}', style: const TextStyle(color: Colors.black87)),
                          Text('${order["created_at"]}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      children: [
                        const Divider(height: 1),
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.grey.shade50,
                          child: Column(
                            children: [
                              ...items.map((item) {
                                final harga = int.tryParse(item['harga'].toString()) ?? 0;
                                final jumlah = int.tryParse(item['jumlah'].toString()) ?? 1;
                                final subtotal = harga * jumlah;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${item["jumlah"]}x', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${item["nama_makanan"]}', style: const TextStyle(fontWeight: FontWeight.w600)),
                                            Text('@ Rp $harga', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                      Text('Rp $subtotal', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                );
                              }).toList(),
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('TOTAL KESELURUHAN', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('Rp ${order["total_harga"]}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16)),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}

// 3. Keamanan & Akses
class SecurityAccessScreen extends StatefulWidget {
  const SecurityAccessScreen({super.key});
  @override
  State<SecurityAccessScreen> createState() => _SecurityAccessScreenState();
}

class _SecurityAccessScreenState extends State<SecurityAccessScreen> {
  final emailCtrl = TextEditingController(text: 'admin@gmail.com');
  final passwordCtrl = TextEditingController();

  Future<void> _updatePassword() async {
    if (passwordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sandi baru tidak boleh kosong!')));
      return;
    }
    try {
      final response = await http.post(Uri.parse('${Config.baseUrl}/change_password.php'), body: {
        'email': emailCtrl.text,
        'new_password': passwordCtrl.text
      });
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
         if(!mounted) return;
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kata sandi berhasil diubah!'), backgroundColor: Colors.green));
         passwordCtrl.clear();
      } else {
         if(!mounted) return;
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message']), backgroundColor: Colors.red));
      }
    } catch (e) {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal terhubung ke server'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(title: const Text('Keamanan & Akses'), backgroundColor: AppStyles.whiteColor, foregroundColor: Colors.black),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Ubah Kata Sandi Admin', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email Admin', border: OutlineInputBorder()), readOnly: true),
          const SizedBox(height: 16),
          TextField(controller: passwordCtrl, decoration: const InputDecoration(labelText: 'Kata Sandi Baru', border: OutlineInputBorder()), obscureText: true),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(vertical: 16)),
            onPressed: _updatePassword,
            child: const Text('Simpan Kata Sandi', style: TextStyle(color: Colors.white, fontSize: 16)),
          )
        ],
      ),
    );
  }
}
