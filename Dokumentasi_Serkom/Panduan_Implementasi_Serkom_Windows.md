# 📚 Buku Panduan Implementasi & Setup Project (Windows)
**Aplikasi Pemesanan Nasi Ponggol - Persiapan Uji Kompetensi (Serkom)**

Dokumentasi ini disusun khusus agar mudah dipelajari, dipahami, dan diimplementasikan ulang di laptop **Windows**. Semua langkah dirancang dari nol (*from scratch*) dengan menggunakan arsitektur *mock data* (data siap pakai) sehingga project ini bisa langsung dijalankan saat ujian.

---

## 🎯 1. Arsitektur Sistem
Project ini menggunakan arsitektur *Client-Server*:
1. **Frontend (Client)**: Dibangun dengan **Flutter (Dart)**. Bertugas menampilkan Antarmuka Pengguna (UI) yang interaktif, mengelola state Keranjang (Cart), dan Form Checkout.
2. **Backend (Server)**: Dibangun dengan **PHP Native (tanpa framework)**. Bertugas sebagai penyedia REST API untuk aplikasi Flutter.
3. **Database**: Menggunakan **MySQL** (lewat XAMPP) yang menyimpan data *User*, *Menu*, *Cart*, dan *Order*.

---

## 💻 2. Kebutuhan Sistem (Prerequisites) di Windows
Sebelum mulai, pastikan laptop Windows yang digunakan sudah terinstall perangkat lunak berikut:
1. **XAMPP** (disarankan versi PHP 7.4 atau 8.x) - Untuk menjalankan Apache (Server Web) & MySQL (Database).
2. **Flutter SDK** & **Android Studio / VS Code** - Untuk menjalankan aplikasi *mobile*.
3. **Git** - (Opsional) Untuk menarik kode dari repositori.
4. **Postman** - (Opsional) Untuk melakukan pengujian REST API di luar aplikasi Flutter.

---

## 🛠️ 3. Langkah Instalasi Backend & Database (XAMPP)

Karena aplikasi ini diuji di Windows, kita akan menggunakan folder `htdocs` dari XAMPP.

### A. Persiapan File Backend
1. Buka *File Explorer* di Windows.
2. Copy folder `backend_php` (yang berisi file `.php` dan folder `uploads`).
3. Paste ke dalam folder instalasi XAMPP, yaitu di `C:\xampp\htdocs\`.
4. Agar rapi, ubah nama folder `backend_php` menjadi `ponggol_api`.
   *(Path Anda sekarang menjadi: `C:\xampp\htdocs\ponggol_api`)*

### B. Setup Database & Mock Data
Sistem sudah dilengkapi dengan *Mock Data* (data dummy) lengkap mulai dari menu, gambar, hingga akun demo.

1. Buka aplikasi **XAMPP Control Panel** di Windows.
2. Klik tombol **Start** pada modul **Apache** dan **MySQL**.
3. Buka browser (Chrome/Edge), lalu ketikkan: `http://localhost/phpmyadmin`
4. Klik tombol **New** (Baru) di sebelah kiri untuk membuat database baru.
5. Beri nama database: `ps_db` lalu klik **Create** (Buat).
6. Klik pada database `ps_db` yang baru dibuat.
7. Pilih tab **Import** di menu atas.
8. Klik **Choose File**, lalu cari dan pilih file `ps_db.sql` yang ada di dalam folder backend.
9. Scroll ke paling bawah dan klik **Go** atau **Import**.
10. Selesai! Semua tabel (*users, menus, cart, orders*) beserta isinya sudah siap.

---

## 📱 4. Langkah Instalasi Frontend (Flutter)

Aplikasi mobile butuh tahu di mana server Backend menyala. Di sinilah konfigurasi IP menjadi sangat krusial di Windows.

### A. Mengetahui IP Laptop Windows Anda
Aplikasi Flutter yang berjalan di Emulator atau HP Fisik **tidak bisa** menggunakan URL `http://localhost`, karena localhost di HP menunjuk ke HP itu sendiri, bukan ke laptop Windows Anda.

1. Buka **Command Prompt (CMD)** di Windows.
2. Ketik perintah: `ipconfig` lalu tekan Enter.
3. Cari bagian *Wireless LAN adapter Wi-Fi* (jika pakai WiFi).
4. Catat angka pada **IPv4 Address** (Contoh: `192.168.1.10` atau `192.168.100.5`).

> **Pengecualian Emulator Bawaan Android Studio:**
> Jika murni menggunakan Android Emulator di laptop, Anda bisa menggunakan IP khusus sakti dari Google: `10.0.2.2` (Ini setara dengan localhost laptop).

### B. Konfigurasi `config.dart`
1. Buka folder project Flutter (Front-End) menggunakan **VS Code**.
2. Buka file `lib/config.dart`.
3. Ubah variabel `baseUrl` menggunakan IP yang sudah dicatat tadi.

```dart
// Contoh menggunakan IPv4 WiFi (Untuk HP Fisik & Emulator)
static const String baseUrl = "http://192.168.1.10/ponggol_api";

// ATAU Contoh menggunakan Emulator Android Studio
// static const String baseUrl = "http://10.0.2.2/ponggol_api";
```

### C. Menjalankan Aplikasi
1. Buka terminal di VS Code.
2. Jalankan perintah untuk mengunduh semua library:
   ```bash
   flutter pub get
   ```
3. Colokkan HP Android Anda (pastikan *USB Debugging* aktif) ATAU buka Emulator.
4. Jalankan aplikasi dengan tombol **Run** atau perintah:
   ```bash
   flutter run
   ```

---

## 🔑 5. Akun Uji Coba (Mock Data Login)

Untuk keperluan demo Serkom, gunakan akun yang sudah tertanam di database berikut:

| Peran (Role) | Email | Password | Keterangan |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin@ponggol.com` | `password123` | Bisa akses Dashboard Admin, tambah menu, ubah status pesanan. |
| **Customer** | `user@gmail.com` | `password123` | Pelanggan biasa, bisa tambah keranjang dan checkout pesanan. |

---

## 💡 6. Poin Penting untuk Presentasi Serkom (Cheat Sheet)

Beri tahu teman Anda agar menonjolkan fitur-fitur "Mahal" berikut saat presentasi di depan penguji:

1. **"Sistem kami menggunakan validasi form yang ketat."**
   *Tunjukkan bahwa saat Checkout, jika lokasi GPS tidak diisi, atau jika bukti transfer kosong, aplikasi menolak memproses pesanan dan memunculkan notifikasi.*
2. **"Kami menerapkan manajemen State & Autentikasi yang responsif."**
   *Tunjukkan bahwa setelah logout, jika user menekan tombol "Back" (kembali) di HP, user tidak bisa masuk lagi ke beranda tanpa login ulang.*
3. **"Semua tombol beroperasi penuh, kami memiliki *Zero Dead-Button Policy*."**
   *Tunjukkan bahwa halaman Profil tidak hanya sekadar pajangan UI, tetapi setiap baris (Pengaturan, Bantuan, Alamat) diikat pada sebuah *Dialog Box* yang memunculkan informasi fungsional.*
4. **"Integrasi API menggunakan JSON dengan standar keamanan Password Hashing."**
   *Tunjukkan bahwa password yang tersimpan di dalam database MySQL tidak terlihat teks aslinya, melainkan di-enkripsi menggunakan metode algoritma hashing bawaan PHP (`password_hash`).*

---

🎉 **Selamat Menempuh Serkom!** Sistem ini dirancang untuk sangat tahan banting (*bulletproof*). Ikuti urutan ini di Windows, dan aplikasi akan berjalan mulus 100%.
