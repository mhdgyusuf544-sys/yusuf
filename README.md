# KelasPaham — Asisten Kuliah

Website statis untuk membantu mengubah penjelasan dosen menjadi catatan belajar yang lebih mudah dipahami.

## Fitur
- Antarmuka responsif untuk HP dan laptop.
- Input transkrip manual dan transkripsi suara bahasa Indonesia melalui Web Speech API (dukungan tergantung browser).
- Mode rangkuman lokal dasar tanpa API.
- Opsional: integrasi Gemini API untuk rangkuman, penjelasan sederhana, istilah, contoh, dan soal latihan.
- Simpan catatan di localStorage browser, salin materi, dan unduh sebagai TXT.
- Bisa dipublikasikan melalui GitHub Pages.

## Jalankan melalui GitHub Pages
1. Buka **Settings → Pages** pada repository.
2. Pada **Build and deployment**, pilih **Deploy from a branch**.
3. Pilih branch `main` dan folder `/ (root)`, lalu **Save**.
4. Tunggu deployment selesai. URL umumnya `https://USERNAME.github.io/REPOSITORY/`.

## Integrasi AI (opsional)
1. Buat API key melalui [Google AI Studio](https://aistudio.google.com/app/apikey).
2. Buka situs → **Pengaturan AI** → masukkan key → simpan.
3. API key disimpan di localStorage browser. Untuk pemakaian pribadi, jangan gunakan perangkat umum dan hapus key jika tidak dipakai. Situs statis tidak menyediakan backend untuk menyembunyikan API key; pemakaian API tunduk pada kuota dan ketentuan provider.

## Privasi dan batasan
- Catatan tersimpan hanya pada browser/perangkat yang digunakan; tidak otomatis tersinkron ke HP lain.
- Transkripsi suara bergantung pada dukungan browser dan koneksi internet. Minta izin yang sesuai sebelum merekam kelas.
- Tanpa API key, rangkuman lokal hanya pemilihan kalimat/kata sederhana dan bukan pemahaman AI penuh.
- Periksa hasil AI dan cocokkan definisi, angka, serta rumus dengan materi resmi dosen.

Dibuat sebagai asisten belajar pribadi.
