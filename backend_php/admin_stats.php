<?php
header('Content-Type: application/json');
require 'koneksi.php';

try {
    // 1. Total Pendapatan
    $stmt1 = $conn->query("SELECT SUM(total_harga) as pendapatan FROM orders WHERE status = 'Selesai'");
    $res1 = $stmt1->fetch();
    $pendapatan = $res1['pendapatan'] ?? 0;

    // 2. Total Pesanan
    $stmt2 = $conn->query("SELECT COUNT(*) as pesanan_total FROM orders");
    $res2 = $stmt2->fetch();
    $pesanan_total = $res2['pesanan_total'] ?? 0;

    // 3. Pesanan Menunggu
    $stmt3 = $conn->query("SELECT COUNT(*) as pesanan_menunggu FROM orders WHERE status = 'Menunggu'");
    $res3 = $stmt3->fetch();
    $pesanan_menunggu = $res3['pesanan_menunggu'] ?? 0;

    // 4. Total Pengguna
    $stmt4 = $conn->query("SELECT COUNT(*) as pengguna FROM users");
    $res4 = $stmt4->fetch();
    $pengguna = $res4['pengguna'] ?? 0;

    echo json_encode([
        "status" => "success",
        "data" => [
            "pendapatan" => $pendapatan,
            "pesanan_total" => $pesanan_total,
            "pesanan_menunggu" => $pesanan_menunggu,
            "pengguna" => $pengguna
        ]
    ]);
} catch (PDOException $e) {
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}
?>
