import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config.dart';
import '../../utils/app_styles.dart';

class AdminMenusScreen extends StatefulWidget {
  const AdminMenusScreen({super.key});

  @override
  State<AdminMenusScreen> createState() => _AdminMenusScreenState();
}

class _AdminMenusScreenState extends State<AdminMenusScreen> {
  bool _isLoading = true;
  List<dynamic> _menus = [];

  @override
  void initState() {
    super.initState();
    _fetchMenus();
  }

  Future<void> _fetchMenus() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(Config.getMenusUrl));
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          _menus = data['data'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteMenu(String id) async {
    try {
      final response = await http.post(Uri.parse(Config.deleteMenuUrl), body: {'id': id});
      final data = jsonDecode(response.body);
      if (mounted) {
        if (data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Menu dihapus'), backgroundColor: Colors.green));
          _fetchMenus();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menghapus'), backgroundColor: Colors.red));
      }
    }
  }

  void _showMenuDialog({Map<String, dynamic>? menu}) {
    final isEdit = menu != null;
    final namaCtrl = TextEditingController(text: isEdit ? menu['nama'] : '');
    final hargaCtrl = TextEditingController(text: isEdit ? menu['harga'].toString() : '');
    final imageCtrl = TextEditingController(text: isEdit ? menu['image'] : '');
    final deskripsiCtrl = TextEditingController(text: isEdit ? menu['deskripsi'] : '');
    String kategori = isEdit ? menu['kategori'] : 'Terlaris';
    
    // Pastikan kategori yang ada di database termasuk dalam list ini, jika tidak default ke Terlaris
    final validCategories = ['Terlaris', 'Lauk', 'Pedas', 'Opor', 'Minuman', 'Pendamping'];
    if (!validCategories.contains(kategori)) {
       kategori = 'Terlaris';
    }
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text(isEdit ? 'Edit Menu' : 'Tambah Menu'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: namaCtrl, decoration: const InputDecoration(labelText: 'Nama Menu')),
                TextField(controller: hargaCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Harga')),
                DropdownButtonFormField<String>(
                  value: kategori,
                  items: validCategories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setStateDialog(() => kategori = v!),
                  decoration: const InputDecoration(labelText: 'Kategori'),
                ),
                TextField(controller: deskripsiCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Deskripsi')),
                TextField(controller: imageCtrl, decoration: const InputDecoration(labelText: 'URL Gambar (Link Langsung)')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() => _isLoading = true);
                final url = isEdit ? Config.updateMenuUrl : Config.addMenuUrl;
                final body = {
                  'nama': namaCtrl.text,
                  'harga': hargaCtrl.text,
                  'kategori': kategori,
                  'rating': '5.0',
                  'image': imageCtrl.text,
                  'deskripsi': deskripsiCtrl.text,
                };
                if (isEdit) body['id'] = menu['id'].toString();
                
                try {
                  await http.post(Uri.parse(url), body: body);
                  if (mounted) _fetchMenus();
                } catch (e) {
                  if (mounted) setState(() => _isLoading = false);
                }
              },
              child: const Text('Simpan'),
            )
          ],
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.whiteColor,
      appBar: AppBar(
        title: const Text('Kelola Menu', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppStyles.whiteColor,
        foregroundColor: AppStyles.appBarForegroundColor,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.add_circle, color: Colors.blue), onPressed: () => _showMenuDialog())
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchMenus,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _menus.length,
                itemBuilder: (context, index) {
                  final menu = _menus[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: AppStyles.cardDecoration,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: menu['image'].toString().startsWith('http') 
                              ? Image.network(menu['image'], width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.fastfood, size: 60))
                              : Image.asset('assets/images/${menu['image']}', width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.fastfood, size: 60)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(menu['nama'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text('Rp ${menu['harga']}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(4)),
                                child: Text(menu['kategori'], style: const TextStyle(color: Colors.blue, fontSize: 12)),
                              )
                            ],
                          ),
                        ),
                        IconButton(icon: const Icon(Icons.edit, color: Colors.orange), onPressed: () => _showMenuDialog(menu: menu)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteMenu(menu['id'].toString())),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
