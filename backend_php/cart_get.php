<?php
header('Content-Type: application/json');
require 'koneksi.php';

$user_id = $_GET['user_id'] ?? 1;

try {
    $stmt = $conn->prepare("SELECT * FROM cart WHERE user_id = :user_id");
    $stmt->bindParam(':user_id', $user_id);
    $stmt->execute();
    
    $items = $stmt->fetchAll();
    echo json_encode([
        "status" => "success",
        "data" => $items
    ]);
} catch (PDOException $e) {
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}
?>
