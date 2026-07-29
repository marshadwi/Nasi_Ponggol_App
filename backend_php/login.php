<?php
header('Content-Type: application/json');
require 'koneksi.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'] ?? '';
    $password = $_POST['password'] ?? '';

    try {
        $stmt = $conn->prepare("SELECT * FROM users WHERE email = :email");
        $stmt->bindParam(':email', $email);
        $stmt->execute();
        
        if ($stmt->rowCount() > 0) {
            $user = $stmt->fetch();
            if (password_verify($password, $user['password'])) {
                echo json_encode([
                    "status" => "success",
                    "message" => "Login berhasil",
                    "data" => [
                        "id" => $user['id'],
                        "nama" => $user['nama'],
                        "email" => $user['email'],
                        "role" => $user['role'], // Adding role so frontend knows if it's admin
                        "profile_pic" => $user['profile_pic'] ?? null
                    ]
                ]);
            } else {
                echo json_encode(["status" => "error", "message" => "Password salah!"]);
            }
        } else {
            echo json_encode(["status" => "error", "message" => "Email tidak terdaftar!"]);
        }
    } catch(PDOException $e) {
        echo json_encode(["status" => "error", "message" => "System error"]);
    }
}
?>
