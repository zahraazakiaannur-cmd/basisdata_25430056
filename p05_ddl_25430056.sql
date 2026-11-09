-- =====================================================================
-- p05_ddl_25430056.sql
-- Praktikum Basis Data - Pertemuan 5: DDL dan Constraint (Yaya Library)
-- Nama: Zahra Zakia An Nur | NPM: 25430056 | Basis data: perpus_056
-- Dapat dijalankan ulang dari basis data kosong.
-- Kode AB-xx merujuk p02_kebutuhan_data_25430056.md.
-- Pola nama constraint: pk_, fk_, uq_, ck_ + nama tabel.
-- Parameter P = 3: batas item per transaksi P + 2 = 5, denda harian Rp3.000.
-- =====================================================================

USE perpus_056;

-- ---------------------------------------------------------------------
-- 0. Hapus tabel lama (urutan anak ke induk)
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS detail_peminjaman;
DROP TABLE IF EXISTS peminjaman;
DROP TABLE IF EXISTS eksemplar;
DROP TABLE IF EXISTS tarif_denda;
DROP TABLE IF EXISTS koleksi;
DROP TABLE IF EXISTS anggota;
DROP TABLE IF EXISTS petugas;

-- ---------------------------------------------------------------------
-- 1. Tabel induk (tanpa kunci tamu)
-- ---------------------------------------------------------------------

CREATE TABLE anggota (
  id_anggota          INT          NOT NULL AUTO_INCREMENT,
  no_anggota          CHAR(7)      NOT NULL,                 -- format YL-0123 (AB-01)
  nim_anggota         CHAR(8)      NOT NULL,                 -- 8 digit (AB-01)
  nama_anggota        VARCHAR(100) NOT NULL,
  prodi_anggota       VARCHAR(60)  NOT NULL,
  no_hp_anggota       VARCHAR(15)  NOT NULL,                 -- DATA PRIBADI: wajib, hanya angka
  tgl_daftar_anggota  DATE         NOT NULL,
  status_anggota      ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',   -- AB-02
  CONSTRAINT pk_anggota PRIMARY KEY (id_anggota),
  UNIQUE KEY uq_anggota_no (no_anggota),           -- AB-01
  UNIQUE KEY uq_anggota_nim (nim_anggota),         -- AB-01
  CONSTRAINT ck_anggota_no CHECK (no_anggota REGEXP '^YL-[0-9]{4}$'),   -- AB-01
  CONSTRAINT ck_anggota_nim CHECK (nim_anggota REGEXP '^[0-9]{8}$'),    -- AB-01
  CONSTRAINT ck_anggota_hp CHECK (no_hp_anggota REGEXP '^[0-9]+$')      -- isu kualitas 10
) ENGINE=InnoDB;

CREATE TABLE petugas (
  id_petugas     SMALLINT     NOT NULL AUTO_INCREMENT,
  kode_petugas   CHAR(3)      NOT NULL,                      -- contoh P02
  nama_petugas   VARCHAR(100) NOT NULL,
  peran_petugas  ENUM('petugas','kepala perpustakaan') NOT NULL,
  CONSTRAINT pk_petugas PRIMARY KEY (id_petugas),
  UNIQUE KEY uq_petugas_kode (kode_petugas)
) ENGINE=InnoDB;

CREATE TABLE koleksi (
  id_koleksi            INT           NOT NULL AUTO_INCREMENT,
  kode_koleksi          CHAR(6)       NOT NULL,              -- contoh BK-001
  judul_koleksi         VARCHAR(200)  NOT NULL,
  jenis_koleksi         ENUM('buku','majalah','jurnal') NOT NULL,   -- AB-03
  penulis_koleksi       VARCHAR(100)  NOT NULL,
  penerbit_koleksi      VARCHAR(100)  NOT NULL,
  tahun_terbit_koleksi  SMALLINT      NOT NULL,
  harga_koleksi         DECIMAL(12,0) NOT NULL,              -- rupiah bulat, dasar ganti rugi (AB-12)
  CONSTRAINT pk_koleksi PRIMARY KEY (id_koleksi),
  UNIQUE KEY uq_koleksi_kode (kode_koleksi),       -- AB-03
  CONSTRAINT ck_koleksi_kode CHECK (kode_koleksi REGEXP '^(BK|MJ|JR)-[0-9]{3}$'),
  CONSTRAINT ck_koleksi_awalan CHECK (                        -- awalan sesuai jenis (kamus data)
       (jenis_koleksi = 'buku'    AND LEFT(kode_koleksi, 2) = 'BK')
    OR (jenis_koleksi = 'majalah' AND LEFT(kode_koleksi, 2) = 'MJ')
    OR (jenis_koleksi = 'jurnal'  AND LEFT(kode_koleksi, 2) = 'JR')),
  CONSTRAINT ck_koleksi_tahun CHECK (tahun_terbit_koleksi BETWEEN 1000 AND 9999),  -- 4 digit
  CONSTRAINT ck_koleksi_harga CHECK (harga_koleksi >= 0)      -- AB-12
) ENGINE=InnoDB;

CREATE TABLE tarif_denda (
  id_tarif_denda            SMALLINT      NOT NULL AUTO_INCREMENT,
  kode_tarif_denda          VARCHAR(10)   NOT NULL,
  nominal_tarif_denda       DECIMAL(12,0) NOT NULL,          -- per hari per koleksi (AB-09)
  berlaku_mulai_tarif_denda DATE          NOT NULL,
  CONSTRAINT pk_tarif_denda PRIMARY KEY (id_tarif_denda),
  UNIQUE KEY uq_tarif_denda_kode (kode_tarif_denda),
  UNIQUE KEY uq_tarif_denda_mulai (berlaku_mulai_tarif_denda),  -- tarif baru = baris baru (AB-10)
  CONSTRAINT ck_tarif_denda_nominal CHECK (nominal_tarif_denda >= 0)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. Tabel dengan kunci tamu
-- ---------------------------------------------------------------------

CREATE TABLE eksemplar (
  id_eksemplar      INT         NOT NULL AUTO_INCREMENT,
  kode_eksemplar    CHAR(9)     NOT NULL,                    -- contoh BK-001-02
  id_koleksi        INT         NOT NULL,                    -- tiap eksemplar milik satu judul (AB-03)
  status_eksemplar  ENUM('tersedia','dipinjam','hilang') NOT NULL DEFAULT 'tersedia',  -- AB-04
  CONSTRAINT pk_eksemplar PRIMARY KEY (id_eksemplar),
  UNIQUE KEY uq_eksemplar_kode (kode_eksemplar),   -- AB-03
  CONSTRAINT ck_eksemplar_kode CHECK (kode_eksemplar REGEXP '^(BK|MJ|JR)-[0-9]{3}-[0-9]{2}$'),
  CONSTRAINT fk_eksemplar_koleksi FOREIGN KEY (id_koleksi)
    REFERENCES koleksi (id_koleksi) ON DELETE RESTRICT       -- koleksi hilang tetap tercatat
) ENGINE=InnoDB;

CREATE TABLE peminjaman (
  id_peminjaman  INT       NOT NULL AUTO_INCREMENT,
  no_peminjaman  CHAR(12)  NOT NULL,                         -- contoh PM-2610-0007
  tgl_pinjam     DATE      NOT NULL,
  id_anggota     INT       NOT NULL,                         -- peminjam wajib anggota (AB-02)
  id_petugas     SMALLINT  NOT NULL,                         -- petugas yang melayani (AB-05)
  CONSTRAINT pk_peminjaman PRIMARY KEY (id_peminjaman),
  UNIQUE KEY uq_peminjaman_no (no_peminjaman),     -- AB-05
  CONSTRAINT ck_peminjaman_no CHECK (no_peminjaman REGEXP '^PM-[0-9]{4}-[0-9]{4}$'),
  CONSTRAINT fk_peminjaman_anggota FOREIGN KEY (id_anggota)
    REFERENCES anggota (id_anggota) ON DELETE RESTRICT,      -- riwayat 5 tahun tidak boleh hilang
  CONSTRAINT fk_peminjaman_petugas FOREIGN KEY (id_petugas)
    REFERENCES petugas (id_petugas) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE detail_peminjaman (
  id_peminjaman                       INT           NOT NULL,
  id_eksemplar                        INT           NOT NULL,
  tgl_kembali_detail_peminjaman       DATE          NULL,    -- kosong bila belum kembali (AB-08)
  tarif_denda_detail_peminjaman       DECIMAL(12,0) NOT NULL,-- tarif beku saat transaksi (AB-10)
  status_item_detail_peminjaman       ENUM('dipinjam','kembali','hilang') NOT NULL DEFAULT 'dipinjam',
  jenis_ganti_rugi_detail_peminjaman  ENUM('koleksi sama','bayar') NULL,   -- hanya bila hilang (AB-12)
  biaya_ganti_rugi_detail_peminjaman  DECIMAL(12,0) NULL,    -- terisi bila jenis = bayar (AB-12)
  denda_detail_peminjaman             DECIMAL(12,0) NULL,    -- diisi saat pengembalian (AB-09, AB-11)
  CONSTRAINT pk_detail_peminjaman PRIMARY KEY (id_peminjaman, id_eksemplar),
  CONSTRAINT fk_detail_peminjaman_peminjaman FOREIGN KEY (id_peminjaman)
    REFERENCES peminjaman (id_peminjaman) ON DELETE RESTRICT,
  CONSTRAINT fk_detail_peminjaman_eksemplar FOREIGN KEY (id_eksemplar)
    REFERENCES eksemplar (id_eksemplar) ON DELETE RESTRICT,
  CONSTRAINT ck_detail_peminjaman_tarif CHECK (tarif_denda_detail_peminjaman >= 0),   -- AB-10
  CONSTRAINT ck_detail_peminjaman_denda CHECK (denda_detail_peminjaman IS NULL
                                               OR denda_detail_peminjaman >= 0),      -- AB-09
  CONSTRAINT ck_detail_peminjaman_biaya CHECK (biaya_ganti_rugi_detail_peminjaman IS NULL
                                               OR biaya_ganti_rugi_detail_peminjaman >= 0),
  -- status 'kembali' <=> tanggal kembali terisi (AB-08)
  CONSTRAINT ck_detail_peminjaman_kembali CHECK
    ((status_item_detail_peminjaman = 'kembali') = (tgl_kembali_detail_peminjaman IS NOT NULL)),
  -- jenis ganti rugi terisi <=> status hilang (AB-12, isu kualitas 11)
  CONSTRAINT ck_detail_peminjaman_hilang CHECK
    ((status_item_detail_peminjaman = 'hilang') = (jenis_ganti_rugi_detail_peminjaman IS NOT NULL)),
  -- biaya terisi <=> jenis ganti rugi = bayar (AB-12)
  CONSTRAINT ck_detail_peminjaman_ganti_rugi CHECK
    ((jenis_ganti_rugi_detail_peminjaman <=> 'bayar') = (biaya_ganti_rugi_detail_peminjaman IS NOT NULL))
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 3. Periksa hasil
-- ---------------------------------------------------------------------
SHOW TABLES;
SHOW CREATE TABLE detail_peminjaman;

-- ---------------------------------------------------------------------
-- Aturan yang TIDAK dapat dijaga constraint (dikerjakan di Modul 14):
--  AB-02 hanya anggota aktif boleh meminjam (membaca status di tabel anggota)
--  AB-04 hanya eksemplar tersedia boleh dipinjam (membaca status eksemplar)
--  AB-05 minimal 1 dan maksimal 5 koleksi per transaksi (P + 2 = 5):
--        menyangkut JUMLAH BARIS detail per peminjaman, sehingga CHECK
--        yang hanya melihat satu baris tidak dapat menjaganya
--  AB-06 jatuh tempo = tgl_pinjam + 7 hari (nilai turunan, dihitung)
--  AB-07 satu eksemplar tidak boleh ada di dua peminjaman terbuka
--        (melibatkan banyak baris)
--  AB-08 tgl_kembali tidak boleh lebih awal dari tgl_pinjam
--        (tgl_pinjam berada di tabel peminjaman, bukan di baris yang sama)
--  AB-09 denda = hari terlambat x tarif (perhitungan lintas tabel)
--  tgl_pinjam dan tgl_daftar_anggota tidak di masa depan; tahun terbit tidak
--  lebih dari tahun berjalan (bergantung waktu, diperiksa aplikasi/pemicu)
-- ---------------------------------------------------------------------
