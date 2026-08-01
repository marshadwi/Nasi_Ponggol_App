<?php
require 'koneksi.php';

$images = [
    'ayam' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/Ayam_goreng_kalasan.jpg/800px-Ayam_goreng_kalasan.jpg',
    'ponggol' => 'https://upload.wikimedia.org/wikipedia/commons/4/41/Nasi_Bungkus.jpg',
    'telur' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Nasi_telur_kecap.jpg/800px-Nasi_telur_kecap.jpg',
    'tempe' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Orek_tempe.jpg/800px-Orek_tempe.jpg',
    'teri' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/Sambal_Teri_Kacang.JPG/800px-Sambal_Teri_Kacang.JPG',
    'sate' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Sate_Usus_Ayam.jpg/800px-Sate_Usus_Ayam.jpg',
    'bakwan' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Bakwan_sayur_and_tempeh_mendoan.jpg/800px-Bakwan_sayur_and_tempeh_mendoan.jpg',
    'gorengan' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Bakwan_sayur_and_tempeh_mendoan.jpg/800px-Bakwan_sayur_and_tempeh_mendoan.jpg',
    'tongkol' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/27/Ikan_Tongkol_Balado.jpg/800px-Ikan_Tongkol_Balado.jpg',
    'mie' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Mie_goreng_jawa_tek_tek.jpg/800px-Mie_goreng_jawa_tek_tek.jpg',
    'seblak' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Seblak_Bandung.jpg/800px-Seblak_Bandung.jpg',
    'opor' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Opor_Ayam.JPG/800px-Opor_Ayam.JPG',
    'lontong' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Lontong_Sayur_Padang.JPG/800px-Lontong_Sayur_Padang.JPG',
    'teh' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/Es_teh_manis.jpg/800px-Es_teh_manis.jpg',
    'jeruk' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4c/Es_Jeruk.jpg/800px-Es_Jeruk.jpg',
    'kopi' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7b/Kopi_Tubruk.jpg/800px-Kopi_Tubruk.jpg',
    'kerupuk' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Krupuk_Bawang.JPG/800px-Krupuk_Bawang.JPG',
    'emping' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Emping.jpg/800px-Emping.jpg',
    'sambal' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/Sambal_Terasi.JPG/800px-Sambal_Terasi.JPG',
    'nasi' => 'https://upload.wikimedia.org/wikipedia/commons/4/41/Nasi_Bungkus.jpg',
    'cincau' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3b/Es_Cincau_Hijau.jpg/800px-Es_Cincau_Hijau.jpg',
    'soda' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Soda_Gembira.JPG/800px-Soda_Gembira.JPG',
    'air' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Aqua_bottle.jpg/450px-Aqua_bottle.jpg',
    'kikil' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/Gulai_Tunjang.jpg/800px-Gulai_Tunjang.jpg',
    'ceker' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Ceker_ayam.jpg/800px-Ceker_ayam.jpg',
    'bakso' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/31/Bakso_mi_bihun.jpg/800px-Bakso_mi_bihun.jpg',
    'makaroni' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/63/Macaroni_Schotel.jpg/800px-Macaroni_Schotel.jpg',
    'tahu' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Tahu_goreng_crispy.jpg/800px-Tahu_goreng_crispy.jpg',
    'acar' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/62/Acar_Campur.JPG/800px-Acar_Campur.JPG',
    'rempeyek' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Rempeyek_kacang.jpg/800px-Rempeyek_kacang.jpg',
];

$default_img_url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/Nasi_Campur.jpg/800px-Nasi_Campur.jpg';

// Create directory if not exists
if (!is_dir(__DIR__ . '/uploads/menus')) {
    mkdir(__DIR__ . '/uploads/menus', 0777, true);
}

function downloadImage($url, $filepath) {
    if (file_exists($filepath) && filesize($filepath) > 10000) {
        return true; // Already downloaded and seems valid
    }
    
    $ch = curl_init($url);
    $fp = fopen($filepath, 'wb');
    curl_setopt($ch, CURLOPT_FILE, $fp);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    // LoremFlickr requires following redirects
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt($ch, CURLOPT_MAXREDIRS, 5);
    curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36');
    curl_setopt($ch, CURLOPT_TIMEOUT, 15);
    
    curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    fclose($fp);
    
    // Check if valid JPEG by looking at file size
    if ($httpCode != 200 || filesize($filepath) < 1000) {
        if(file_exists($filepath)) {
            unlink($filepath);
        }
        return false;
    }
    return true;
}

// Map real Indonesian food names to loremflickr tags
$foodTags = [
    'ayam' => 'chicken,indonesia,food',
    'ponggol' => 'rice,indonesia,food',
    'telur' => 'egg,food',
    'tempe' => 'tempeh,food',
    'teri' => 'anchovies,food',
    'sate' => 'satay,food',
    'bakwan' => 'fritters,food',
    'gorengan' => 'snack,fried,food',
    'tongkol' => 'fish,food',
    'tahu' => 'tofu,food',
    'kerupuk' => 'crackers,food',
    'nasi' => 'rice,food',
    'mie' => 'noodles,food',
    'sayur' => 'vegetables,food',
    'daging' => 'beef,food',
    'rendang' => 'rendang,food',
    'teh' => 'tea,drink',
    'kopi' => 'coffee,drink',
    'es' => 'ice,drink',
    'minum' => 'drink'
];

function getUrlForName($name) {
    global $foodTags;
    $lower = strtolower($name);
    $tag = 'food,indonesia';
    
    foreach ($foodTags as $key => $val) {
        if (strpos($lower, $key) !== false) {
            $tag = $val;
            break;
        }
    }
    
    // Add a random number to avoid caching the same image for the same tag
    return "https://loremflickr.com/600/400/" . $tag . "?random=" . rand(1, 1000);
}

try {
    $stmt = $conn->query("SELECT id, nama FROM menus");
    $menus = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $updated = 0;
    foreach ($menus as $menu) {
        $nama = strtolower($menu['nama']);
        $matched_key = null;
        
        foreach ($images as $key => $url) {
            if (strpos($nama, $key) !== false) {
                $matched_key = $key;
                break;
            }
        }
        
        $filename = $matched_key ? $matched_key . '_' . $menu['id'] . '.jpg' : 'default_' . $menu['id'] . '.jpg';
        $filepath = __DIR__ . '/uploads/menus/' . $filename;
        
        // Generate URL
        $imageUrl = getUrlForName($menu['nama']);
        
        if (downloadImage($imageUrl, $filepath)) {
        
            // Update DB
            $db_path = 'uploads/menus/' . $filename;
            $update_stmt = $conn->prepare("UPDATE menus SET image = ? WHERE id = ?");
            $update_stmt->execute([$db_path, $menu['id']]);
            $updated++;
        }
    }

    echo "Successfully downloaded and updated images for $updated menus.\n";

} catch (PDOException $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
?>
