import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk fitur Salin/Copy
import '../config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../database/db_helper.dart';
import '../utils/app_styles.dart'; // <--- IMPORT "CSS"

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final List<Map<String, dynamic>> cartItems;

  const CheckoutScreen({super.key, required this.userData, required this.cartItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _locationMsg = "Lokasi belum diambil";
  bool _isLoadingLoc = false;
  bool _isSubmitting = false;
  File? _paymentProof;
  final ImagePicker _picker = ImagePicker();
  String _selectedPaymentMethod = "Transfer Bank";

  final List<String> _paymentMethods = ["Transfer Bank", "E-Wallet (OVO/GoPay/Dana)", "COD (Bayar di Tempat)"];
  final String apiUrl = Config.checkoutUrl;

  // Fungsi mengambil koordinat GPS dan Alamat
  Future<void> _getLocation() async {
    setState(() => _isLoadingLoc = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationMsg = "Izin lokasi ditolak";
            _isLoadingLoc = false;
          });
          return;
        }
      }
      
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = "${place.street}, ${place.subLocality}, ${place.locality}";
        setState(() {
          _locationMsg = address;
          _isLoadingLoc = false;
        });
      } else {
        setState(() {
          _locationMsg = "Lat: ${position.latitude}, Long: ${position.longitude}";
          _isLoadingLoc = false;
        });
      }
    } catch (e) {
      setState(() {
        _locationMsg = "Gagal mengambil lokasi: $e";
        _isLoadingLoc = false;
      });
    }
  }

  // Fungsi untuk mengambil gambar dari galeri
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _paymentProof = File(image.path);
      });
    }
  }

  // Fungsi mengirim pesanan ke MySQL
  Future<void> _submitOrder() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama dan No WA harus diisi!'), backgroundColor: AppStyles.errorColor));
      return;
    }
    if (_locationMsg == "Lokasi belum diambil" || _locationMsg == "Izin lokasi ditolak" || _locationMsg == "Gagal mengambil lokasi") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silakan ambil lokasi GPS yang valid!'), backgroundColor: AppStyles.errorColor));
      return;
    }
    
    if (_selectedPaymentMethod != "COD (Bayar di Tempat)" && _paymentProof == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harap unggah bukti pembayaran!'), backgroundColor: AppStyles.errorColor));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      if (widget.cartItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Keranjang Anda kosong!'), backgroundColor: AppStyles.errorColor));
        setState(() => _isSubmitting = false);
        return;
      }

      int totalHarga = 0;
      for (var item in widget.cartItems) {
        totalHarga += int.parse(item['harga'].toString()) * int.parse(item['jumlah'].toString());
      }

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['user_id'] = widget.userData['id'].toString();
      request.fields['nama_penerima'] = _nameController.text;
      request.fields['phone_penerima'] = _phoneController.text;
      request.fields['gps_location'] = _locationMsg;
      request.fields['payment_method'] = _selectedPaymentMethod;
      request.fields['total_harga'] = totalHarga.toString();
      request.fields['items'] = jsonEncode(widget.cartItems);

      if (_paymentProof != null && _selectedPaymentMethod != "COD (Bayar di Tempat)") {
        request.files.add(await http.MultipartFile.fromPath('payment_proof', _paymentProof!.path));
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);

      if (jsonResponse['status'] == 'success') {
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Column(
                children: [
                  Icon(Icons.check_circle, color: AppStyles.successColor, size: 60),
                  SizedBox(height: 16),
                  Text('Pesanan Berhasil!'),
                ],
              ),
              content: const Text('Pesanan dan bukti pembayaran Anda telah kami terima dan sedang diproses.', textAlign: TextAlign.center),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.checkoutAppBarColor,
                      foregroundColor: AppStyles.checkoutAppBarIconColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text('Kembali ke Beranda'),
                  ),
                )
              ],
            ),
          );
        }
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(jsonResponse['message']), backgroundColor: AppStyles.errorColor));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Terjadi kesalahan jaringan!'), backgroundColor: AppStyles.errorColor));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor, // <-- DARI CSS
      appBar: AppBar(
        title: const Text('Checkout', style: AppStyles.appBarTitleStyle), // <-- DARI CSS
        centerTitle: true,
        backgroundColor: AppStyles.whiteColor,
        foregroundColor: AppStyles.appBarForegroundColor,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BAGIAN ALAMAT & KONTAK
            Container(
              margin: const EdgeInsets.only(top: 8),
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.local_shipping_outlined, color: AppStyles.checkoutIconColor, size: 20),
                      SizedBox(width: 8),
                      Text('Informasi Pengiriman', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: AppStyles.generalInputDecoration.copyWith( // <-- DARI CSS
                      labelText: 'Nama Lengkap Penerima',
                      labelStyle: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: AppStyles.generalInputDecoration.copyWith( // <-- DARI CSS
                      labelText: 'Nomor WhatsApp Aktif',
                      labelStyle: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade100)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.redAccent, size: 18),
                                SizedBox(width: 6),
                                Text("Titik GPS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                            if (_isLoadingLoc) 
                              const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(_locationMsg, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 38,
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.my_location, size: 16),
                            label: const Text('Ambil Lokasi Saat Ini', style: TextStyle(fontSize: 13)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue.shade700,
                              side: BorderSide(color: Colors.blue.shade700),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: _isLoadingLoc ? null : _getLocation,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 10),
            
            // BAGIAN PEMBAYARAN
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.payment_outlined, color: Colors.orange, size: 20),
                      SizedBox(width: 8),
                      Text('Metode Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedPaymentMethod,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    decoration: AppStyles.generalInputDecoration, // <-- DARI CSS
                    items: _paymentMethods.map((String method) {
                      return DropdownMenuItem<String>(
                        value: method,
                        child: Text(method, style: const TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() => _selectedPaymentMethod = newValue!);
                    },
                  ),
                  
                  if (_selectedPaymentMethod != "COD (Bayar di Tempat)") ...[
                    const SizedBox(height: 20),
                    // KARTU VIRTUAL ACCOUNT / REKENING ALA SHOPEE
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedPaymentMethod == "Transfer Bank" ? "Bank BCA" : "OVO / Dana", 
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)
                              ),
                              Image.network(
                                _selectedPaymentMethod == "Transfer Bank" 
                                  ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Bank_Central_Asia.svg/2560px-Bank_Central_Asia.svg.png'
                                  : 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/Logo_DANA_%28dompet_digital%29.svg/1200px-Logo_DANA_%28dompet_digital%29.svg.png',
                                height: 16,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.account_balance_wallet, size: 16, color: Colors.blue),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          const Text("No. Rekening / Virtual Account", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedPaymentMethod == "Transfer Bank" ? "8732 1234 5678 9012" : "0812 3456 7890", 
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.2, color: Colors.orange)
                              ),
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: _selectedPaymentMethod == "Transfer Bank" ? "8732123456789012" : "081234567890"));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Nomor berhasil disalin!'), duration: Duration(seconds: 2))
                                  );
                                },
                                child: const Text("SALIN", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14)),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text("a/n Warung Ponggol Setan", style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Upload Bukti Transfer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 12),
                    Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200, style: BorderStyle.solid, width: 1.5),
                      ),
                      child: _paymentProof != null
                          ? Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        insetPadding: const EdgeInsets.all(10),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            InteractiveViewer(
                                              child: Image.file(_paymentProof!, fit: BoxFit.contain),
                                            ),
                                            Positioned(
                                              top: 20, right: 20,
                                              child: CircleAvatar(
                                                backgroundColor: Colors.black54,
                                                child: IconButton(
                                                  icon: const Icon(Icons.close, color: Colors.white),
                                                  onPressed: () => Navigator.pop(context),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Image.file(_paymentProof!, fit: BoxFit.cover)
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8, right: 8,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black54,
                                    radius: 14,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.close, size: 16, color: Colors.white),
                                      onPressed: () => setState(() => _paymentProof = null),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : InkWell(
                              onTap: _pickImage,
                              borderRadius: BorderRadius.circular(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cloud_upload_outlined, size: 48, color: Colors.blue.shade300),
                                  const SizedBox(height: 12),
                                  Text("Pilih foto dari Galeri", style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 4),
                                  Text("Maksimal ukuran 5MB", style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                                ],
                              ),
                            ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
      
      // BOTTOM NAVIGATION (FIXED DI BAWAH)
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF2994A), // Warna Oranye Premium
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              onPressed: _isSubmitting ? null : _submitOrder,
              child: _isSubmitting
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Buat Pesanan Sekarang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            ),
          ),
        ),
      ),
    );
  }
}

