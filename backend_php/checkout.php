<?php
header('Content-Type: application/json');
require 'koneksi.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user_id = $_POST['user_id'] ?? 1; // Default 1 for demo if no login implemented in app state
    $nama_penerima = $_POST['nama_penerima'] ?? '';
    $phone_penerima = $_POST['phone_penerima'] ?? '';
    $gps_location = $_POST['gps_location'] ?? '';
    $payment_method = $_POST['payment_method'] ?? '';
    $total_harga = $_POST['total_harga'] ?? 0;
    $items = json_decode($_POST['items'] ?? '[]', true); // JSON array of items from local SQLite

    // Handle File Upload (Bukti Pembayaran)
    $payment_proof = null;
    if (isset($_FILES['payment_proof']) && $_FILES['payment_proof']['error'] === UPLOAD_ERR_OK) {
        $allowed_exts = ['jpg', 'jpeg', 'png', 'pdf'];
        $file_ext = strtolower(pathinfo($_FILES['payment_proof']['name'], PATHINFO_EXTENSION));
        
        if (!in_array($file_ext, $allowed_exts)) {
            echo json_encode(["status" => "error", "message" => "Format file tidak didukung! Gunakan JPG/PNG/PDF."]);
            exit;
        }

        $upload_dir = 'uploads/';
        if (!is_dir($upload_dir)) mkdir($upload_dir, 0777, true);
        
        $file_tmp = $_FILES['payment_proof']['tmp_name'];
        $file_name = time() . '_' . $_FILES['payment_proof']['name'];
        $file_path = $upload_dir . $file_name;
        
        if (move_uploaded_file($file_tmp, $file_path)) {
            $payment_proof = $file_name;
        }
    }

    try {
        $conn->beginTransaction();
        
        // Insert Order
        $sql = "INSERT INTO orders (user_id, nama_penerima, phone_penerima, gps_location, payment_method, payment_proof, total_harga) 
                VALUES (:user_id, :nama, :phone, :gps, :payment, :proof, :total)";
        
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':user_id', $user_id);
        $stmt->bindParam(':nama', $nama_penerima);
        $stmt->bindParam(':phone', $phone_penerima);
        $stmt->bindParam(':gps', $gps_location);
        $stmt->bindParam(':payment', $payment_method);
        $stmt->bindParam(':proof', $payment_proof);
        $stmt->bindParam(':total', $total_harga);
        $stmt->execute();
        
        $order_id = $conn->lastInsertId();

        // Insert Order Details
        if (is_array($items)) {
            $stmtDetails = $conn->prepare("INSERT INTO order_details (order_id, nama_makanan, harga, jumlah) VALUES (:order_id, :nama, :harga, :jumlah)");
            foreach ($items as $item) {
                $stmtDetails->bindValue(':order_id', $order_id);
                $stmtDetails->bindValue(':nama', $item['nama_makanan']);
                $stmtDetails->bindValue(':harga', $item['harga']);
                $stmtDetails->bindValue(':jumlah', $item['jumlah']);
                $stmtDetails->execute();
            }
        }
        
        // Delete Cart Items
        $stmtClearCart = $conn->prepare("DELETE FROM cart WHERE user_id = :user_id");
        $stmtClearCart->bindParam(':user_id', $user_id);
        $stmtClearCart->execute();
        
        $conn->commit();
        echo json_encode(["status" => "success", "message" => "Pesanan berhasil dikirim!"]);
    } catch (PDOException $e) {
        $conn->rollBack();
        echo json_encode(["status" => "error", "message" => "Gagal memproses pesanan: " . $e->getMessage()]);
    }
}
?>
