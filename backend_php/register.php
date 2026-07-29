<?php
header('Content-Type: application/json');
require 'koneksi.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $nama = $_POST['nama'] ?? '';
    $phone = $_POST['phone'] ?? '';
    $email = $_POST['email'] ?? '';
    $password_raw = $_POST['password'] ?? '';
    $password = password_hash($password_raw, PASSWORD_DEFAULT);

    try {
        $cek = $conn->prepare("SELECT id FROM users WHERE email = :email");
        $cek->bindParam(':email', $email);
        $cek->execute();

        if ($cek->rowCount() > 0) {
            echo json_encode(["status" => "error", "message" => "Email sudah terdaftar!"]);
        } else {
            $sql = "INSERT INTO users (nama, phone, email, password) VALUES (:nama, :phone, :email, :password)";
            $stmt = $conn->prepare($sql);
            $stmt->bindParam(':nama', $nama);
            $stmt->bindParam(':phone', $phone);
            $stmt->bindParam(':email', $email);
            $stmt->bindParam(':password', $password);
            
            if ($stmt->execute()) {
                echo json_encode(["status" => "success", "message" => "Registrasi berhasil!"]);
            } else {
                echo json_encode(["status" => "error", "message" => "Gagal menyimpan data"]);
            }
        }
    } catch(PDOException $e) {
        echo json_encode(["status" => "error", "message" => "System error"]);
    }
}
?>
