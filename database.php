<?php
// =====================================================
// config/database.php - Koneksi Database
// =====================================================

define('DB_HOST', 'localhost');
define('DB_USER', 'root');       // username MySQL XAMPP default
define('DB_PASS', '');           // password MySQL XAMPP default (kosong)
define('DB_NAME', 'bengkelpro');
define('DB_CHARSET', 'utf8mb4');

function getDB() {
    static $pdo = null;
    if ($pdo === null) {
        $dsn = "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=" . DB_CHARSET;
        $options = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ];
        try {
            $pdo = new PDO($dsn, DB_USER, DB_PASS, $options);
        } catch (PDOException $e) {
            http_response_code(500);
            die(json_encode(['success' => false, 'message' => 'Koneksi database gagal: ' . $e->getMessage()]));
        }
    }
    return $pdo;
}

// Helper: kirim response JSON
function jsonResponse($data, $code = 200) {
    http_response_code($code);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}

// Helper: ambil input JSON dari request body
function getInput() {
    $input = json_decode(file_get_contents('php://input'), true);
    return $input ?? $_POST;
}
