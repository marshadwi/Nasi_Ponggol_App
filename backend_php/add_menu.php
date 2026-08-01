<?php
header('Content-Type: application/json');
require 'koneksi.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $nama = $_POST['nama'] ?? '';
    $harga = $_POST['harga'] ?? 0;
    $kategori = $_POST['kategori'] ?? '';
    $rating = $_POST['rating'] ?? '5.0';
    $image = 'default.jpg';
    if (isset($_FILES['image_file']) && $_FILES['image_file']['error'] == UPLOAD_ERR_OK) {
        $uploadDir = 'uploads/menus/';
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0777, true);
        }
        $filename = time() . '_' . basename($_FILES['image_file']['name']);
        if (move_uploaded_file($_FILES['image_file']['tmp_name'], $uploadDir . $filename)) {
            $image = $filename;
        }
    } else if (isset($_POST['image'])) {
        $image = $_POST['image'];
    }

    try {
        $sql = "INSERT INTO menus (nama, harga, kategori, rating, image, deskripsi) VALUES (:nama, :harga, :kategori, :rating, :image, :deskripsi)";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':nama', $nama);
        $stmt->bindParam(':harga', $harga);
        $stmt->bindParam(':kategori', $kategori);
        $stmt->bindParam(':rating', $rating);
        $stmt->bindParam(':image', $image);
        $stmt->bindParam(':deskripsi', $deskripsi);
        
        if ($stmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Menu berhasil ditambahkan!"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Gagal menambahkan menu."]);
        }
    } catch(PDOException $e) {
        echo json_encode(["status" => "error", "message" => "System error: " . $e->getMessage()]);
    }
}
?>
