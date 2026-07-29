import 'package:flutter/material.dart';

class AppStyles {
  // WARNA (COLORS)
  static const Color primaryColor = Colors.orange;
  static const Color secondaryColor = Colors.blue;
  static const Color backgroundColor = Color(0xFFF4F6F9);
  static const Color whiteColor = Colors.white;
  static const Color onlineColor = Colors.green;
  static const Color dangerColor = Colors.red;


  // GAYA TEKS (TYPOGRAPHY / TEXT STYLES)
  
  // Teks judul di Splash Screen
  static const TextStyle splashTitleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    height: 1.2,
    letterSpacing: 1.5,
  );

  // Teks subjudul di Splash Screen
  static const TextStyle splashSubtitleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: Colors.white70,
  );

  // GAYA TEKS (TYPOGRAPHY / TEXT STYLES)
  
  static const TextStyle appBarTitleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Colors.black87,
  );

  static const TextStyle headerTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Colors.black87,
  );

  static const TextStyle titleTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.black87,
  );

  static const TextStyle subtitleTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  static const TextStyle priceTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: primaryColor,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: whiteColor,
  );

  // Digunakan untuk teks "Online" (Chat)
  static const TextStyle onlineTextStyle = TextStyle(
    color: onlineColor,
    fontSize: 12,
  );

  static const TextStyle myChatTextStyle = TextStyle(
    color: whiteColor,
    fontSize: 14,
  );

  static const TextStyle otherChatTextStyle = TextStyle(
    color: Colors.black87,
    fontSize: 14,
  );

  static const TextStyle timeTextStyle = TextStyle(
    color: Colors.black54,
    fontSize: 10,
  );


  // DEKORASI KOTAK (BOX DECORATIONS)
  
  // Background gradient biru elegan untuk Splash Screen
  static const BoxDecoration splashBackgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  // Efek kaca transparan (Glassmorphism) untuk kotak luar logo di Splash Screen
  static final BoxDecoration splashLogoOuterDecoration = BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.white10,
    boxShadow: [
      BoxShadow(color: Colors.black12, blurRadius: 30, spreadRadius: 5)
    ],
    border: Border.all(color: Colors.white24, width: 1.5)
  );

  // Kotak putih solid untuk lingkaran dalam logo di Splash Screen
  static const BoxDecoration splashLogoInnerDecoration = BoxDecoration(
    shape: BoxShape.circle,
    color: whiteColor,
  );

  // Header melengkung di Home Screen
  static const BoxDecoration homeHeaderDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(30),
      bottomRight: Radius.circular(30),
    ),
  );

  // Kotak pencarian (Search Bar) di Home Screen
  static final BoxDecoration searchBarDecoration = BoxDecoration(
    color: whiteColor,
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
      BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))
    ]
  );

  // Dekorasi kategori yang sedang dipilih (Active)
  static final BoxDecoration categoryActiveDecoration = BoxDecoration(
    gradient: const LinearGradient(colors: [Color(0xFFF2994A), Color(0xFFF2C94C)]),
    borderRadius: BorderRadius.circular(25),
    boxShadow: [
      BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
    ],
    border: Border.all(color: Colors.transparent),
  );

  // Dekorasi kategori yang TIDAK dipilih (Inactive)
  static final BoxDecoration categoryInactiveDecoration = BoxDecoration(
    gradient: const LinearGradient(colors: [Colors.white, Colors.white]),
    borderRadius: BorderRadius.circular(25),
    border: Border.all(color: Colors.grey.shade300),
  );

  // Dekorasi standar untuk Kartu (Card) dengan shadow lembut
  static final BoxDecoration cardDecoration = BoxDecoration(
    color: whiteColor,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.grey.shade200),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.02),
        blurRadius: 10,
        offset: const Offset(0, 4),
      )
    ],
  );

  static final BoxDecoration homeGridItemDecoration = BoxDecoration(
    color: whiteColor,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: const Offset(0, 12))
    ],
    border: Border.all(color: Colors.grey.shade100, width: 1.5),
  );

  static final BoxDecoration homeImageDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(16),
  );

  static final BoxDecoration homeRatingDecoration = BoxDecoration(
    color: Colors.white.withOpacity(0.9),
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))
    ]
  );

  static final BoxDecoration homeAddToCartDecoration = BoxDecoration(
    gradient: const LinearGradient(colors: [Color(0xFFF2994A), Color(0xFFF2C94C)]),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
    ]
  );

  static final BoxDecoration bottomNavDecoration = BoxDecoration(
    color: whiteColor,
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
    ],
  );

  static final BoxDecoration bottomNavItemDecorationActive = BoxDecoration(
    color: secondaryColor.withOpacity(0.1),
    shape: BoxShape.circle,
  );
  
  static const BoxDecoration bottomNavItemDecorationInactive = BoxDecoration(
    color: Colors.transparent,
    shape: BoxShape.circle,
  );

  static final BoxDecoration quantityControlDecoration = BoxDecoration(
    border: Border.all(color: Colors.grey.shade300),
    borderRadius: BorderRadius.circular(8),
  );

  static final BoxDecoration orderHeaderDecoration = BoxDecoration(
    color: Colors.blue.shade50.withOpacity(0.5),
    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
  );

  static final BoxDecoration orderStatusDecoration = BoxDecoration(
    color: Colors.green.shade50,
    borderRadius: BorderRadius.circular(20),
  );

  static const TextStyle orderQuantityTextStyle = TextStyle(fontWeight: FontWeight.bold, color: Colors.blue);
  static final TextStyle orderItemNameTextStyle = TextStyle(color: Colors.grey.shade800);
  static const TextStyle orderItemPriceTextStyle = TextStyle(fontWeight: FontWeight.w600);
  static const TextStyle orderTotalLabelTextStyle = TextStyle(fontSize: 12, color: Colors.grey);

  // --- CART SCREEN CSS ---
  // Digunakan untuk mewarnai ikon keranjang kosong dan tombol
  static final Color cartIconBackgroundColor = Colors.blue.shade50;
  static const Color cartIconColor = Colors.blueGrey;
  static final Color cartEmptyIconColor = Colors.grey.shade400;
  static const Color cartRemoveIconColor = Colors.red;
  static final Color cartAddIconColor = Colors.blue.shade700;
  
  // Digunakan untuk teks di Cart Screen
  static const TextStyle cartEmptyTextStyle = TextStyle(fontSize: 18, color: Colors.grey);
  static const TextStyle cartItemNameTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  static final TextStyle cartItemPriceTextStyle = TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold);
  static const TextStyle cartQuantityTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static const TextStyle cartTotalLabelTextStyle = TextStyle(fontSize: 16, color: Colors.grey);
  static final TextStyle cartTotalPriceTextStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue.shade800);
  static const TextStyle cartCheckoutButtonTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  
  // Digunakan untuk wadah gambar di Cart Screen
  static final BoxDecoration cartImageDecoration = BoxDecoration(
    color: cartIconBackgroundColor,
    borderRadius: BorderRadius.circular(12),
  );

  // --- WADAH BAWAH (Bottom Sheet / Checkout Bar) ---
  static final BoxDecoration bottomSheetDecoration = BoxDecoration(
    color: whiteColor,
    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))
    ],
  );

  // --- UMUM (SNACKBAR & ICON UTAMA) ---
  // Digunakan untuk warna background peringatan (SnackBar) dan warna ikon bawaan
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color appBarForegroundColor = Colors.black87;

  // --- CHECKOUT SCREEN CSS ---
  // Digunakan untuk desain kartu dan warna di halaman Checkout
  static const Color checkoutIconColor = Colors.blue;
  static final Color checkoutAppBarColor = Colors.blue.shade800;
  static const Color checkoutAppBarIconColor = Colors.white;

  // Digunakan untuk kotak input pesan di bagian bawah (Chat)
  static final BoxDecoration inputContainerDecoration = BoxDecoration(
    color: whiteColor,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, -5),
      )
    ],
  );

  // Dekorasi khusus Text Field umum (Checkout/Form)
  static final InputDecoration generalInputDecoration = InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
  );

  // Digunakan untuk kotak TextField (kolom ketik Chat)
  static final InputDecoration messageInputDecoration = InputDecoration(
    hintText: "Ketik pesan di sini...",
    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
    filled: true,
    fillColor: Colors.grey.shade100,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: BorderSide.none,
    ),
  );

  // Dekorasi khusus Text Field Otentikasi (Login/Register)
  static final InputDecoration authInputDecoration = InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );


  // GAYA TOMBOL (BUTTON STYLES)
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: whiteColor,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
  );

  static final ButtonStyle authButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: secondaryColor.withOpacity(0.9), // Warna biru dari logo
    foregroundColor: whiteColor,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  static final ButtonStyle dangerOutlinedButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: dangerColor,
    side: const BorderSide(color: dangerColor),
    padding: const EdgeInsets.symmetric(vertical: 16),
  );
}
