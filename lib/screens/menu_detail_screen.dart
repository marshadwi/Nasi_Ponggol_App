import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../utils/app_styles.dart'; // <--- IMPORT "CSS"

class MenuDetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  final List<Map<String, dynamic>> allMenus;
  final Map<String, dynamic> userData; const MenuDetailScreen({super.key, required this.item, required this.allMenus, required this.userData});

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  int quantity = 1;
  Set<String> selectedExtras = {};

  int get totalHarga {
    int base = int.parse(widget.item['harga'].toString());
    
    // Tambah harga ekstra yang dipilih
    if (selectedExtras.contains('Nasi Putih')) {
      base += 5000;
    }
    
    return base * quantity;
  }

  bool isAdding = false;

  void _addToCart() async {
    setState(() => isAdding = true);
    
    // Modifikasi nama agar spesifik dengan tambahannya
    String addonText = "";
    if (selectedExtras.isNotEmpty) {
      addonText += " (+" + selectedExtras.join(", +") + ")";
    }
    
    String finalName = widget.item['nama'] + addonText;
    int finalPrice = totalHarga ~/ quantity;

    try {
      final response = await http.post(
        Uri.parse(Config.cartAddUrl),
        body: {
          "user_id": widget.userData['id'].toString(),
          "nama_makanan": finalName,
          "harga": finalPrice.toString(),
          "jumlah": quantity.toString(),
        },
      ).timeout(const Duration(seconds: 10));

      if (mounted) {
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.item['nama']} ditambahkan ke keranjang!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menambahkan ke keranjang.'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal terhubung ke server.'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => isAdding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.item['image'].toString().startsWith('http')
                  ? Image.network(
                      widget.item['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, size: 100),
                    )
                  : Image.asset(
                      'assets/images/${widget.item['image']}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, size: 100),
                    ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.blue.shade800,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.item['nama'],
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(widget.item['rating'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Rp ${widget.item['harga']}",
                    style: TextStyle(fontSize: 20, color: Colors.blue.shade800, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Deskripsi",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.item['deskripsi'] ?? "Menu lezat khas Tegal yang sangat menggugah selera.",
                    style: const TextStyle(color: Colors.grey, height: 1.5),
                  ),
                  
                  const Divider(height: 40, thickness: 1),
                  
                  const Text("Tambahan Ekstra (Opsional)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  
                  // LIST MENU TAMBAHAN
                  ...[{'nama': 'Nasi Putih', 'harga': 5000}].map((ekstra) {
                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(ekstra['nama'] as String),
                      subtitle: Text("+Rp ${ekstra['harga']}", style: TextStyle(color: Colors.orange.shade700)),
                      value: selectedExtras.contains(ekstra['nama']),
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            selectedExtras.add(ekstra['nama'] as String);
                          } else {
                            selectedExtras.remove(ekstra['nama']);
                          }
                        });
                      },
                    );
                  }).toList(),

                  const SizedBox(height: 100), // Ruang ekstra bawah
                ],
              ),
            ),
          )
        ],
      ),
      
      // BOTTOM BAR FOR ORDERING
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppStyles.bottomSheetDecoration, // <-- DARI CSS
        child: SafeArea(
          child: Row(
            children: [
              // Quantity control
              Container(
                decoration: AppStyles.quantityControlDecoration, // <-- DARI CSS
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (quantity > 1) {
                          setState(() => quantity--);
                        }
                      },
                    ),
                    Text('$quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() => quantity++);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Add to cart button
              Expanded(
                child: ElevatedButton(
                  style: AppStyles.primaryButtonStyle, // <-- DARI CSS
                  onPressed: _addToCart,
                  child: Text(
                    "Tambah - Rp $totalHarga",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}

