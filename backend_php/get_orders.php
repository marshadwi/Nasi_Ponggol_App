<?php
header('Content-Type: application/json');
require 'koneksi.php';

try {
    $stmt = $conn->query("SELECT * FROM orders ORDER BY created_at DESC");
    $orders = $stmt->fetchAll();
    echo json_encode([
        "status" => "success",
        "data" => $orders
    ]);
} catch (PDOException $e) {
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}
?>
