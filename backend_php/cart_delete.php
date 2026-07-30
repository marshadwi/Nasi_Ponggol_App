<?php
header('Content-Type: application/json');
require 'koneksi.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id = $_POST['id'] ?? 0;

    try {
        $stmt = $conn->prepare("DELETE FROM cart WHERE id = :id");
        $stmt->bindParam(':id', $id);
        $stmt->execute();
        
        echo json_encode(["status" => "success", "message" => "Item dihapus"]);
    } catch(PDOException $e) {
        echo json_encode(["status" => "error", "message" => $e->getMessage()]);
    }
}
?>
