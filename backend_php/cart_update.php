<?php
header('Content-Type: application/json');
require 'koneksi.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id = $_POST['id'] ?? 0;
    $jumlah = $_POST['jumlah'] ?? 0;

    try {
        if ($jumlah <= 0) {
            $stmt = $conn->prepare("DELETE FROM cart WHERE id = :id");
            $stmt->bindParam(':id', $id);
            $stmt->execute();
        } else {
            $stmt = $conn->prepare("UPDATE cart SET jumlah = :jumlah WHERE id = :id");
            $stmt->bindParam(':jumlah', $jumlah);
            $stmt->bindParam(':id', $id);
            $stmt->execute();
        }
        
        echo json_encode(["status" => "success", "message" => "Keranjang diupdate"]);
    } catch(PDOException $e) {
        echo json_encode(["status" => "error", "message" => $e->getMessage()]);
    }
}
?>
