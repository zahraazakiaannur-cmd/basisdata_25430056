# Dokumen Kebutuhan Data - Yaya Library

**Nama:** Zahra Zakia An Nur    
**NPM:** 25430056    
**Kelas:** B    
**Tema:** Perpustakaan


## 1. Latar belakang dan aktivitas organisasi

Yaya Library adalah perpustakaan fiktif yang melayani mahasiswa. Koleksinya terdiri dari buku, majalah, dan jurnal. Setiap judul dicatat dengan kode koleksi, judul, jenis, penulis, penerbit, tahun terbit, dan harga, dan satu judul bisa punya beberapa eksemplar yang masing-masing punya kode sendiri. Setiap eksemplar berstatus tersedia, dipinjam, atau hilang.
Mahasiswa yang ingin menjadi anggota mendaftar di meja petugas dengan menyerahkan NIM, nama, program studi, dan nomor HP. Petugas mencatat tanggal pendaftaran dan memberikan nomor anggota berformat YL-xxxx. Anggota berstatus aktif sejak mendaftar. Petugas mengubahnya menjadi nonaktif ketika anggota tidak lagi berstatus mahasiswa, dan hanya anggota aktif yang boleh meminjam.
Dalam satu transaksi peminjaman, anggota boleh membawa paling banyak 5 koleksi selama 7 hari. Setiap peminjaman dicatat petugas yang melayani, lengkap dengan tanggalnya. Koleksi dalam satu transaksi boleh dikembalikan sendiri-sendiri, dan tiap pengembalian dicatat dengan tanggal kembali masing-masing. Koleksi yang terlambat dikenai denda Rp3.000 per hari per koleksi, dibayar tunai saat pengembalian dan dicatat petugas. Koleksi yang hilang ditandai hilang dan tidak bisa dipinjam lagi. Anggota wajib menggantinya dengan koleksi yang sama atau membayar sesuai harga koleksi itu. Rata-rata ada sekitar 55 transaksi per hari.
Ketika perpustakaan membeli atau menerima sumbangan koleksi baru, petugas menambahkannya ke data koleksi dan eksemplar. [tambahan] Setiap awal bulan, kepala perpustakaan menerima laporan berisi koleksi yang paling sering dipinjam, anggota paling aktif, koleksi yang lewat batas kembali, dan total denda yang terkumpul. 
Kutipan wawancara. Kepala perpustakaan: "Tarif denda bisa berubah. Kalau ada anggota protes soal denda lama, kami susah membuktikan tarif yang berlaku waktu itu." Petugas: "Satu judul punya beberapa eksemplar, tapi kami tidak tahu eksemplar yang mana yang sedang keluar." Petugas: "Anggota sering mengembalikan sebagian dulu, sisanya belakangan, dan catatan kami jadi berantakan."

## 2. Aktor dan proses bisnis

| Kode | Proses Bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Pendaftaran dan pengelolaan anggota | Petugas Perpustakaan | Mahasiswa ingin menjadi anggota perpustakaan |
| PB-02 | Pengelolaan koleksi dan eksemplar | Petugas Perpustakaan | Perpustakaan menerima atau menambah koleksi |
| PB-03 | Peminjaman koleksi | Anggota, Petugas Perpustakaan | Anggota ingin meminjam koleksi |
| PB-04 | Pengembalian koleksi dan pencatatan denda | Anggota, Petugas Perpustakaan | Anggota mengembalikan koleksi |
| PB-05 | Pelaporan aktivitas perpustakaan | Petugas Perpustakaan, Kepala Perpustakaan | Awal periode pelaporan |

## 3. Dokumen sumber yang dianalisis

<!-- Min. 1 dokumen sumber fiktif rancangan sendiri (misalnya formulir anggota, slip peminjaman, atau kuitansi denda). Tampilkan bentuknya, lalu bedah: tiap isian disimpan atau turunan. -->

**Dokumen: [nama dokumen]**

```text
[Gambarkan isi dokumen di sini]
```

| Isian pada dokumen | Disimpan / turunan | Alasan |
|---|---|---|
| | | |

## 4. Entitas kandidat dan elemen data

<!-- Min. 6 entitas, semuanya kata benda. -->

| Entitas kandidat | Elemen data utama | Sumber |
|---|---|---|
| | | |

## 5. Aturan bisnis

<!-- Min. 8 aturan, kode unik AB-xx. Setiap aturan harus bisa ditelusuri ke satu proses bisnis. Gunakan batas dari parameter P (lihat bagian 9). -->

| Kode | Aturan bisnis | Berasal dari proses |
|---|---|---|
| AB-01 | | |

## 6. Kebutuhan informasi

<!-- Min. 5 kebutuhan informasi: pertanyaan apa yang harus bisa dijawab, dan data apa yang diperlukan. -->

| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | | |

## 7. Matriks CRUD

<!-- Setiap entitas harus punya minimal satu C. Kalau tidak, jelaskan alasannya atau tambahkan proses pemeliharaan data. Sesuaikan kolom dengan entitas Anda. -->

| Proses | [Entitas 1] | [Entitas 2] | [Entitas 3] | [Entitas 4] | [Entitas 5] | [Entitas 6] |
|---|---|---|---|---|---|---|
| PB-01 | | | | | | |

## 8. Kamus data awal (dengan penanggung jawab)

<!-- Min. 20 elemen, kolom penanggung jawab wajib. -->

| Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|
| | | | | |

## 9. Kebutuhan non-fungsional data

### Parameter personal P

<!-- Wajib mencantumkan perhitungan P. Nilainya dipakai lagi di Modul 6. -->

P = (2 digit terakhir NIM mod 9) + 1 = (56 mod 9) + 1 = 2 + 1 = **3**

| Parameter | Rumus | Nilai |
|---|---|---|
| Batas maksimal item per transaksi | P + 2 | 5 |
| Denda harian (ribu rupiah) | P | Rp3.000 |
| Perkiraan volume transaksi harian | 40 + 5 x P | 55 |

### Volume, retensi, dan privasi

<!-- Berapa lama data disimpan? Data apa yang bersifat pribadi, dan siapa yang boleh mengaksesnya? -->

[Tulis di sini]

## 10. Isu kualitas data yang diantisipasi

<!-- Contoh arah pikir: nilai yang berubah lalu catatan lama ikut berubah, satu judul buku dengan banyak eksemplar, status yang tidak pernah diperbarui. Tulis dari analisis Anda. -->

[Tulis di sini]
