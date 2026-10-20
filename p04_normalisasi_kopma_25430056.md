# Normalisasi Kopma - Pertemuan 4

**Nama:** Zahra Zakia An Nur  
**NPM:** 25430056  
**Kelas:** B  

Dokumen ini memuat semua tahap normalisasi Kopma (UNF sampai 3NF, pemeriksaan BCNF, keputusan nilai turunan) dari ERD Pertemuan 3.

## D.1 Dari UNF ke 1NF

Relasi spreadsheet lama dalam bentuk UNF. Satu nota menyimpan grup berulang barang (di dalam `{ }`).

```
NOTA_UNF (no_nota_penjualan, tgl_jam_penjualan, kode_petugas, nama_petugas,
          no_anggota, nama_anggota,
          { kode_barang, nama_barang, qty_detail_penjualan,
            harga_satuan_detail_penjualan, subtotal_detail_penjualan },
          jumlah_penjualan, diskon_penjualan, total_penjualan,
          bayar_penjualan, kembali_penjualan)
```

Grup berulang dihilangkan: satu baris untuk setiap barang di setiap nota. Kunci primer menjadi komposit `(no_nota_penjualan, kode_barang)`.

```
NOTA_1NF (no_nota_penjualan, kode_barang, tgl_jam_penjualan, kode_petugas,
          nama_petugas, no_anggota, nama_anggota, nama_barang,
          qty_detail_penjualan, harga_satuan_detail_penjualan,
          subtotal_detail_penjualan, jumlah_penjualan, diskon_penjualan,
          total_penjualan, bayar_penjualan, kembali_penjualan)
```

Tiga anomali yang muncul pada `NOTA_1NF`:

| Anomali | Contoh di Kopma |
|---|---|
| Ubah | Nama anggota tertulis di setiap baris barang pada setiap nota. Jika nama dikoreksi di satu baris saja, anggota yang sama punya dua nama. |
| Sisip | Barang baru yang belum pernah terjual tidak dapat dicatat, karena kunci tabel memerlukan nomor nota. |
| Hapus | Jika satu-satunya nota yang memuat sebuah barang dihapus, data nama barang ikut hilang. |

## D.2 Dependensi fungsional

Semua dependensi diturunkan dari aturan bisnis Pertemuan 2, bukan dari isi contoh data.

| Kode | Dependensi fungsional | Dasar |
|---|---|---|
| FD1 | no_nota_penjualan → tgl_jam_penjualan, kode_petugas, no_anggota, bayar_penjualan | AB-01 (satu nota satu nomor unik); AB-02 (anggota boleh kosong) |
| FD2 | kode_petugas → nama_petugas, peran_petugas | kamus data petugas |
| FD3 | no_anggota → nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota | kamus data anggota; AB-02 (status) |
| FD3b | nim_anggota → no_anggota | AB-05 (NIM unik; pencarian lewat nomor anggota atau NIM) |
| FD4 | kode_barang → nama_barang, kategori_barang, harga_jual_barang, stok_barang, batas_min_stok_barang | kamus data barang; AB-03 (stok); AB-06 (batas minimum) |
| FD5 | (no_nota_penjualan, kode_barang) → qty_detail_penjualan, harga_satuan_detail_penjualan | AB-04 |
| FD6 | qty_detail_penjualan, harga_satuan_detail_penjualan → subtotal_detail_penjualan | turunan |
| FD7 | (no_faktur_pembelian, kode_pemasok) → tgl_pembelian, kode_petugas_penerima | AB-06 (pesanan pembelian); AB-11 (petugas penerima) |
| FD8 | kode_pemasok → nama_pemasok, telepon_pemasok, alamat_pemasok | kamus data pemasok |
| FD9 | (no_faktur_pembelian, kode_pemasok, kode_barang) → qty_detail_pembelian, harga_beli_detail_pembelian | faktur pemasok |

Dependensi yang **tidak** berlaku:

- `kode_barang → harga_satuan_detail_penjualan` salah, karena AB-04 menyatakan harga di nota dapat berbeda dari harga barang saat ini.
- `no_anggota → diskon_penjualan` salah, karena diskon bergantung pada status anggota saat transaksi, bukan sifat tetap anggota.
- `no_faktur_pembelian → kode_pemasok` salah, karena dua pemasok bisa memakai nomor faktur yang sama.

**Titik Analisis 1.** FD5 menempatkan `harga_satuan_detail_penjualan` pada kunci `(no_nota_penjualan, kode_barang)` karena harga adalah salinan harga pada saat transaksi (AB-04). Satu barang bisa dijual dengan harga berbeda di nota yang berbeda, sehingga harga tidak ditentukan oleh `kode_barang` saja. Jika harga dipindah ke tabel `barang`, setiap perubahan harga ikut mengubah semua nota lama. Contoh ilustrasi: 100 pulpen terjual pada bulan lalu dengan harga Rp4.000 (omzet Rp400.000). Setelah harga naik menjadi Rp4.500, laporan omzet bulan lalu yang dihitung ulang menjadi Rp450.000, padahal uang yang benar-benar diterima Rp400.000. Omzet tahun lalu menjadi salah dan tidak dapat dipulihkan.

## D.3 Menuju 2NF dan 3NF

### 2NF

FD1 dan FD4 hanya bergantung pada sebagian kunci komposit `(no_nota_penjualan, kode_barang)`, yaitu FD1 pada `no_nota_penjualan` saja dan FD4 pada `kode_barang` saja. Keduanya dipisah menjadi relasi sendiri.

```
PENJUALAN_2NF (no_nota_penjualan, tgl_jam_penjualan, kode_petugas, nama_petugas,
               no_anggota, nama_anggota, bayar_penjualan)
BARANG (kode_barang, nama_barang, kategori_barang, harga_jual_barang,
        stok_barang, batas_min_stok_barang)
DETAIL_PENJUALAN (no_nota_penjualan, kode_barang,
                  qty_detail_penjualan, harga_satuan_detail_penjualan)
```

### 3NF

Pada `PENJUALAN_2NF` ada dua rantai dependensi transitif: `no_nota_penjualan → kode_petugas → nama_petugas` dan `no_nota_penjualan → no_anggota → nama_anggota`. Petugas dan anggota dipisah menjadi relasi sendiri.

```
PENJUALAN (no_nota_penjualan, tgl_jam_penjualan, kode_petugas*, no_anggota*, bayar_penjualan)
PETUGAS (kode_petugas, nama_petugas, peran_petugas)
ANGGOTA (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota,
         status_anggota)
```

Sisi pembelian dinormalisasi dengan pola yang sama:

```
PEMBELIAN (no_faktur_pembelian, kode_pemasok*, tgl_pembelian, kode_petugas_penerima*)
PEMASOK (kode_pemasok, nama_pemasok, telepon_pemasok, alamat_pemasok)
DETAIL_PEMBELIAN (no_faktur_pembelian*, kode_pemasok*, kode_barang*,
                  qty_detail_pembelian, harga_beli_detail_pembelian)
```

(Garis bawah kunci primer, tanda `*` kunci tamu. Di skema kanonik, kunci pembelian digantikan `id_pembelian`, lihat D.4.)

### Nilai turunan

| Nilai | Keputusan | Alasan |
|---|---|---|
| subtotal_detail_penjualan | Dihitung | qty × harga satuan, FD6; menyimpannya berisiko tidak sinkron jika qty dikoreksi |
| jumlah_penjualan | Dihitung | Jumlah semua subtotal dalam satu nota |
| diskon_penjualan | Dihitung | 5% dari jumlah untuk anggota aktif (AB-02) |
| total_penjualan | Dihitung | jumlah dikurangi diskon |
| kembali_penjualan | Dihitung | bayar_penjualan dikurangi total_penjualan |
| bayar_penjualan | **Disimpan** | Uang yang diterima di kasir adalah fakta, bukan hasil hitung |

Risiko yang saya catat dari Pertemuan 3: diskon dihitung dari status anggota. Jika status anggota berubah kemudian (PB-08), hitung ulang total nota lama bisa memberi hasil lain. Untuk tabel operasional saya tetap memakai keputusan dihitung supaya tidak ada nilai yang tidak konsisten; potret nilai total yang tidak boleh berubah baru disimpan pada tabel arsip (Buku 2).

**Titik Analisis 2.** Tabel operasional (`penjualan`) masih dapat dikoreksi, sehingga total yang disimpan bisa tidak sinkron dengan rinciannya, jadi total dihitung. Tabel arsip adalah potret historis dari nota yang sudah final dan tidak boleh berubah, sehingga total justru dibekukan agar laporan lama tidak bergeser ketika harga, diskon, atau status anggota berubah. Dua keputusan itu konsisten karena tujuannya sama, yaitu menjaga kebenaran data. Yang berbeda adalah sifat datanya: data yang masih hidup dihitung supaya selalu benar, data yang sudah menjadi sejarah disimpan supaya tidak berubah.

## D.4 Mencocokkan dengan skema kanonik

Perbedaan utama dengan hasil D.3: skema kanonik memakai kunci pengganti `id_*` sebagai kunci primer, sedangkan kode alami (`no_nota_penjualan`, `kode_barang`, dan seterusnya) menjadi kunci unik.

| Tabel | Kunci primer | Kunci unik | Kunci tamu |
|---|---|---|---|
| petugas | id_petugas | kode_petugas | - |
| anggota | id_anggota | no_anggota, nim_anggota | - |
| barang | id_barang | kode_barang | - |
| pemasok | id_pemasok | kode_pemasok | - |
| penjualan | id_penjualan | no_nota_penjualan | id_petugas, id_anggota (boleh NULL) |
| detail_penjualan | (id_penjualan, id_barang) | - | id_penjualan, id_barang |
| pembelian | id_pembelian | (id_pemasok, no_faktur_pembelian) | id_pemasok, id_petugas (boleh NULL, AB-11) |
| detail_pembelian | (id_pembelian, id_barang) | - | id_pembelian, id_barang |

### Pemeriksaan BCNF

Pemeriksaan memakai kunci alami, supaya kunci pengganti tidak menutupi masalah.

| Tabel | Penentu | Kunci kandidat? | Hasil |
|---|---|---|---|
| petugas | id_petugas, kode_petugas | Ya, keduanya | BCNF |
| anggota | id_anggota, no_anggota, nim_anggota | Ya, ketiganya | BCNF (`nama_anggota` bukan penentu karena tidak unik) |
| barang | id_barang, kode_barang | Ya, keduanya | BCNF |
| pemasok | id_pemasok, kode_pemasok | Ya, keduanya | BCNF |
| penjualan | id_penjualan, no_nota_penjualan | Ya, keduanya | BCNF |
| detail_penjualan | (id_penjualan, id_barang) | Ya | BCNF |
| pembelian | id_pembelian, (id_pemasok, no_faktur_pembelian) | Ya, keduanya | BCNF |
| detail_pembelian | (id_pembelian, id_barang) | Ya | BCNF |

Semua tabel memenuhi BCNF karena setiap penentu adalah kunci kandidat.

**Catatan koreksi ERD Kopma.** Pada ERD Pertemuan 3, `no_faktur_pembelian` saya tulis sebagai kunci alternatif (unik) pada `pembelian`. FD7 dan skema kanonik menunjukkan nomor faktur tidak unik sendirian, karena dua pemasok bisa memakai nomor yang sama. Yang unik hanya pasangan `(id_pemasok, no_faktur_pembelian)`. Perubahan ini perlu dicatat di ERD Kopma.

**Titik Analisis 3.** Informasi "barang ini dipasok oleh siapa" kini tersimpan di `pembelian` (kunci tamu `id_pemasok`) dan `detail_pembelian` (kunci tamu `id_barang`), sehingga jalurnya `barang → detail_pembelian → pembelian → pemasok`. Keuntungannya dibanding satu nama pemasok di tabel `barang`: satu barang bisa dipasok beberapa pemasok dan pemasoknya bisa berganti dari waktu ke waktu, sehingga riwayat pengadaan tetap ada. Jika nama pemasok disimpan di `barang`, ejaannya bisa berbeda antarbaris (anomali ubah) dan data pemasok hilang ketika barang dihapus (anomali hapus).

## E. Latihan dan modifikasi

### Latihan E1: beberapa nomor telepon pemasok

Atribut `telepon_pemasok` tidak lagi memenuhi 1NF jika satu pemasok punya beberapa nomor, karena selnya berisi daftar. Nomor telepon dipindah ke relasi sendiri.

```
PEMASOK (id_pemasok, nama_pemasok, alamat_pemasok)
TELEPON_PEMASOK (id_telepon_pemasok, id_pemasok*, no_telepon_pemasok)
-- kunci unik: (id_pemasok, no_telepon_pemasok)
```

Relasinya: satu pemasok memiliki nol atau banyak nomor telepon (`TELEPON_PEMASOK` ke `PEMASOK` tepat satu).

### Latihan E2: anomali ubah jika nama_anggota di tabel penjualan

Jika `nama_anggota` disimpan di `penjualan`, muncul rantai `id_penjualan → id_anggota → nama_anggota` yang melanggar 3NF.

| id_penjualan | no_nota_penjualan | id_anggota | nama_anggota |
|---|---|---|---|
| 1 | PJ-2610-0001 | 7 | Budi Santoso |
| 2 | PJ-2610-0002 | 7 | Budi Santoso |

Nama dikoreksi hanya pada satu nota:

```sql
UPDATE penjualan SET nama_anggota = 'Budi S.' WHERE no_nota_penjualan = 'PJ-2610-0001';

SELECT DISTINCT id_anggota, nama_anggota FROM penjualan WHERE id_anggota = 7;
```

Hasil kueri kedua menampilkan dua baris untuk anggota yang sama (`Budi S.` dan `Budi Santoso`). Itulah anomali ubah: satu fakta tertulis di banyak baris dan menjadi tidak konsisten. Pada rancangan 3NF, nama hanya ada di `anggota`, sehingga cukup satu `UPDATE`.

## Hasil akhir Kopma

Skema relasional Kopma terdiri dari delapan tabel pada tabel skema kanonik di D.4, seluruhnya memenuhi BCNF. Satu perubahan yang perlu dicatat: `no_faktur_pembelian` bukan kunci unik tunggal.
