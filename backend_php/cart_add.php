<?php
header('Content-Type: application/json');
require 'koneksi.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user_id = $_POST['user_id'] ?? 1;
    $nama_makanan = $_POST['nama_makanan'] ?? '';
    $harga = $_POST['harga'] ?? 0;
    $jumlah = $_POST['jumlah'] ?? 1;

    try {
        // Cek apakah makanan sudah ada di keranjang untuk user ini
        $cek = $conn->prepare("SELECT id, jumlah FROM cart WHERE user_id = :user_id AND nama_makanan = :nama_makanan");
        $cek->bindParam(':user_id', $user_id);
        $cek->bindParam(':nama_makanan', $nama_makanan);
        $cek->execute();
        
        if ($cek->rowCount() > 0) {
            // Update jumlah
            $row = $cek->fetch();
            $new_jumlah = $row['jumlah'] + $jumlah;
            $update = $conn->prepare("UPDATE cart SET jumlah = :jumlah WHERE id = :id");
            $update->bindParam(':jumlah', $new_jumlah);
            $update->bindParam(':id', $row['id']);
            $update->execute();
        } else {
            // Insert baru
            $insert = $conn->prepare("INSERT INTO cart (user_id, nama_makanan, harga, jumlah) VALUES (:user_id, :nama_makanan, :harga, :jumlah)");
            $insert->bindParam(':user_id', $user_id);
            $insert->bindParam(':nama_makanan', $nama_makanan);
            $insert->bindParam(':harga', $harga);
            $insert->bindParam(':jumlah', $jumlah);
            $insert->execute();
        }
        
        echo json_encode(["status" => "success", "message" => "Berhasil ditambahkan ke keranjang"]);
    } catch(PDOException $e) {
        echo json_encode(["status" => "error", "message" => $e->getMessage()]);
    }
}
?>
