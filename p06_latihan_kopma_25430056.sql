-- =====================================================================
-- p06_latihan_kopma_25430056.sql
-- Latihan E1 (pengarsipan anggota) dan E2 (kenaikan harga makanan 5%)
-- Jalankan SETELAH p05_ddl_kopma_25430056.sql dan p06_data_kopma_25430056.sql.
-- Skrip ini mengubah struktur (ALTER) dan data. Untuk mengembalikan keadaan
-- awal, jalankan ulang DDL Modul 5 lalu data Modul 6.
-- =====================================================================

USE kopma_056;
SET SESSION sql_safe_updates = 1;
DROP TABLE IF EXISTS anggota_arsip;

-- ---------------------------------------------------------------------
-- E1. Arsipkan anggota nonaktif yang mendaftar sebelum 2025
-- Tabel anggota Kopma belum punya tanggal daftar, sehingga kolomnya
-- ditambahkan dulu (perubahan desain, dicatat di laporan).
-- ---------------------------------------------------------------------
ALTER TABLE anggota ADD COLUMN tgl_daftar_anggota DATE NULL AFTER status_anggota;

UPDATE anggota SET tgl_daftar_anggota = '2025-03-10' WHERE no_anggota = 'A-0457';
UPDATE anggota SET tgl_daftar_anggota = '2025-08-21' WHERE no_anggota = 'A-0458';
UPDATE anggota SET tgl_daftar_anggota = '2026-01-15' WHERE no_anggota = 'A-0459';
UPDATE anggota SET tgl_daftar_anggota = '2024-06-12' WHERE no_anggota = 'A-0460';
UPDATE anggota SET tgl_daftar_anggota = '2024-02-05' WHERE no_anggota = 'A-0461';

SELECT 'E1 sebelum: anggota' AS langkah;
SELECT no_anggota, nama_anggota, status_anggota, tgl_daftar_anggota FROM anggota;

CREATE TABLE anggota_arsip LIKE anggota;

-- Anggota yang masih punya penjualan (A-0461) tidak ikut diarsipkan
INSERT INTO anggota_arsip
SELECT * FROM anggota
WHERE status_anggota = 'nonaktif'
  AND tgl_daftar_anggota < '2025-01-01'
  AND id_anggota NOT IN (SELECT id_anggota FROM penjualan WHERE id_anggota IS NOT NULL);

DELETE FROM anggota
WHERE id_anggota > 0
  AND status_anggota = 'nonaktif'
  AND tgl_daftar_anggota < '2025-01-01'
  AND id_anggota NOT IN (SELECT id_anggota FROM penjualan WHERE id_anggota IS NOT NULL);

SELECT 'E1 sesudah: anggota yang tersisa' AS langkah;
SELECT no_anggota, nama_anggota, status_anggota FROM anggota;
SELECT 'E1 sesudah: anggota_arsip' AS langkah;
SELECT no_anggota, nama_anggota, status_anggota FROM anggota_arsip;

-- ---------------------------------------------------------------------
-- E2. Naikkan harga barang kategori makanan 5%, dibulatkan ke ratusan
-- ---------------------------------------------------------------------
SELECT 'E2 sebelum: harga makanan' AS langkah;
SELECT kode_barang, harga_jual_barang FROM barang WHERE kategori_barang = 'makanan';

UPDATE barang
SET harga_jual_barang = ROUND(harga_jual_barang * 1.05, -2)
WHERE kategori_barang = 'makanan' AND id_barang > 0;

SELECT 'E2 sesudah: harga makanan' AS langkah;
SELECT kode_barang, harga_jual_barang FROM barang WHERE kategori_barang = 'makanan';

-- Nota lama tidak berubah karena harga disalin per baris (AB-04)
SELECT 'Harga nota lama MKN-001 tetap' AS langkah;
SELECT d.harga_satuan_detail_penjualan FROM detail_penjualan d
JOIN barang b ON b.id_barang = d.id_barang WHERE b.kode_barang = 'MKN-001';
