-- =====================================================================
-- p06_uji_kopma_25430056.sql
-- Skenario uji Kopma (UJ-01 sampai UJ-09) dan langkah D.3 Modul 6
-- Jalankan SETELAH p05_ddl_kopma_25430056.sql dan p06_data_kopma_25430056.sql.
-- Semua perubahan dibungkus transaksi dan dibatalkan (ROLLBACK) di akhir,
-- sehingga data sampel tetap sama dan uji dapat diulang.
-- Satu kali jalan (hasil ringkas), di Command Prompt / Shell XAMPP:
--   mysql -u root -p -f -N kopma_056 < "<jalur>\p06_uji_kopma_25430056.sql"
-- Opsi -f melanjutkan walau ada galat, -N menyembunyikan judul kolom.
-- =====================================================================

USE kopma_056;
SET SESSION sql_safe_updates = 0;
START TRANSACTION;

-- ---------------------------------------------------------------------
-- UJ-01 (positif) nota baru dengan anggota aktif -> diterima (AB-02)
-- ---------------------------------------------------------------------
SELECT 'UJ-01 nota anggota aktif (harus diterima, jumlah baris = 1)' AS skenario;
INSERT INTO penjualan (no_nota_penjualan, tgl_jam_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2610-0099', '2026-10-05 09:00:00',
        (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K01'),
        (SELECT id_anggota FROM anggota WHERE no_anggota = 'A-0457'), 10000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 2, b.harga_jual_barang
FROM penjualan p, barang b WHERE p.no_nota_penjualan = 'PJ-2610-0099' AND b.kode_barang = 'ATK-001';
SELECT COUNT(*) AS jumlah_nota FROM penjualan WHERE no_nota_penjualan = 'PJ-2610-0099';

-- ---------------------------------------------------------------------
-- UJ-02 (positif) nota tanpa anggota -> diterima, id_anggota NULL (AB-02)
-- ---------------------------------------------------------------------
SELECT 'UJ-02 nota pembeli umum (harus diterima, id_anggota NULL)' AS skenario;
INSERT INTO penjualan (no_nota_penjualan, tgl_jam_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2610-0098', '2026-10-05 09:30:00',
        (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K02'), NULL, 5000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang
FROM penjualan p, barang b WHERE p.no_nota_penjualan = 'PJ-2610-0098' AND b.kode_barang = 'MKN-001';
SELECT no_nota_penjualan, id_anggota FROM penjualan WHERE no_nota_penjualan = 'PJ-2610-0098';

-- ---------------------------------------------------------------------
-- UJ-03 (negatif) stok diubah menjadi -5 -> ERROR 4025 (AB-03, ck_barang_stok)
-- ---------------------------------------------------------------------
SELECT 'UJ-03 stok -5 (harus ERROR 4025)' AS skenario;
UPDATE barang SET stok_barang = -5 WHERE kode_barang = 'ATK-001';

-- ---------------------------------------------------------------------
-- UJ-04 (negatif) nomor nota sudah ada -> ERROR 1062 (AB-01, uq_penjualan_nota)
-- ---------------------------------------------------------------------
SELECT 'UJ-04 nomor nota kembar (harus ERROR 1062)' AS skenario;
INSERT INTO penjualan (no_nota_penjualan, tgl_jam_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0142', '2026-10-05 10:00:00',
        (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K01'), NULL, 5000);

-- ---------------------------------------------------------------------
-- UJ-05 (negatif) detail dengan qty 0 -> ERROR 4025 (ck_detail_penjualan_qty)
-- ---------------------------------------------------------------------
SELECT 'UJ-05 qty 0 (harus ERROR 4025)' AS skenario;
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 0, b.harga_jual_barang
FROM penjualan p, barang b WHERE p.no_nota_penjualan = 'PJ-2610-0099' AND b.kode_barang = 'ATK-002';

-- ---------------------------------------------------------------------
-- UJ-06 (negatif) anggota dengan NIM kembar -> ERROR 1062 (AB-05, uq_anggota_nim)
-- ---------------------------------------------------------------------
SELECT 'UJ-06 NIM kembar (harus ERROR 1062)' AS skenario;
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota)
VALUES ('A-0470', '2326100457', 'NIM Kembar', 'Manajemen', '081200000000', 'aktif');

-- ---------------------------------------------------------------------
-- UJ-07 (negatif) penjualan oleh petugas tidak dikenal -> ERROR 1452 (fk_penjualan_petugas)
-- ---------------------------------------------------------------------
SELECT 'UJ-07 petugas tidak dikenal (harus ERROR 1452)' AS skenario;
INSERT INTO penjualan (no_nota_penjualan, tgl_jam_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2610-0097', '2026-10-05 10:30:00', 99, NULL, 5000);

-- ---------------------------------------------------------------------
-- UJ-08 (negatif) UPDATE tanpa WHERE di mode aman -> ERROR 1175
-- ---------------------------------------------------------------------
SELECT 'UJ-08 UPDATE tanpa WHERE, mode aman (harus ERROR 1175)' AS skenario;
SET SESSION sql_safe_updates = 1;
UPDATE barang SET harga_jual_barang = harga_jual_barang * 1.1;

-- Langkah D.3 nomor 5: dengan syarat kolom kunci, UPDATE diterima
SELECT 'D.3-5 UPDATE harga ATK naik 10% dengan syarat kunci (harus diterima, 2 baris)' AS skenario;
UPDATE barang SET harga_jual_barang = harga_jual_barang * 1.1
WHERE kategori_barang = 'ATK' AND id_barang > 0;
SELECT ROW_COUNT() AS baris_terubah;
SET SESSION sql_safe_updates = 0;

-- ---------------------------------------------------------------------
-- UJ-09 (GAGAL) qty melebihi stok -> seharusnya ditolak (AB-03), tetapi DITERIMA
-- ---------------------------------------------------------------------
SELECT 'UJ-09 qty 500 melebihi stok 29 (seharusnya ditolak, hasilnya diterima)' AS skenario;
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 500, b.harga_jual_barang
FROM penjualan p, barang b WHERE p.no_nota_penjualan = 'PJ-2610-0099' AND b.kode_barang = 'MNM-002';
SELECT qty_detail_penjualan AS qty_tercatat, (SELECT stok_barang FROM barang WHERE kode_barang = 'MNM-002') AS stok_saat_ini
FROM detail_penjualan d JOIN barang b ON b.id_barang = d.id_barang
WHERE b.kode_barang = 'MNM-002' AND d.qty_detail_penjualan = 500;

-- ---------------------------------------------------------------------
-- Langkah D.3 nomor 6: CASCADE dan petugas yang pernah melayani
-- ---------------------------------------------------------------------
SELECT 'D.3-6a rincian nota uji kedua sebelum dihapus (1 baris)' AS skenario;
SELECT COUNT(*) AS baris_detail FROM detail_penjualan d
JOIN penjualan p ON p.id_penjualan = d.id_penjualan WHERE p.no_nota_penjualan = 'PJ-2610-0098';
SELECT 'D.3-6b hapus nota uji kedua (harus diterima), rincian ikut terhapus (0 baris)' AS skenario;
DELETE FROM penjualan WHERE no_nota_penjualan = 'PJ-2610-0098';
SELECT COUNT(*) AS baris_detail FROM detail_penjualan d
JOIN penjualan p ON p.id_penjualan = d.id_penjualan WHERE p.no_nota_penjualan = 'PJ-2610-0098';
SELECT 'D.3-6c hapus petugas K03 yang pernah melayani nota (harus ERROR 1451)' AS skenario;
DELETE FROM petugas WHERE kode_petugas = 'K03';

ROLLBACK;
SELECT 'Selesai. ROLLBACK dijalankan, data sampel tidak berubah.' AS keterangan;
