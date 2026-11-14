-- =====================================================================
-- p07_kueri_kopma_25430056.sql
-- Praktikum Basis Data - Pertemuan 7: SELECT dan fungsi skalar (Kopma)
-- Nama: Zahra Zakia An Nur | NPM: 25430056 | Basis data: kopma_056
-- Prasyarat: p05_ddl_kopma, p06_data_kopma, lalu p06_latihan_kopma
-- (E1 menambah kolom tgl_daftar_anggota dan mengarsipkan A-0460; E2
-- menaikkan harga makanan). Hasil yang diharapkan di bawah mengikuti
-- keadaan itu. Tanggal acuan "hari ini": 2026-10-25 (bukan CURDATE(),
-- supaya hasil tidak berubah dari hari ke hari).
-- Setiap kueri diberi: kode KI, pertanyaan sehari-hari, dan hasil yang
-- diharapkan yang ditulis SEBELUM kueri dijalankan.
-- Satu kali jalan (hasil dengan judul kolom), di Shell XAMPP:
--   mysql -u root -p -f kopma_056 < "<jalur>\p07_kueri_kopma_25430056.sql"
-- Opsi -f melanjutkan walau ada galat (K05a memang menghasilkan galat).
-- =====================================================================

USE kopma_056;

-- ---------------------------------------------------------------------
-- K01 | KI-03 | Barang apa yang stoknya di bawah batas minimum?
-- Diharapkan: 1 baris. MKN-001 Roti Cokelat, stok 5, batas 10, kurang 5.
-- (Stok lain di atas batasnya: ATK-001 112/20, ATK-002 76/20,
--  MNM-001 46/24, MKN-002 39/10, MNM-002 29/12.)
-- ---------------------------------------------------------------------
SELECT 'K01 KI-03 barang di bawah stok minimum' AS kueri;
SELECT kode_barang, nama_barang, stok_barang, batas_min_stok_barang,
       batas_min_stok_barang - stok_barang AS kurang
FROM barang
WHERE stok_barang < batas_min_stok_barang
ORDER BY kurang DESC;

-- ---------------------------------------------------------------------
-- K02 | KI-03 (pendukung) | Barang apa saja yang kategorinya ATK atau minuman?
-- Diharapkan: 4 baris urut kode: ATK-001, ATK-002, MNM-001, MNM-002.
-- ---------------------------------------------------------------------
SELECT 'K02 kategori ATK atau minuman (IN)' AS kueri;
SELECT kode_barang, nama_barang, kategori_barang, harga_jual_barang
FROM barang
WHERE kategori_barang IN ('ATK', 'minuman')
ORDER BY kode_barang;

-- ---------------------------------------------------------------------
-- K03 | KI-01 (pendukung) | Nota apa saja yang terjadi pada 24 dan 25 September 2026?
-- Batas akhir ditulis 23:59:59 karena kolom bertipe DATETIME.
-- Diharapkan: 3 baris: PJ-2609-0142 (10:15, 30000), PJ-2609-0143 (11:40, 10000),
-- PJ-2609-0150 (25-09 09:05, 20000).
-- ---------------------------------------------------------------------
SELECT 'K03 nota rentang tanggal (BETWEEN)' AS kueri;
SELECT no_nota_penjualan, tgl_jam_penjualan, bayar_penjualan
FROM penjualan
WHERE tgl_jam_penjualan BETWEEN '2026-09-24 00:00:00' AND '2026-09-25 23:59:59'
ORDER BY tgl_jam_penjualan;

-- ---------------------------------------------------------------------
-- K04a | Anggota mana yang tidak punya nomor HP?
-- Diharapkan: 0 baris (hasil kosong), karena semua anggota sampel punya nomor HP.
-- ---------------------------------------------------------------------
SELECT 'K04a anggota tanpa nomor HP (IS NULL)' AS kueri;
SELECT no_anggota, nama_anggota FROM anggota WHERE no_hp_anggota IS NULL;

-- ---------------------------------------------------------------------
-- K04b | KI-02/AB-02 (pendukung) | Nota mana yang dibeli pembeli umum (tanpa anggota)?
-- Diharapkan: 1 baris: PJ-2609-0143 dengan id_anggota NULL.
-- ---------------------------------------------------------------------
SELECT 'K04b nota pembeli umum (IS NULL)' AS kueri;
SELECT no_nota_penjualan, id_anggota FROM penjualan WHERE id_anggota IS NULL;

-- ---------------------------------------------------------------------
-- K05a | Titik Analisis 1 | Alias kolom dipakai di WHERE
-- Diharapkan: ERROR 1054 Unknown column 'kurang' in 'where clause', karena WHERE
-- dievaluasi sebelum SELECT sehingga alias belum ada.
-- ---------------------------------------------------------------------
SELECT 'K05a alias dipakai di WHERE (harus ERROR 1054)' AS kueri;
SELECT kode_barang, batas_min_stok_barang - stok_barang AS kurang
FROM barang
WHERE kurang > 0;

-- K05b | Syarat setara tanpa alias (ekspresinya diulang di WHERE)
-- Diharapkan: 1 baris: MKN-001 dengan kurang 5.
SELECT 'K05b syarat setara tanpa alias' AS kueri;
SELECT kode_barang, batas_min_stok_barang - stok_barang AS kurang
FROM barang
WHERE batas_min_stok_barang - stok_barang > 0;

-- ---------------------------------------------------------------------
-- K06 | Titik Analisis 2 | NULL tidak sama dengan apa pun, termasuk NULL
-- K06a Diharapkan: 0 baris, karena id_anggota = NULL tidak pernah bernilai benar.
-- K06b Diharapkan: 1 baris: PJ-2609-0143.
-- ---------------------------------------------------------------------
SELECT 'K06a id_anggota = NULL (harus 0 baris)' AS kueri;
SELECT no_nota_penjualan FROM penjualan WHERE id_anggota = NULL;
SELECT 'K06b id_anggota IS NULL (harus 1 baris)' AS kueri;
SELECT no_nota_penjualan FROM penjualan WHERE id_anggota IS NULL;

-- ---------------------------------------------------------------------
-- K07 | AB-02 | Anggota yang namanya mengandung huruf a, beserta keterangan diskon
-- Alias dibuat tgl_daftar (bukan tgl_daftar_anggota) supaya ORDER BY memakai
-- kolom tanggal asli, bukan teks hasil DATE_FORMAT.
-- Diharapkan: 3 baris, tanggal daftar terbaru dulu:
--   Fajar Nugroho (A-0459)  15-01-2026  081234560459  Diskon 5%
--   Citra Lestari (A-0458)  21-08-2025  081234560458  Diskon 5%
--   Budi Santoso (A-0457)   10-03-2025  081234560457  Diskon 5%
-- (Teguh Wibisono tidak mengandung huruf a.)
-- ---------------------------------------------------------------------
SELECT 'K07 anggota mengandung a (LIKE, CONCAT, DATE_FORMAT, IFNULL, CASE)' AS kueri;
SELECT CONCAT(nama_anggota, ' (', no_anggota, ')')             AS anggota,
       DATE_FORMAT(tgl_daftar_anggota, '%d-%m-%Y')             AS tgl_daftar,
       IFNULL(no_hp_anggota, '-')                              AS hp,
       CASE status_anggota WHEN 'aktif' THEN 'Diskon 5%'
                           ELSE 'Tanpa diskon' END             AS keterangan
FROM anggota
WHERE nama_anggota LIKE '%a%'
ORDER BY tgl_daftar_anggota DESC
LIMIT 5;

-- ---------------------------------------------------------------------
-- K08 | Berapa hari setiap anggota sudah terdaftar (acuan 2026-10-25)?
-- Diharapkan: 4 baris urut nomor anggota, semuanya kategori lama (>= 180 hari):
--   A-0457 594 lama | A-0458 430 lama | A-0459 283 lama | A-0461 993 lama
-- ---------------------------------------------------------------------
SELECT 'K08 lama keanggotaan (DATEDIFF, CASE)' AS kueri;
SELECT no_anggota, nama_anggota,
       DATEDIFF('2026-10-25', tgl_daftar_anggota) AS hari_terdaftar,
       CASE WHEN DATEDIFF('2026-10-25', tgl_daftar_anggota) < 180 THEN 'baru'
            ELSE 'lama' END AS kategori
FROM anggota
ORDER BY no_anggota;

-- ---------------------------------------------------------------------
-- K09 | Subtotal setiap baris nota PJ-2609-0142 (nota ini ber-id 1)
-- Nomor nota diganti id_penjualan = 1 karena penelusuran lewat nomor nota
-- membutuhkan JOIN (Modul 10).
-- Diharapkan: 3 baris: (1,1,3,4000,12000) (1,2,2,6500,13000) (1,3,1,4000,4000).
-- Jumlah manual 12000 + 13000 + 4000 = 29000, sama dengan nota di Modul 2.
-- ---------------------------------------------------------------------
SELECT 'K09 subtotal per baris nota PJ-2609-0142' AS kueri;
SELECT id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan,
       qty_detail_penjualan * harga_satuan_detail_penjualan AS subtotal
FROM detail_penjualan
WHERE id_penjualan = 1
ORDER BY id_barang;

-- ---------------------------------------------------------------------
-- E1 | Nama barang huruf kapital dan harga berformat Rp
-- Diharapkan: 6 baris urut kode:
--   ATK-001 PULPEN GEL 0.5 Rp4.000 | ATK-002 BUKU TULIS 58 Rp6.500
--   MKN-001 ROTI COKELAT Rp5.300   | MKN-002 WAFER COKELAT Rp3.700
--   MNM-001 AIR MINERAL 600 Rp4.000 | MNM-002 TEH BOTOL 350 Rp4.500
-- ---------------------------------------------------------------------
SELECT 'E1 nama kapital dan harga Rp (UPPER, FORMAT)' AS kueri;
SELECT kode_barang, UPPER(nama_barang) AS nama,
       CONCAT('Rp', FORMAT(harga_jual_barang, 0, 'id_ID')) AS harga
FROM barang
ORDER BY kode_barang;

-- ---------------------------------------------------------------------
-- E2 | Kesalahan semantik: OR tanpa tanda kurung
-- Pertanyaan: barang ATK atau minuman yang stoknya di bawah 40.
-- E2a (salah) Diharapkan: 3 baris, ATK-001 (112), ATK-002 (76), dan MNM-002 (29),
--   karena AND diproses lebih dulu: ATK mana pun lolos, hanya minuman yang dibatasi stok.
-- E2b (benar) Diharapkan: 1 baris, MNM-002 (29).
-- ---------------------------------------------------------------------
SELECT 'E2a OR tanpa kurung (berjalan tanpa galat, hasil salah)' AS kueri;
SELECT kode_barang, nama_barang, kategori_barang, stok_barang
FROM barang
WHERE kategori_barang = 'ATK' OR kategori_barang = 'minuman' AND stok_barang < 40
ORDER BY kode_barang;

SELECT 'E2b dengan tanda kurung (benar)' AS kueri;
SELECT kode_barang, nama_barang, kategori_barang, stok_barang
FROM barang
WHERE (kategori_barang = 'ATK' OR kategori_barang = 'minuman') AND stok_barang < 40
ORDER BY kode_barang;
