# REQUIREMENT DATABASE DESIGN

# Feature: Notifikasi
# 1. Feature Inbox
#   Menampilkan semua informasi notifikasi untuk semua pengguna dalam satu tampilan.

# 2. Feature Kategori
# -Promo:
#  Berisi informasi promo yang akan di-broadcast ke semua pengguna.
# -Info:
#  Berisi informasi yang hanya ditujukan untuk pengguna tertentu, misalnya pengguna yang telah melakukan pembelian atau pembayaran.
# -Behavior:
#  Ketika kategori diklik, secara otomatis isi Inbox akan difilter untuk hanya menampilkan notifikasi dari kategori yang dipilih.
# 3. Feature Read/Unread
#   Membeda-bedakan antara notifikasi yang telah dibaca (read) dan yang belum dibaca (unread).
#   Memberikan tanda visual, seperti warna atau ikon, untuk menunjukkan status read/unread.
# 4. Feature Jumlah Notifikasi
#   Menu notifikasi harus menampilkan jumlah notifikasi yang belum dibaca secara real-time agar pengguna dapat langsung mengetahuinya.
# Catatan
# Pastikan sistem ini user-friendly dan memudahkan interaksi dengan notifikasi.
# Desain database harus dioptimalkan untuk performa, terutama dalam proses filtering, penandaan read/unread, dan penghitungan jumlah notifikasi.

########################################################################################################
# 1. User
CREATE Table User(
    id VARCHAR (100) NOT NULL,
    name VARCHAR (100) NOT NULL,
    PRIMARY KEY (id)
) engine = InnoDB;

SHOW TABLES;
# Kita coba insert data 
INSERT INTO user (id, name) VALUES ("Eko","Eko Kurniawan"), ("Ryan","Ryan Kurniawan");
SELECT*from user;

# Tabel user digunakan untuk menyimpan data pengguna aplikasi.
# Kolom id: Kunci utama untuk setiap pengguna, wajib diisi.
# Kolom name: Nama pengguna, wajib diisi.

#############################################################################################
# Pengerjaan Feature Inbox

# 2. Notification
# Dalam tabel notification, jika ada user yang ingin diberikan informasi maka
# notikasi hanya masuk ke user tertentu dan ada juga notification yang di tujukan
# secara global.Taktisinya user_id dibuat no lable sehingga kalau global maka null user_idnya
CREATE TABLE Notification(
    id INT NOT NULL AUTO_INCREMENT,
    Title VARCHAR (255) NOT NULL,
    Detail TEXT NOT NULL,
    Created_at TIMESTAMP NOT NULL,
    user_id VARCHAR(100),
    PRIMARY KEY (id)
) engine=InnoDB ;

# Tabel Notification menyimpan data notifikasi.
# Kolom id: Kunci utama, dengan nilai yang dihasilkan secara otomatis.
# Kolom Title: Judul notifikasi, wajib diisi.
# Kolom Detail: Rincian isi notifikasi.
# Kolom Created_at: Tanggal dan waktu ketika notifikasi dibuat, wajib diisi.
# Kolom user_id: ID pengguna terkait, bersifat opsional.

SHOW TABLES ;
DESCRIBE notification;

# kita buat relasinya 
ALTER table notification
    ADD constraint fk_notification_user
        FOREIGN KEY (user_id) REFERENCES user (id);
DESCRIBE notification;

# kita buat datanya khusus untuk user tertentu Pesanan (1), global (2), Pembayaran (3)
# (1)
INSERT INTO notification (`Title`, `Detail`,`Created_at`,user_id)
VALUES ('Contoh Pesanan','Detail Pesanan', CURRENT_TIMESTAMP,'Eko');
# (2)
INSERT INTO notification (`Title`, `Detail`,`Created_at`,user_id)
VALUES ('Contoh Promo','Detail Promo', CURRENT_TIMESTAMP, null);
# (3)
INSERT INTO notification (`Title`, `Detail`,`Created_at`,user_id)
VALUES ('Contoh Pembayaran','Detail Pembayaran', CURRENT_TIMESTAMP, 'ryan');

SELECT*FROM notification;
# Cara menampilkan 
# Pesanan Eko
SELECT*FROM notification WHERE user_id= 'eko';
# Pesanan Eko atau promo
SELECT*FROM notification 
    WHERE (user_id= 'eko' or user_id is NULL) 
        ORDER BY created_at DESC;
# Pembayaran Ryan atau Promo
SELECT*FROM notification 
    WHERE (user_id= 'Ryan' or user_id is NULL) 
        ORDER BY created_at DESC;
# Note: Sekarang Feature Inboxnya Sudah Siap
#######################################################################

#Pengerjaan Feature Kategori
# 3. Category
CREATE Table Category (
    id VARCHAR(100) NOT NULL,
    name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
)Engine = InnoDB

# Tabel Category digunakan untuk menyimpan kategori notifikasi.
# Kolom id: Kunci utama kategori, berupa string unik yang wajib diisi.
# Kolom name: Nama kategori, wajib diisi.
SHOW TABLES; 

# selanjutnya kita insert data category
INSERT INTO category (id, name) VALUES ("INFO", "Info");
INSERT INTO category (id, name) VALUES ("PROMO", "Promo");

SELECT*FROM category;

#sekarang karena Table notifikasi harus terhubung dengan Table Category
# maka kita tambah Category_id di Table Notification
ALTER Table notification
    ADD COLUMN category_id VARCHAR(100);
# kita coba lihat
DESCRIBE notification;

# kita isi column category_id nya
UPDATE notification
    SET category_id = "INFO"
        where id = 1;
UPDATE notification
    SET category_id = "INFO"
        where id = 2;
UPDATE notification
    SET category_id = "PROMO"
        where id = 3;
SELECT*FROM notification;

# ok sudah ada, sekarang kita buat relasinya table notification dengan table category
ALTER Table notification
    ADD constraint fk_notification_category
        Foreign Key (category_id) REFERENCES category(id);
DESCRIBE Notification;

# kita ingin select 1 user saja dan disertai promo
SELECT*FROM notification
    where (user_id="Eko" OR category_id = "PROMO") 
        ORDER BY created_at DESC;
SELECT*FROM notification
    where (user_id="Ryan" OR category_id = "PROMO") 
        ORDER BY created_at DESC;

# tapi kita ingin nama categorynya juga muncul maka kita pakai join
SELECT*FROM notification as n JOIN category as c 
    ON (n.category_id = c.id);

# ok sudah, kita ambil lagi per user + promo
SELECT*FROM notification as n JOIN category as c 
    ON (n.category_id = c.id)
        where (user_id="Eko" OR category_id = "PROMO") 
            ORDER BY created_at DESC;
SELECT*FROM notification as n JOIN category as c 
    ON (n.category_id = c.id)
        where (user_id="Ryan" OR category_id = "PROMO") 
            ORDER BY created_at DESC;
# kalau kita click info, info saja yang muncul untuk user ryan
SELECT*FROM notification as n JOIN category as c 
    ON (n.category_id = c.id)
        where (user_id="Ryan" OR category_id = "PROMO") 
            AND c.id = "INFO"
                ORDER BY created_at DESC;

# kalau kita click Promo, promo saja yang muncul untuk user EKo
SELECT*FROM notification as n JOIN category as c 
    ON (n.category_id = c.id)
        where (user_id="Eko" OR category_id = "PROMO") 
            AND c.id = "PROMO"
                ORDER BY created_at DESC;
# Oke sekarang Feature Category sudah selesai
##########################################################################################

# 4. Read & Unread
# kita bisa saja memasukkan semisal is_read pada table Notification
# kalau semua user ada user_id, tapi masalahnya ada user global sehingga ini tidak bisa
# solusinya, kita buat table baru yang kita sebut NotificationRead

CREATE Table NotificationRead (
    id INT NOT NULL AUTO_INCREMENT,
    is_read BOOLEAN NOT NULL,
    notification_id INT NOT NULL,
    user_id VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
) Engine = InnoDB;

# Tabel ini digunakan untuk mencatat status "dibaca" dari setiap notifikasi untuk setiap pengguna.
# Kolom id: Kunci utama, dengan nilai yang dihasilkan secara otomatis.
# Kolom is_read: Status apakah notifikasi telah dibaca (TRUE atau FALSE), wajib diisi.
# Kolom notification_id: ID notifikasi yang terkait, merujuk pada tabel Notification.
# Kolom user_id: ID pengguna yang menerima notifikasi, wajib diisi.
SHOW TABLES;

# okey, sekarang kita buat relasinya 
ALTER Table notificationread
    ADD constraint fk_notificationread_notification
        Foreign Key (notification_id) REFERENCES notification (id);
ALTER Table notificationread
    ADD constraint fk_notificationread_user
        Foreign Key (user_id) REFERENCES user (id);
DESC notificationread;

# sekarang kita coba read dan unreadnya untuk promo global
SELECT*FROM notification;
INSERT INTO notificationread (is_read,notification_id,user_id)
    VALUES (TRUE,3,'Eko');
INSERT INTO notificationread (is_read,notification_id,user_id)
    VALUES (TRUE,3,'Ryan');
SELECT*FROM notificationread;


SELECT*FROM notification as n 
    JOIN category as c ON (n.category_id = c.id)
    JOIN notificationread nr ON (nr.notification_id = n.id)
        where (n.user_id="Ryan" OR n.user_id is NULL) 
            AND nr.user_id = "Ryan" ORDER BY n.created_at DESC;

SELECT*FROM notification as n 
    JOIN category as c ON (n.category_id = c.id)
    LEFT JOIN notificationread nr ON (nr.notification_id = n.id)
        where (n.user_id="Ryan" OR n.user_id is NULL) 
            AND (nr.user_id = "Ryan" OR nr.user_id is null)
             ORDER BY n.created_at DESC;
# untuk memastikan kita coba lagi insert data di table notification
INSERT INTO notification (title, detail, category_id, user_id, Created_at)
    VALUES ('contoh pesanan lagi','detai pesanan lagi', 'INFO', 'Ryan', CURRENT_TIMESTAMP);
INSERT INTO notification (title, detail, category_id, user_id, Created_at)
    VALUES ('contoh promo lagi','detai promo lagi', 'PROMO', NULL, CURRENT_TIMESTAMP);
SELECT*FROM notification;
# ok sudah, dan run kembali query pada baris 190
# okey sekarang kita sudah bisa implementasi feature read & unread

##################################################################################################

# 5. Counter
# kita hanya akan select dan jumlahkan bagian yang Unread untuk mengetahui berapa yang belum di baca

SELECT COUNT(*) FROM notification as n 
    JOIN category as c ON (n.category_id = c.id)
    LEFT JOIN notificationread nr ON (nr.notification_id = n.id)
        where (n.user_id="Ryan" OR n.user_id is NULL) 
            AND ( nr.user_id is null)
             ORDER BY n.created_at DESC;
# sekarang sisa 3 yang belum dibaca oleh Ryan
# mari kita buat bahwa ryan sudah membaca satu lagi

#kita cek id
SELECT*FROM notification;
#kita baca lagi
INSERT INTO notificationread (is_read,notification_id,user_id)
    VALUES (TRUE,2,'Ryan');
# kita pastikan
SELECT*FROM notification as n 
    JOIN category as c ON (n.category_id = c.id)
    LEFT JOIN notificationread nr ON (nr.notification_id = n.id)
        where (n.user_id="Ryan" OR n.user_id is NULL) 
            AND (nr.user_id = "Ryan" OR nr.user_id is null)
             ORDER BY n.created_at DESC;
# kita Counter lagi
SELECT COUNT(*) FROM notification as n 
    JOIN category as c ON (n.category_id = c.id)
    LEFT JOIN notificationread nr ON (nr.notification_id = n.id)
        where (n.user_id="Ryan" OR n.user_id is NULL) 
            AND ( nr.user_id is null)
             ORDER BY n.created_at DESC;
# sekarang sisa 2 yang belum terbaca, lakukan baris ke 225 hingga 243 untuk
# mebuat ryan membaca INFO atau PROMO lagi

# okey sekarang Mini Project Databases Design untuk Studi Kasusnya Feature Notification telah selesai