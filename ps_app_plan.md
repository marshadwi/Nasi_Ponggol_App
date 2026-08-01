# Implementation Plan: PS_APP Completion & Audit

## Goal Description
The objective is to complete the `PS_APP` project for the user's friend so that it functions correctly and is ready for the BNSP JMP assessment. The app is a Food Delivery / Bakery E-Commerce app. The tech stack is **Flutter (Dart)** for the frontend and **Native PHP (Procedural)** for the backend API. 
The critical issues currently are that the PHP backend is highly insecure (SQL Injection vulnerable) and incomplete (missing Admin CRUD endpoints), which is causing the Admin panel in Flutter to silently fail when editing or deleting data. We will also enhance the UI (Splash Screen) and implement GPS location for checkout. The HTML/CSS requirement is intentionally ignored as it is out-of-scope for a pure mobile Flutter app.

> [!WARNING]
> **CRITICAL SECURITY RISK IDENTIFIED**
> The existing PHP files (`login.php`, `register.php`) concatenate variables directly into SQL queries (e.g., `SELECT * FROM users WHERE email='$email'`). This is a critical SQL Injection vulnerability. If presented to an assessor, it will result in an instant failure. 
> **Resolution:** We must rewrite all database interactions in the PHP files to use **PDO (PHP Data Objects) with Prepared Statements**.

## User Review Required
> [!IMPORTANT]
> Since we are ignoring the "HTML/CSS" request from the friend, please confirm that the friend will not be evaluated on Web Development competencies. If they are, we would need to build a separate web-based Admin Panel. Otherwise, we proceed with 100% Mobile (Flutter).

## Proposed Changes

---
### 1. Backend PHP API (Database & Security)
We will secure existing files and create the missing CRUD endpoints required by the Flutter Admin screens.

#### [MODIFY] `backend_php/koneksi.php`
- Change from `mysqli` to `PDO` for secure prepared statements across all files.

#### [MODIFY] `backend_php/login.php`, `register.php`, `checkout.php`
- Rewrite SQL queries to use PDO `prepare()` and `execute()` to prevent SQL injection.
- In `checkout.php`, add support for receiving and storing `gps_location`.

#### [NEW] `backend_php/get_menus.php`, `add_menu.php`, `update_menu.php`, `delete_menu.php`
- Create these missing endpoints. This directly fixes the friend's issue: *"di halaman admin kalo mau edit gambar pake link gambar lain, yang sebelumnya ada gambar malah ilang"* and *"cek di database kalo edit/hapus data berhasil apa ga"*. The reason it fails currently is that the API endpoints do not exist.

#### [NEW] `backend_php/get_orders.php`, `update_order_status.php`
- Create endpoints for the Admin to manage and fulfill user orders.

---
### 2. Flutter Frontend (Admin & User UI)
Enhance the UI and integrate the requested features.

#### [MODIFY] `lib/screens/splash_screen.dart`
- Redesign the splash screen to be more visually appealing ("lebih bagus") using modern animations or better imagery.

#### [MODIFY] `lib/screens/checkout_screen.dart`
- Integrate `geolocator` and `geocoding` packages to automatically fetch the user's current GPS location (Latitude/Longitude) and exact address when they press the "Checkout" button. Send this data to `checkout.php`.

#### [MODIFY] `lib/screens/admin/admin_menus_screen.dart`
- Fix state management when editing an image URL to ensure the UI updates correctly and the image doesn't disappear. Ensure it connects to the newly created `update_menu.php`.

---
### 3. Documentation & Diagrams
Provide the required JMP BNSP documentation artifacts tailored to the Native PHP + Flutter architecture.

#### [NEW] `5_Diagram/ps_usecase.drawio` & `Penjelasan_UseCase.md`
- Create a Use Case diagram depicting Actor (User) buying food and Actor (Admin) managing menus/orders.

#### [NEW] `6_Dokumentasi/Laporan_PS_APP.md`
- Create a comprehensive report detailing the architecture (Flutter + PHP), database schema, and features.

#### [NEW] `4_Presentasi/Skrip_Presentasi_PS_APP.txt`
- Create a speaker script tailored to the friend's tech stack so they can confidently explain the app to the assessor.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure there are no syntax errors in Dart.
- (N/A for PHP native scripts, rely on manual API testing).

### Manual Verification
1. **API Security:** The user should attempt to login with `' OR '1'='1` to verify that SQL injection is blocked.
2. **Admin Panel:** The user should login as Admin, add a new menu item, edit its image URL, and delete it, verifying that the changes persist in the MySQL database.
3. **Checkout & GPS:** The user should make a purchase, grant location permissions, and verify that their exact coordinates appear in the `orders` table in the database.
