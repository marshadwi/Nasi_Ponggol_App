<?php
require 'koneksi.php';

$images = [
    'ayam' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/4/40/Ayam_goreng_kalasan.jpg/800px-Ayam_goreng_kalasan.jpg',
    'ponggol' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/4/41/Nasi_Bungkus.jpg',
    'telur' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Nasi_telur_kecap.jpg/800px-Nasi_telur_kecap.jpg',
    'tempe' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Orek_tempe.jpg/800px-Orek_tempe.jpg',
    'teri' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/6/69/Sambal_Teri_Kacang.JPG/800px-Sambal_Teri_Kacang.JPG',
    'sate' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/8/87/Sate_Usus_Ayam.jpg/800px-Sate_Usus_Ayam.jpg',
    'bakwan' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/1/15/Bakwan_sayur_and_tempeh_mendoan.jpg/800px-Bakwan_sayur_and_tempeh_mendoan.jpg',
    'gorengan' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/1/15/Bakwan_sayur_and_tempeh_mendoan.jpg/800px-Bakwan_sayur_and_tempeh_mendoan.jpg',
    'tongkol' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/2/27/Ikan_Tongkol_Balado.jpg/800px-Ikan_Tongkol_Balado.jpg',
    'mie' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/3/30/Mie_goreng_jawa_tek_tek.jpg/800px-Mie_goreng_jawa_tek_tek.jpg',
    'seblak' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/3/36/Seblak_Bandung.jpg/800px-Seblak_Bandung.jpg',
    'opor' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Opor_Ayam.JPG/800px-Opor_Ayam.JPG',
    'lontong' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Lontong_Sayur_Padang.JPG/800px-Lontong_Sayur_Padang.JPG',
    'teh' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/8/80/Es_teh_manis.jpg/800px-Es_teh_manis.jpg',
    'jeruk' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/4/4c/Es_Jeruk.jpg/800px-Es_Jeruk.jpg',
    'kopi' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/7/7b/Kopi_Tubruk.jpg/800px-Kopi_Tubruk.jpg',
    'kerupuk' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Krupuk_Bawang.JPG/800px-Krupuk_Bawang.JPG',
    'emping' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Emping.jpg/800px-Emping.jpg',
    'sambal' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/0/07/Sambal_Terasi.JPG/800px-Sambal_Terasi.JPG',
    'nasi' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/4/41/Nasi_Bungkus.jpg',
    'cincau' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/3/3b/Es_Cincau_Hijau.jpg/800px-Es_Cincau_Hijau.jpg',
    'soda' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/6/65/Soda_Gembira.JPG/800px-Soda_Gembira.JPG',
    'air' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/9/91/Aqua_bottle.jpg/450px-Aqua_bottle.jpg',
    'kikil' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/3/37/Gulai_Tunjang.jpg/800px-Gulai_Tunjang.jpg',
    'ceker' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Ceker_ayam.jpg/800px-Ceker_ayam.jpg',
    'bakso' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/3/31/Bakso_mi_bihun.jpg/800px-Bakso_mi_bihun.jpg',
    'makaroni' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/6/63/Macaroni_Schotel.jpg/800px-Macaroni_Schotel.jpg',
    'tahu' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/4/41/Tahu_goreng_crispy.jpg/800px-Tahu_goreng_crispy.jpg',
    'acar' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/6/62/Acar_Campur.JPG/800px-Acar_Campur.JPG',
    'rempeyek' => 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Rempeyek_kacang.jpg/800px-Rempeyek_kacang.jpg',
];

$default_img = 'https://wsrv.nl/?url=upload.wikimedia.org/wikipedia/commons/thumb/2/23/Nasi_Campur.jpg/800px-Nasi_Campur.jpg';

try {
    $stmt = $conn->query("SELECT id, nama FROM menus");
    $menus = $stmt->fetchAll();
    
    foreach ($menus as $menu) {
        $id = $menu['id'];
        $nama = strtolower($menu['nama']);
        
        $new_img = $default_img;
        foreach ($images as $keyword => $url) {
            if (strpos($nama, $keyword) !== false) {
                $new_img = $url;
                break; // Use the first matching keyword
            }
        }
        
        $update = $conn->prepare("UPDATE menus SET image = :image WHERE id = :id");
        $update->execute([':image' => $new_img, ':id' => $id]);
    }
    
    echo "Successfully updated images for " . count($menus) . " menus.";
    
} catch (PDOException $e) {
    echo "Error: " . $e->getMessage();
}
?>
