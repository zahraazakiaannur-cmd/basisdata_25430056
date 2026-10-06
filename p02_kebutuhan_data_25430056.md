# Dokumen Kebutuhan Data - [Nama Organisasi Anda, memuat inisial]

**Nama:** Zahra Zakia An Nur    **NIM:** 25430056    **Kelas:** B    **Tema:** Perpustakaan

<!-- MILESTONE PROYEK 2 (45%). Isi harus berasal dari analisis Anda sendiri, berdasarkan paragraf Lingkup Layanan di README. Dokumen yang mirip akan diperiksa lewat viva: Anda harus bisa menjelaskan asal tiap aturan dari proses bisnisnya.
Minimum: 4 proses bisnis, 6 entitas kandidat, 8 aturan bisnis, 5 kebutuhan informasi, matriks CRUD lengkap, kamus data minimal 20 elemen dengan penanggung jawab, kebutuhan non-fungsional (termasuk data pribadi), dan minimal satu dokumen sumber fiktif rancangan sendiri beserta pembedahannya.
Perhatian khusus tema Perpustakaan: satu judul buku bisa memiliki banyak eksemplar.
Hapus komentar ini sebelum commit. Commit: "p02: ..." -->

## 1. Latar belakang dan aktivitas organisasi

<!-- Dasarnya paragraf Lingkup Layanan di README. Tulis ulang dengan kata-kata sendiri. -->

[Tulis di sini]

## 2. Aktor dan proses bisnis

<!-- Min. 4 proses. Tandai kata kerja pada narasi layanan Anda, kelompokkan menurut pelaku. -->

| Kode | Proses bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | | | |
| PB-02 | | | |
| PB-03 | | | |
| PB-04 | | | |

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
