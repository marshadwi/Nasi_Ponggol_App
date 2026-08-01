<?php
header('Content-Type: application/json');
require 'koneksi.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'] ?? '';
    $new_password = $_POST['new_password'] ?? '';

    if (empty($email) || empty($new_password)) {
        echo json_encode(["status" => "error", "message" => "Email dan password baru harus diisi"]);
        exit;
    }

    try {
        // Hash password baru dengan bcrypt
        $hashed_password = password_hash($new_password, PASSWORD_BCRYPT);
        
        $sql = "UPDATE users SET password = :password WHERE email = :email";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':password', $hashed_password);
        $stmt->bindParam(':email', $email);
        
        if ($stmt->execute()) {
            // Check if any row was actually updated
            if ($stmt->rowCount() > 0) {
                echo json_encode(["status" => "success", "message" => "Kata sandi berhasil diubah!"]);
            } else {
                echo json_encode(["status" => "error", "message" => "Email tidak ditemukan!"]);
            }
        } else {
            echo json_encode(["status" => "error", "message" => "Gagal mengubah kata sandi."]);
        }
    } catch(PDOException $e) {
        echo json_encode(["status" => "error", "message" => "System error: " . $e->getMessage()]);
    }
}
?>
