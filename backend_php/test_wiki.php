<?php
$options = [
    'http' => [
        'method' => 'GET',
        'header' => "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36\r\n"
    ]
];
$context = stream_context_create($options);
$res = file_get_contents("https://upload.wikimedia.org/wikipedia/commons/4/40/Ayam_goreng_kalasan.jpg", false, $context);
if ($res) {
    echo "SUCCESS: " . strlen($res) . " bytes";
} else {
    echo "FAILED";
}
