<?php
header('Content-Type: application/json');
require 'koneksi.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id = $_POST['id'] ?? 0;
    $nama = $_POST['nama'] ?? '';
    $harga = $_POST['harga'] ?? 0;
    $kategori = $_POST['kategori'] ?? '';
    $rating = $_POST['rating'] ?? '5.0';
    $image = $_POST['old_image'] ?? 'default.jpg';
    if (isset($_FILES['image_file']) && $_FILES['image_file']['error'] == UPLOAD_ERR_OK) {
        $uploadDir = 'uploads/menus/';
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0777, true);
        }
        $filename = time() . '_' . basename($_FILES['image_file']['name']);
        if (move_uploaded_file($_FILES['image_file']['tmp_name'], $uploadDir . $filename)) {
            $image = $filename;
        }
    }

    try {
        $sql = "UPDATE menus SET nama = :nama, harga = :harga, kategori = :kategori, rating = :rating, image = :image, deskripsi = :deskripsi WHERE id = :id";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':id', $id);
        $stmt->bindParam(':nama', $nama);
        $stmt->bindParam(':harga', $harga);
        $stmt->bindParam(':kategori', $kategori);
        $stmt->bindParam(':rating', $rating);
        $stmt->bindParam(':image', $image);
        $stmt->bindParam(':deskripsi', $deskripsi);
        
        if ($stmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Menu berhasil diupdate!"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Gagal mengupdate menu."]);
        }
    } catch(PDOException $e) {
        echo json_encode(["status" => "error", "message" => "System error: " . $e->getMessage()]);
    }
}
?>
