# AI DECLARATION

## 1. Daftar Alat AI

Dalam pengembangan aplikasi SIPENA (Sistem Informasi Penelitian dan Pengabdian), AI digunakan sebagai alat bantu dalam proses penulisan kode dan penyusunan dokumentasi.

Alat yang digunakan adalah:

- **GitHub Copilot:** Digunakan melalui Visual Studio Code untuk membantu memberikan saran kode program dan mengembangkan tampilan serta fitur aplikasi berdasarkan instruksi yang diberikan.

## 2. Pembagian Peran Penggunaan AI

Penggunaan AI dalam pengembangan SIPENA dilakukan sebagai alat bantu. Hasil yang diberikan AI tetap perlu diperiksa dan disesuaikan dengan kebutuhan aplikasi.

| Bagian Aplikasi | Peran AI | Penyesuaian dan Pemeriksaan |
|---|---|---|
| Dashboard Admin | Membantu memberikan saran kode untuk tampilan dashboard dan menu administrasi. | Kode diperiksa dan disesuaikan dengan rancangan antarmuka SIPENA. |
| Beranda Admin | Membantu menyusun tampilan ringkasan informasi pada dashboard. | Tampilan diperiksa agar sesuai dengan kebutuhan halaman admin. |
| Data Kegiatan | Membantu memberikan saran untuk tampilan pengelolaan data kegiatan. | Kesesuaian tampilan dan fungsi diperiksa kembali. |
| Kelola Pengguna | Membantu menyusun tampilan pengelolaan pengguna. | Tampilan disesuaikan dengan konsep desain aplikasi. |
| Dokumentasi proyek | ChatGPT digunakan untuk membantu menyusun dan merapikan dokumentasi proyek jika digunakan dalam proses tersebut. | Isi dokumentasi diperiksa agar sesuai dengan kondisi proyek yang sebenarnya. |

Bagian yang tidak dibantu AI dikerjakan secara mandiri sesuai proses pengembangan proyek. Pembagian ini perlu disesuaikan dengan penggunaan AI yang sebenarnya selama pengerjaan SIPENA.

## 3. Studi Kasus Prompting

### A. Pembuatan Dashboard Admin

**Prompt yang digunakan:**

"Lanjutkan project Flutter SIPENA dengan membuat Dashboard Admin terpisah dari dashboard mahasiswa. Buat 5 menu berikut: 1. Beranda: ringkasan jumlah pengguna, total kegiatan, kegiatan menunggu validasi, disetujui, dan perlu revisi. 2. Data Kegiatan: daftar kegiatan penelitian dan pengabdian, pencarian/filter, detail kegiatan, serta aksi setujui, minta revisi, dan tolak. 3. Kelola Pengguna: daftar pengguna, detail profil, pencarian, tambah, edit, dan hapus pengguna. 4. Cetak Laporan: pilih periode dan jenis kegiatan, tampilkan rekap laporan, serta fitur cetak atau ekspor PDF jika memungkinkan. 5. Profil: informasi admin, edit profil, pengaturan, dan logout dengan konfirmasi. Gunakan konsep desain yang sama seperti Dashboard Mahasiswa."

**Hasil awal AI:**

GitHub Copilot memberikan saran kode untuk membangun Dashboard Admin dengan lima menu utama, yaitu Beranda, Data Kegiatan, Kelola Pengguna, Cetak Laporan, dan Profil.

**Penyesuaian manual:**

Kode yang dihasilkan perlu diperiksa dan disesuaikan dengan struktur project Flutter SIPENA, penamaan halaman, navigasi antarmenu, dan rancangan antarmuka yang telah dibuat. Fitur yang belum terhubung dengan data atau belum berfungsi sepenuhnya perlu diperiksa dan dikembangkan kembali.

### B. Penyempurnaan Tampilan Aplikasi

**Contoh instruksi:**

Instruksi diberikan kepada GitHub Copilot untuk melanjutkan pengembangan tampilan SIPENA agar sesuai dengan rancangan antarmuka yang sudah dibuat dan tetap konsisten antara Dashboard Mahasiswa dan Dashboard Admin.

**Hasil awal AI:**

AI memberikan saran kode untuk membantu menyusun tampilan halaman dan komponen antarmuka aplikasi.

**Penyesuaian manual:**

Saran kode diperiksa kembali dan disesuaikan dengan struktur aplikasi, susunan menu, serta tampilan yang dibutuhkan. Pemeriksaan juga diperlukan untuk memastikan halaman dapat ditampilkan melalui browser sesuai target pengembangan SIPENA.

## 4. Evaluasi Penggunaan AI

Penggunaan GitHub Copilot membantu proses pengembangan SIPENA, terutama dalam memberikan saran kode dan menyusun tampilan aplikasi berdasarkan instruksi yang diberikan. Namun, hasil dari AI tidak selalu dapat langsung digunakan tanpa pemeriksaan.

Oleh karena itu, kode yang dihasilkan perlu ditinjau, disesuaikan, dan diuji agar sesuai dengan kebutuhan proyek. AI berperan sebagai alat bantu, sedangkan keputusan mengenai kebutuhan fitur, kesesuaian rancangan, dan pemeriksaan hasil tetap menjadi tanggung jawab mahasiswa.