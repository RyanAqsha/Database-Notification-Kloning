# Database-Notification-Kloning
# Notification SQL Project

## Deskripsi

Proyek ini adalah studi kasus desain database untuk mengelola notifikasi dalam aplikasi. Fitur yang disediakan meliputi:

- Menyimpan data pengguna dan notifikasi.
- Mengelompokkan notifikasi ke dalam kategori (Promo dan Info).
- Menandai notifikasi sebagai dibaca atau belum dibaca.
- Menghitung jumlah notifikasi yang belum dibaca.
- Menampilkan notifikasi terbaru berdasarkan ID.

## Fitur Utama

1. **Tabel User**: Menyimpan informasi pengguna.
2. **Tabel Notification**: Menyimpan data notifikasi.
3. **Tabel Category**: Menyimpan kategori notifikasi.
4. **Tabel NotificationRead**: Mencatat status baca dari notifikasi per pengguna.
5. **View UnreadCount**: Menghitung jumlah notifikasi yang belum dibaca.
6. **Trigger UpdateReadStatus**: Memberikan sinyal saat notifikasi ditandai sebagai dibaca.
7. **Prosedur GetUserNotifications**: Mengambil notifikasi untuk pengguna tertentu.

## Cara Menggunakan

1. **Impor File SQL**:
   ```bash
   mysql -u [username] -p [database_name] < Notification.sql
