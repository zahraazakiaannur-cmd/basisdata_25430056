# Dokumen Kebutuhan Data - Yaya Library

**Nama:** Zahra Zakia An Nur  
**NPM:** 25430056  
**Kelas:** B  
**Tema:** Perpustakaan

## 1. Latar belakang dan aktivitas organisasi

Yaya Library adalah perpustakaan fiktif yang melayani mahasiswa. Koleksinya terdiri dari buku, majalah, dan jurnal. Setiap judul dicatat dengan kode koleksi, judul, jenis, penulis, penerbit, tahun terbit, dan harga, dan satu judul bisa punya beberapa eksemplar yang masing-masing punya kode sendiri. Setiap eksemplar berstatus tersedia, dipinjam, atau hilang.
Mahasiswa yang ingin menjadi anggota mendaftar di meja petugas dengan menyerahkan NIM, nama, program studi, dan nomor HP. Petugas mencatat tanggal pendaftaran dan memberikan nomor anggota berformat YL-xxxx. Anggota berstatus aktif sejak mendaftar. Petugas mengubahnya menjadi nonaktif ketika anggota tidak lagi berstatus mahasiswa, dan hanya anggota aktif yang boleh meminjam.
Dalam satu transaksi peminjaman, anggota boleh membawa paling banyak 5 koleksi selama 7 hari. Setiap peminjaman dicatat petugas yang melayani, lengkap dengan tanggalnya. Koleksi dalam satu transaksi boleh dikembalikan sendiri-sendiri, dan tiap pengembalian dicatat dengan tanggal kembali masing-masing. Koleksi yang terlambat dikenai denda Rp3.000 per hari per koleksi, dibayar tunai saat pengembalian dan dicatat petugas. Koleksi yang hilang ditandai hilang dan tidak bisa dipinjam lagi. Anggota wajib menggantinya dengan koleksi yang sama atau membayar sesuai harga koleksi itu. Rata-rata ada sekitar 55 transaksi per hari.
Ketika perpustakaan membeli atau menerima sumbangan koleksi baru, petugas menambahkannya ke data koleksi dan eksemplar. Setiap awal bulan, kepala perpustakaan menerima laporan berisi koleksi yang paling sering dipinjam, anggota paling aktif, koleksi yang lewat batas kembali, dan total denda yang terkumpul.
Kutipan wawancara. Kepala perpustakaan: "Tarif denda bisa berubah. Kalau ada anggota protes soal denda lama, kami susah membuktikan tarif yang berlaku waktu itu." Petugas: "Satu judul punya beberapa eksemplar, tapi kami tidak tahu eksemplar yang mana yang sedang keluar." Petugas: "Anggota sering mengembalikan sebagian dulu, sisanya belakangan, dan catatan kami jadi berantakan."

## 2. Aktor dan proses bisnis

| Kode  | Proses Bisnis                             | Aktor                                     | Pemicu                                                      |
| ----- | ----------------------------------------- | ----------------------------------------- | ----------------------------------------------------------- |
| PB-01 | Pendaftaran dan pengelolaan anggota       | Petugas Perpustakaan                      | Mahasiswa ingin menjadi anggota perpustakaan                |
| PB-02 | Pengelolaan koleksi dan eksemplar         | Petugas Perpustakaan                      | Perpustakaan menerima atau menambah koleksi                 |
| PB-03 | Peminjaman koleksi                        | Anggota, Petugas Perpustakaan             | Anggota ingin meminjam koleksi                              |
| PB-04 | Pengembalian koleksi dan pencatatan denda | Anggota, Petugas Perpustakaan             | Anggota mengembalikan koleksi                               |
| PB-05 | Pelaporan aktivitas perpustakaan          | Petugas Perpustakaan, Kepala Perpustakaan | Awal periode pelaporan                                      |
| PB-06 | Pengelolaan data petugas dan tarif denda  | Kepala Perpustakaan                       | Pergantian petugas atau perubahan kebijakan tarif denda     |


## 3. Dokumen sumber yang dianalisis

**Dokumen: Slip Peminjaman dan Pengembalian Yaya Library (dokumen fiktif rancangan sendiri)**

```
+--------------------------------------------------------------------+
|                       YAYA LIBRARY                                 |
|                Slip Peminjaman dan Pengembalian                    |
|                                                                    |
|  No. Pinjam   : PM-2610-0007                                       |
|  Tgl Pinjam   : 05-10-2026                                         |
|  Petugas      : Dina (P02)                                         |
|  Anggota      : YL-0123 / Rizki Aditya                             |
|  Jatuh Tempo  : 12-10-2026                                         |
|                                                                    |
|  Kode Eksemplar  Judul                   Jenis    Tgl Kembali      |
|  ---------------------------------------------------------------   |
|  BK-001-02       Basis Data Konsep       Buku     12-10-2026       |
|  MJ-014-01       Majalah Komputer Edisi 9 Majalah 15-10-2026       |
|  JR-007-01       Jurnal Sistem Informasi Jurnal   (belum kembali)  |
|  ---------------------------------------------------------------   |
|  Jumlah koleksi dipinjam      : 3                                  |
|  Denda per hari per koleksi   : Rp3.000                            |
|  Hari terlambat (MJ-014-01)   : 3 hari                             |
|  Denda MJ-014-01              : Rp9.000                            |
|  Total denda dibayar          : Rp9.000 (tunai)                    |
+--------------------------------------------------------------------+
```

| Isian pada dokumen                  | Disimpan / turunan | Alasan                                                                                                   |
| ----------------------------------- | ------------------ | -------------------------------------------------------------------------------------------------------- |
| No. Pinjam                          | Disimpan           | Identitas unik transaksi peminjaman                                                                      |
| Tgl Pinjam                          | Disimpan           | Fakta yang terjadi saat transaksi, dasar menghitung jatuh tempo                                          |
| Petugas (kode dan nama)             | Disimpan (kode)    | Kode petugas disimpan sebagai penanda pelayan; nama diambil dari data petugas                            |
| Anggota (nomor dan nama)            | Disimpan (nomor)   | Nomor anggota disimpan sebagai penanda peminjam; nama diambil dari data anggota                          |
| Jatuh Tempo                         | Turunan            | Dapat dihitung dari tgl pinjam + 7 hari (AB-04)                                                          |
| Kode Eksemplar                      | Disimpan           | Menunjukkan eksemplar fisik mana yang keluar, menjawab keluhan petugas                                   |
| Judul dan Jenis                     | Turunan            | Berasal dari data koleksi lewat kode eksemplar, tidak perlu disimpan ulang                               |
| Tgl Kembali (per koleksi)           | Disimpan           | Pengembalian dilakukan sendiri-sendiri sehingga setiap koleksi punya tanggal kembali sendiri             |
| Jumlah koleksi dipinjam             | Turunan            | Dapat dihitung dari banyaknya baris koleksi pada transaksi                                               |
| Denda per hari per koleksi (Rp3.000)| Disimpan per baris | Tarif bisa berubah, jadi tarif saat transaksi dibekukan pada baris koleksi agar bisa dibuktikan kemudian |
| Hari terlambat                      | Turunan            | Dihitung dari tgl kembali dikurangi jatuh tempo                                                          |
| Denda per koleksi                   | Turunan (lihat catatan) | Hari terlambat x tarif; dapat dihitung ulang                                                        |
| Total denda dibayar                 | Turunan (lihat catatan) | Jumlah denda semua koleksi pada transaksi                                                           |


## 4. Entitas kandidat dan elemen data

| Entitas kandidat   | Elemen data utama                                                                                                                                  | Sumber                                       |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| Anggota            | nomor anggota, NIM, nama, program studi, nomor HP, tanggal daftar, status anggota                                                                  | Formulir pendaftaran, wawancara              |
| Petugas            | kode petugas, nama petugas, peran (petugas / kepala perpustakaan)                                                                                  | Slip peminjaman, wawancara                   |
| Koleksi            | kode koleksi, judul, jenis (buku/majalah/jurnal), penulis, penerbit, tahun terbit, harga                                                           | Data koleksi, narasi                         |
| Eksemplar          | kode eksemplar, kode koleksi, status eksemplar (tersedia/dipinjam/hilang)                                                                          | Narasi, wawancara petugas                    |
| Peminjaman         | nomor peminjaman, tanggal pinjam, nomor anggota, kode petugas                                                                                      | Slip peminjaman                              |
| Detail peminjaman  | nomor peminjaman, kode eksemplar, tanggal jatuh tempo, tanggal kembali, tarif denda saat transaksi, denda, status item, jenis ganti rugi, biaya ganti rugi | Slip peminjaman, wawancara                   |
| Tarif denda        | kode tarif, nominal per hari, berlaku mulai                                                                                                        | Wawancara kepala perpustakaan                |

## 5. Aturan bisnis

| Kode  | Aturan bisnis                                                                                                                                                  | Berasal dari proses |
| ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| AB-01 | Nomor anggota unik dan berformat YL-xxxx; NIM anggota unik sehingga satu mahasiswa hanya punya satu keanggotaan.                                               | PB-01               |
| AB-02 | Anggota berstatus aktif sejak mendaftar dan diubah menjadi nonaktif bila bukan mahasiswa lagi; hanya anggota aktif yang boleh meminjam.                         | PB-01, PB-03        |
| AB-03 | Setiap koleksi berjenis buku, majalah, atau jurnal; setiap judul punya minimal satu eksemplar dan setiap eksemplar punya kode unik.                            | PB-02               |
| AB-04 | Eksemplar berstatus tersedia, dipinjam, atau hilang; hanya eksemplar berstatus tersedia yang boleh dipinjam, dan eksemplar hilang tidak bisa dipinjam lagi.     | PB-02, PB-03        |
| AB-05 | Setiap transaksi peminjaman punya nomor unik, tanggal pinjam, dan petugas yang melayani, serta berisi minimal 1 dan maksimal 5 koleksi.                         | PB-03               |
| AB-06 | Lama pinjam 7 hari; tanggal jatuh tempo = tanggal pinjam + 7 hari.                                                                                              | PB-03               |
| AB-07 | Satu eksemplar tidak boleh berada pada dua peminjaman yang belum dikembalikan pada saat yang sama.                                                              | PB-03               |
| AB-08 | Koleksi dalam satu transaksi boleh dikembalikan sendiri-sendiri dan tiap koleksi punya tanggal kembali sendiri; tanggal kembali tidak boleh lebih awal dari tanggal pinjam. | PB-04               |
| AB-09 | Koleksi terlambat dikenai denda Rp3.000 per hari per koleksi (hari terlambat x tarif); koleksi yang tepat waktu tidak dikenai denda.                           | PB-04               |
| AB-10 | Tarif denda yang berlaku saat transaksi disimpan pada baris koleksi dan tidak berubah meski tarif kemudian diubah.                                              | PB-04, PB-06        |
| AB-11 | Denda dibayar tunai saat pengembalian dan dicatat oleh petugas yang melayani.                                                                                   | PB-04               |
| AB-12 | Koleksi yang hilang ditandai hilang dan anggota wajib mengganti dengan koleksi yang sama atau membayar sesuai harga koleksi tersebut.                           | PB-04               |

## 6. Kebutuhan informasi

| Kode  | Kebutuhan informasi                                                                      | Data yang diperlukan                                      |
| ----- | ---------------------------------------------------------------------------------------- | --------------------------------------------------------- |
| KI-01 | Sepuluh koleksi yang paling sering dipinjam per bulan                                    | Detail peminjaman, peminjaman, eksemplar, koleksi         |
| KI-02 | Sepuluh anggota paling aktif (jumlah transaksi terbanyak) per bulan                      | Peminjaman, anggota                                       |
| KI-03 | Daftar koleksi yang lewat batas kembali (belum kembali dan tanggal jatuh tempo terlewati) | Detail peminjaman, peminjaman, anggota, eksemplar, koleksi |
| KI-04 | Total denda yang terkumpul per bulan                                                     | Detail peminjaman                                         |
| KI-05 | Jumlah eksemplar tersedia, dipinjam, dan hilang untuk setiap judul koleksi               | Eksemplar, koleksi                                        |
| KI-06 | Koleksi yang belum dikembalikan pada suatu transaksi (untuk pengembalian sebagian)       | Peminjaman, detail peminjaman, eksemplar, koleksi         |
| KI-07 | Bukti tarif denda yang berlaku pada suatu transaksi lama                                 | Detail peminjaman, peminjaman                             |

## 7. Matriks CRUD

| Proses | Anggota | Petugas | Koleksi | Eksemplar | Peminjaman | Detail peminjaman | Tarif denda |
| ------ | ------- | ------- | ------- | --------- | ---------- | ----------------- | ----------- |
| PB-01  | C, R, U |         |         |           |            |                   |             |
| PB-02  |         |         | C, R, U | C, R, U   |            |                   |             |
| PB-03  | R       | R       |         | R, U      | C          | C                 | R           |
| PB-04  | R       | R       |         | U         | R          | R, U              | R           |
| PB-05  | R       | R       | R       | R         | R          | R                 |             |
| PB-06  |         | C, R, U |         |           |            |                   | C, R        |


## 8. Kamus data awal (dengan penanggung jawab)

| Elemen                 | Arti                                              | Contoh                | Aturan                                                  | Penanggung jawab        |
| ---------------------- | ------------------------------------------------- | --------------------- | ------------------------------------------------------- | ----------------------- |
| no_anggota             | Nomor anggota perpustakaan                        | YL-0123               | Unik, format YL- diikuti 4 digit (AB-01)                | Petugas Perpustakaan    |
| nim_anggota            | NIM mahasiswa anggota                             | 25430056              | Unik, 8 digit angka (AB-01)                             | Petugas Perpustakaan    |
| nama_anggota           | Nama lengkap anggota                              | Rizki Aditya          | Wajib diisi                                             | Petugas Perpustakaan    |
| prodi_anggota          | Program studi anggota                             | Ilmu Komputer         | Wajib diisi                                             | Petugas Perpustakaan    |
| no_hp_anggota          | Nomor HP anggota                                  | 0812xxxxxxx           | Data pribadi, akses terbatas, hanya angka               | Kepala Perpustakaan     |
| tgl_daftar_anggota     | Tanggal anggota mendaftar                         | 2026-09-01            | Diisi petugas saat pendaftaran, tidak di masa depan     | Petugas Perpustakaan    |
| status_anggota         | Status keanggotaan                                | aktif                 | Hanya aktif atau nonaktif (AB-02)                       | Petugas Perpustakaan    |
| kode_petugas           | Kode petugas                                      | P02                   | Unik                                                    | Kepala Perpustakaan     |
| nama_petugas           | Nama petugas                                      | Dina                  | Wajib diisi                                             | Kepala Perpustakaan     |
| peran_petugas          | Peran petugas                                     | petugas               | Hanya petugas atau kepala perpustakaan                  | Kepala Perpustakaan     |
| kode_koleksi           | Kode judul koleksi                                | BK-001                | Unik; awalan BK/MJ/JR sesuai jenis                      | Petugas Perpustakaan    |
| judul_koleksi          | Judul koleksi                                     | Basis Data Konsep     | Wajib diisi                                             | Petugas Perpustakaan    |
| jenis_koleksi          | Jenis koleksi                                     | Buku                  | Hanya buku, majalah, atau jurnal (AB-03)                | Petugas Perpustakaan    |
| penulis_koleksi        | Penulis koleksi                                   | A. Santoso            | Wajib diisi                                             | Petugas Perpustakaan    |
| penerbit_koleksi       | Penerbit koleksi                                  | Penerbit Nusantara    | Wajib diisi                                             | Petugas Perpustakaan    |
| tahun_terbit_koleksi   | Tahun terbit koleksi                              | 2023                  | 4 digit, tidak lebih dari tahun berjalan                | Petugas Perpustakaan    |
| harga_koleksi          | Harga koleksi, dasar ganti rugi bila hilang       | 85000                 | Bilangan bulat >= 0 (rupiah) (AB-12)                    | Petugas Perpustakaan    |
| kode_eksemplar         | Kode eksemplar fisik suatu judul                  | BK-001-02             | Unik (AB-03)                                            | Petugas Perpustakaan    |
| status_eksemplar       | Keadaan eksemplar saat ini                        | tersedia              | Hanya tersedia, dipinjam, atau hilang (AB-04)           | Petugas Perpustakaan    |
| no_peminjaman          | Nomor transaksi peminjaman                        | PM-2610-0007          | Unik per transaksi (AB-05)                              | Petugas Perpustakaan    |
| tgl_pinjam             | Tanggal peminjaman                                | 2026-10-05            | Tidak di masa depan (AB-05)                             | Petugas Perpustakaan    |
| tgl_jatuh_tempo        | Batas tanggal kembali koleksi                     | 2026-10-12            | tgl_pinjam + 7 hari (AB-06)                             | Petugas Perpustakaan    |
| tgl_kembali            | Tanggal koleksi dikembalikan                      | 2026-10-15            | Kosong bila belum kembali; tidak lebih awal dari tgl_pinjam (AB-08) | Petugas Perpustakaan |
| tarif_denda_per_hari   | Tarif denda per hari per koleksi saat transaksi   | 3000                  | Bilangan bulat >= 0 (rupiah) (AB-10)                    | Kepala Perpustakaan     |
| denda_item             | Denda untuk satu koleksi pada transaksi           | 9000                  | Hari terlambat x tarif; 0 bila tepat waktu (AB-09)      | Petugas Perpustakaan    |
| status_item            | Keadaan koleksi pada suatu transaksi              | kembali               | Hanya dipinjam, kembali, atau hilang                    | Petugas Perpustakaan    |
| jenis_ganti_rugi       | Cara anggota mengganti koleksi hilang             | bayar                 | Hanya koleksi sama atau bayar; terisi hanya bila hilang (AB-12) | Petugas Perpustakaan |
| biaya_ganti_rugi       | Nominal ganti rugi bila dibayar                   | 85000                 | Sama dengan harga koleksi bila jenis ganti rugi = bayar (AB-12) | Petugas Perpustakaan |

## 9. Kebutuhan non-fungsional data

### Parameter personal P

P = (2 digit terakhir NIM mod 9) + 1 = (56 mod 9) + 1 = 2 + 1 = **3**

| Parameter                         | Rumus      | Nilai   |
| --------------------------------- | ---------- | ------- |
| Batas maksimal item per transaksi | P + 2      | 5       |
| Denda harian (ribu rupiah)        | P          | Rp3.000 |
| Perkiraan volume transaksi harian | 40 + 5 x P | 55      |

### Volume, retensi, dan privasi

**Volume.** Sekitar 55 transaksi peminjaman per hari. Dengan asumsi rata-rata 2 sampai 3 koleksi per transaksi dan perpustakaan buka 6 hari seminggu (sekitar 312 hari setahun), perkiraannya sekitar 17.000 baris peminjaman dan sekitar 43.000 baris detail peminjaman per tahun. Asumsi rata-rata koleksi per transaksi ini adalah perkiraan penulis dan dapat dikoreksi setelah ada data nyata.

**Retensi.** Data peminjaman, detail peminjaman, dan tarif denda disimpan minimal 5 tahun supaya sengketa denda lama masih bisa dibuktikan. Data anggota nonaktif tidak dihapus selama masih ada transaksi yang terkait. Data koleksi dan eksemplar disimpan selama koleksi tercatat, termasuk yang berstatus hilang.

**Data pribadi dan akses.**

| Data pribadi          | Pihak yang boleh melihat                                                         | Catatan                                                               |
| --------------------- | -------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| no_hp_anggota         | Kepala Perpustakaan; petugas hanya untuk menghubungi anggota yang terlambat      | Tidak ditampilkan di laporan bulanan                                  |
| nim_anggota           | Petugas Perpustakaan dan Kepala Perpustakaan                                      | Dipakai untuk memverifikasi status mahasiswa                          |
| nama_anggota          | Petugas Perpustakaan dan Kepala Perpustakaan; anggota hanya data miliknya sendiri | Laporan koleksi terlaris tidak memuat nama anggota                    |
| riwayat peminjaman    | Petugas Perpustakaan dan Kepala Perpustakaan; anggota hanya miliknya sendiri      | Tidak dibuka ke anggota lain                                          |

Pembatasan akses ini sejalan dengan kewajiban menjaga data pribadi dalam Undang-Undang Pelindungan Data Pribadi.

## 10. Isu kualitas data yang diantisipasi

| No | Isu kualitas data                                                         | Dimensi kualitas | Dampak                                                        | Pencegahan / aturan terkait                                        | Penanggung jawab     |
| -- | ------------------------------------------------------------------------- | ---------------- | ------------------------------------------------------------- | ------------------------------------------------------------------ | -------------------- |
| 1  | Mahasiswa yang sama terdaftar dua kali dengan nomor anggota berbeda       | Keunikan         | Riwayat pinjam terpecah, batas pinjam bisa dilanggar          | NIM unik (AB-01)                                                   | Petugas Perpustakaan |
| 2  | Nomor anggota atau NIM salah format                                       | Validitas        | Anggota sulit dicari                                          | Format YL-xxxx dan NIM 8 digit (AB-01)                             | Petugas Perpustakaan |
| 3  | Anggota nonaktif masih bisa meminjam                                      | Konsistensi      | Koleksi dipinjam oleh orang yang tidak berhak                 | Status anggota dicek saat peminjaman (AB-02)                       | Petugas Perpustakaan |
| 4  | Status eksemplar tidak sesuai kenyataan (tercatat tersedia padahal dipinjam) | Akurasi       | Eksemplar yang sama dipinjamkan dua kali                      | Status berubah saat pinjam dan kembali (AB-04, AB-07)              | Petugas Perpustakaan |
| 5  | Pengembalian sebagian tidak tercatat per koleksi                          | Kelengkapan      | Catatan berantakan, denda salah                               | Tanggal kembali per koleksi (AB-08)                                | Petugas Perpustakaan |
| 6  | Tarif denda lama hilang karena tarif ditimpa                              | Ketertelusuran   | Sengketa denda tidak bisa dibuktikan                          | Tarif disimpan per baris dan tarif baru jadi baris baru (AB-10)    | Kepala Perpustakaan  |
| 7  | Denda dihitung manual dan salah                                           | Akurasi          | Denda kurang atau lebih bayar                                 | Rumus hari terlambat x tarif (AB-09)                               | Petugas Perpustakaan |
| 8  | Tanggal kembali lebih awal dari tanggal pinjam                            | Validitas        | Hari terlambat bernilai negatif                               | Aturan pengecekan tanggal (AB-08)                                  | Petugas Perpustakaan |
| 9  | Satu judul koleksi dicatat ganda dengan kode berbeda                      | Keunikan         | Laporan koleksi terlaris terpecah                             | Kode koleksi unik, cek judul sebelum menambah (AB-03)              | Petugas Perpustakaan |
| 10 | Nomor HP tidak valid atau kosong                                          | Kelengkapan      | Anggota terlambat tidak bisa dihubungi                        | Nomor HP wajib diisi dan hanya angka                               | Petugas Perpustakaan |
| 11 | Koleksi hilang tidak diberi tanda ganti rugi                              | Kelengkapan      | Kewajiban anggota tidak tertagih                              | Jenis dan biaya ganti rugi wajib terisi bila status hilang (AB-12) | Petugas Perpustakaan |
