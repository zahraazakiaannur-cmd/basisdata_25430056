# Normalisasi Proyek Yaya Library - Pertemuan 4

**Nama:** Zahra Zakia An Nur  
**NPM:** 25430056  
**Kelas:** B  
**Organisasi:** Yaya Library (Perpustakaan), basis data `perpus_056`

Titik awal normalisasi adalah dokumen sumber proyek dari Pertemuan 2: **Slip Peminjaman dan Pengembalian Yaya Library** (contoh PM-2610-0007). Kode AB mengacu pada `p02_kebutuhan_data_25430056.md`.

Pemetaan nama: pada kamus data P02, `tarif_denda_per_hari` dan `denda_item` bernama `tarif_denda_detail_peminjaman` dan `denda_detail_peminjaman` di ERD, mengikuti kebiasaan penamaan kolom tabel detail.

## 1. Titik awal: UNF dari slip peminjaman

Satu slip memuat satu transaksi peminjaman dan beberapa koleksi (grup berulang di dalam `{ }`). Kode koleksi tidak tercetak sendiri di slip, tetapi menjadi bagian dari kode eksemplar (BK-001-02 adalah eksemplar ke-2 dari BK-001).

```
SLIP_UNF (no_peminjaman, tgl_pinjam, kode_petugas, nama_petugas,
          no_anggota, nama_anggota, tgl_jatuh_tempo,
          { kode_eksemplar, kode_koleksi, judul_koleksi, jenis_koleksi,
            tgl_kembali, tarif_denda_per_hari, hari_terlambat, denda_item },
          jumlah_koleksi_dipinjam, total_denda)
```

## 2. Dependensi fungsional

Setiap dependensi diturunkan dari aturan bisnis Pertemuan 2, bukan dari contoh data.

| Kode | Dependensi fungsional | Aturan bisnis |
|---|---|---|
| FD1 | no_peminjaman → tgl_pinjam, kode_petugas, no_anggota | AB-05 (satu peminjaman punya satu nomor, satu tanggal, satu petugas); AB-02 (peminjam anggota aktif) |
| FD2 | kode_petugas → nama_petugas, peran_petugas | kamus data petugas |
| FD3 | no_anggota → nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, tgl_daftar_anggota, status_anggota | AB-01 (nomor anggota unik); AB-02 (status) |
| FD3b | nim_anggota → no_anggota | AB-01 (NIM unik, satu mahasiswa satu keanggotaan) |
| FD4 | kode_koleksi → judul_koleksi, jenis_koleksi, penulis_koleksi, penerbit_koleksi, tahun_terbit_koleksi, harga_koleksi | AB-03 |
| FD5 | kode_eksemplar → kode_koleksi, status_eksemplar | AB-03 (kode eksemplar unik, tiap eksemplar milik satu judul); AB-04 (status per eksemplar) |
| FD6 | (no_peminjaman, kode_eksemplar) → tgl_kembali, tarif_denda_per_hari, status_item, jenis_ganti_rugi, biaya_ganti_rugi, denda_item | AB-08 (tanggal kembali per koleksi); AB-10 (tarif per baris); AB-11 (denda dicatat); AB-12 (ganti rugi) |
| FD7 | kode_tarif_denda → nominal_tarif_denda, berlaku_mulai_tarif_denda | AB-10; PB-06 |
| FD8 | tgl_pinjam → tgl_jatuh_tempo | AB-06 (tgl_pinjam + 7 hari); turunan |
| FD9 | (tgl_jatuh_tempo, tgl_kembali) → hari_terlambat | AB-08, AB-09; turunan |
| FD10 | (hari_terlambat, tarif_denda_per_hari) → denda_item | AB-09; turunan |

Dependensi yang **tidak** berlaku:

- `no_peminjaman → tgl_kembali` salah, karena koleksi boleh dikembalikan sendiri-sendiri, sehingga tanggal kembali berbeda per koleksi (AB-08).
- `kode_koleksi → tarif_denda_per_hari` dan `kode_eksemplar → tarif_denda_per_hari` salah, karena tarif yang berlaku saat transaksi dibekukan per baris dan dapat berbeda antartransaksi (AB-10).
- `judul_koleksi → kode_koleksi` salah, karena satu judul dapat tercatat dengan kode berbeda (isu kualitas data nomor 9).
- `tgl_kembali → status_item` salah, karena koleksi yang hilang tidak punya tanggal kembali, tetapi statusnya tetap tercatat (AB-12).

Catatan `biaya_ganti_rugi`: nilainya sama dengan `harga_koleksi` bila `jenis_ganti_rugi` adalah bayar (AB-12). Nilai ini disalin dari harga koleksi pada saat penggantian dicatat, sehingga bergantung pada kejadian (peminjaman dan eksemplar tertentu), bukan hanya pada jenisnya. Harga koleksi tetap berada di `koleksi`.

## 3. Tahapan normalisasi

### 1NF

Grup berulang dihilangkan: satu baris untuk setiap koleksi di setiap peminjaman. Kunci primer menjadi komposit `(no_peminjaman, kode_eksemplar)`.

```
SLIP_1NF (no_peminjaman, kode_eksemplar, tgl_pinjam, kode_petugas, nama_petugas,
          no_anggota, nama_anggota, tgl_jatuh_tempo, kode_koleksi, judul_koleksi,
          jenis_koleksi, tgl_kembali, tarif_denda_per_hari, hari_terlambat,
          denda_item, jumlah_koleksi_dipinjam, total_denda)
```

Anomali pada `SLIP_1NF`: nama anggota dan judul koleksi tertulis di setiap baris (anomali ubah), koleksi atau anggota baru tidak dapat dicatat sebelum ada peminjaman (anomali sisip), dan menghapus satu-satunya peminjaman sebuah eksemplar menghilangkan data eksemplar dan judulnya (anomali hapus).

### 2NF

Beberapa atribut bergantung pada sebagian kunci komposit: FD1 (dan FD2, FD3 lewat FD1) hanya pada `no_peminjaman`, serta FD4 dan FD5 hanya pada `kode_eksemplar`. Relasi dipisah. Atribut yang tidak tercetak di slip dilengkapi dari kamus data ke relasi pemiliknya, seperti pada Kopma.

```
PEMINJAMAN_2NF (no_peminjaman, tgl_pinjam, kode_petugas, nama_petugas, peran_petugas,
                no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota,
                tgl_daftar_anggota, status_anggota)
EKSEMPLAR_2NF (kode_eksemplar, status_eksemplar, kode_koleksi, judul_koleksi,
               jenis_koleksi, penulis_koleksi, penerbit_koleksi,
               tahun_terbit_koleksi, harga_koleksi)
DETAIL_PEMINJAMAN (no_peminjaman, kode_eksemplar, tgl_kembali, tarif_denda_per_hari,
                   status_item, jenis_ganti_rugi, biaya_ganti_rugi, denda_item)
TARIF_DENDA (kode_tarif_denda, nominal_tarif_denda, berlaku_mulai_tarif_denda)
```

### 3NF

Rantai transitif yang masih ada:

- `no_peminjaman → kode_petugas → nama_petugas, peran_petugas`
- `no_peminjaman → no_anggota → nama_anggota, prodi_anggota, no_hp_anggota, ...`
- `kode_eksemplar → kode_koleksi → judul_koleksi, jenis_koleksi, ...`

Ketiganya dipisah menjadi relasi sendiri.

```
PEMINJAMAN (no_peminjaman, tgl_pinjam, kode_petugas*, no_anggota*)
PETUGAS (kode_petugas, nama_petugas, peran_petugas)
ANGGOTA (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota,
         tgl_daftar_anggota, status_anggota)
KOLEKSI (kode_koleksi, judul_koleksi, jenis_koleksi, penulis_koleksi,
         penerbit_koleksi, tahun_terbit_koleksi, harga_koleksi)
EKSEMPLAR (kode_eksemplar, kode_koleksi*, status_eksemplar)
DETAIL_PEMINJAMAN (no_peminjaman*, kode_eksemplar*, tgl_kembali, tarif_denda_per_hari,
                   status_item, jenis_ganti_rugi, biaya_ganti_rugi, denda_item)
TARIF_DENDA (kode_tarif_denda, nominal_tarif_denda, berlaku_mulai_tarif_denda)
```

(Garis bawah kunci primer, tanda `*` kunci tamu.)

### Pemeriksaan BCNF

| Tabel | Penentu | Kunci kandidat? | Hasil |
|---|---|---|---|
| anggota | id_anggota, no_anggota, nim_anggota | Ya, ketiganya | BCNF (`nama_anggota` bukan penentu, karena tidak unik) |
| petugas | id_petugas, kode_petugas | Ya, keduanya | BCNF |
| koleksi | id_koleksi, kode_koleksi | Ya, keduanya | BCNF (`judul_koleksi` bukan penentu) |
| eksemplar | id_eksemplar, kode_eksemplar | Ya, keduanya | BCNF (`id_koleksi` bukan penentu atribut lain) |
| peminjaman | id_peminjaman, no_peminjaman | Ya, keduanya | BCNF |
| detail_peminjaman | (id_peminjaman, id_eksemplar) | Ya | BCNF |
| tarif_denda | id_tarif_denda, kode_tarif_denda | Ya, keduanya | BCNF |

Jika dua tarif tidak boleh mulai berlaku pada tanggal yang sama, `berlaku_mulai_tarif_denda` juga kunci kandidat, dan tabel tetap BCNF.

Catatan `detail_peminjaman`: `denda_item` dapat dihitung dari `tgl_kembali`, `tarif_denda_per_hari`, dan `tgl_pinjam`, tetapi `tgl_pinjam` berada di `peminjaman`, sehingga di dalam `detail_peminjaman` tidak ada penentu bukan kunci. Menyimpan denda adalah keputusan nilai turunan (bagian 4), bukan pelanggaran bentuk normal.

## 4. Keputusan nilai turunan

| Nilai turunan | Keputusan | Alasan |
|---|---|---|
| jumlah_koleksi_dipinjam | Dihitung (COUNT baris detail per peminjaman) | Disimpan akan bisa tidak sinkron dengan jumlah baris detail; batas 5 koleksi (AB-05) dijaga oleh constraint dan transaksi di modul lanjutan |
| tgl_jatuh_tempo | Dihitung (tgl_pinjam + 7 hari, AB-06) | Semua masukannya sudah tersimpan, dan nilainya hanya dipakai untuk menghitung hari terlambat dan mencari koleksi yang lewat batas kembali (KI-03) |
| hari_terlambat | Dihitung (tgl_kembali, atau tanggal hari ini bila belum kembali, dikurangi jatuh tempo, minimal 0) | Murni selisih tanggal; tidak ada fakta baru yang perlu dibekukan |
| denda_item | **Disimpan** per baris detail | Keputusan yang saya tunda dari Pertemuan 2. Denda dibayar tunai saat pengembalian dan dicatat petugas (AB-11), sehingga nominal yang ditagih adalah fakta keuangan yang terjadi pada saat itu. Tarif sudah dibekukan (AB-10), tetapi lama pinjam (AB-06) adalah kebijakan yang dapat berubah dan tidak dibekukan per transaksi; jika dihitung ulang kelak, jatuh tempo dan denda transaksi lama ikut bergeser. KI-04 juga cukup dijawab dari `detail_peminjaman` saja. Risikonya adalah nilai tidak sinkron bila `tgl_kembali` dikoreksi, sehingga `denda_item` diisi bersamaan dengan `tgl_kembali` dalam satu transaksi |
| total_denda per peminjaman dan per bulan | Dihitung (SUM denda_item) | Jumlah dari denda per baris; KI-04 dijawab dengan kueri |
| status_eksemplar | **Disimpan** (bukan turunan murni) | Memuat keadaan seperti hilang yang tidak dapat ditebak dari riwayat pinjam, dan dipakai langsung di KI-05; harus diperbarui bersamaan dengan baris detail (dibahas di modul transaksi) |
| biaya_ganti_rugi | **Disimpan** | Nominal yang benar-benar dibayar anggota (AB-12), disalin dari harga koleksi saat tercatat, sehingga tidak berubah bila harga koleksi kemudian dikoreksi |

## 5. Skema relasional akhir (3NF, BCNF)

| Tabel | Kunci primer | Kunci unik | Kunci tamu |
|---|---|---|---|
| anggota | id_anggota | no_anggota, nim_anggota | - |
| petugas | id_petugas | kode_petugas | - |
| koleksi | id_koleksi | kode_koleksi | - |
| eksemplar | id_eksemplar | kode_eksemplar | id_koleksi |
| peminjaman | id_peminjaman | no_peminjaman | id_anggota, id_petugas |
| detail_peminjaman | (id_peminjaman, id_eksemplar) | - | id_peminjaman, id_eksemplar |
| tarif_denda | id_tarif_denda | kode_tarif_denda | - |

## 6. Perubahan pada ERD proyek

| No | Perubahan | Alasan |
|---|---|---|
| 1 | Kolom `denda_detail_peminjaman` ditambahkan pada `detail_peminjaman` | Keputusan menyimpan denda per baris (bagian 4). Pada ERD Pertemuan 3, denda tidak digambar karena keputusannya ditunda ke Pertemuan 4 |
| 2 | Legenda ERD diperbarui: atribut turunan yang tidak digambar tinggal `jumlah_koleksi_dipinjam`, `tgl_jatuh_tempo`, dan `hari_terlambat` | Mengikuti keputusan nomor 1 |
| 3 | Struktur tabel dan relasi lain tidak berubah | Seluruh tabel sudah memenuhi 3NF dan BCNF |

Normalisasi ini menjadi dasar skrip DDL Pertemuan 5. Setiap kunci unik, kunci tamu, dan aturan di atas harus muncul sebagai constraint.
