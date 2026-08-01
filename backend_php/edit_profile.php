<?php
header('Content-Type: application/json');
require 'koneksi.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id = $_POST['id'] ?? 0;
    $nama = $_POST['nama'] ?? '';
    $email = $_POST['email'] ?? '';
    $password = $_POST['password'] ?? '';
    
    try {
        // Build the update query dynamically
        $query = "UPDATE users SET nama = :nama, email = :email";
        $params = [':nama' => $nama, ':email' => $email, ':id' => $id];
        
        // Handle Password
        if (!empty($password)) {
            $query .= ", password = :password";
            $params[':password'] = password_hash($password, PASSWORD_BCRYPT);
        }
        
        // Handle File Upload
        if (isset($_FILES['profile_pic']) && $_FILES['profile_pic']['error'] == 0) {
            $allowed_exts = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
            $file_ext = strtolower(pathinfo($_FILES['profile_pic']['name'], PATHINFO_EXTENSION));
            
            if (!in_array($file_ext, $allowed_exts)) {
                echo json_encode(["status" => "error", "message" => "Format gambar tidak didukung! Hanya JPG/PNG/GIF/WEBP."]);
                exit;
            }

            $upload_dir = 'uploads/profiles/';
            if (!is_dir($upload_dir)) {
                mkdir($upload_dir, 0777, true);
            }
            
            $file_ext = pathinfo($_FILES['profile_pic']['name'], PATHINFO_EXTENSION);
            $new_filename = "user_" . $id . "_" . time() . "." . $file_ext;
            $target_file = $upload_dir . $new_filename;
            
            if (move_uploaded_file($_FILES['profile_pic']['tmp_name'], $target_file)) {
                $query .= ", profile_pic = :profile_pic";
                $params[':profile_pic'] = $new_filename;
            }
        }
        
        $query .= " WHERE id = :id";
        
        $stmt = $conn->prepare($query);
        foreach ($params as $key => &$val) {
            $stmt->bindParam($key, $val);
        }
        
        if ($stmt->execute()) {
            // Fetch updated data to return to Flutter
            $stmtFetch = $conn->prepare("SELECT id, nama, email, role, profile_pic FROM users WHERE id = :id");
            $stmtFetch->bindParam(':id', $id);
            $stmtFetch->execute();
            $updatedUser = $stmtFetch->fetch(PDO::FETCH_ASSOC);
            
            echo json_encode(["status" => "success", "message" => "Profil berhasil diupdate!", "data" => $updatedUser]);
        } else {
            echo json_encode(["status" => "error", "message" => "Gagal mengupdate profil."]);
        }
    } catch(PDOException $e) {
        echo json_encode(["status" => "error", "message" => "System error: " . $e->getMessage()]);
    }
}
?>
