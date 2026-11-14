-- =====================================================================
-- p07_kueri_25430056.sql
-- Praktikum Basis Data - Pertemuan 7: SELECT dan fungsi skalar (proyek)
-- Nama: Zahra Zakia An Nur | NPM: 25430056 | Basis data: perpus_056
-- Prasyarat: p05_ddl_25430056 lalu p06_data_25430056 (tanpa perubahan lain).
-- Tanggal acuan "hari ini": 2026-10-25 (bukan CURDATE(), supaya hasil tetap).
-- Setiap kueri satu tabel diberi: kode KI, pertanyaan sehari-hari, dan hasil
-- yang diharapkan yang ditulis SEBELUM kueri dijalankan.
-- id_peminjaman dan id_eksemplar mengikuti urutan pemasukan di skrip data
-- (peminjaman 1-30, eksemplar 1-30).
-- Satu kali jalan (hasil dengan judul kolom), di Shell XAMPP:
--   mysql -u root -p -f perpus_056 < "<jalur>\p07_kueri_25430056.sql"
-- =====================================================================

USE perpus_056;

-- ---------------------------------------------------------------------
-- P01 | KI-07 (pendukung) | Tarif denda mana yang berlaku pada 7 September 2026?
-- Satu tabel: tarif terbaru yang mulai berlaku pada atau sebelum tanggal itu.
-- Diharapkan: 1 baris: TD-2026, 3000, 2026-01-01.
-- ---------------------------------------------------------------------
SELECT 'P01 KI-07 tarif berlaku pada tanggal tertentu' AS kueri;
SELECT kode_tarif_denda, nominal_tarif_denda, berlaku_mulai_tarif_denda
FROM tarif_denda
WHERE berlaku_mulai_tarif_denda <= '2026-09-07'
ORDER BY berlaku_mulai_tarif_denda DESC
LIMIT 1;

-- ---------------------------------------------------------------------
-- P02 | KI-06 (pendukung) | Lima baris peminjaman terlama yang koleksinya belum kembali?
-- Diharapkan: 5 baris (id_peminjaman, id_eksemplar, tarif):
--   17, 12, 3000
--   18, 5, 3000
--   21, 15, 3000
--   22, 1, 3000
--   22, 11, 3000
-- ---------------------------------------------------------------------
SELECT 'P02 KI-06 koleksi belum kembali (IS NULL)' AS kueri;
SELECT id_peminjaman, id_eksemplar, tarif_denda_detail_peminjaman
FROM detail_peminjaman
WHERE tgl_kembali_detail_peminjaman IS NULL
  AND status_item_detail_peminjaman = 'dipinjam'
ORDER BY id_peminjaman, id_eksemplar
LIMIT 5;

-- ---------------------------------------------------------------------
-- P03 | KI-04 (pendukung) | Lima denda per koleksi terbesar?
-- Diharapkan: 5 baris (id_peminjaman, id_eksemplar, denda), denda terbesar dulu:
--   13, 23, 24000
--   15, 14, 24000
--   19, 29, 24000
--   20, 9, 24000
--   9, 21, 21000
-- ---------------------------------------------------------------------
SELECT 'P03 KI-04 denda terbesar per koleksi' AS kueri;
SELECT id_peminjaman, id_eksemplar, denda_detail_peminjaman
FROM detail_peminjaman
WHERE denda_detail_peminjaman > 0
ORDER BY denda_detail_peminjaman DESC, id_peminjaman, id_eksemplar
LIMIT 5;

-- ---------------------------------------------------------------------
-- P04 | KI-02 (pendukung) | Peminjaman apa saja pada 14 sampai 21 September 2026, dan kapan jatuh tempo?
-- Jatuh tempo = tgl_pinjam + 7 hari (AB-06).
-- Diharapkan: 8 baris (no_peminjaman, tgl_pinjam, jatuh_tempo):
--   PM-2609-0006, 14-09-2026, 21-09-2026
--   PM-2609-0007, 14-09-2026, 21-09-2026
--   PM-2609-0008, 14-09-2026, 21-09-2026
--   PM-2609-0009, 15-09-2026, 22-09-2026
--   PM-2609-0010, 15-09-2026, 22-09-2026
--   PM-2609-0011, 21-09-2026, 28-09-2026
--   PM-2609-0012, 21-09-2026, 28-09-2026
--   PM-2609-0013, 21-09-2026, 28-09-2026
-- ---------------------------------------------------------------------
SELECT 'P04 KI-02 peminjaman rentang tanggal (BETWEEN, DATE_ADD, DATE_FORMAT)' AS kueri;
SELECT no_peminjaman,
       DATE_FORMAT(tgl_pinjam, '%d-%m-%Y')                           AS tgl_pinjam,
       DATE_FORMAT(DATE_ADD(tgl_pinjam, INTERVAL 7 DAY), '%d-%m-%Y') AS jatuh_tempo
FROM peminjaman
WHERE tgl_pinjam BETWEEN '2026-09-14' AND '2026-09-21'
ORDER BY peminjaman.tgl_pinjam, no_peminjaman;

-- ---------------------------------------------------------------------
-- P05 | AB-02 | Lima anggota terlama yang namanya mengandung "an", dan bolehkah mereka meminjam?
-- Diharapkan: 5 baris (anggota, tgl_daftar, keterangan):
--   Lukman Hakim (YL-0012), 14-08-2023, Tidak boleh meminjam
--   Citra Maharani (YL-0003), 03-09-2024, Boleh meminjam
--   Dewangga Putra (YL-0004), 03-09-2024, Boleh meminjam
--   Farhan Ghifari (YL-0006), 18-08-2025, Boleh meminjam
--   Hafidz Maulana (YL-0008), 01-09-2025, Boleh meminjam
-- ---------------------------------------------------------------------
SELECT 'P05 AB-02 anggota nama mengandung an (LIKE, CONCAT, CASE)' AS kueri;
SELECT CONCAT(nama_anggota, ' (', no_anggota, ')') AS anggota,
       DATE_FORMAT(tgl_daftar_anggota, '%d-%m-%Y') AS tgl_daftar,
       CASE status_anggota WHEN 'aktif' THEN 'Boleh meminjam'
                           ELSE 'Tidak boleh meminjam' END AS keterangan
FROM anggota
WHERE nama_anggota LIKE '%an%'
ORDER BY tgl_daftar_anggota, no_anggota
LIMIT 5;

-- ---------------------------------------------------------------------
-- P06 | KI-05 (pendukung) | Judul majalah dan jurnal apa saja yang dimiliki perpustakaan?
-- Diharapkan: 4 baris (kode, judul huruf kapital, jenis):
--   JR-001, JURNAL SISTEM INFORMASI TERAPAN VOL. 12, jurnal
--   JR-002, JURNAL REKAYASA DATA VOL. 8, jurnal
--   MJ-001, MAJALAH TEKNOLOGI KAMPUS EDISI TAHUNAN, majalah
--   MJ-002, MAJALAH SAINS POPULER, majalah
-- ---------------------------------------------------------------------
SELECT 'P06 KI-05 majalah dan jurnal (IN, UPPER)' AS kueri;
SELECT kode_koleksi, UPPER(judul_koleksi) AS judul, jenis_koleksi
FROM koleksi
WHERE jenis_koleksi IN ('majalah', 'jurnal')
ORDER BY kode_koleksi;

-- ---------------------------------------------------------------------
-- P07 | KI-05 | Eksemplar mana yang berstatus hilang?
-- Diharapkan: 2 baris:
--   BK-001-02, hilang
--   BK-006-02, hilang
-- ---------------------------------------------------------------------
SELECT 'P07 KI-05 eksemplar hilang' AS kueri;
SELECT kode_eksemplar, status_eksemplar
FROM eksemplar
WHERE status_eksemplar = 'hilang'
ORDER BY kode_eksemplar;

-- ---------------------------------------------------------------------
-- P08 | KI-05 (pendukung) | Delapan eksemplar buku pertama (urut kode) yang tersedia?
-- Diharapkan: 8 baris:
--   BK-001-04, tersedia
--   BK-002-03, tersedia
--   BK-003-02, tersedia
--   BK-003-03, tersedia
--   BK-004-03, tersedia
--   BK-006-03, tersedia
--   BK-007-02, tersedia
--   BK-008-01, tersedia
-- ---------------------------------------------------------------------
SELECT 'P08 KI-05 eksemplar buku tersedia (LIKE)' AS kueri;
SELECT kode_eksemplar, status_eksemplar
FROM eksemplar
WHERE kode_eksemplar LIKE 'BK-%' AND status_eksemplar = 'tersedia'
ORDER BY kode_eksemplar
LIMIT 8;

-- ---------------------------------------------------------------------
-- P09 | KI-03 (pendukung) | Peminjaman 12-23 Oktober 2026: sudah berapa hari, dan apakah lewat batas 7 hari?
-- Dengan acuan 2026-10-25. Belum memeriksa pengembalian (butuh JOIN, Pertemuan 10).
-- Diharapkan: 9 baris (no_peminjaman, tgl_pinjam, hari_berlalu, keterangan):
--   PM-2610-0006, 12-10-2026, 13, lewat batas pinjam
--   PM-2610-0007, 12-10-2026, 13, lewat batas pinjam
--   PM-2610-0008, 12-10-2026, 13, lewat batas pinjam
--   PM-2610-0009, 19-10-2026, 6, masih dalam batas
--   PM-2610-0010, 19-10-2026, 6, masih dalam batas
--   PM-2610-0011, 22-10-2026, 3, masih dalam batas
--   PM-2610-0012, 22-10-2026, 3, masih dalam batas
--   PM-2610-0013, 23-10-2026, 2, masih dalam batas
--   PM-2610-0014, 23-10-2026, 2, masih dalam batas
-- ---------------------------------------------------------------------
SELECT 'P09 KI-03 usia peminjaman (BETWEEN, DATEDIFF, CASE)' AS kueri;
SELECT no_peminjaman,
       DATE_FORMAT(tgl_pinjam, '%d-%m-%Y')         AS tgl_pinjam,
       DATEDIFF('2026-10-25', tgl_pinjam)          AS hari_berlalu,
       CASE WHEN DATEDIFF('2026-10-25', tgl_pinjam) > 7 THEN 'lewat batas pinjam'
            ELSE 'masih dalam batas' END           AS keterangan
FROM peminjaman
WHERE tgl_pinjam BETWEEN '2026-10-12' AND '2026-10-23'
ORDER BY peminjaman.tgl_pinjam, no_peminjaman;

-- ---------------------------------------------------------------------
-- P10 | AB-12 (pendukung KI-05) | Koleksi berharga 80.000 sampai 110.000 (dasar ganti rugi), termahal dulu?
-- Diharapkan: 6 baris (kode, judul, harga):
--   BK-003, Jaringan Komputer Modern, 110000
--   BK-007, Manajemen Proyek Perangkat Lunak, 105000
--   BK-001, Dasar-Dasar Basis Data, 95000
--   BK-004, Statistika Terapan, 90000
--   BK-002, Pemrograman Python untuk Pemula, 85000
--   BK-005, Pengantar Ekonomi Mikro, 80000
-- ---------------------------------------------------------------------
SELECT 'P10 AB-12 koleksi rentang harga (BETWEEN)' AS kueri;
SELECT kode_koleksi, judul_koleksi, harga_koleksi
FROM koleksi
WHERE harga_koleksi BETWEEN 80000 AND 110000
ORDER BY harga_koleksi DESC, kode_koleksi;

-- ---------------------------------------------------------------------
-- P11 | KI-04 (pendukung) | Pada empat peminjaman pertama, koleksi mana yang tepat waktu dan mana yang terlambat?
-- Diharapkan: 7 baris (id_peminjaman, id_eksemplar, status, denda, ketepatan):
--   1, 19, kembali, 6000, terlambat
--   1, 29, kembali, 0, tepat waktu
--   2, 15, kembali, 18000, terlambat
--   3, 1, kembali, 15000, terlambat
--   3, 9, kembali, 0, tepat waktu
--   3, 30, kembali, 0, tepat waktu
--   4, 12, kembali, 0, tepat waktu
-- ---------------------------------------------------------------------
SELECT 'P11 KI-04 ketepatan pengembalian (CASE, IS NULL)' AS kueri;
SELECT id_peminjaman, id_eksemplar, status_item_detail_peminjaman AS status,
       denda_detail_peminjaman AS denda,
       CASE WHEN denda_detail_peminjaman IS NULL THEN 'belum selesai'
            WHEN denda_detail_peminjaman = 0 THEN 'tepat waktu'
            ELSE 'terlambat' END AS ketepatan
FROM detail_peminjaman
WHERE id_peminjaman <= 4
ORDER BY id_peminjaman, id_eksemplar;

-- ---------------------------------------------------------------------
-- P12 | AB-02 | Anggota mana yang tidak aktif?
-- Diharapkan: 1 baris: YL-0012, Lukman Hakim, nonaktif.
-- ---------------------------------------------------------------------
SELECT 'P12 AB-02 anggota nonaktif' AS kueri;
SELECT no_anggota, nama_anggota, status_anggota
FROM anggota
WHERE status_anggota <> 'aktif';

-- ---------------------------------------------------------------------
-- P13 | KI-02 (pendukung) | Lima peminjaman terbaru?
-- Alias tgl_pinjam bernama sama dengan kolomnya, sehingga ORDER BY harus memakai
-- peminjaman.tgl_pinjam (kolom asli). Tanpa nama tabel, urutan memakai teks
-- hasil DATE_FORMAT (hari-bulan-tahun) dan salah. Hal yang sama berlaku di P04 dan P09.
-- Diharapkan: 5 baris, terbaru dulu:
--   PM-2610-0014, 23-10-2026
--   PM-2610-0013, 23-10-2026
--   PM-2610-0012, 22-10-2026
--   PM-2610-0011, 22-10-2026
--   PM-2610-0010, 19-10-2026
-- ---------------------------------------------------------------------
SELECT 'P13 KI-02 lima peminjaman terbaru' AS kueri;
SELECT no_peminjaman, DATE_FORMAT(tgl_pinjam, '%d-%m-%Y') AS tgl_pinjam
FROM peminjaman
ORDER BY peminjaman.tgl_pinjam DESC, no_peminjaman DESC
LIMIT 5;

-- ---------------------------------------------------------------------
-- P14 | Petugas biasa (bukan kepala perpustakaan) siapa saja, nama huruf kapital?
-- Diharapkan: 4 baris:
--   P02, RATNA KARTIKA
--   P03, YOGA PRATAMA
--   P04, SITI NURHALIZA
--   P05, ADITYA FIRMANSYAH
-- ---------------------------------------------------------------------
SELECT 'P14 petugas biasa (UPPER)' AS kueri;
SELECT kode_petugas, UPPER(nama_petugas) AS nama
FROM petugas
WHERE peran_petugas = 'petugas'
ORDER BY kode_petugas;

-- ---------------------------------------------------------------------
-- KI yang belum dapat dijawab penuh dengan satu tabel (dijawab Pertemuan 9-12):
--  KI-01 koleksi paling sering dipinjam per bulan: perlu GROUP BY dan JOIN
--        detail_peminjaman, peminjaman, eksemplar, koleksi.
--  KI-02 anggota paling aktif per bulan: perlu COUNT dan GROUP BY.
--  KI-03 koleksi lewat batas kembali: perlu JOIN detail, peminjaman, anggota,
--        eksemplar, koleksi (P02 dan P09 hanya mencakup sebagian).
--  KI-04 total denda per bulan: perlu SUM dan JOIN ke peminjaman untuk bulannya.
--  KI-05 jumlah eksemplar per status untuk setiap judul: perlu COUNT, GROUP BY, JOIN.
--  KI-06 koleksi belum kembali pada satu transaksi (pakai nomor peminjaman):
--        perlu JOIN peminjaman, detail, eksemplar, koleksi.
--  KI-07 bukti tarif pada transaksi lama (pakai nomor peminjaman): perlu JOIN detail
--        dengan peminjaman (P01 hanya menjawab tarif berlaku pada suatu tanggal).
-- ---------------------------------------------------------------------
