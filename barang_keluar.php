<?php
// =====================================================
// api/barang_keluar.php - Transaksi Barang Keluar
// =====================================================
session_start();
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') exit;

require_once '../config/database.php';

if (!isset($_SESSION['user_id'])) {
    jsonResponse(['success' => false, 'message' => 'Silakan login terlebih dahulu'], 401);
}

$method = $_SERVER['REQUEST_METHOD'];
$input  = getInput();
$db     = getDB();

switch ($method) {

    case 'GET':
        $bulan  = $_GET['bulan'] ?? '';
        $search = $_GET['search'] ?? '';

        $sql = "SELECT bk.*, b.nama as nama_barang, b.kode, b.satuan, b.harga_satuan as harga_barang
                FROM barang_keluar bk
                JOIN barang b ON bk.barang_id = b.id
                WHERE 1=1";
        $params = [];

        if ($bulan)  { $sql .= " AND DATE_FORMAT(bk.tanggal,'%Y-%m') = ?"; $params[] = $bulan; }
        if ($search) { $sql .= " AND (b.nama LIKE ? OR bk.mekanik LIKE ? OR bk.no_keluar LIKE ? OR bk.no_polisi LIKE ?)";
            $params[] = "%$search%"; $params[] = "%$search%"; $params[] = "%$search%"; $params[] = "%$search%"; }

        $sql .= " ORDER BY bk.tanggal DESC, bk.id DESC";

        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        $rows = $stmt->fetchAll();

        $totalQty = array_sum(array_column($rows, 'jumlah'));

        jsonResponse(['success' => true, 'data' => $rows,
            'summary' => ['total_transaksi' => count($rows), 'total_qty' => $totalQty]]);
        break;

    case 'POST':
        $barang_id  = (int)($input['barang_id'] ?? 0);
        $mekanik    = trim($input['mekanik'] ?? '');
        $no_polisi  = trim($input['no_polisi'] ?? '');
        $jumlah     = (int)($input['jumlah'] ?? 0);
        $tanggal    = $input['tanggal'] ?? date('Y-m-d');
        $keterangan = $input['keterangan'] ?? '';

        if (!$barang_id || !$mekanik || $jumlah <= 0) {
            jsonResponse(['success' => false, 'message' => 'Data tidak lengkap atau jumlah tidak valid']);
            exit;
        }

        // Ambil harga_satuan otomatis dari tabel barang
        $stmt = $db->prepare("SELECT stok, nama, harga_satuan FROM barang WHERE id = ?");
        $stmt->execute([$barang_id]);
        $barang = $stmt->fetch();

        if (!$barang) {
            jsonResponse(['success' => false, 'message' => 'Barang tidak ditemukan']);
            exit;
        }
        if ($barang['stok'] < $jumlah) {
            jsonResponse(['success' => false, 'message' => "Stok {$barang['nama']} tidak cukup. Stok tersedia: {$barang['stok']}"]);
            exit;
        }

        $harga_satuan = (int)$barang['harga_satuan'];

        // Generate nomor keluar
        $stmt = $db->query("SELECT COALESCE(MAX(id), 0) as max_id FROM barang_keluar");
        $max  = (int)$stmt->fetch()['max_id'];
        $noKlr = 'KLR-' . str_pad($max + 1, 3, '0', STR_PAD_LEFT);

        $db->beginTransaction();
        try {
            $stmt = $db->prepare("INSERT INTO barang_keluar 
                (no_keluar, barang_id, mekanik, no_polisi, jumlah, harga_satuan, tanggal, keterangan, created_by) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
            
            $stmt->execute([
                $noKlr, 
                $barang_id, 
                $mekanik, 
                $no_polisi, 
                $jumlah, 
                $harga_satuan, 
                $tanggal, 
                $keterangan, 
                $_SESSION['user_id']
            ]);

            // Kurangi stok
            $stmt = $db->prepare("UPDATE barang SET stok = stok - ? WHERE id = ?");
            $stmt->execute([$jumlah, $barang_id]);

            $db->commit();
            jsonResponse([
                'success' => true, 
                'message' => 'Barang keluar berhasil dicatat', 
                'no_keluar' => $noKlr
            ]);
        } catch (Exception $e) {
            $db->rollBack();
            jsonResponse(['success' => false, 'message' => 'Gagal menyimpan: ' . $e->getMessage()], 500);
        }
        break;

    // ==================== DELETE BARANG KELUAR ====================
    case 'DELETE':
        // Ambil ID dengan berbagai cara (lebih robust)
        $id = 0;
        $rawInput = file_get_contents('php://input');
        $jsonData = json_decode($rawInput, true);

        if (isset($jsonData['id']) && $jsonData['id'] > 0) {
            $id = (int)$jsonData['id'];
        } elseif (isset($input['id']) && $input['id'] > 0) {
            $id = (int)$input['id'];
        } elseif (isset($_GET['id']) && $_GET['id'] > 0) {
            $id = (int)$_GET['id'];
        }

        if ($id <= 0) {
            jsonResponse(['success' => false, 'message' => 'ID transaksi tidak valid - ID = ' . $id], 400);
            exit;
        }

        $db->beginTransaction();
        try {
            // Ambil data transaksi
            $stmt = $db->prepare("SELECT barang_id, jumlah FROM barang_keluar WHERE id = ?");
            $stmt->execute([$id]);
            $transaksi = $stmt->fetch();

            if (!$transaksi) {
                jsonResponse(['success' => false, 'message' => 'Transaksi tidak ditemukan'], 404);
                exit;
            }

            // Kembalikan stok ke tabel barang
            $stmt = $db->prepare("UPDATE barang SET stok = stok + ? WHERE id = ?");
            $stmt->execute([$transaksi['jumlah'], $transaksi['barang_id']]);

            // Hapus transaksi barang keluar
            $stmt = $db->prepare("DELETE FROM barang_keluar WHERE id = ?");
            $stmt->execute([$id]);

            $db->commit();

            jsonResponse([
                'success' => true, 
                'message' => 'Transaksi barang keluar berhasil dihapus. Stok telah dikembalikan.'
            ]);

        } catch (Exception $e) {
            $db->rollBack();
            jsonResponse(['success' => false, 'message' => 'Gagal menghapus transaksi: ' . $e->getMessage()], 500);
        }
        break;
    // ============================================================
}