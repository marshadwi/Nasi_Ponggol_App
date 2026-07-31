<?php
header('Content-Type: application/json');
require 'koneksi.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id = $_POST['id'] ?? 0;
    $status = $_POST['status'] ?? 'Menunggu';
    
    // Validasi ketat enum status untuk mencegah injeksi
    $allowed_statuses = ['Menunggu', 'Diproses', 'Selesai', 'Ditolak'];
    if (!in_array($status, $allowed_statuses)) {
        echo json_encode(["status" => "error", "message" => "Status tidak valid!"]);
        exit;
    }

    try {
        $sql = "UPDATE orders SET status = :status WHERE id = :id";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':id', $id);
        $stmt->bindParam(':status', $status);
        
        if ($stmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Status berhasil diupdate!"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Gagal mengupdate status."]);
        }
    } catch(PDOException $e) {
        echo json_encode(["status" => "error", "message" => "System error: " . $e->getMessage()]);
    }
}
?>
