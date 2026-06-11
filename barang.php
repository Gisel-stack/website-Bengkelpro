<?php
// =====================================================
// api/barang.php - CRUD Master Barang / Stok
// =====================================================
session_start();
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') exit;

require_once '../config/database.php';

// Cek session login
if (!isset($_SESSION['user_id'])) {
    jsonResponse(['success' => false, 'message' => 'Silakan login terlebih dahulu'], 401);
}

$method = $_SERVER['REQUEST_METHOD'];
$input  = getInput();
$db     = getDB();

switch ($method) {

    // --------------------------------------------------
    case 'GET':
        $search = $_GET['search'] ?? '';
        $kat    = $_GET['kategori'] ?? '';
        $id     = $_GET['id'] ?? null;

        if ($id) {
            $stmt = $db->prepare("SELECT * FROM barang WHERE id = ?");
            $stmt->execute([$id]);
            $row = $stmt->fetch();
            jsonResponse($row ? ['success' => true, 'data' => $row] : ['success' => false, 'message' => 'Barang tidak ditemukan']);
        }

        $sql    = "SELECT * FROM barang WHERE 1=1";
        $params = [];
        if ($search) { $sql .= " AND (nama LIKE ? OR kode LIKE ?)"; $params[] = "%$search%"; $params[] = "%$search%"; }
        if ($kat)    { $sql .= " AND kategori = ?"; $params[] = $kat; }
        $sql .= " ORDER BY kode ASC";

        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        $rows = $stmt->fetchAll();

        // Hitung summary
        $totalBarang  = count($rows);
        $stokMenipis  = array_filter($rows, fn($b) => $b['stok'] <= $b['stok_minimum']);
        $nilaiTotal   = array_sum(array_map(fn($b) => $b['stok'] * $b['harga_satuan'], $rows));

        jsonResponse([
            'success' => true,
            'data'    => $rows,
            'summary' => ['total_barang' => $totalBarang, 'stok_menipis' => count($stokMenipis), 'nilai_total' => $nilaiTotal]
        ]);
        break;

    // --------------------------------------------------
    case 'POST':
        $nama     = trim($input['nama'] ?? '');
        $kategori = $input['kategori'] ?? '';
        $stok     = (int)($input['stok'] ?? 0);
        $stok_min = (int)($input['stok_minimum'] ?? 5);
        $satuan   = $input['satuan'] ?? 'Pcs';
        $harga    = (int)($input['harga_satuan'] ?? 0);

        if (!$nama || !$kategori) {
            jsonResponse(['success' => false, 'message' => 'Nama dan kategori wajib diisi']);
        }

        // Generate kode otomatis
        $stmt = $db->query("SELECT MAX(CAST(SUBSTRING(kode,4) AS UNSIGNED)) as max_num FROM barang WHERE kode LIKE 'BRG%'");
        $maxNum = $stmt->fetch()['max_num'] ?? 0;
        $kode   = 'BRG' . str_pad($maxNum + 1, 3, '0', STR_PAD_LEFT);

        $stmt = $db->prepare("INSERT INTO barang (kode, nama, kategori, stok, stok_minimum, satuan, harga_satuan) VALUES (?,?,?,?,?,?,?)");
        $stmt->execute([$kode, $nama, $kategori, $stok, $stok_min, $satuan, $harga]);

        jsonResponse(['success' => true, 'message' => 'Barang berhasil ditambahkan', 'id' => $db->lastInsertId(), 'kode' => $kode]);
        break;

    // --------------------------------------------------
    case 'PUT':
        $id       = $input['id'] ?? null;
        $nama     = trim($input['nama'] ?? '');
        $kategori = $input['kategori'] ?? '';
        $stok     = (int)($input['stok'] ?? 0);
        $stok_min = (int)($input['stok_minimum'] ?? 5);
        $satuan   = $input['satuan'] ?? 'Pcs';
        $harga    = (int)($input['harga_satuan'] ?? 0);

        if (!$id || !$nama || !$kategori) {
            jsonResponse(['success' => false, 'message' => 'Data tidak lengkap']);
        }

        $stmt = $db->prepare("UPDATE barang SET nama=?, kategori=?, stok=?, stok_minimum=?, satuan=?, harga_satuan=? WHERE id=?");
        $stmt->execute([$nama, $kategori, $stok, $stok_min, $satuan, $harga, $id]);

        jsonResponse(['success' => true, 'message' => 'Barang berhasil diperbarui']);
        break;

    // --------------------------------------------------
    case 'DELETE':
        $id = $_GET['id'] ?? $input['id'] ?? null;
        if (!$id) jsonResponse(['success' => false, 'message' => 'ID tidak ditemukan']);

        // Cek apakah ada transaksi yang mereferensikan barang ini
        $stmt = $db->prepare("SELECT COUNT(*) as cnt FROM barang_masuk WHERE barang_id = ?");
        $stmt->execute([$id]);
        if ($stmt->fetch()['cnt'] > 0) {
            jsonResponse(['success' => false, 'message' => 'Barang tidak bisa dihapus karena memiliki riwayat transaksi']);
        }

        $stmt = $db->prepare("DELETE FROM barang WHERE id = ?");
        $stmt->execute([$id]);

        jsonResponse(['success' => true, 'message' => 'Barang berhasil dihapus']);
        break;
}
