-- =====================================================================
-- p06_uji_25430056.sql
-- Skenario uji proyek Yaya Library (UJ-01 sampai UJ-15)
-- Jalankan SETELAH p05_ddl_25430056.sql dan p06_data_25430056.sql.
-- Semua perubahan dibungkus transaksi dan dibatalkan (ROLLBACK) di akhir,
-- sehingga data sampel tetap sama dan uji dapat diulang.
-- Satu kali jalan (hasil ringkas), di Command Prompt / Shell XAMPP:
--   mysql -u root -p -f -N perpus_056 < "<jalur>\p06_uji_25430056.sql"
-- Opsi -f melanjutkan walau ada galat, -N menyembunyikan judul kolom.
-- Eksemplar cadangan yang tidak pernah dipinjam di data sampel:
--   BK-001-04, BK-002-03, BK-003-03, BK-004-03, BK-006-03, MJ-001-02,
--   BK-008-02, JR-001-02.
-- =====================================================================

USE perpus_056;
SET SESSION sql_safe_updates = 0;
START TRANSACTION;

-- ---------------------------------------------------------------------
-- UJ-01 (positif) peminjaman baru anggota aktif dengan dua koleksi (AB-05)
-- ---------------------------------------------------------------------
SELECT 'UJ-01 peminjaman baru, 2 koleksi (harus diterima, jumlah detail = 2)' AS skenario;
INSERT INTO peminjaman (no_peminjaman, tgl_pinjam, id_anggota, id_petugas)
VALUES ('PM-2610-0090', '2026-10-20',
        (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0001'),
        (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P02'));
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar, tarif_denda_detail_peminjaman)
SELECT p.id_peminjaman, e.id_eksemplar, 3000
FROM peminjaman p, eksemplar e
WHERE p.no_peminjaman = 'PM-2610-0090' AND e.kode_eksemplar IN ('BK-001-04', 'BK-002-03');
SELECT COUNT(*) AS jumlah_detail FROM detail_peminjaman d
JOIN peminjaman p ON p.id_peminjaman = d.id_peminjaman WHERE p.no_peminjaman = 'PM-2610-0090';

-- ---------------------------------------------------------------------
-- UJ-02 (positif) pengembalian tepat waktu: status kembali, tanggal terisi, denda 0 (AB-08)
-- ---------------------------------------------------------------------
SELECT 'UJ-02 pengembalian tepat waktu (harus diterima, 1 baris terubah)' AS skenario;
UPDATE detail_peminjaman
SET status_item_detail_peminjaman = 'kembali',
    tgl_kembali_detail_peminjaman = '2026-10-24',
    denda_detail_peminjaman = 0
WHERE id_peminjaman = (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0090')
  AND id_eksemplar = (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-001-04');
SELECT ROW_COUNT() AS baris_terubah;

-- ---------------------------------------------------------------------
-- UJ-03 (positif) koleksi hilang diganti dengan membayar harga koleksi (AB-12)
-- ---------------------------------------------------------------------
SELECT 'UJ-03 koleksi hilang, ganti rugi bayar Rp85.000 (harus diterima, 1 baris terubah)' AS skenario;
UPDATE detail_peminjaman
SET status_item_detail_peminjaman = 'hilang',
    jenis_ganti_rugi_detail_peminjaman = 'bayar',
    biaya_ganti_rugi_detail_peminjaman = 85000
WHERE id_peminjaman = (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0090')
  AND id_eksemplar = (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-002-03');
SELECT ROW_COUNT() AS baris_terubah;

-- ---------------------------------------------------------------------
-- UJ-04 (negatif) nomor peminjaman kembar -> ERROR 1062 (AB-05, uq_peminjaman_no)
-- ---------------------------------------------------------------------
SELECT 'UJ-04 nomor peminjaman kembar (harus ERROR 1062)' AS skenario;
INSERT INTO peminjaman (no_peminjaman, tgl_pinjam, id_anggota, id_petugas)
VALUES ('PM-2609-0001', '2026-10-21',
        (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0002'),
        (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P02'));

-- ---------------------------------------------------------------------
-- UJ-05 (negatif) NIM anggota kembar -> ERROR 1062 (AB-01, uq_anggota_nim)
-- ---------------------------------------------------------------------
SELECT 'UJ-05 NIM kembar (harus ERROR 1062)' AS skenario;
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, tgl_daftar_anggota)
VALUES ('YL-0099', '24110101', 'NIM Kembar', 'Manajemen', '081300000099', '2026-10-01');

-- ---------------------------------------------------------------------
-- UJ-06 (negatif) nomor anggota berformat salah -> ERROR 4025 (AB-01, ck_anggota_no)
-- ---------------------------------------------------------------------
SELECT 'UJ-06 no_anggota YL-12 (harus ERROR 4025)' AS skenario;
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, tgl_daftar_anggota)
VALUES ('YL-12', '24119999', 'Format Salah', 'Manajemen', '081300000098', '2026-10-01');

-- ---------------------------------------------------------------------
-- UJ-07 (negatif) status kembali tanpa tanggal kembali -> ERROR 4025 (AB-08)
-- ---------------------------------------------------------------------
SELECT 'UJ-07 status kembali tanpa tgl_kembali (harus ERROR 4025)' AS skenario;
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar, tarif_denda_detail_peminjaman, status_item_detail_peminjaman)
SELECT p.id_peminjaman, e.id_eksemplar, 3000, 'kembali'
FROM peminjaman p, eksemplar e WHERE p.no_peminjaman = 'PM-2610-0090' AND e.kode_eksemplar = 'BK-003-03';

-- ---------------------------------------------------------------------
-- UJ-08 (negatif) status hilang tanpa jenis ganti rugi -> ERROR 4025 (AB-12)
-- ---------------------------------------------------------------------
SELECT 'UJ-08 status hilang tanpa jenis ganti rugi (harus ERROR 4025)' AS skenario;
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar, tarif_denda_detail_peminjaman, status_item_detail_peminjaman)
SELECT p.id_peminjaman, e.id_eksemplar, 3000, 'hilang'
FROM peminjaman p, eksemplar e WHERE p.no_peminjaman = 'PM-2610-0090' AND e.kode_eksemplar = 'BK-003-03';

-- ---------------------------------------------------------------------
-- UJ-09 (negatif) biaya terisi padahal jenis bukan bayar -> ERROR 4025 (AB-12)
-- ---------------------------------------------------------------------
SELECT 'UJ-09 biaya terisi dengan jenis koleksi sama (harus ERROR 4025)' AS skenario;
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar, tarif_denda_detail_peminjaman,
                               status_item_detail_peminjaman, jenis_ganti_rugi_detail_peminjaman,
                               biaya_ganti_rugi_detail_peminjaman)
SELECT p.id_peminjaman, e.id_eksemplar, 3000, 'hilang', 'koleksi sama', 50000
FROM peminjaman p, eksemplar e WHERE p.no_peminjaman = 'PM-2610-0090' AND e.kode_eksemplar = 'BK-003-03';

-- ---------------------------------------------------------------------
-- UJ-10 (negatif) peminjaman oleh petugas tidak dikenal -> ERROR 1452 (fk_peminjaman_petugas)
-- ---------------------------------------------------------------------
SELECT 'UJ-10 petugas tidak dikenal (harus ERROR 1452)' AS skenario;
INSERT INTO peminjaman (no_peminjaman, tgl_pinjam, id_anggota, id_petugas)
VALUES ('PM-2610-0093', '2026-10-21',
        (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0002'), 99);

-- ---------------------------------------------------------------------
-- UJ-11 (negatif) hapus anggota yang punya peminjaman -> ERROR 1451 (fk_peminjaman_anggota)
-- ---------------------------------------------------------------------
SELECT 'UJ-11 hapus anggota yang punya peminjaman (harus ERROR 1451)' AS skenario;
DELETE FROM anggota WHERE no_anggota = 'YL-0001';

-- ---------------------------------------------------------------------
-- UJ-12 (negatif) awalan kode koleksi tidak sesuai jenis -> ERROR 4025 (AB-03, ck_koleksi_awalan)
-- ---------------------------------------------------------------------
SELECT 'UJ-12 kode MJ-009 untuk jenis buku (harus ERROR 4025)' AS skenario;
INSERT INTO koleksi (kode_koleksi, judul_koleksi, jenis_koleksi, penulis_koleksi, penerbit_koleksi,
                     tahun_terbit_koleksi, harga_koleksi)
VALUES ('MJ-009', 'Awalan Salah', 'buku', 'Penulis Uji', 'Penerbit Uji', 2024, 50000);

-- ---------------------------------------------------------------------
-- UJ-13 (negatif) UPDATE tanpa WHERE di mode aman -> ERROR 1175
-- ---------------------------------------------------------------------
SELECT 'UJ-13 UPDATE tanpa WHERE, mode aman (harus ERROR 1175)' AS skenario;
SET SESSION sql_safe_updates = 1;
UPDATE koleksi SET harga_koleksi = harga_koleksi * 1.1;
SET SESSION sql_safe_updates = 0;

-- ---------------------------------------------------------------------
-- UJ-14 (GAGAL) peminjaman dengan 6 koleksi, melebihi batas P + 2 = 5 (AB-05)
-- ---------------------------------------------------------------------
SELECT 'UJ-14 peminjaman 6 koleksi (seharusnya ditolak, hasilnya diterima)' AS skenario;
INSERT INTO peminjaman (no_peminjaman, tgl_pinjam, id_anggota, id_petugas)
VALUES ('PM-2610-0091', '2026-10-21',
        (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0003'),
        (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P03'));
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar, tarif_denda_detail_peminjaman)
SELECT p.id_peminjaman, e.id_eksemplar, 3000
FROM peminjaman p, eksemplar e
WHERE p.no_peminjaman = 'PM-2610-0091'
  AND e.kode_eksemplar IN ('BK-003-03', 'BK-004-03', 'BK-006-03', 'MJ-001-02', 'BK-008-02', 'JR-001-02');
SELECT COUNT(*) AS jumlah_detail FROM detail_peminjaman d
JOIN peminjaman p ON p.id_peminjaman = d.id_peminjaman WHERE p.no_peminjaman = 'PM-2610-0091';

-- ---------------------------------------------------------------------
-- UJ-15 (GAGAL) anggota nonaktif meminjam (AB-02)
-- ---------------------------------------------------------------------
SELECT 'UJ-15 anggota nonaktif YL-0012 meminjam (seharusnya ditolak, hasilnya diterima)' AS skenario;
INSERT INTO peminjaman (no_peminjaman, tgl_pinjam, id_anggota, id_petugas)
VALUES ('PM-2610-0092', '2026-10-21',
        (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0012'),
        (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P02'));
SELECT p.no_peminjaman, a.no_anggota, a.status_anggota
FROM peminjaman p JOIN anggota a ON a.id_anggota = p.id_anggota
WHERE p.no_peminjaman = 'PM-2610-0092';

ROLLBACK;
SELECT 'Selesai. ROLLBACK dijalankan, data sampel tidak berubah.' AS keterangan;
