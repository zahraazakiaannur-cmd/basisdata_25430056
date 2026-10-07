# Dokumen Kebutuhan Data - Koperasi Mahasiswa Sejahtera (Kopma)

**Nama:** Zahra Zakia An Nur 
**NPM:** 25430056 
**Kelas:** B

## 1. Latar belakang dan aktivitas organisasi

Koperasi Mahasiswa Sejahtera (Kopma) adalah koperasi fiktif di lingkungan kampus yang menjual alat tulis, makanan ringan, dan minuman. Pembeli dapat berupa anggota atau umum. Mahasiswa mendaftar sebagai anggota dengan menyerahkan NIM, nama, program studi, dan nomor HP, lalu memperoleh nomor anggota berformat A-xxxx. Anggota aktif memperoleh diskon 5% untuk setiap nota.

Tiga kasir bekerja bergantian per sif. Kasir mencatat penjualan dan mencetak nota. Setiap sore petugas gudang memeriksa stok; bila stok suatu barang di bawah batas minimum, ia membuat pesanan pembelian ke pemasok. Ketika barang datang, stok bertambah sesuai faktur pemasok. Setiap awal bulan, ketua koperasi menerima laporan omzet, barang terlaris, barang dengan stok menipis, dan anggota paling aktif.

Kutipan wawancara. Ketua: "Harga barang sering naik, jadi kami bingung saat melihat nota lama." Petugas gudang: "Kadang di buku catatan stoknya malah minus." Kasir: "Anggota sering lupa membawa kartu, jadi kami mencarinya lewat NIM."

Tiga keluhan itu diterjemahkan menjadi kebutuhan data: harga pada nota lama harus tetap bisa dicek (harga disimpan per baris nota), stok tidak boleh negatif, dan anggota harus bisa dicari lewat NIM maupun nomor anggota.

## 2. Aktor dan proses bisnis

| Kode  | Proses bisnis                          | Aktor                          | Pemicu                                           |
| ----- | -------------------------------------- | ------------------------------ | ------------------------------------------------ |
| PB-01 | Mendaftarkan anggota                   | Kasir (atas permintaan mahasiswa) | Mahasiswa ingin menjadi anggota               |
| PB-02 | Mencatat penjualan                     | Kasir                          | Pembeli membayar di kasir                        |
| PB-03 | Memesan barang ke pemasok              | Petugas gudang                 | Stok di bawah batas minimum                      |
| PB-04 | Menerima barang dari pemasok           | Petugas gudang                 | Barang datang bersama faktur                     |
| PB-05 | Menyusun laporan bulanan               | Ketua koperasi                 | Awal bulan                                       |
| PB-06 | Mengelola data pemasok (tambahan)      | Petugas gudang                 | Koperasi mulai bekerja sama dengan pemasok baru  |
| PB-07 | Mengelola data barang (tambahan)       | Petugas gudang                 | Ada barang baru atau perubahan harga jual        |
| PB-08 | Memelihara data anggota (tambahan)     | Ketua koperasi                 | Anggota tidak lagi berstatus mahasiswa           |


## 3. Dokumen sumber yang dianalisis

Dokumen: Nota Penjualan Kopma, No. PJ-2609-0142, tanggal 24-09-2026 10:15, kasir Rina (K03), anggota A-0457 / Budi S. Barisnya: Pulpen Gel 0.5 (qty 3, Rp4.000, subtotal Rp12.000), Buku Tulis 58 (qty 2, Rp6.500, subtotal Rp13.000), Air Mineral 600 (qty 1, Rp4.000, subtotal Rp4.000). Jumlah Rp29.000, diskon anggota 5% Rp1.450, total Rp27.550, bayar tunai Rp30.000, kembali Rp2.450.

| Isian pada nota                    | Disimpan / turunan | Alasan                                                                                         |
| ---------------------------------- | ------------------ | ---------------------------------------------------------------------------------------------- |
| No. Nota                           | Disimpan           | Identitas unik transaksi (AB-01)                                                               |
| Tanggal dan jam                    | Disimpan           | Fakta yang terjadi saat transaksi, dasar laporan harian dan bulanan                            |
| Kasir (kode)                       | Disimpan           | Penanda petugas yang melayani; nama diambil dari data petugas                                  |
| Anggota (nomor anggota)            | Disimpan (opsional) | Pembeli boleh umum, jadi boleh kosong (AB-02); nama diambil dari data anggota                 |
| Nama barang                        | Turunan            | Diambil dari data barang lewat kode barang                                                     |
| Qty                                | Disimpan           | Jumlah yang dibeli pada transaksi itu, tidak bisa dihitung dari data lain                      |
| Harga (satuan)                     | Disimpan per baris | Harga barang bisa naik, nota lama harus tetap menunjukkan harga saat transaksi (AB-04)         |
| Subtotal                           | Turunan            | qty x harga satuan, bisa dihitung ulang                                                        |
| Jumlah                             | Turunan            | Jumlah semua subtotal                                                                          |
| Diskon anggota 5%                  | Turunan            | 5% x jumlah bila anggota aktif (AB-02)                                                         |
| Total                              | Turunan            | Jumlah dikurangi diskon (keputusan akhir disimpan atau tidak dibahas di Modul 4)               |
| Bayar tunai                        | Disimpan           | Uang yang diserahkan pembeli, tidak bisa dihitung dari data lain                               |
| Kembali                            | Turunan            | Bayar dikurangi total                                                                          |

## 4. Entitas kandidat dan elemen data

| Entitas kandidat           | Elemen data utama                                                      | Sumber                  |
| -------------------------- | ---------------------------------------------------------------------- | ----------------------- |
| Anggota                    | nomor anggota, NIM, nama, program studi, nomor HP, status aktif        | Formulir pendaftaran    |
| Barang                     | kode, nama, kategori, harga jual, stok, batas minimum stok             | Daftar barang, faktur   |
| Penjualan                  | nomor nota, tanggal-jam, kasir, anggota (opsional), bayar              | Nota penjualan          |
| Detail penjualan           | nomor nota, barang, qty, harga saat transaksi                          | Nota penjualan          |
| Petugas                    | kode petugas, nama, peran (kasir/gudang/ketua)                         | Wawancara               |
| Pemasok                    | kode, nama, telepon, alamat                                            | Faktur pemasok          |
| Pembelian dan detailnya    | nomor faktur, tanggal, pemasok, barang, qty, harga beli                | Faktur pemasok          |

## 5. Aturan bisnis

| Kode  | Aturan bisnis                                                                                                          |
| ----- | ---------------------------------------------------------------------------------------------------------------------- |
| AB-01 | Setiap nota memiliki nomor unik dan minimal satu baris barang.                                                         |
| AB-02 | Penjualan boleh tanpa anggota (pembeli umum); jika ada, anggota harus berstatus aktif untuk memperoleh diskon 5%.      |
| AB-03 | Stok barang tidak boleh negatif; penjualan ditolak bila qty melebihi stok tersedia.                                    |
| AB-04 | Harga jual yang dipakai pada nota disimpan per baris dan tidak berubah meski harga barang kemudian naik.               |
| AB-05 | NIM anggota unik; pencarian anggota dapat dilakukan lewat nomor anggota atau NIM.                                      |
| AB-06 | Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut.                                          |

## 6. Kebutuhan informasi

| Kode  | Kebutuhan informasi                                  | Data yang diperlukan                    |
| ----- | ---------------------------------------------------- | --------------------------------------- |
| KI-01 | Omzet dan jumlah nota per hari dan per bulan         | Penjualan, detail penjualan             |
| KI-02 | Lima barang terlaris per bulan berdasarkan qty       | Detail penjualan, barang                |
| KI-03 | Barang dengan stok di bawah batas minimum            | Barang                                  |
| KI-04 | Sepuluh anggota dengan belanja terbesar per bulan    | Penjualan, detail penjualan, anggota    |

## 7. Matriks CRUD

| Proses                      | Anggota | Barang  | Penjualan | Detail | Pemasok | Pembelian |
| --------------------------- | ------- | ------- | --------- | ------ | ------- | --------- |
| PB-01 Daftar anggota        | C       |         |           |        |         |           |
| PB-02 Catat penjualan       | R       | R, U    | C         | C      |         |           |
| PB-03 Pesan ke pemasok      |         | R       |           |        | R       | C         |
| PB-04 Terima barang         |         | U       |           |        | R       | U         |
| PB-05 Laporan bulanan       | R       | R       | R         | R      |         | R         |
| PB-06 Kelola data pemasok   |         |         |           |        | C, R, U |           |
| PB-07 Kelola data barang    |         | C, R, U |           |        |         |           |
| PB-08 Pelihara data anggota | R, U    |         |           |        |         |           |

## 8. Kamus data awal (dengan penanggung jawab)

| Elemen                    | Arti                          | Contoh          | Aturan                                  | Penanggung jawab |
| ------------------------- | ----------------------------- | --------------- | --------------------------------------- | ---------------- |
| no_anggota                | Nomor anggota koperasi        | A-0457          | Unik, format A-4 digit                  | Ketua            |
| nim_anggota               | NIM anggota                   | 2301010123      | Unik, 10 digit                          | Ketua            |
| no_hp_anggota             | Nomor HP anggota              | 0812xxxx        | Data pribadi, akses terbatas            | Ketua            |
| no_nota_penjualan         | Nomor nota penjualan          | PJ-2609-0142    | Unik per nota                           | Kasir            |
| harga_satuan_detail_penjualan | Harga jual saat transaksi | 4000            | Bilangan bulat >= 0 (rupiah)            | Kasir            |
| stok_barang               | Jumlah barang tersedia        | 35              | Bilangan bulat >= 0 (AB-03)             | Petugas gudang   |
| status_aktif_anggota      | Status keanggotaan            | aktif           | Hanya aktif atau nonaktif (AB-02)       | Ketua            |
| qty_detail_penjualan      | Jumlah barang pada satu baris nota | 3          | Bilangan bulat > 0 dan <= stok (AB-03)  | Kasir            |
| batas_minimum_stok        | Batas stok untuk memicu pesanan | 10            | Bilangan bulat >= 0 (AB-06)             | Petugas gudang   |


## 9. Kebutuhan non-fungsional data

- **Volume:** perkiraan sekitar 150 nota per hari.
- **Retensi:** data transaksi disimpan minimal 5 tahun.
- **Data pribadi dan akses:** nomor HP anggota adalah data pribadi dan hanya boleh dilihat oleh ketua. Pembatasan ini sejalan dengan kewajiban pengendali data dalam Undang-Undang Pelindungan Data Pribadi.

## 10. Isu kualitas data yang diantisipasi

| No | Isu kualitas data                                         | Dimensi        | Pencegahan                                   |
| -- | --------------------------------------------------------- | -------------- | -------------------------------------------- |
| 1  | Harga pada nota lama berubah mengikuti harga barang       | Ketertelusuran | Harga disimpan per baris nota (AB-04)        |
| 2  | Stok negatif di catatan                                   | Akurasi        | Penjualan ditolak bila qty melebihi stok (AB-03) |
| 3  | Anggota ganda karena dicari lewat NIM lalu didaftar ulang | Keunikan       | NIM unik (AB-05)                             |
| 4  | Anggota nonaktif masih mendapat diskon                    | Konsistensi    | Diskon hanya untuk anggota aktif (AB-02)     |
| 5  | Pesanan ke pemasok terlewat saat stok menipis             | Kelengkapan    | Laporan stok di bawah batas minimum (KI-03)  |

---

## Lampiran: Jawaban Titik Analisis dan Latihan (untuk laporan)

### Titik Analisis 1
Harga di data barang bisa berubah kapan saja. Kalau nota hanya mengambil harga lewat relasi ke data barang, setiap kali harga naik, total nota lama ikut berubah dan omzet bulan lalu jadi salah. Itulah sumber keluhan ketua yang bingung melihat nota lama. Dengan menyimpan harga saat transaksi pada tiap baris nota (AB-04), nota lama tetap menampilkan harga yang benar-benar dibayar pembeli.

### Titik Analisis 2
Alasan tidak disimpan: subtotal dan total bisa dihitung dari qty, harga, dan diskon, sehingga menyimpannya menambah risiko tidak sinkron kalau salah satu nilai dikoreksi (redundansi). Alasan mungkin tetap disimpan: total adalah angka yang tercetak dan dibayar pada nota, sehingga menyimpannya membekukan nilai itu sebagai bukti jika aturan diskon berubah, dan membuat laporan omzet lebih cepat karena tidak perlu menghitung ulang semua baris. Keputusan akhir dibahas di Modul 4.

### Titik Analisis 3
Kolom Pemasok tidak punya huruf C, artinya tidak ada proses yang membuat data pemasok. Ada proses yang terlewat, yaitu mengelola data pemasok (PB-06) oleh petugas gudang. Pemeriksaan yang sama menunjukkan kolom Barang juga tidak punya C, sehingga ditambahkan PB-07 mengelola data barang. Soal status aktif anggota, tidak ada proses yang mengubahnya. Narasi hanya menyebut anggota aktif memperoleh diskon. Karena penanggung jawab data anggota adalah ketua, ditambahkan PB-08 memelihara data anggota oleh ketua (U pada Anggota).

### Latihan E.1: Poin loyalitas
Asumsi: poin dihitung dari total bayar setelah diskon, dibulatkan ke bawah.

- **Elemen data baru:** poin_didapat_penjualan, poin_ditukar_penjualan, potongan_poin_penjualan, saldo_poin_anggota.
- **AB-07:** Setiap kelipatan Rp10.000 belanja anggota aktif bernilai 1 poin (dibulatkan ke bawah). Contoh: total Rp27.550 menghasilkan 2 poin.
- **AB-08:** 50 poin dapat ditukar dengan potongan Rp5.000; penukaran hanya dalam kelipatan 50 poin.
- **AB-09:** Saldo poin tidak boleh negatif; penukaran ditolak bila poin kurang dari yang ditukar.
- **AB-10:** Pembeli umum tidak memperoleh poin; poin didapat dan ditukar dicatat per nota agar bisa ditelusuri.
- **KI-05:** Saldo poin setiap anggota (data: anggota).
- **KI-06:** Total poin diterbitkan dan ditukar per bulan (data: penjualan).
- **Perubahan matriks CRUD:** PB-02 Catat penjualan pada kolom Anggota berubah dari R menjadi R, U (saldo poin diperbarui); kolom Penjualan tetap C (menyimpan poin didapat dan poin ditukar). PB-05 Laporan bulanan tetap membaca kolom Anggota dan Penjualan.

### Latihan E.2: Memperbaiki pernyataan kabur

| Pernyataan kabur                       | Pernyataan yang dapat diuji                                                                                                                                                                        |
| -------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| (a) "data anggota harus aman"          | Nomor HP anggota hanya dapat dibaca oleh ketua; akun kasir yang mencoba membaca kolom no_hp_anggota ditolak, dan akun kasir hanya dapat melihat nomor anggota dan nama.                              |
| (b) "sistem harus cepat mencari barang"| Pencarian barang berdasarkan kode atau nama menampilkan hasil dalam paling lama 2 detik pada data sampai 2.000 barang.                                                                              |
| (c) "laporan stok harus akurat"        | Untuk setiap barang, stok = stok awal + total qty diterima - total qty terjual; selisih dengan hasil pemeriksaan fisik sore hari adalah 0 untuk setiap barang yang diperiksa, dan stok tidak pernah negatif (AB-03). |
