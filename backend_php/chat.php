<?php
header('Content-Type: application/json');
require 'koneksi.php';

$method = $_SERVER['REQUEST_METHOD'];

try {
    if ($method == 'GET') {
        $action = $_GET['action'] ?? '';

        if ($action == 'get_users') {
            // Get users who have chats
            $stmt = $conn->query("SELECT DISTINCT u.id, u.nama, u.email FROM users u JOIN chats c ON u.id = c.user_id");
            $users = $stmt->fetchAll();
            echo json_encode(["status" => "success", "data" => $users]);
        } else if ($action == 'get') {
            $user_id = $_GET['user_id'] ?? 0;
            $stmt = $conn->prepare("SELECT * FROM chats WHERE user_id = :user_id ORDER BY created_at ASC");
            $stmt->bindParam(':user_id', $user_id);
            $stmt->execute();
            $chats = $stmt->fetchAll();
            echo json_encode(["status" => "success", "data" => $chats]);
        } else {
            echo json_encode(["status" => "error", "message" => "Unknown action"]);
        }
    } else if ($method == 'POST') {
        $action = $_POST['action'] ?? '';
        
        if ($action == 'send') {
            $user_id = $_POST['user_id'] ?? 0;
            $is_admin = $_POST['is_admin'] ?? 0;
            $message = $_POST['message'] ?? '';

            $stmt = $conn->prepare("INSERT INTO chats (user_id, is_admin, message) VALUES (:user_id, :is_admin, :message)");
            $stmt->bindParam(':user_id', $user_id);
            $stmt->bindParam(':is_admin', $is_admin);
            $stmt->bindParam(':message', $message);
            $stmt->execute();

            echo json_encode(["status" => "success", "message" => "Pesan terkirim"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Unknown action"]);
        }
    }
} catch (PDOException $e) {
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}
?>
