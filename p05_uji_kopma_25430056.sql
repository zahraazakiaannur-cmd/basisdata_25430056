-- =====================================================================
-- p05_uji_kopma_25430056.sql
-- Pembuktian constraint Kopma + langkah ALTER + Latihan E1 dan E2
-- Jalankan SETELAH p05_ddl_kopma_25430056.sql (tabel masih kosong).
-- Perintah bertanda [DITOLAK] memang harus gagal; jalankan satu per satu
-- di phpMyAdmin (tab SQL) dan ambil tangkapan layar pesan galatnya.
-- Untuk mengulang dari awal, jalankan lagi p05_ddl_kopma_25430056.sql.
-- Cara satu kali jalan (hasil ringkas di satu layar), di Command Prompt:
--   cd /d C:\xampp\mysql\bin
--   mysql -u root -f -N kopma_056 < "<jalur>\p05_uji_kopma_25430056.sql"
-- Opsi -f melanjutkan walau ada galat, -N menyembunyikan judul kolom.
-- =====================================================================

USE kopma_056;

-- ---------------------------------------------------------------------
-- A. Data induk secukupnya
-- ---------------------------------------------------------------------
INSERT INTO petugas (id_petugas, kode_petugas, nama_petugas, peran_petugas)
VALUES (1, 'K01', 'Sari',  'kasir'),
       (2, 'G01', 'Budi',  'gudang');

INSERT INTO barang (id_barang, kode_barang, nama_barang, kategori_barang,
                    harga_jual_barang, stok_barang)
VALUES (1, 'ATK-001', 'Pulpen', 'ATK',     4000, 35),
       (2, 'MKN-001', 'Roti',   'makanan', 5000, 20);

INSERT INTO anggota (id_anggota, no_anggota, nim_anggota, nama_anggota,
                     prodi_anggota, no_hp_anggota, status_anggota)
VALUES (1, 'A-0457', '2301010123', 'Rizki Aditya', 'Ilmu Komputer', '08123456789', 'aktif');

-- ---------------------------------------------------------------------
-- B. Pembuktian constraint (Gambar 5.2) - semua harus DITOLAK
-- ---------------------------------------------------------------------

-- B1 [DITOLAK] kunci tamu: petugas 99 tidak ada -> ERROR 1452
SELECT 'B1 FK petugas 99 (harus ERROR 1452)' AS percobaan;
INSERT INTO penjualan (no_nota_penjualan, tgl_jam_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0199', NOW(), 99, NULL, 5000);

-- B2 [DITOLAK] CHECK stok tidak boleh negatif (AB-03) -> ERROR 4025
SELECT 'B2 stok -1 (harus ERROR 4025)' AS percobaan;
UPDATE barang SET stok_barang = -1 WHERE id_barang = 1;

-- B3 [DITOLAK] UNIQUE kode barang kembar -> ERROR 1062
SELECT 'B3 kode barang kembar (harus ERROR 1062)' AS percobaan;
INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang)
VALUES ('ATK-001', 'Duplikat', 'ATK', 1000);

-- B4 [DITOLAK] CHECK format NIM 10 digit (AB-05) -> ERROR 4025
SELECT 'B4 NIM bukan 10 digit (harus ERROR 4025)' AS percobaan;
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, status_anggota)
VALUES ('A-0458', '123', 'NIM Salah', 'Ilmu Komputer', 'aktif');

-- B5 [DITOLAK] UNIQUE NIM kembar (AB-05) -> ERROR 1062
SELECT 'B5 NIM kembar (harus ERROR 1062)' AS percobaan;
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, status_anggota)
VALUES ('A-0459', '2301010123', 'NIM Kembar', 'Ilmu Komputer', 'aktif');

-- Satu nota yang sah untuk pengujian berikutnya
INSERT INTO penjualan (id_penjualan, no_nota_penjualan, tgl_jam_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES (1, 'PJ-2610-0001', NOW(), 1, NULL, 10000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
VALUES (1, 1, 2, 4000);

-- B6 [DITOLAK] CHECK qty harus > 0 (AB-03) -> ERROR 4025
SELECT 'B6 qty 0 (harus ERROR 4025)' AS percobaan;
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
VALUES (1, 2, 0, 5000);

-- B7 [DITOLAK] kunci primer komposit: barang sama dua kali di satu nota -> ERROR 1062
SELECT 'B7 barang sama dua kali di satu nota (harus ERROR 1062)' AS percobaan;
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
VALUES (1, 1, 1, 4000);

-- B8 [DITOLAK] petugas yang pernah melayani tidak boleh dihapus -> ERROR 1451
SELECT 'B8 hapus petugas yang punya nota (harus ERROR 1451)' AS percobaan;
DELETE FROM petugas WHERE id_petugas = 1;

-- B9 [DITOLAK] barang yang pernah terjual tidak boleh dihapus (tanpa CASCADE) -> ERROR 1451
SELECT 'B9 hapus barang yang pernah terjual (harus ERROR 1451)' AS percobaan;
DELETE FROM barang WHERE id_barang = 1;

-- B10 CASCADE: membatalkan nota ikut menghapus rinciannya (Titik Analisis 1)
SELECT 'B10 hapus nota 1, rincian ikut terhapus (harus berhasil, jumlah baris detail = 0)' AS percobaan;
DELETE FROM penjualan WHERE id_penjualan = 1;
SELECT COUNT(*) AS jumlah_baris_detail FROM detail_penjualan;   -- harus 0

-- ---------------------------------------------------------------------
-- C. Mengubah struktur (langkah 6)
-- ---------------------------------------------------------------------
SELECT 'C1 tambah kolom tgl_kedaluwarsa' AS percobaan;
ALTER TABLE barang ADD COLUMN tgl_kedaluwarsa DATE NULL AFTER batas_min_stok_barang;
DESCRIBE barang;
SELECT 'C2 buang kolom tgl_kedaluwarsa' AS percobaan;
ALTER TABLE barang DROP COLUMN tgl_kedaluwarsa;     -- dibatalkan setelah dicoba
DESCRIBE barang;

-- ---------------------------------------------------------------------
-- D. Latihan E1: CHECK batas minimum stok tidak negatif
-- ---------------------------------------------------------------------
ALTER TABLE barang
  ADD CONSTRAINT ck_barang_batas_min CHECK (batas_min_stok_barang >= 0);

SELECT 'E1 batas minimum stok -5 (harus ERROR 4025)' AS percobaan;
-- [DITOLAK] -> ERROR 4025
UPDATE barang SET batas_min_stok_barang = -5 WHERE id_barang = 1;

-- ---------------------------------------------------------------------
-- E. Latihan E2: ON DELETE SET NULL pada fk_penjualan_anggota
-- ---------------------------------------------------------------------
-- Nota milik anggota 1
INSERT INTO penjualan (id_penjualan, no_nota_penjualan, tgl_jam_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES (2, 'PJ-2610-0002', NOW(), 1, 1, 10000);

-- Sebelum diubah: menghapus anggota yang punya nota ditolak -> ERROR 1451
SELECT 'E2a hapus anggota sebelum SET NULL (harus ERROR 1451)' AS percobaan;
DELETE FROM anggota WHERE id_anggota = 1;

ALTER TABLE penjualan DROP FOREIGN KEY fk_penjualan_anggota;
ALTER TABLE penjualan
  ADD CONSTRAINT fk_penjualan_anggota FOREIGN KEY (id_anggota)
  REFERENCES anggota (id_anggota) ON DELETE SET NULL;

-- Sesudah diubah: anggota terhapus, nota tetap ada dengan id_anggota NULL
SELECT 'E2b hapus anggota sesudah SET NULL (harus berhasil, id_anggota nota = NULL)' AS percobaan;
DELETE FROM anggota WHERE id_anggota = 1;
SELECT id_penjualan, no_nota_penjualan, id_anggota FROM penjualan;

-- Kembalikan ke struktur awal: jalankan ulang p05_ddl_kopma_25430056.sql
