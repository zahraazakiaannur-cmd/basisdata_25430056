-- =====================================================================
-- p06_data_25430056.sql
-- Praktikum Basis Data - Pertemuan 6: data sampel proyek Yaya Library
-- Nama: Zahra Zakia An Nur | NPM: 25430056 | Basis data: perpus_056
-- Jalankan SETELAH p05_ddl_25430056.sql (tabel kosong).
-- Urutan: induk (anggota, petugas, koleksi, tarif_denda), lalu eksemplar,
-- peminjaman, detail_peminjaman. Kunci tamu diambil lewat kode alami
-- (subkueri), bukan menebak nilai AUTO_INCREMENT.
-- Parameter P = 3: 10 x P = 30 peminjaman pada 12 tanggal berbeda,
-- tarif denda berlaku Rp3.000 per hari (P ribu), batas 5 koleksi (P + 2).
-- Tanggal acuan data: 25-10-2026 (jatuh tempo = tgl_pinjam + 7 hari, AB-06).
-- =====================================================================

USE perpus_056;

-- 1. Anggota (11 aktif, 1 nonaktif)
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, tgl_daftar_anggota, status_anggota) VALUES
  ('YL-0001', '24110101', 'Aulia Rahmawati', 'Sistem Informasi', '081310010001', '2024-08-12', 'aktif'),
  ('YL-0002', '24110102', 'Bagas Prasetyo', 'Teknik Informatika', '081310010002', '2024-08-12', 'aktif'),
  ('YL-0003', '24110203', 'Citra Maharani', 'Manajemen', '081310010003', '2024-09-03', 'aktif'),
  ('YL-0004', '24110204', 'Dewangga Putra', 'Akuntansi', '081310010004', '2024-09-03', 'aktif'),
  ('YL-0005', '25110105', 'Elvira Salsabila', 'Sistem Informasi', '081310010005', '2025-08-18', 'aktif'),
  ('YL-0006', '25110106', 'Farhan Ghifari', 'Teknik Informatika', '081310010006', '2025-08-18', 'aktif'),
  ('YL-0007', '25110207', 'Gita Permatasari', 'Manajemen', '081310010007', '2025-09-01', 'aktif'),
  ('YL-0008', '25110208', 'Hafidz Maulana', 'Akuntansi', '081310010008', '2025-09-01', 'aktif'),
  ('YL-0009', '26110109', 'Intan Kusumawardani', 'Sistem Informasi', '081310010009', '2026-02-09', 'aktif'),
  ('YL-0010', '26110110', 'Jovan Anggara', 'Teknik Informatika', '081310010010', '2026-02-09', 'aktif'),
  ('YL-0011', '26110211', 'Kirana Ayuningtyas', 'Manajemen', '081310010011', '2026-08-17', 'aktif'),
  ('YL-0012', '23110112', 'Lukman Hakim', 'Akuntansi', '081310010012', '2023-08-14', 'nonaktif');

-- 2. Petugas (1 kepala perpustakaan, 4 petugas)
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
  ('P01', 'Hendra Wijaya', 'kepala perpustakaan'),
  ('P02', 'Ratna Kartika', 'petugas'),
  ('P03', 'Yoga Pratama', 'petugas'),
  ('P04', 'Siti Nurhaliza', 'petugas'),
  ('P05', 'Aditya Firmansyah', 'petugas');

-- 3. Koleksi (8 buku, 2 majalah, 2 jurnal)
INSERT INTO koleksi (kode_koleksi, judul_koleksi, jenis_koleksi, penulis_koleksi, penerbit_koleksi, tahun_terbit_koleksi, harga_koleksi) VALUES
  ('BK-001', 'Dasar-Dasar Basis Data', 'buku', 'R. Mahendra', 'Penerbit Nusantara Ilmu', 2022, 95000),
  ('BK-002', 'Pemrograman Python untuk Pemula', 'buku', 'A. Setiawan', 'Cahaya Digital', 2021, 85000),
  ('BK-003', 'Jaringan Komputer Modern', 'buku', 'L. Pradipta', 'Penerbit Nusantara Ilmu', 2020, 110000),
  ('BK-004', 'Statistika Terapan', 'buku', 'M. Kusuma', 'Gema Akademika', 2019, 90000),
  ('BK-005', 'Pengantar Ekonomi Mikro', 'buku', 'S. Wardhani', 'Gema Akademika', 2018, 80000),
  ('BK-006', 'Struktur Data dan Algoritma', 'buku', 'D. Anggara', 'Cahaya Digital', 2023, 125000),
  ('BK-007', 'Manajemen Proyek Perangkat Lunak', 'buku', 'T. Handayani', 'Penerbit Nusantara Ilmu', 2022, 105000),
  ('BK-008', 'Kalkulus Dasar', 'buku', 'B. Santosa', 'Gema Akademika', 2017, 70000),
  ('MJ-001', 'Majalah Teknologi Kampus Edisi Tahunan', 'majalah', 'Redaksi Teknologi Kampus', 'Media Cakrawala', 2025, 45000),
  ('MJ-002', 'Majalah Sains Populer', 'majalah', 'Redaksi Sains Populer', 'Media Cakrawala', 2024, 40000),
  ('JR-001', 'Jurnal Sistem Informasi Terapan Vol. 12', 'jurnal', 'Tim Editor JSIT', 'Program Studi Sistem Informasi', 2025, 60000),
  ('JR-002', 'Jurnal Rekayasa Data Vol. 8', 'jurnal', 'Tim Editor JRD', 'Program Studi Teknik Informatika', 2024, 55000);

-- 4. Tarif denda: riwayat kenaikan tahunan, tarif berlaku saat ini Rp3.000 (P = 3)
INSERT INTO tarif_denda (kode_tarif_denda, nominal_tarif_denda, berlaku_mulai_tarif_denda) VALUES
  ('TD-2022', 1000, '2022-01-01'),
  ('TD-2023', 1500, '2023-01-01'),
  ('TD-2024', 2000, '2024-01-01'),
  ('TD-2025', 2500, '2025-01-01'),
  ('TD-2026', 3000, '2026-01-01');

-- 5. Eksemplar (30). Status akhir mengikuti riwayat peminjaman di bawah.
-- Delapan eksemplar tidak pernah dipinjam dan dicadangkan untuk skenario uji:
-- BK-001-04, BK-002-03, BK-003-03, BK-004-03, BK-006-03, MJ-001-02, BK-008-02, JR-001-02.
INSERT INTO eksemplar (kode_eksemplar, id_koleksi, status_eksemplar) VALUES
  ('BK-001-01', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-001'), 'dipinjam'),
  ('BK-001-02', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-001'), 'hilang'),
  ('BK-001-03', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-001'), 'dipinjam'),
  ('BK-001-04', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-001'), 'tersedia'),
  ('BK-002-01', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-002'), 'dipinjam'),
  ('BK-002-02', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-002'), 'dipinjam'),
  ('BK-002-03', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-002'), 'tersedia'),
  ('BK-003-01', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-003'), 'dipinjam'),
  ('BK-003-02', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-003'), 'tersedia'),
  ('BK-003-03', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-003'), 'tersedia'),
  ('BK-004-01', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-004'), 'dipinjam'),
  ('BK-004-02', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-004'), 'dipinjam'),
  ('BK-004-03', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-004'), 'tersedia'),
  ('BK-005-01', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-005'), 'dipinjam'),
  ('BK-005-02', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-005'), 'dipinjam'),
  ('BK-006-01', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-006'), 'dipinjam'),
  ('BK-006-02', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-006'), 'hilang'),
  ('BK-006-03', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-006'), 'tersedia'),
  ('BK-007-01', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-007'), 'dipinjam'),
  ('BK-007-02', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-007'), 'tersedia'),
  ('BK-008-01', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-008'), 'tersedia'),
  ('BK-008-02', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'BK-008'), 'tersedia'),
  ('MJ-001-01', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'MJ-001'), 'dipinjam'),
  ('MJ-001-02', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'MJ-001'), 'tersedia'),
  ('MJ-002-01', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'MJ-002'), 'dipinjam'),
  ('MJ-002-02', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'MJ-002'), 'dipinjam'),
  ('JR-001-01', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'JR-001'), 'tersedia'),
  ('JR-001-02', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'JR-001'), 'tersedia'),
  ('JR-002-01', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'JR-002'), 'tersedia'),
  ('JR-002-02', (SELECT id_koleksi FROM koleksi WHERE kode_koleksi = 'JR-002'), 'dipinjam');

-- 6. Peminjaman (30), diurutkan menurut tanggal
INSERT INTO peminjaman (no_peminjaman, tgl_pinjam, id_anggota, id_petugas) VALUES
  ('PM-2609-0001', '2026-09-07', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0009'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P01')),
  ('PM-2609-0002', '2026-09-07', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0006'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P05')),
  ('PM-2609-0003', '2026-09-07', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0004'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P01')),
  ('PM-2609-0004', '2026-09-08', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0004'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P02')),
  ('PM-2609-0005', '2026-09-08', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0003'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P04')),
  ('PM-2609-0006', '2026-09-14', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0004'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P05')),
  ('PM-2609-0007', '2026-09-14', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0008'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P03')),
  ('PM-2609-0008', '2026-09-14', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0010'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P01')),
  ('PM-2609-0009', '2026-09-15', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0009'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P04')),
  ('PM-2609-0010', '2026-09-15', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0005'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P02')),
  ('PM-2609-0011', '2026-09-21', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0001'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P05')),
  ('PM-2609-0012', '2026-09-21', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0005'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P05')),
  ('PM-2609-0013', '2026-09-21', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0007'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P02')),
  ('PM-2609-0014', '2026-09-28', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0010'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P02')),
  ('PM-2609-0015', '2026-09-28', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0003'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P05')),
  ('PM-2609-0016', '2026-09-28', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0006'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P02')),
  ('PM-2610-0001', '2026-10-05', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0002'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P02')),
  ('PM-2610-0002', '2026-10-05', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0010'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P01')),
  ('PM-2610-0003', '2026-10-05', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0007'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P05')),
  ('PM-2610-0004', '2026-10-06', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0009'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P04')),
  ('PM-2610-0005', '2026-10-06', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0002'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P03')),
  ('PM-2610-0006', '2026-10-12', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0006'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P04')),
  ('PM-2610-0007', '2026-10-12', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0007'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P01')),
  ('PM-2610-0008', '2026-10-12', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0003'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P02')),
  ('PM-2610-0009', '2026-10-19', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0001'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P04')),
  ('PM-2610-0010', '2026-10-19', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0010'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P01')),
  ('PM-2610-0011', '2026-10-22', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0008'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P03')),
  ('PM-2610-0012', '2026-10-22', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0010'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P01')),
  ('PM-2610-0013', '2026-10-23', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0002'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P02')),
  ('PM-2610-0014', '2026-10-23', (SELECT id_anggota FROM anggota WHERE no_anggota = 'YL-0006'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'P04'));

-- 7. Detail peminjaman. Tarif Rp3.000 disalin per baris (AB-10).
-- denda = hari terlambat x Rp3.000, diisi saat pengembalian (AB-09, AB-11).
-- Koleksi hilang: ganti rugi 'bayar' (biaya = harga koleksi) atau 'koleksi sama' (AB-12).
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar, tgl_kembali_detail_peminjaman, tarif_denda_detail_peminjaman, status_item_detail_peminjaman, jenis_ganti_rugi_detail_peminjaman, biaya_ganti_rugi_detail_peminjaman, denda_detail_peminjaman) VALUES
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0001'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'JR-002-01'), '2026-09-13', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0001'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-007-01'), '2026-09-16', 3000, 'kembali', NULL, NULL, 6000),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0002'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-005-02'), '2026-09-20', 3000, 'kembali', NULL, NULL, 18000),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0003'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-003-02'), '2026-09-13', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0003'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'JR-002-02'), '2026-09-14', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0003'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-001-01'), '2026-09-19', 3000, 'kembali', NULL, NULL, 15000),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0004'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-004-02'), '2026-09-13', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0005'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'JR-001-01'), '2026-09-17', 3000, 'kembali', NULL, NULL, 6000),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0006'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-004-01'), '2026-09-20', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0007'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-001-03'), '2026-09-16', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0008'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-006-02'), NULL, 3000, 'hilang', 'bayar', 125000, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0008'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-006-01'), '2026-09-18', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0008'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-007-02'), '2026-09-24', 3000, 'kembali', NULL, NULL, 9000),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0009'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-008-01'), '2026-09-29', 3000, 'kembali', NULL, NULL, 21000),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0009'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-003-01'), '2026-09-22', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0009'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'MJ-002-01'), '2026-09-18', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0010'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-004-02'), '2026-09-18', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0010'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-001-02'), '2026-09-19', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0010'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-003-02'), '2026-09-24', 3000, 'kembali', NULL, NULL, 6000),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0011'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'MJ-002-01'), '2026-09-23', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0011'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'JR-002-02'), '2026-10-04', 3000, 'kembali', NULL, NULL, 18000),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0012'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-001-01'), '2026-10-05', 3000, 'kembali', NULL, NULL, 21000),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0013'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'MJ-001-01'), '2026-10-06', 3000, 'kembali', NULL, NULL, 24000),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0014'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-001-02'), NULL, 3000, 'hilang', 'koleksi sama', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0014'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'JR-002-01'), '2026-10-04', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0014'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-002-02'), '2026-10-05', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0015'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'MJ-002-02'), '2026-10-07', 3000, 'kembali', NULL, NULL, 6000),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0015'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-005-01'), '2026-10-13', 3000, 'kembali', NULL, NULL, 24000),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0015'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-003-02'), '2026-09-30', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0016'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-003-01'), '2026-10-12', 3000, 'kembali', NULL, NULL, 21000),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0016'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'MJ-002-01'), '2026-10-01', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2609-0016'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-007-01'), '2026-10-10', 3000, 'kembali', NULL, NULL, 15000),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0001'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-004-02'), NULL, 3000, 'dipinjam', NULL, NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0002'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-002-01'), NULL, 3000, 'dipinjam', NULL, NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0003'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'JR-002-01'), '2026-10-20', 3000, 'kembali', NULL, NULL, 24000),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0003'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'JR-002-02'), '2026-10-19', 3000, 'kembali', NULL, NULL, 21000),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0004'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-003-02'), '2026-10-21', 3000, 'kembali', NULL, NULL, 24000),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0004'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'MJ-002-01'), '2026-10-11', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0005'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-005-02'), NULL, 3000, 'dipinjam', NULL, NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0005'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'JR-001-01'), '2026-10-12', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0006'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-004-01'), NULL, 3000, 'dipinjam', NULL, NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0006'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-001-01'), NULL, 3000, 'dipinjam', NULL, NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0007'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-001-03'), NULL, 3000, 'dipinjam', NULL, NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0007'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-007-02'), '2026-10-17', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0008'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-007-01'), '2026-10-14', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0008'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'MJ-002-02'), '2026-10-16', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0009'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-006-01'), NULL, 3000, 'dipinjam', NULL, NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0009'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-002-02'), NULL, 3000, 'dipinjam', NULL, NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0009'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'MJ-002-01'), NULL, 3000, 'dipinjam', NULL, NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0010'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'MJ-001-01'), NULL, 3000, 'dipinjam', NULL, NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0011'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'JR-002-01'), '2026-10-24', 3000, 'kembali', NULL, NULL, 0),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0012'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-007-01'), NULL, 3000, 'dipinjam', NULL, NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0012'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'JR-002-02'), NULL, 3000, 'dipinjam', NULL, NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0013'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-003-01'), NULL, 3000, 'dipinjam', NULL, NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0013'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'BK-005-01'), NULL, 3000, 'dipinjam', NULL, NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PM-2610-0014'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'MJ-002-02'), NULL, 3000, 'dipinjam', NULL, NULL, NULL);

-- 8. Jumlah baris per tabel
SELECT 'anggota' AS tabel, COUNT(*) AS jumlah_baris FROM anggota
UNION ALL SELECT 'petugas', COUNT(*) FROM petugas
UNION ALL SELECT 'koleksi', COUNT(*) FROM koleksi
UNION ALL SELECT 'tarif_denda', COUNT(*) FROM tarif_denda
UNION ALL SELECT 'eksemplar', COUNT(*) FROM eksemplar
UNION ALL SELECT 'peminjaman', COUNT(*) FROM peminjaman
UNION ALL SELECT 'detail_peminjaman', COUNT(*) FROM detail_peminjaman;

-- Tanggal peminjaman berbeda (minimal tiga)
SELECT COUNT(DISTINCT tgl_pinjam) AS jumlah_tanggal_berbeda FROM peminjaman;
