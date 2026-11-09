-- =====================================================================
-- p05_ddl_kopma_25430056.sql
-- Praktikum Basis Data - Pertemuan 5: DDL dan Constraint (Kopma)
-- Nama: Zahra Zakia An Nur | NPM: 25430056 | Basis data: kopma_056
-- Dapat dijalankan ulang dari basis data kosong (DROP TABLE IF EXISTS
-- dengan urutan anak ke induk di bagian awal).
-- Kode AB-xx merujuk p02_kebutuhan_data_kopma_25430056.md.
-- Pola nama constraint: pk_, fk_, uq_, ck_ + nama tabel.
-- Tabel tidak diberi CHARACTER SET sendiri: mewarisi collation basis data.
-- =====================================================================

USE kopma_056;

-- ---------------------------------------------------------------------
-- 0. Hapus tabel lama (urutan anak ke induk)
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS detail_pembelian;
DROP TABLE IF EXISTS detail_penjualan;
DROP TABLE IF EXISTS pembelian;
DROP TABLE IF EXISTS penjualan;
DROP TABLE IF EXISTS pemasok;
DROP TABLE IF EXISTS barang;
DROP TABLE IF EXISTS anggota;
DROP TABLE IF EXISTS petugas;

-- ---------------------------------------------------------------------
-- 1. Tabel induk (tanpa kunci tamu)
-- ---------------------------------------------------------------------

CREATE TABLE petugas (
  id_petugas    SMALLINT                      NOT NULL AUTO_INCREMENT,
  kode_petugas  CHAR(3)                       NOT NULL,
  nama_petugas  VARCHAR(100)                  NOT NULL,
  peran_petugas ENUM('kasir','gudang','ketua') NOT NULL,
  CONSTRAINT pk_petugas PRIMARY KEY (id_petugas),
  UNIQUE KEY uq_petugas_kode (kode_petugas)
) ENGINE=InnoDB;

CREATE TABLE anggota (
  id_anggota     INT                  NOT NULL AUTO_INCREMENT,
  no_anggota     CHAR(6)              NOT NULL,        -- format A-0457
  nim_anggota    CHAR(10)             NOT NULL,        -- 10 digit
  nama_anggota   VARCHAR(100)         NOT NULL,
  prodi_anggota  VARCHAR(60)          NOT NULL,
  no_hp_anggota  VARCHAR(15)          NULL,            -- DATA PRIBADI: hanya ketua
  status_anggota ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',  -- AB-02
  CONSTRAINT pk_anggota PRIMARY KEY (id_anggota),
  UNIQUE KEY uq_anggota_no (no_anggota),
  UNIQUE KEY uq_anggota_nim (nim_anggota),    -- AB-05
  CONSTRAINT ck_anggota_no CHECK (no_anggota REGEXP '^A-[0-9]{4}$'),
  CONSTRAINT ck_anggota_nim CHECK (nim_anggota REGEXP '^[0-9]{10}$'),   -- AB-05
  CONSTRAINT ck_anggota_hp CHECK (no_hp_anggota IS NULL
                                  OR no_hp_anggota REGEXP '^[0-9]+$')
) ENGINE=InnoDB;

CREATE TABLE barang (
  id_barang           INT                              NOT NULL AUTO_INCREMENT,
  kode_barang         VARCHAR(10)                      NOT NULL,
  nama_barang         VARCHAR(100)                     NOT NULL,
  kategori_barang     ENUM('ATK','makanan','minuman')  NOT NULL,
  harga_jual_barang   DECIMAL(12,2)                    NOT NULL,
  stok_barang         INT                              NOT NULL DEFAULT 0,
  batas_min_stok_barang INT                            NOT NULL DEFAULT 5,   -- AB-06
  CONSTRAINT pk_barang PRIMARY KEY (id_barang),
  UNIQUE KEY uq_barang_kode (kode_barang),
  CONSTRAINT ck_barang_stok CHECK (stok_barang >= 0),             -- AB-03
  CONSTRAINT ck_barang_harga CHECK (harga_jual_barang >= 0)
) ENGINE=InnoDB;

CREATE TABLE pemasok (
  id_pemasok       INT          NOT NULL AUTO_INCREMENT,
  kode_pemasok     VARCHAR(10)  NOT NULL,
  nama_pemasok     VARCHAR(100) NOT NULL,
  telepon_pemasok  VARCHAR(20)  NULL,
  alamat_pemasok   VARCHAR(200) NULL,
  CONSTRAINT pk_pemasok PRIMARY KEY (id_pemasok),
  UNIQUE KEY uq_pemasok_kode (kode_pemasok)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. Tabel transaksi dengan kunci tamu
-- ---------------------------------------------------------------------

CREATE TABLE penjualan (
  id_penjualan       INT           NOT NULL AUTO_INCREMENT,
  no_nota_penjualan  CHAR(12)      NOT NULL,           -- format PJ-2609-0142
  tgl_jam_penjualan  DATETIME      NOT NULL,           -- KI-01 per hari
  id_petugas         SMALLINT      NOT NULL,           -- kasir wajib ada
  id_anggota         INT           NULL,               -- NULL = pembeli umum (AB-02)
  bayar_penjualan    DECIMAL(12,2) NOT NULL,           -- uang diterima (disimpan)
  CONSTRAINT pk_penjualan PRIMARY KEY (id_penjualan),
  UNIQUE KEY uq_penjualan_nota (no_nota_penjualan),    -- AB-01
  CONSTRAINT ck_penjualan_nota CHECK (no_nota_penjualan REGEXP '^PJ-[0-9]{4}-[0-9]{4}$'),
  CONSTRAINT ck_penjualan_bayar CHECK (bayar_penjualan >= 0),
  CONSTRAINT fk_penjualan_petugas FOREIGN KEY (id_petugas)
    REFERENCES petugas (id_petugas),
  CONSTRAINT fk_penjualan_anggota FOREIGN KEY (id_anggota)
    REFERENCES anggota (id_anggota)
) ENGINE=InnoDB;

CREATE TABLE detail_penjualan (
  id_penjualan                   INT           NOT NULL,
  id_barang                      INT           NOT NULL,
  qty_detail_penjualan           SMALLINT      NOT NULL,
  harga_satuan_detail_penjualan  DECIMAL(12,2) NOT NULL,   -- salinan harga saat transaksi (AB-04)
  CONSTRAINT pk_detail_penjualan PRIMARY KEY (id_penjualan, id_barang),
  CONSTRAINT fk_detail_penjualan_penjualan FOREIGN KEY (id_penjualan)
    REFERENCES penjualan (id_penjualan) ON DELETE CASCADE,
  CONSTRAINT fk_detail_penjualan_barang FOREIGN KEY (id_barang)
    REFERENCES barang (id_barang),
  CONSTRAINT ck_detail_penjualan_qty CHECK (qty_detail_penjualan > 0),    -- AB-03
  CONSTRAINT ck_detail_penjualan_harga CHECK (harga_satuan_detail_penjualan >= 0)  -- AB-04
) ENGINE=InnoDB;

CREATE TABLE pembelian (
  id_pembelian        INT          NOT NULL AUTO_INCREMENT,
  no_faktur_pembelian VARCHAR(30)  NOT NULL,           -- dari pemasok, tidak unik sendirian
  tgl_pembelian       DATE         NOT NULL,
  status_pembelian    ENUM('dipesan','diterima') NOT NULL DEFAULT 'dipesan',  -- AB-06
  id_pemasok          INT          NOT NULL,
  id_petugas          SMALLINT     NULL,               -- petugas penerima (AB-11)
  CONSTRAINT pk_pembelian PRIMARY KEY (id_pembelian),
  UNIQUE KEY uq_pembelian_pemasok_faktur (id_pemasok, no_faktur_pembelian),
  CONSTRAINT fk_pembelian_pemasok FOREIGN KEY (id_pemasok)
    REFERENCES pemasok (id_pemasok),
  CONSTRAINT fk_pembelian_petugas FOREIGN KEY (id_petugas)
    REFERENCES petugas (id_petugas)
) ENGINE=InnoDB;

CREATE TABLE detail_pembelian (
  id_pembelian                 INT           NOT NULL,
  id_barang                    INT           NOT NULL,
  qty_detail_pembelian         INT           NOT NULL,
  harga_beli_detail_pembelian  DECIMAL(12,2) NOT NULL,   -- harga modal per unit
  CONSTRAINT pk_detail_pembelian PRIMARY KEY (id_pembelian, id_barang),
  CONSTRAINT fk_detail_pembelian_pembelian FOREIGN KEY (id_pembelian)
    REFERENCES pembelian (id_pembelian) ON DELETE CASCADE,
  CONSTRAINT fk_detail_pembelian_barang FOREIGN KEY (id_barang)
    REFERENCES barang (id_barang),
  CONSTRAINT ck_detail_pembelian_qty CHECK (qty_detail_pembelian > 0),
  CONSTRAINT ck_detail_pembelian_harga CHECK (harga_beli_detail_pembelian >= 0)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 3. Periksa hasil
-- ---------------------------------------------------------------------
SHOW TABLES;
SHOW CREATE TABLE penjualan;

-- ---------------------------------------------------------------------
-- Aturan yang TIDAK dapat dijaga constraint (dikerjakan di Modul 14):
--  AB-01 minimal satu baris per nota (melibatkan banyak baris)
--  AB-02 diskon 5% hanya untuk anggota aktif (menyangkut tabel anggota)
--  AB-03 penjualan ditolak bila qty > stok (membandingkan dua tabel)
--  AB-04 harga di nota = harga barang saat transaksi (membaca tabel barang)
--  AB-06 pesanan dibuat bila stok < batas minimum (proses, bukan struktur)
--  AB-11 petugas penerima diisi saat status berubah menjadi diterima
-- ---------------------------------------------------------------------
