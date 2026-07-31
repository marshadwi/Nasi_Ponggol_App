<?php
header('Content-Type: application/json');
require 'koneksi.php';

try {
    $stmt = $conn->query("SELECT id, nama, email, phone, role, profile_pic, created_at FROM users WHERE role != 'admin' ORDER BY created_at DESC");
    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode([
        "status" => "success",
        "data" => $users
    ]);
} catch (PDOException $e) {
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}
?>
