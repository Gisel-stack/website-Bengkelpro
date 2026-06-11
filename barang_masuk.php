<?php
// =====================================================
// api/barang_masuk.php - Transaksi Barang Masuk
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
        $bulan = $_GET['bulan'] ?? '';
        $search = $_GET['search'] ?? '';

        $sql = "SELECT bm.*, b.nama as nama_barang, b.kode, b.satuan
                FROM barang_masuk bm
                JOIN barang b ON bm.barang_id = b.id
                WHERE 1=1";
        $params = [];

        if ($bulan) { 
            $sql .= " AND DATE_FORMAT(bm.tanggal,'%Y-%m') = ?"; 
            $params[] = $bulan; 
        }
        if ($search) { 
            $sql .= " AND (b.nama LIKE ? OR bm.supplier LIKE ? OR bm.no_terima LIKE ?)";
            $params[] = "%$search%"; 
            $params[] = "%$search%"; 
            $params[] = "%$search%"; 
        }

        $sql .= " ORDER BY bm.tanggal DESC, bm.id DESC";

        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        $rows = $stmt->fetchAll();

        $totalQty   = array_sum(array_column($rows, 'jumlah'));
        $totalNilai = array_sum(array_map(fn($r) => $r['jumlah'] * ($r['harga_beli'] ?? 0), $rows));

        jsonResponse(['success' => true, 'data' => $rows,
            'summary' => [
                'total_transaksi' => count($rows), 
                'total_qty' => $totalQty, 
                'total_nilai' => $totalNilai
            ]]);
        break;

    case 'POST':
        $barang_id     = (int)($input['barang_id'] ?? 0);
        $supplier      = trim($input['supplier'] ?? '');
        $jumlah        = (int)($input['jumlah'] ?? 0);
        $harga_beli    = (int)($input['harga_beli'] ?? 0);
        $harga_satuan  = (int)($input['harga_satuan'] ?? 0);
        $tanggal       = $input['tanggal'] ?? date('Y-m-d');
        $keterangan    = $input['keterangan'] ?? '';
        $update_harga_beli = isset($input['update_harga_beli']) && 
                             ($input['update_harga_beli'] === true || 
                              $input['update_harga_beli'] === 'true' || 
                              $input['update_harga_beli'] == 1);

        if (!$barang_id || !$supplier || $jumlah <= 0) {
            jsonResponse(['success' => false, 'message' => 'Data tidak lengkap atau jumlah tidak valid']);
            exit;
        }

        // Cek barang ada
        $stmt = $db->prepare("SELECT id FROM barang WHERE id = ?");
        $stmt->execute([$barang_id]);
        if (!$stmt->fetch()) {
            jsonResponse(['success' => false, 'message' => 'Barang tidak ditemukan']);
            exit;
        }

        $db->beginTransaction();
        try {
            // ================== PERBAIKAN UTAMA ==================
            // Generate nomor TRM-YYMMDDxxx (tidak akan duplikat)
            $hari = date('ymd');
            $prefix = "TRM-{$hari}";

            $stmt = $db->prepare("SELECT no_terima FROM barang_masuk 
                                  WHERE no_terima LIKE ? 
                                  ORDER BY no_terima DESC LIMIT 1");
            $stmt->execute(["$prefix%"]);
            $last = $stmt->fetch();

            if ($last) {
                $lastSeq = (int)substr($last['no_terima'], -3);
                $newSeq  = $lastSeq + 1;
            } else {
                $newSeq = 1;
            }

            $noTrm = $prefix . str_pad($newSeq, 3, '0', STR_PAD_LEFT);
            // ====================================================

            $stmt = $db->prepare("INSERT INTO barang_masuk 
                (no_terima, barang_id, supplier, jumlah, harga_beli, harga_satuan, tanggal, keterangan, created_by) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");

            $stmt->execute([
                $noTrm, 
                $barang_id, 
                $supplier, 
                $jumlah, 
                $harga_beli, 
                $harga_satuan, 
                $tanggal, 
                $keterangan, 
                $_SESSION['user_id']
            ]);

            // Tambah stok barang
            $stmt = $db->prepare("UPDATE barang SET stok = stok + ? WHERE id = ?");
            $stmt->execute([$jumlah, $barang_id]);

            // Update harga beli terbaru
            if ($update_harga_beli && $harga_beli > 0) {
                $stmt = $db->prepare("UPDATE barang SET harga_beli = ? WHERE id = ?");
                $stmt->execute([$harga_beli, $barang_id]);
            }

            $db->commit();

            jsonResponse([
                'success' => true, 
                'message' => 'Barang masuk berhasil dicatat', 
                'no_terima' => $noTrm
            ]);

        } catch (Exception $e) {
            $db->rollBack();
            jsonResponse(['success' => false, 'message' => 'Gagal menyimpan: ' . $e->getMessage()], 500);
        }
        break;

    case 'DELETE':
        $id = 0;
        if (isset($input['id'])) $id = (int)$input['id'];
        elseif (isset($_GET['id'])) $id = (int)$_GET['id'];

        if ($id <= 0) {
            jsonResponse(['success' => false, 'message' => 'ID transaksi tidak valid'], 400);
            exit;
        }

        $db->beginTransaction();
        try {
            $stmt = $db->prepare("SELECT barang_id, jumlah FROM barang_masuk WHERE id = ?");
            $stmt->execute([$id]);
            $transaksi = $stmt->fetch();

            if (!$transaksi) {
                jsonResponse(['success' => false, 'message' => 'Transaksi tidak ditemukan'], 404);
                exit;
            }

            // Kurangi stok kembali
            $stmt = $db->prepare("UPDATE barang SET stok = stok - ? WHERE id = ?");
            $stmt->execute([$transaksi['jumlah'], $transaksi['barang_id']]);

            $stmt = $db->prepare("DELETE FROM barang_masuk WHERE id = ?");
            $stmt->execute([$id]);

            $db->commit();

            jsonResponse([
                'success' => true, 
                'message' => 'Transaksi barang masuk berhasil dihapus. Stok telah dikurangi kembali.'
            ]);

        } catch (Exception $e) {
            $db->rollBack();
            jsonResponse(['success' => false, 'message' => 'Gagal menghapus transaksi: ' . $e->getMessage()], 500);
        }
        break;

    default:
        jsonResponse(['success' => false, 'message' => 'Method tidak didukung'], 405);
        break;
}