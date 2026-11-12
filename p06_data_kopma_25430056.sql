-- =====================================================================
-- p06_data_kopma_25430056.sql
-- Praktikum Basis Data - Pertemuan 6: data sampel Kopma
-- Nama: Zahra Zakia An Nur | NPM: 25430056 | Basis data: kopma_056
-- Jalankan SETELAH p05_ddl_kopma_25430056.sql (tabel kosong).
-- Urutan: induk dulu, anak kemudian. Kunci tamu diambil lewat kode alami
-- (subkueri), bukan menebak nilai AUTO_INCREMENT. Harga satuan nota
-- disalin dari harga jual barang saat itu (AB-04).
-- =====================================================================

USE kopma_056;

-- ---------------------------------------------------------------------
-- 1. Data induk
-- ---------------------------------------------------------------------
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
  ('K01', 'Dimas',        'kasir'),
  ('K02', 'Sari',         'kasir'),
  ('K03', 'Rina',         'kasir'),
  ('G01', 'Joko',         'gudang'),
  ('P01', 'Ketua Kopma',  'ketua');

INSERT INTO barang (kode_barang, nama_barang, kategori_barang,
                    harga_jual_barang, stok_barang, batas_min_stok_barang) VALUES
  ('ATK-001', 'Pulpen Gel 0.5',  'ATK',     4000, 120, 20),
  ('ATK-002', 'Buku Tulis 58',   'ATK',     6500,  80, 20),
  ('MNM-001', 'Air Mineral 600', 'minuman', 4000,  48, 24),
  ('MKN-001', 'Roti Cokelat',    'makanan', 5000,   6, 10),
  ('MKN-002', 'Wafer Cokelat',   'makanan', 3500,  40, 10),
  ('MNM-002', 'Teh Botol 350',   'minuman', 4500,  30, 12);

INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota,
                     no_hp_anggota, status_anggota) VALUES
  ('A-0457', '2326100457', 'Budi Santoso',     'Sistem Informasi',   '081234560457', 'aktif'),
  ('A-0458', '2326100458', 'Citra Lestari',    'Manajemen',          '081234560458', 'aktif'),
  ('A-0459', '2326100459', 'Fajar Nugroho',    'Teknik Informatika', '081234560459', 'aktif'),
  ('A-0460', '2226100460', 'Maya Anggraini',   'Akuntansi',          '081234560460', 'nonaktif'),
  ('A-0461', '2226100461', 'Teguh Wibisono',   'Manajemen',          '081234560461', 'nonaktif');

INSERT INTO pemasok (kode_pemasok, nama_pemasok, telepon_pemasok, alamat_pemasok) VALUES
  ('S01', 'CV Sinar Alat Tulis', '0721-481234', 'Jl. Pemuda No. 12'),
  ('S02', 'UD Segar Makmur',     '0721-482345', 'Jl. Merdeka No. 45');

-- ---------------------------------------------------------------------
-- 2. Nota penjualan (empat nota pada tiga tanggal berbeda)
-- ---------------------------------------------------------------------
INSERT INTO penjualan (no_nota_penjualan, tgl_jam_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES
  ('PJ-2609-0142', '2026-09-24 10:15:00',
     (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K03'),
     (SELECT id_anggota FROM anggota WHERE no_anggota = 'A-0457'), 30000),
  ('PJ-2609-0143', '2026-09-24 11:40:00',
     (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K01'),
     NULL, 10000),
  ('PJ-2609-0150', '2026-09-25 09:05:00',
     (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K02'),
     (SELECT id_anggota FROM anggota WHERE no_anggota = 'A-0461'), 20000),
  ('PJ-2610-0001', '2026-10-01 13:20:00',
     (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K01'),
     (SELECT id_anggota FROM anggota WHERE no_anggota = 'A-0458'), 25000);

-- Nota contoh Modul 2: jumlah Rp29.000, diskon 5% Rp1.450, total Rp27.550
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 3, b.harga_jual_barang
FROM penjualan p, barang b WHERE p.no_nota_penjualan = 'PJ-2609-0142' AND b.kode_barang = 'ATK-001';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 2, b.harga_jual_barang
FROM penjualan p, barang b WHERE p.no_nota_penjualan = 'PJ-2609-0142' AND b.kode_barang = 'ATK-002';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang
FROM penjualan p, barang b WHERE p.no_nota_penjualan = 'PJ-2609-0142' AND b.kode_barang = 'MNM-001';

-- Nota pembeli umum
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang
FROM penjualan p, barang b WHERE p.no_nota_penjualan = 'PJ-2609-0143' AND b.kode_barang = 'MKN-001';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang
FROM penjualan p, barang b WHERE p.no_nota_penjualan = 'PJ-2609-0143' AND b.kode_barang = 'MNM-001';

-- Nota anggota nonaktif (tanpa diskon, AB-02)
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 2, b.harga_jual_barang
FROM penjualan p, barang b WHERE p.no_nota_penjualan = 'PJ-2609-0150' AND b.kode_barang = 'ATK-002';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang
FROM penjualan p, barang b WHERE p.no_nota_penjualan = 'PJ-2609-0150' AND b.kode_barang = 'MKN-002';

-- Nota anggota aktif
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 5, b.harga_jual_barang
FROM penjualan p, barang b WHERE p.no_nota_penjualan = 'PJ-2610-0001' AND b.kode_barang = 'ATK-001';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang
FROM penjualan p, barang b WHERE p.no_nota_penjualan = 'PJ-2610-0001' AND b.kode_barang = 'MNM-002';

-- Kurangi stok sesuai qty yang terjual (kode_barang adalah kunci unik)
UPDATE barang SET stok_barang = stok_barang - 8 WHERE kode_barang = 'ATK-001';
UPDATE barang SET stok_barang = stok_barang - 4 WHERE kode_barang = 'ATK-002';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'MNM-001';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'MKN-001';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'MKN-002';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'MNM-002';

-- ---------------------------------------------------------------------
-- 3. Pembelian dari pemasok (diterima gudang, AB-11)
-- ---------------------------------------------------------------------
INSERT INTO pembelian (no_faktur_pembelian, tgl_pembelian, status_pembelian, id_pemasok, id_petugas) VALUES
  ('INV-0915', '2026-09-15', 'diterima',
     (SELECT id_pemasok FROM pemasok WHERE kode_pemasok = 'S01'),
     (SELECT id_petugas FROM petugas WHERE kode_petugas = 'G01')),
  ('FK-0922', '2026-09-22', 'diterima',
     (SELECT id_pemasok FROM pemasok WHERE kode_pemasok = 'S02'),
     (SELECT id_petugas FROM petugas WHERE kode_petugas = 'G01'));

INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian)
SELECT pb.id_pembelian, b.id_barang, 100, 2800
FROM pembelian pb, barang b WHERE pb.no_faktur_pembelian = 'INV-0915' AND b.kode_barang = 'ATK-001';
INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian)
SELECT pb.id_pembelian, b.id_barang, 60, 4500
FROM pembelian pb, barang b WHERE pb.no_faktur_pembelian = 'INV-0915' AND b.kode_barang = 'ATK-002';
INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian)
SELECT pb.id_pembelian, b.id_barang, 48, 2900
FROM pembelian pb, barang b WHERE pb.no_faktur_pembelian = 'FK-0922' AND b.kode_barang = 'MNM-001';
INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian)
SELECT pb.id_pembelian, b.id_barang, 24, 3400
FROM pembelian pb, barang b WHERE pb.no_faktur_pembelian = 'FK-0922' AND b.kode_barang = 'MKN-001';

-- ---------------------------------------------------------------------
-- 4. Jumlah baris per tabel
-- ---------------------------------------------------------------------
SELECT 'petugas' AS tabel, COUNT(*) AS jumlah_baris FROM petugas
UNION ALL SELECT 'barang', COUNT(*) FROM barang
UNION ALL SELECT 'anggota', COUNT(*) FROM anggota
UNION ALL SELECT 'pemasok', COUNT(*) FROM pemasok
UNION ALL SELECT 'penjualan', COUNT(*) FROM penjualan
UNION ALL SELECT 'detail_penjualan', COUNT(*) FROM detail_penjualan
UNION ALL SELECT 'pembelian', COUNT(*) FROM pembelian
UNION ALL SELECT 'detail_pembelian', COUNT(*) FROM detail_pembelian;
