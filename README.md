# The Antheia Label Generator — Website & Aplikasi Android

Satu kode untuk dua bentuk:

- **Aplikasi Android (APK)**, dibuat otomatis oleh GitHub setiap kali file di repository berubah.
- **Website**, dipublikasikan gratis lewat GitHub Pages.

Setiap orang login dengan akunnya sendiri. Akun dan semua desain disimpan di **Firebase** (layanan cloud Google, paket gratis Spark), jadi desain yang dibuat di HP tetap ada saat login di HP lain atau di komputer.

Tidak perlu memasang program apa pun di komputer. Semua langkah dilakukan lewat browser.

---

## Isi folder

| File / folder | Fungsi |
|---|---|
| `www/` | Aplikasinya (website). `index.html` adalah generator mockup. |
| `www/firebase-config.js` | **Satu-satunya file yang perlu Anda isi** (langkah 6). |
| `firestore.rules` | Aturan keamanan database: tiap akun hanya bisa membaca dan menulis desainnya sendiri. |
| `capacitor.config.json` | Nama dan ID aplikasi Android (`com.antheia.labelgenerator`). |
| `resources/` | Ikon aplikasi dan splash screen. |
| `scripts/` | Skrip yang dijalankan GitHub saat membuat APK. |
| `.github/workflows/` | Perintah otomatis GitHub: build APK, publikasi website, buat kunci tanda tangan. |

---

## Langkah 1 — Buat project Firebase (gratis)

1. Buka **https://console.firebase.google.com** dan login dengan akun Google.
2. Klik **Create a project** (atau *Add project*). Beri nama, misalnya `antheia-label`.
3. Google Analytics boleh dimatikan. Klik **Create project**, tunggu sampai selesai, lalu **Continue**.

Project baru otomatis memakai paket gratis **Spark**. Tidak perlu memasukkan kartu kredit.

## Langkah 2 — Aktifkan login

1. Menu kiri: **Build › Authentication › Get started**.
2. Tab **Sign-in method**:
   - Klik **Email/Password**, aktifkan tombol pertama (*Email/Password*), lalu **Save**.
   - (Untuk website, opsional) Klik **Add new provider › Google**, aktifkan, pilih email dukungan, lalu **Save**.

> Di aplikasi Android, login memakai **email + password**. Login Google hanya tersedia di versi website. Kalau tim memakai keduanya, buat akun dengan email + password supaya bisa dipakai di website dan aplikasi.

## Langkah 3 — Buat database Firestore dan pasang aturan keamanan

1. Menu kiri: **Build › Firestore Database › Create database**.
2. Pilih lokasi **asia-southeast2 (Jakarta)**, lalu **Next**.
3. Pilih **Start in production mode**, lalu **Create**.
4. Buka tab **Rules**. Hapus semua isinya, lalu tempel isi file `firestore.rules` dari folder ini:

   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /data/users/{uid}/{rest=**} {
         allow read, write: if request.auth != null && request.auth.uid == uid;
       }
     }
   }
   ```

5. Klik **Publish**.

## Langkah 4 — Ambil konfigurasi web

1. Klik ikon **roda gigi** (kiri atas) › **Project settings**.
2. Di tab **General**, bagian **Your apps**, klik ikon **`</>`** (Web).
3. Isi nama aplikasi, misalnya `antheia-web`. **Jangan** centang Firebase Hosting. Klik **Register app**.
4. Akan muncul kode berisi `const firebaseConfig = { ... }`. Salin bagian di dalam kurung kurawal (apiKey, authDomain, projectId, storageBucket, messagingSenderId, appId). Simpan dulu, karena dipakai di langkah 6.

> Nilai-nilai ini memang dirancang untuk ada di aplikasi dan **bukan rahasia**. Data Anda dilindungi oleh aturan keamanan dari langkah 3.

## Langkah 5 — Upload proyek ke GitHub

1. Buat akun di **https://github.com** kalau belum punya.
2. Klik **+** (kanan atas) › **New repository**.
   - Nama: `antheia-label-app`
   - Pilih **Public**. Ini diperlukan agar website gratis di GitHub Pages bisa dipakai, dan pembuatan APK tidak dibatasi menit. Lihat catatan di bawah kalau ingin Private.
   - Klik **Create repository**.
3. Di halaman repository yang masih kosong, klik **uploading an existing file**.
4. Ekstrak file zip, buka folder `antheia-label-app`, lalu **seret seluruh isinya** (bukan foldernya) ke halaman GitHub. Isinya: folder `.github`, `resources`, `scripts`, `www`, dan file-file lainnya.
5. Klik **Commit changes** dan tunggu upload selesai.
6. Pastikan folder **`.github`** ikut terupload (terlihat di daftar file repository).
   - Di Mac, folder yang diawali titik disembunyikan oleh Finder. Tekan **Cmd + Shift + .** untuk menampilkannya.
   - Kalau `.github` tidak ikut: klik **Add file › Create new file**, ketik nama `.github/workflows/android.yml`, lalu tempel isi file tersebut. Ulangi untuk `pages.yml` dan `signing-key.yml`.

> **Repository Private?** Membuat APK tetap bisa (gratis 2.000 menit per bulan, dan satu build sekitar 5–8 menit). Tapi GitHub Pages untuk repository private butuh paket berbayar, jadi versi website tidak bisa dipublikasikan gratis.

## Langkah 6 — Isi `firebase-config.js`

1. Di GitHub, buka folder **`www`** › file **`firebase-config.js`** › klik ikon **pensil** (Edit).
2. Ganti nilai-nilai `PASTE_...` dengan konfigurasi dari langkah 4. Hasilnya kira-kira seperti ini:

   ```js
   window.FIREBASE_CONFIG = {
     apiKey: "AIzaSy...",
     authDomain: "antheia-label.firebaseapp.com",
     projectId: "antheia-label",
     storageBucket: "antheia-label.appspot.com",
     messagingSenderId: "1234567890",
     appId: "1:1234567890:web:abc123"
   };
   ```

3. Klik **Commit changes**.

Selama nilainya masih `PASTE_...`, aplikasi tetap bisa dipakai, tapi tanpa akun (desain hanya tersimpan di perangkat itu).

## Langkah 7 — Download APK dan install di HP

1. Di repository, buka tab **Actions**. Setiap kali ada perubahan, workflow **Build Android APK** berjalan otomatis (sekitar 5–8 menit). Pakai hasil build **setelah** langkah 6.
2. Tunggu sampai ada **centang hijau**, lalu klik nama run tersebut.
3. Di bagian bawah, **Artifacts**, klik **antheia-label-apk** untuk mengunduh file zip.
4. Ekstrak zip itu. Di dalamnya ada file `.apk`.
5. Kirim file APK ke HP Android (lewat WhatsApp, Google Drive, atau kabel USB), lalu buka file itu di HP.
6. Kalau diminta, izinkan **Install unknown apps** untuk aplikasi yang membuka file tersebut, lalu **Install**. Kalau Play Protect memberi peringatan, pilih **More details › Install anyway**. Peringatan ini wajar untuk aplikasi yang tidak dipasang lewat Play Store.

Di aplikasi, buat akun (**New here? Create an account**) atau login. Login dengan akun yang sama di HP lain atau di website akan menampilkan desain yang sama.

## Langkah 8 (disarankan) — Kunci tanda tangan, agar update terpasang langsung

Tanpa langkah ini, GitHub membuat APK versi *debug* dengan kunci yang berbeda di setiap build. Akibatnya, untuk memasang versi baru, aplikasi lama harus di-uninstall dulu. Desain yang tersimpan di akun tetap aman, tapi ini merepotkan. Dengan kunci tetap, versi baru langsung terpasang di atas yang lama.

1. Di repository: **Settings › Secrets and variables › Actions › New repository secret**.
   - Name: `KEYSTORE_PASSWORD`
   - Secret: password buatan Anda sendiri, minimal 8 karakter, huruf dan angka. **Catat dan simpan baik-baik.**
2. Tab **Actions** › di kiri pilih **Create signing key (run once)** › **Run workflow** › **Run workflow**.
3. Setelah selesai, buka run tersebut dan unduh artifact **signing-key**. Ekstrak, lalu buka `KEYSTORE_BASE64.txt` dengan Notepad dan salin **seluruh** isinya.
4. Kembali ke **Settings › Secrets and variables › Actions › New repository secret**.
   - Name: `KEYSTORE_BASE64`
   - Secret: tempel isi tadi.
5. Hapus artifact signing-key dari halaman run (ikon tempat sampah), lalu simpan salinan `KEYSTORE_BASE64.txt` dan password-nya di tempat aman. Isi file itu terenkripsi dengan password Anda, jadi tidak bisa dipakai orang lain tanpa password.
6. Tab **Actions** › **Build Android APK** › **Run workflow**. Mulai sekarang hasilnya adalah APK *release* yang ditandatangani, misalnya `antheia-label-1.0.0.apk`.

Kalau sebelumnya sudah memasang APK debug, uninstall dulu **sekali**, lalu pasang APK release ini. Setelah itu, setiap versi baru tinggal di-install di atasnya.

## Langkah 9 (opsional) — Versi website lewat GitHub Pages

1. Di repository: **Settings › Pages**. Di **Build and deployment › Source**, pilih **GitHub Actions**.
2. Tab **Actions** › **Publish website** › **Run workflow**. Setelah itu website diperbarui otomatis setiap ada perubahan.
3. Alamat website muncul di **Settings › Pages**, biasanya `https://NAMA-AKUN-GITHUB.github.io/antheia-label-app/`.
4. Agar **login Google** bisa dipakai di website: di Firebase, buka **Authentication › Settings › Authorized domains › Add domain**, lalu isi `NAMA-AKUN-GITHUB.github.io`.

Website juga bisa dipasang ke layar utama HP: di Chrome, buka menu ⋮ › **Add to Home screen**.

> Kalau tidak memakai versi website, workflow *Publish website* akan gagal (tanda X merah) karena Pages belum diaktifkan. Ini tidak memengaruhi APK. Anda bisa menghapus file `.github/workflows/pages.yml` kalau tidak membutuhkannya.

---

## Cara update aplikasi

Ganti file yang berubah di GitHub (biasanya `www/index.html`): buka foldernya › **Add file › Upload files**, lalu seret file baru dan **Commit changes**. GitHub otomatis membuat APK baru dan memperbarui website. Download APK baru dari tab **Actions** seperti langkah 7, lalu install di atas yang lama.

Untuk mengubah nomor versi yang terlihat di Android, edit `"version"` di `package.json` (misalnya `1.0.1`).

## Batas paket gratis Firebase (Spark)

| Layanan | Gratis |
|---|---|
| Penyimpanan Firestore | 1 GiB |
| Baca data | 50.000 per hari |
| Tulis data | 20.000 per hari |
| Hapus data | 20.000 per hari |
| Akun pengguna (Authentication) | 50.000 pengguna aktif per bulan |

Saat mengedit, aplikasi mengirim desain ke cloud sekitar 8 detik setelah perubahan terakhir, dan langsung saat menekan **Save** atau kembali ke katalog. Untuk tim kecil, kuota di atas lebih dari cukup. Gambar yang di-upload disimpan sekali saja per gambar, meskipun dipakai di beberapa desain. Cloud Storage tidak dipakai (layanan itu tidak tersedia di paket gratis).

## Cara kerja penyimpanan

- Desain selalu disimpan dulu di perangkat, lalu dikirim ke akun. Kalau internet putus, desain tetap aman dan dikirim saat koneksi kembali.
- Status di editor: **Saved to account** (sudah di cloud), **Syncing…** (sedang mengirim), **This device only** (belum login), **Sync paused** (tidak ada koneksi).
- Desain yang dibuat sebelum login akan ikut masuk ke akun saat Anda login di perangkat itu.
- Saat logout, desain milik akun disembunyikan dari perangkat tersebut.

## Masalah umum

| Masalah | Solusi |
|---|---|
| Kartu akun bertuliskan **Cloud not set up** | `firebase-config.js` belum diisi (langkah 6), atau APK yang dipakai berasal dari build sebelum langkah 6. |
| **Sync blocked** / *The cloud database refused to save* | Aturan Firestore belum dipasang atau salah tempel. Ulangi langkah 3 nomor 4–5. |
| *This sign-in method isn't turned on* | Email/Password belum diaktifkan (langkah 2). |
| *This website address isn't allowed yet* (login Google) | Tambahkan domain github.io di Authorized domains (langkah 9 nomor 4). |
| Workflow **Build Android APK** gagal | Buka run-nya dan lihat langkah yang berwarna merah. Kalau gagal di *Build the APK* setelah menambahkan secret, kemungkinan `KEYSTORE_PASSWORD` tidak sama dengan yang dipakai saat membuat kunci. Ulangi langkah 8. |
| Tidak bisa install versi baru (*App not installed*) | Versi lama ditandatangani dengan kunci berbeda (APK debug). Uninstall dulu, lalu install. Pakai langkah 8 agar ini tidak terulang. |
| Lupa password akun | Di layar login, ketik email lalu tekan **Forgot password?**. Link reset akan dikirim ke email tersebut. |
