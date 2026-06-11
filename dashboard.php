<?php
// =====================================================
// api/dashboard.php - Statistik & Laporan
// =====================================================
session_start();
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') exit;

require_once '../config/database.php';

if (!isset($_SESSION['user_id'])) {
    jsonResponse(['success' => false, 'message' => 'Silakan login terlebih dahulu'], 401);
}

$db     = getDB();
$action = $_GET['action'] ?? 'summary';

switch ($action) {

    case 'summary':
        $bulanIni = date('Y-m');

        // Total barang
        $total = $db->query("SELECT COUNT(*) as cnt, SUM(stok * harga_satuan) as nilai FROM barang")->fetch();

        // Stok menipis
        $menipis = $db->query("SELECT COUNT(*) as cnt FROM barang WHERE stok <= stok_minimum")->fetch();

        // Barang masuk bulan ini
        $masuk = $db->prepare("SELECT COUNT(*) as trx, COALESCE(SUM(jumlah),0) as qty FROM barang_masuk WHERE DATE_FORMAT(tanggal,'%Y-%m') = ?");
        $masuk->execute([$bulanIni]); $masuk = $masuk->fetch();

        // Barang keluar bulan ini
        $keluar = $db->prepare("SELECT COUNT(*) as trx, COALESCE(SUM(jumlah),0) as qty FROM barang_keluar WHERE DATE_FORMAT(tanggal,'%Y-%m') = ?");
        $keluar->execute([$bulanIni]); $keluar = $keluar->fetch();

        // 5 transaksi terbaru (gabungan masuk & keluar)
        $recent = $db->prepare("
            (SELECT 'Masuk' as tipe, bm.no_terima as nomor, b.nama as barang, bm.jumlah, bm.tanggal
             FROM barang_masuk bm JOIN barang b ON bm.barang_id = b.id
             ORDER BY bm.tanggal DESC LIMIT 5)
            UNION ALL
            (SELECT 'Keluar' as tipe, bk.no_keluar as nomor, b.nama as barang, bk.jumlah, bk.tanggal
             FROM barang_keluar bk JOIN barang b ON bk.barang_id = b.id
             ORDER BY bk.tanggal DESC LIMIT 5)
            ORDER BY tanggal DESC LIMIT 8
        ");
        $recent->execute(); $recent = $recent->fetchAll();

        // Level stok (top 6)
        $stockLevel = $db->query("SELECT nama, stok, satuan FROM barang ORDER BY stok DESC LIMIT 6")->fetchAll();

        jsonResponse([
            'success' => true,
            'total_barang'  => (int)$total['cnt'],
            'nilai_stok'    => (float)$total['nilai'],
            'stok_menipis'  => (int)$menipis['cnt'],
            'masuk_bulan'   => ['trx' => (int)$masuk['trx'], 'qty' => (int)$masuk['qty']],
            'keluar_bulan'  => ['trx' => (int)$keluar['trx'], 'qty' => (int)$keluar['qty']],
            'transaksi_terbaru' => $recent,
            'stock_level'   => $stockLevel,
        ]);
        break;

    case 'laporan':
        $bulan = $_GET['bulan'] ?? date('Y-m');

        $stmt = $db->prepare("
            SELECT b.kategori,
                COALESCE(SUM(CASE WHEN bm.barang_id IS NOT NULL THEN bm.jumlah ELSE 0 END),0) as masuk,
                COALESCE(SUM(CASE WHEN bk.barang_id IS NOT NULL THEN bk.jumlah ELSE 0 END),0) as keluar,
                SUM(b.stok) as sisa_stok,
                SUM(b.stok * b.harga_satuan) as nilai_stok
            FROM barang b
            LEFT JOIN barang_masuk bm ON bm.barang_id = b.id AND DATE_FORMAT(bm.tanggal,'%Y-%m') = ?
            LEFT JOIN barang_keluar bk ON bk.barang_id = b.id AND DATE_FORMAT(bk.tanggal,'%Y-%m') = ?
            GROUP BY b.kategori
            ORDER BY b.kategori
        ");
        $stmt->execute([$bulan, $bulan]);
        jsonResponse(['success' => true, 'data' => $stmt->fetchAll(), 'bulan' => $bulan]);
        break;

    case 'stok_menipis':
        $stmt = $db->query("SELECT * FROM barang WHERE stok <= stok_minimum ORDER BY stok ASC");
        jsonResponse(['success' => true, 'data' => $stmt->fetchAll()]);
        break;
}
