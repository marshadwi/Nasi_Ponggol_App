class Config {
  // --- KONFIGURASI LAPTOP IRSYAD (SEKARANG) ---
  static const String baseUrl = "https://shaunte-coua-eveline.ngrok-free.dev";
  
  // --- KONFIGURASI LAPTOP MARSHA (WINDOWS XAMPP) NANTI ---
  // Jika Marsha menaruh folder backend_php di dalam htdocs, maka URL-nya harus ditambah /backend_php
  // static const String baseUrl = "https://shaunte-coua-eveline.ngrok-free.dev/backend_php";
  
  // Endpoint URL siap pakai
  static const String loginUrl = "$baseUrl/login.php";
  static const String registerUrl = "$baseUrl/register.php";
  static const String getMenusUrl = "$baseUrl/get_menus.php";
  static const String getOrdersUrl = "$baseUrl/get_orders.php";
  static const String checkoutUrl = "$baseUrl/checkout.php";
  static const String editProfileUrl = "$baseUrl/edit_profile.php";
  
  // Cart API
  static const String cartAddUrl = "$baseUrl/cart_add.php";
  static const String setupCartUrl = "$baseUrl/cart_setup.php";
  static const String adminStatsUrl = "$baseUrl/admin_stats.php";
  static const String adminGetOrdersUrl = "$baseUrl/get_orders.php";
  static const String updateOrderUrl = "$baseUrl/update_order_status.php";
  static const String deleteMenuUrl = "$baseUrl/delete_menu.php";
  static const String addMenuUrl = "$baseUrl/add_menu.php";
  static const String updateMenuUrl = "$baseUrl/update_menu.php";
  static const String cartGetUrl = "$baseUrl/cart_get.php";
  static const String cartUpdateUrl = "$baseUrl/cart_update.php";
  static const String cartDeleteUrl = "$baseUrl/cart_delete.php";
  
  // URL untuk direktori gambar profil
  static const String profileImageUrl = "$baseUrl/uploads/profiles/";
  static const String chatUrl = "$baseUrl/chat.php";
}
