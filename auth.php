<?php
// ==========================================
// AUTH FINAL - SINGLE ADMIN ONLY
// ==========================================
session_start();
header('Content-Type: application/json');

// koneksi database
require_once '../config/database.php';

// ambil input (support POST biasa & JSON)
$input = json_decode(file_get_contents("php://input"), true);
$action = $_POST['action'] ?? $input['action'] ?? $_GET['action'] ?? '';

// koneksi DB
$db = getDB();

// ================= LOGIN =================
if ($action === 'login') {

    $email    = trim($_POST['email'] ?? $input['email'] ?? '');
    $password = $_POST['password'] ?? $input['password'] ?? '';

    if (!$email || !$password) {
        echo json_encode([
            "success" => false,
            "message" => "Email dan password wajib diisi"
        ]);
        exit;
    }

    // ambil hanya 1 admin
    $stmt = $db->prepare("SELECT * FROM users WHERE email = ? LIMIT 1");
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    // cek user + password
    if (!$user || !password_verify($password, $user['password'])) {
        echo json_encode([
            "success" => false,
            "message" => "Email atau password salah"
        ]);
        exit;
    }

    // 🔒 OPTIONAL: pastikan hanya admin
    if (isset($user['role']) && $user['role'] !== 'admin') {
        echo json_encode([
            "success" => false,
            "message" => "Akses ditolak"
        ]);
        exit;
    }

    // simpan session
    $_SESSION['user_id']    = $user['id'];
    $_SESSION['user_nama']  = $user['nama'];
    $_SESSION['user_email'] = $user['email'];

    echo json_encode([
        "success" => true,
        "message" => "Login berhasil",
        "user" => [
            "id"    => $user['id'],
            "nama"  => $user['nama'],
            "email" => $user['email']
        ]
    ]);
    exit;
}

// ================= LOGOUT =================
if ($action === 'logout') {
    session_destroy();
    echo json_encode([
        "success" => true,
        "message" => "Logout berhasil"
    ]);
    exit;
}

// ================= CHECK SESSION =================
if ($action === 'check') {
    if (isset($_SESSION['user_id'])) {
        echo json_encode([
            "success" => true,
            "logged_in" => true,
            "user" => [
                "id"    => $_SESSION['user_id'],
                "nama"  => $_SESSION['user_nama'],
                "email" => $_SESSION['user_email']
            ]
        ]);
    } else {
        echo json_encode([
            "success" => true,
            "logged_in" => false
        ]);
    }
    exit;
}

// ================= DEFAULT =================
echo json_encode([
    "success" => false,
    "message" => "Action tidak dikenal"
]);