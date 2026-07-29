<?php
header('Content-Type: application/json');
require 'koneksi.php';

try {
    $stmt = $conn->query("SELECT * FROM menus ORDER BY id DESC");
    $menus = $stmt->fetchAll(PDO::FETCH_ASSOC);
    $protocol = isset($_SERVER['HTTP_X_FORWARDED_PROTO']) ? $_SERVER['HTTP_X_FORWARDED_PROTO'] : (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? 'https' : 'http');
    $host = isset($_SERVER['HTTP_X_FORWARDED_HOST']) ? $_SERVER['HTTP_X_FORWARDED_HOST'] : $_SERVER['HTTP_HOST'];
    $base_url = $protocol . '://' . $host;

    foreach ($menus as &$menu) {
        if (strpos($menu['image'], 'http') !== 0) {
            $menu['image'] = $base_url . '/' . ltrim($menu['image'], '/');
        }
    }

    echo json_encode([
        "status" => "success",
        "data" => $menus
    ]);
} catch (PDOException $e) {
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}
?>
