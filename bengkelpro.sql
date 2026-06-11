-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 11 Jun 2026 pada 06.47
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bengkelpro`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `barang`
--

CREATE TABLE `barang` (
  `id` int(11) NOT NULL,
  `kode` varchar(20) NOT NULL,
  `nama` varchar(150) NOT NULL,
  `kategori` enum('Oli & Pelumas','Filter','Ban','Busi','Aki','CDI','Kopling','Karburator','Kelistrikan','Kabel','Rem','Kampas','Mesin','Injektor','Lainnya') NOT NULL DEFAULT 'Lainnya',
  `stok` int(11) NOT NULL DEFAULT 0,
  `stok_minimum` int(11) NOT NULL DEFAULT 5,
  `satuan` enum('Liter','Pcs','Set','Pasang','Unit') DEFAULT 'Pcs',
  `harga_satuan` decimal(12,0) NOT NULL DEFAULT 0,
  `harga_beli` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `barang`
--

INSERT INTO `barang` (`id`, `kode`, `nama`, `kategori`, `stok`, `stok_minimum`, `satuan`, `harga_satuan`, `harga_beli`, `created_at`, `updated_at`) VALUES
(1, 'BRG001', 'Oli Mesin 10W40', 'Oli & Pelumas', 21, 5, 'Liter', 40000, 40000, '2026-04-20 11:33:58', '2026-06-04 07:27:35'),
(2, 'BRG002', 'Filter Oli Honda', 'Filter', 20, 4, 'Pcs', 25000, 0, '2026-04-20 11:33:58', '2026-06-01 03:16:06'),
(3, 'BRG003', 'Ban Luar FDR 80/90', 'Ban', 4, 5, 'Pcs', 180000, 160000, '2026-04-20 11:33:58', '2026-06-04 06:06:37'),
(4, 'BRG004', 'Busi NGK CR6HSA', 'Busi', 11, 5, 'Pcs', 35000, 0, '2026-04-20 11:33:58', '2026-06-03 03:54:31'),
(5, 'BRG005', 'Aki GS Yuasa 5Ah', 'Aki', 43, 5, 'Unit', 280000, 0, '2026-04-20 11:33:58', '2026-06-03 04:33:13'),
(6, 'BRG006', 'Kampas Rem Belakang', 'Rem', 1, 5, 'Set', 35000, 25000, '2026-04-20 11:33:58', '2026-04-29 08:44:49'),
(7, 'BRG007', 'Oli Gardan Matic', 'Oli & Pelumas', 19, 5, 'Liter', 30000, 0, '2026-04-20 11:33:58', '2026-06-03 03:15:35'),
(8, 'BRG008', 'Filter Udara Yamaha', 'Filter', 20, 5, 'Pcs', 45000, 0, '2026-04-20 11:33:58', '2026-04-20 12:53:17'),
(9, 'BRG009', 'Ban Dalam 80/90', 'Ban', 12, 5, 'Pcs', 55000, 0, '2026-04-20 11:33:58', '2026-04-20 11:33:58'),
(10, 'BRG010', 'Busi Iridium NGK', 'Busi', 10, 5, 'Pcs', 85000, 20000, '2026-04-20 11:33:58', '2026-06-03 04:34:57'),
(11, 'BRG011', 'Aki MF 7Ah', 'Aki', 6, 3, 'Unit', 380000, 0, '2026-04-20 11:33:58', '2026-05-05 20:15:23'),
(12, 'BRG012', 'Kampas Rem Depan', 'Rem', 10, 5, 'Set', 42000, 0, '2026-04-20 11:33:58', '2026-05-19 05:39:00'),
(363, 'CDI-001', 'CDI Honda', 'CDI', 10, 2, 'Pcs', 175000, 0, '2026-04-24 01:50:55', '2026-05-05 16:46:48'),
(364, 'CDI-002', 'CDI Suzuki', 'CDI', 10, 5, 'Pcs', 175000, 0, '2026-04-24 01:50:55', '2026-04-24 12:45:21'),
(365, 'CDI-003', 'CDI Yamaha', 'CDI', 10, 5, 'Pcs', 175000, 0, '2026-04-24 01:50:55', '2026-04-24 12:46:03'),
(366, 'ELS-001', 'Coil Honda', 'Kelistrikan', 10, 5, 'Pcs', 85000, 0, '2026-04-24 01:50:55', '2026-04-24 12:47:58'),
(367, 'ELS-002', 'Coil Suzuki', 'Kelistrikan', 15, 5, 'Pcs', 85000, 0, '2026-04-24 01:50:55', '2026-04-24 12:48:44'),
(368, 'ELS-003', 'Coil Yamaha', 'Kelistrikan', 15, 5, 'Pcs', 85000, 0, '2026-04-24 01:50:55', '2026-04-24 12:49:32'),
(369, 'ELS-004', 'ECU Honda', 'Kelistrikan', 10, 5, 'Pcs', 650000, 0, '2026-04-24 01:50:55', '2026-04-24 12:49:56'),
(370, 'ELS-005', 'ECU Suzuki', 'Kelistrikan', 10, 5, 'Pcs', 650000, 0, '2026-04-24 01:50:55', '2026-04-24 12:50:16'),
(371, 'ELS-006', 'ECU Yamaha', 'Kelistrikan', 10, 5, 'Pcs', 650000, 0, '2026-04-24 01:50:55', '2026-04-24 12:51:05'),
(372, 'ELS-007', 'Dinamo Stater Honda Gigi', 'Kelistrikan', 11, 5, 'Pcs', 350000, 0, '2026-04-24 01:50:55', '2026-04-24 12:51:39'),
(373, 'ELS-008', 'Dinamo Stater Honda Matic', 'Kelistrikan', 11, 5, 'Pcs', 375000, 0, '2026-04-24 01:50:55', '2026-04-24 12:51:58'),
(374, 'ELS-009', 'Dinamo Stater Kawasaki', 'Kelistrikan', 11, 5, 'Pcs', 400000, 0, '2026-04-24 01:50:55', '2026-04-24 12:52:29'),
(375, 'ELS-010', 'Dinamo Stater Suzuki Gigi', 'Kelistrikan', 11, 5, 'Pcs', 350000, 0, '2026-04-24 01:50:55', '2026-04-24 12:52:52'),
(376, 'ELS-011', 'Dinamo Stater Yamaha Gigi', 'Kelistrikan', 11, 5, 'Pcs', 350000, 0, '2026-04-24 01:50:55', '2026-04-24 12:53:20'),
(377, 'ELS-012', 'Dinamo Stater Yamaha Matic', 'Kelistrikan', 11, 5, 'Pcs', 375000, 0, '2026-04-24 01:50:55', '2026-04-24 12:54:13'),
(378, 'KBL-001', 'Kabel Gas Honda Gigi', 'Kabel', 15, 5, 'Pcs', 55000, 0, '2026-04-24 01:50:55', '2026-04-24 12:55:59'),
(379, 'KBL-002', 'Kabel Gas Honda Matic', 'Kabel', 13, 5, 'Pcs', 60000, 0, '2026-04-24 01:50:55', '2026-04-24 12:56:36'),
(380, 'KBL-003', 'Kabel Gas Kawasaki', 'Kabel', 14, 5, 'Pcs', 60000, 0, '2026-04-24 01:50:55', '2026-04-24 12:56:57'),
(381, 'KBL-004', 'Kabel Gas Suzuki', 'Kabel', 14, 5, 'Pcs', 55000, 0, '2026-04-24 01:50:55', '2026-04-24 12:57:35'),
(382, 'KBL-005', 'Kabel Gas Yamaha Gigi', 'Kabel', 12, 5, 'Pcs', 55000, 0, '2026-04-24 01:50:55', '2026-04-24 12:57:55'),
(383, 'KBL-006', 'Kabel Gas Yamaha Matic', 'Kabel', 16, 5, 'Pcs', 60000, 0, '2026-04-24 01:50:55', '2026-04-24 12:58:13'),
(384, 'KBL-007', 'Kabel Rem Honda Matic', 'Kabel', 18, 5, 'Pcs', 30000, 0, '2026-04-24 01:50:55', '2026-05-17 07:53:58'),
(385, 'KBL-008', 'Kabel Rem Yamaha Matic', 'Kabel', 15, 5, 'Pcs', 60000, 0, '2026-04-24 01:50:55', '2026-04-24 12:58:48'),
(386, 'KBL-009', 'Kabel RPM', 'Kabel', 15, 5, 'Pcs', 45000, 0, '2026-04-24 01:50:55', '2026-04-24 12:59:03'),
(387, 'KBL-010', 'Kabel Speedometer Honda Gigi', 'Kabel', 13, 5, 'Pcs', 50000, 0, '2026-04-24 01:50:55', '2026-05-31 19:33:41'),
(388, 'KBL-011', 'Kabel Speedometer Honda Matic', 'Kabel', 7, 5, 'Pcs', 50000, 0, '2026-04-24 01:50:55', '2026-04-24 13:00:11'),
(389, 'KBL-012', 'Kabel Speedometer Yamaha Gigi', 'Kabel', 7, 5, 'Pcs', 50000, 0, '2026-04-24 01:50:55', '2026-04-24 13:00:44'),
(390, 'KPL-001', 'Kabel Kopling Honda', 'Kopling', 10, 5, 'Pcs', 35000, 0, '2026-04-24 01:50:55', '2026-04-24 13:03:07'),
(391, 'KPL-002', 'Kabel Kopling Yamaha', 'Kabel', 14, 5, 'Pcs', 45000, 0, '2026-04-24 01:50:55', '2026-04-24 13:04:09'),
(392, 'KPL-003', 'Paking Kopling Honda', 'Kopling', 10, 5, 'Pcs', 35000, 0, '2026-04-24 01:50:55', '2026-04-24 13:04:42'),
(393, 'KPL-004', 'Paking Kopling Suzuki & Kawasaki', 'Kopling', 11, 5, 'Pcs', 40000, 0, '2026-04-24 01:50:55', '2026-04-24 13:05:19'),
(394, 'KPL-005', 'Furing Assy Honda Bebek/Kopling', 'Kopling', 10, 5, 'Pcs', 115000, 0, '2026-04-24 01:50:55', '2026-05-20 06:31:28'),
(395, 'KPL-006', 'Furing Assy Honda Metic', 'Kopling', 6, 5, 'Set', 115000, 0, '2026-04-24 01:50:55', '2026-04-25 10:30:36'),
(396, 'KPL-007', 'Furing Assy Suzuki Bebek/Kopling', 'Kopling', 4, 1, 'Set', 115000, 0, '2026-04-24 01:50:55', '2026-04-25 10:31:44'),
(397, 'KPL-008', 'Furing Assy Suzuki Metic', 'Kopling', 4, 1, 'Set', 115000, 0, '2026-04-24 01:50:55', '2026-04-25 10:32:26'),
(398, 'KPL-009', 'Furing Assy Yamaha Bebek/Kopling', 'Kopling', 5, 1, 'Set', 115000, 0, '2026-04-24 01:50:55', '2026-04-25 10:32:48'),
(399, 'KPL-010', 'Furing Assy Yamaha Metic', 'Kopling', 3, 2, 'Set', 115000, 0, '2026-04-24 01:50:55', '2026-04-25 10:50:09'),
(400, 'REM-001', 'Kaliper Belakang Honda', 'Rem', 4, 1, 'Pcs', 225000, 0, '2026-04-24 01:50:55', '2026-04-25 10:43:16'),
(401, 'REM-002', 'Kaliper Belakang Kawasaki', 'Rem', 4, 1, 'Pcs', 250000, 0, '2026-04-24 01:50:55', '2026-04-25 10:42:57'),
(402, 'REM-003', 'Kaliper Belakang Suzuki', 'Rem', 4, 1, 'Pcs', 225000, 0, '2026-04-24 01:50:55', '2026-04-25 10:42:27'),
(403, 'REM-004', 'Kaliper Belakang Yamaha', 'Rem', 3, 1, 'Pcs', 225000, 0, '2026-04-24 01:50:55', '2026-04-25 10:41:52'),
(404, 'REM-005', 'Kaliper Depan Honda', 'Rem', 4, 1, 'Pcs', 275000, 0, '2026-04-24 01:50:55', '2026-04-25 10:39:48'),
(405, 'REM-006', 'Kaliper Depan Kawasaki', 'Rem', 3, 1, 'Pcs', 300000, 0, '2026-04-24 01:50:55', '2026-04-25 10:38:51'),
(406, 'REM-007', 'Kaliper Depan Suzuki', 'Rem', 3, 1, 'Pcs', 275000, 0, '2026-04-24 01:50:55', '2026-04-25 10:38:18'),
(407, 'REM-008', 'Kaliper Depan Yamaha', 'Rem', 3, 1, 'Pcs', 275000, 0, '2026-04-24 01:50:55', '2026-04-25 10:37:08'),
(408, 'REM-009', 'Master Rem Atas Honda', 'Rem', 4, 5, 'Pcs', 145000, 0, '2026-04-24 01:50:55', '2026-04-25 10:36:29'),
(409, 'REM-010', 'Master Rem Atas Suzuki', 'Rem', 3, 1, 'Pcs', 145000, 0, '2026-04-24 01:50:55', '2026-04-25 10:36:15'),
(410, 'REM-011', 'Master Rem Atas Yamaha', 'Rem', 10, 1, 'Pcs', 145000, 0, '2026-04-24 01:50:55', '2026-06-01 03:18:44'),
(411, 'REM-012', 'Master Rem Bawah Honda', 'Rem', 5, 1, 'Pcs', 135000, 0, '2026-04-24 01:50:55', '2026-04-25 10:35:13'),
(412, 'REM-013', 'Master Rem Bawah Kawasaki', 'Rem', 9, 1, 'Pcs', 135000, 0, '2026-04-24 01:50:55', '2026-06-03 03:14:38'),
(415, 'KMP-001', 'Kampas Otomat Assy Honda', 'Kampas', 6, 5, 'Set', 125000, 0, '2026-04-24 01:50:55', '2026-04-24 13:01:15'),
(416, 'KMP-002', 'Kampas Otomat Assy Suzuki', 'Kampas', 12, 5, 'Set', 125000, 0, '2026-04-24 01:50:55', '2026-05-24 07:02:59'),
(417, 'KMP-003', 'Kampas Otomat Assy Yamaha', 'Kampas', 7, 5, 'Set', 125000, 0, '2026-04-24 01:50:55', '2026-04-24 13:02:25'),
(418, 'KRB-001', 'Karburator Assy Honda', 'Karburator', 1, 2, 'Pcs', 275000, 0, '2026-04-24 01:50:55', '2026-04-25 10:50:38'),
(419, 'KRB-002', 'Karburator Assy Suzuki', 'Karburator', 1, 5, 'Pcs', 275000, 0, '2026-04-24 01:50:55', '2026-04-25 10:51:09'),
(420, 'KRB-003', 'Karburator Assy Yamaha', 'Karburator', 1, 1, 'Pcs', 275000, 0, '2026-04-24 01:50:55', '2026-04-25 10:51:32'),
(421, 'INJ-001', 'Injektor Honda', 'Injektor', 8, 5, 'Pcs', 225000, 0, '2026-04-24 01:50:55', '2026-04-24 12:54:53'),
(422, 'INJ-002', 'Injektor Suzuki', 'Injektor', 8, 5, 'Pcs', 225000, 0, '2026-04-24 01:50:55', '2026-04-24 12:55:16'),
(423, 'INJ-003', 'Injektor Yamaha', 'Injektor', 4, 5, 'Pcs', 225000, 0, '2026-04-24 01:50:55', '2026-04-29 07:21:01'),
(424, 'MSN-001', 'Cylinder Head Assy', 'Mesin', 1, 1, 'Pcs', 1250000, 0, '2026-04-24 01:50:55', '2026-04-25 11:03:57'),
(425, 'MSN-002', 'Noken As Honda', 'Mesin', 1, 1, 'Pcs', 275000, 0, '2026-04-24 01:50:55', '2026-04-25 11:03:31'),
(426, 'MSN-003', 'Noken As Kawasaki', 'Mesin', 1, 1, 'Pcs', 300000, 0, '2026-04-24 01:50:55', '2026-04-25 11:02:56'),
(427, 'MSN-004', 'Noken As Suzuki', 'Mesin', 2, 1, 'Pcs', 275000, 0, '2026-04-24 01:50:55', '2026-04-25 11:02:23'),
(428, 'MSN-005', 'Noken As Yamaha', 'Mesin', 2, 1, 'Pcs', 275000, 0, '2026-04-24 01:50:55', '2026-04-25 11:00:59'),
(429, 'MSN-006', 'Kipas Rumah Roller Honda', 'Mesin', 6, 1, 'Pcs', 85000, 0, '2026-04-24 01:50:55', '2026-05-18 04:13:19'),
(430, 'MSN-007', 'Kipas Rumah Roller Suzuki', 'Mesin', 2, 1, 'Pcs', 85000, 0, '2026-04-24 01:50:55', '2026-04-25 10:56:05'),
(431, 'MSN-008', 'Kipas Rumah Roller Yamaha', 'Mesin', 3, 1, 'Pcs', 85000, 0, '2026-04-24 01:50:55', '2026-04-25 10:49:38'),
(432, 'MSN-009', 'Kiprok Honda', 'Mesin', 3, 1, 'Pcs', 175000, 0, '2026-04-24 01:50:55', '2026-04-25 10:49:07'),
(433, 'MSN-010', 'Kiprok Suzuki', 'Mesin', 3, 1, 'Pcs', 175000, 0, '2026-04-24 01:50:55', '2026-04-25 10:48:25'),
(434, 'MSN-011', 'Kiprok Yamaha', 'Mesin', 4, 1, 'Pcs', 175000, 0, '2026-04-24 01:50:55', '2026-04-25 10:44:39'),
(435, 'MSN-012', 'Kiprox Suzuki', 'Mesin', 3, 1, 'Pcs', 200000, 0, '2026-04-24 01:50:55', '2026-04-25 10:43:56'),
(436, 'LNY-001', 'Kunci Kontak Honda Gigi', 'Lainnya', 1, 1, 'Pcs', 150000, 0, '2026-04-24 01:50:55', '2026-04-25 10:52:39'),
(437, 'LNY-002', 'Kunci Kontak Honda Matic', 'Lainnya', 1, 1, 'Pcs', 155000, 0, '2026-04-24 01:50:55', '2026-04-25 10:53:20'),
(438, 'LNY-003', 'Kunci Kontak Kawasaki', 'Lainnya', 1, 1, 'Pcs', 155000, 0, '2026-04-24 01:50:55', '2026-04-25 10:53:38'),
(439, 'LNY-004', 'Kunci Kontak Yamaha Gigi', 'Lainnya', 2, 1, 'Pcs', 150000, 0, '2026-04-24 01:50:55', '2026-04-25 10:57:42'),
(440, 'LNY-005', 'Kunci Kontak Yamaha Matic', 'Lainnya', 1, 3, 'Pcs', 150000, 0, '2026-04-24 01:50:55', '2026-04-25 11:12:44'),
(441, 'LNY-006', 'One Way Honda', 'Lainnya', 4, 2, 'Pcs', 125000, 0, '2026-04-24 01:50:55', '2026-04-25 11:13:22'),
(442, 'LNY-007', 'One Way Kawasaki', 'Lainnya', 2, 1, 'Pcs', 125000, 0, '2026-04-24 01:50:55', '2026-04-25 11:12:02'),
(443, 'LNY-008', 'One Way Suzuki', 'Lainnya', 1, 2, 'Pcs', 125000, 0, '2026-04-24 01:50:55', '2026-04-25 11:11:30'),
(444, 'LNY-009', 'One Way Yamaha', 'Lainnya', 3, 1, 'Pcs', 125000, 0, '2026-04-24 01:50:55', '2026-04-25 11:11:12'),
(445, 'LNY-010', 'Membran Bensin Honda', 'Lainnya', 10, 3, 'Pcs', 35000, 0, '2026-04-24 01:50:55', '2026-04-25 11:09:20'),
(446, 'LNY-011', 'Membran Bensin Kawasaki', 'Lainnya', 7, 3, 'Pcs', 35000, 0, '2026-04-24 01:50:55', '2026-04-25 11:05:47'),
(447, 'LNY-012', 'Membran Bensin Suzuki', 'Lainnya', 8, 3, 'Pcs', 35000, 0, '2026-04-24 01:50:55', '2026-04-25 11:05:30'),
(448, 'LNY-013', 'Membran Bensin Yamaha', 'Lainnya', 10, 3, 'Pcs', 35000, 0, '2026-04-24 01:50:55', '2026-04-25 11:05:12'),
(449, 'LNY-014', 'Lonceng Ganda Assy', 'Lainnya', 1, 1, 'Pcs', 325000, 0, '2026-04-24 01:50:55', '2026-04-25 11:04:30'),
(452, 'BRG014', 'Oli Mesin 11w40', 'Oli & Pelumas', 10, 2, 'Liter', 30000, 0, '2026-05-31 19:16:03', '2026-05-31 19:16:03'),
(453, 'BRG015', 'Oli Mesin 15W40', 'Filter', 10, 2, 'Liter', 40000, 0, '2026-05-31 19:29:18', '2026-05-31 19:29:18'),
(454, 'BRG016', 'Filter Oli Honda 52', 'Filter', 10, 2, 'Pcs', 25000, 0, '2026-06-03 03:12:15', '2026-06-03 03:12:15');

-- --------------------------------------------------------

--
-- Struktur dari tabel `barang_keluar`
--

CREATE TABLE `barang_keluar` (
  `id` int(11) NOT NULL,
  `no_keluar` varchar(20) NOT NULL,
  `barang_id` int(11) NOT NULL,
  `mekanik` varchar(100) NOT NULL,
  `no_polisi` varchar(20) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `harga_satuan` int(11) DEFAULT 0,
  `tanggal` date NOT NULL,
  `keterangan` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `barang_keluar`
--

INSERT INTO `barang_keluar` (`id`, `no_keluar`, `barang_id`, `mekanik`, `no_polisi`, `jumlah`, `harga_satuan`, `tanggal`, `keterangan`, `created_by`, `created_at`) VALUES
(19, 'KLR-019', 1, 'Budi s', 'DB 1234  DB', 1, 45000, '2026-04-29', 'Ganti oli', NULL, '2026-04-29 07:45:32'),
(20, 'KLR-020', 10, 'jojo', 'DB 2245', 1, 85000, '2026-05-02', 'Ganti busi', NULL, '2026-05-02 07:07:45'),
(21, 'KLR-021', 384, 'acel', 'DB 2456 DB', 1, 30000, '2026-05-05', 'ganti kabel rem', NULL, '2026-05-05 16:44:29'),
(22, 'KLR-022', 11, 'Andre', 'DB 2276 DB', 1, 380000, '2026-05-05', 'Ganti aki', 4, '2026-05-05 20:15:23'),
(24, 'KLR-024', 384, 'udin', 'DB 2341 DB', 1, 30000, '2026-05-17', 'Ganti kabel', 4, '2026-05-17 07:53:58'),
(25, 'KLR-025', 4, 'aldo', 'DB 4576 DB', 1, 28000, '2026-05-18', 'Ganti busi', 4, '2026-05-18 04:13:58'),
(26, 'KLR-026', 12, 'Budi s', 'DB  1234 DB', 1, 42000, '2026-05-19', 'ganti kampas rem', 4, '2026-05-19 05:39:00'),
(27, 'KLR-027', 416, 'randy', 'DB 5674 DB', 1, 125000, '2026-05-19', 'servis', 4, '2026-05-19 05:50:28'),
(28, 'KLR-028', 394, 'levin', 'DB 2254 DB', 1, 115000, '2026-05-20', 'servis', 4, '2026-05-20 06:31:28'),
(29, 'KLR-029', 416, 'randy', 'DB 6785 DB', 1, 125000, '2026-05-24', 'perbaikan', 4, '2026-05-24 07:02:59'),
(30, 'KLR-030', 387, 'toar', 'DB 2275 DB', 1, 50000, '2026-05-31', 'servis', 4, '2026-05-31 19:33:41'),
(31, 'KLR-031', 1, 'toar', 'DB 2288 DB', 1, 45000, '2026-05-31', 'perbaikan', 4, '2026-05-31 19:41:35'),
(32, 'KLR-032', 1, 'aldo', 'DB 5568 DB', 1, 45000, '2026-06-01', 'ganti oli', 4, '2026-06-01 03:20:40'),
(33, 'KLR-033', 7, 'acel', 'DB 2246 DB', 1, 30000, '2026-06-03', 'ganti oli', 4, '2026-06-03 03:15:35'),
(34, 'KLR-034', 5, 'Atin', 'DB 1876 DB', 1, 280000, '2026-06-03', 'perbaikan', 4, '2026-06-03 04:33:13'),
(35, 'KLR-035', 3, 'indra', 'DB 8872 DB', 1, 180000, '2026-06-03', 'perbaikan ', 4, '2026-06-03 13:59:15'),
(36, 'KLR-036', 1, 'maxi', 'DB 8872 DB', 1, 40000, '2026-06-04', 'ganti oli ', 4, '2026-06-04 07:27:35');

-- --------------------------------------------------------

--
-- Struktur dari tabel `barang_masuk`
--

CREATE TABLE `barang_masuk` (
  `id` int(11) NOT NULL,
  `no_terima` varchar(20) NOT NULL,
  `barang_id` int(11) NOT NULL,
  `supplier` varchar(100) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `harga_beli` decimal(15,2) DEFAULT 0.00,
  `harga_satuan` decimal(12,0) NOT NULL,
  `total` decimal(14,0) GENERATED ALWAYS AS (`jumlah` * `harga_satuan`) STORED,
  `tanggal` date NOT NULL,
  `keterangan` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `barang_masuk`
--

INSERT INTO `barang_masuk` (`id`, `no_terima`, `barang_id`, `supplier`, `jumlah`, `harga_beli`, `harga_satuan`, `tanggal`, `keterangan`, `created_by`, `created_at`) VALUES
(33, 'TRM-260502001', 2, '10', 10, 20000.00, 25000, '2026-05-02', '', NULL, '2026-05-02 07:58:52'),
(34, 'TRM-260505001', 387, 'CV. Timur jaya', 5, 45000.00, 50000, '2026-05-05', '', NULL, '2026-05-05 16:43:22'),
(35, 'TRM-260505002', 1, 'CV maju jaya', 1, 40000.00, 45000, '2026-05-05', '', 4, '2026-05-05 20:14:50'),
(36, 'TRM-260507001', 1, 'CV maju jaya', 1, 40000.00, 45000, '2026-05-07', '', 4, '2026-05-07 10:13:59'),
(37, 'TRM-260507002', 410, 'CV. Timur jaya', 3, 140000.00, 145000, '2026-05-07', '', 4, '2026-05-07 10:58:55'),
(38, 'TRM-260518001', 429, 'CV. Timur jaya', 3, 75000.00, 80000, '2026-05-18', '', 4, '2026-05-18 04:13:19'),
(39, 'TRM-260519001', 4, 'CV. Timur jaya', 1, 20000.00, 28000, '2026-05-19', '', 4, '2026-05-19 05:48:36'),
(41, 'TRM-260524002', 2, 'pt jaya', 5, 25000.00, 30000, '2026-05-24', '', 4, '2026-05-24 07:09:05'),
(42, 'TRM-260531001', 4, 'cv bintang jaya', 3, 30000.00, 35000, '2026-05-31', '', 4, '2026-05-31 19:31:57'),
(43, 'TRM-260601001', 410, 'cv bintang timur', 3, 140000.00, 145000, '2026-06-01', '', 4, '2026-06-01 03:18:44'),
(44, 'TRM-260603001', 412, 'cv bintang jaya', 4, 130000.00, 135000, '2026-06-03', '', 4, '2026-06-03 03:14:38'),
(46, 'TRM-260603002', 10, 'cv bintang raya', 5, 80000.00, 85000, '2026-06-03', '', 4, '2026-06-03 04:34:57');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `google_id` varchar(100) DEFAULT NULL,
  `photo` varchar(500) DEFAULT NULL,
  `role` enum('admin','superadmin') DEFAULT 'admin',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `nama`, `email`, `password`, `google_id`, `photo`, `role`, `created_at`) VALUES
(4, '', 'admin@gmail.com', '$2y$10$BwhUzE2cEaxBtd5dWYrTY.EHJbOLvIY5.sSmzB75psNOhcnIx278y', NULL, NULL, 'admin', '2026-05-05 19:10:57');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kode` (`kode`);

--
-- Indeks untuk tabel `barang_keluar`
--
ALTER TABLE `barang_keluar`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `no_keluar` (`no_keluar`),
  ADD KEY `barang_id` (`barang_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indeks untuk tabel `barang_masuk`
--
ALTER TABLE `barang_masuk`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `no_terima` (`no_terima`),
  ADD KEY `barang_id` (`barang_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `barang`
--
ALTER TABLE `barang`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=456;

--
-- AUTO_INCREMENT untuk tabel `barang_keluar`
--
ALTER TABLE `barang_keluar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT untuk tabel `barang_masuk`
--
ALTER TABLE `barang_masuk`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `barang_keluar`
--
ALTER TABLE `barang_keluar`
  ADD CONSTRAINT `barang_keluar_ibfk_1` FOREIGN KEY (`barang_id`) REFERENCES `barang` (`id`),
  ADD CONSTRAINT `barang_keluar_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `barang_masuk`
--
ALTER TABLE `barang_masuk`
  ADD CONSTRAINT `barang_masuk_ibfk_1` FOREIGN KEY (`barang_id`) REFERENCES `barang` (`id`),
  ADD CONSTRAINT `barang_masuk_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
