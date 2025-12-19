# MamiCoach Mobile
[![Build Status](https://app.bitrise.io/app/4ce4a436-2137-4ff8-a52a-9c66c38e7575/status.svg?token=c0bp-Q4qTMROXMeW85JwgA&branch=release)](https://app.bitrise.io/app/4ce4a436-2137-4ff8-a52a-9c66c38e7575)
[![Quality Gate Status](https://sonarqube-sonarqube.tenex.cloud/api/project_badges/measure?project=pbp-kelompok-e02_mamicoach-mobile_eb07f6e9-478b-4f1f-85dd-0e3dbede1903&metric=alert_status&token=sqb_7182fd41238a2b334d9d43f1515c3b6d3b652625)](https://sonarqube-sonarqube.tenex.cloud/dashboard?id=pbp-kelompok-e02_mamicoach-mobile_eb07f6e9-478b-4f1f-85dd-0e3dbede1903)

> [!Note]
> **Anggota Kelompok PBP E02**:
> - Galih Nur Rizqy (2406343224)
> - Kevin Cornellius Widjaja (2406428781)
> - Natan Harum Panogu Silalahi (2406496170)
> - Vincent Valentino Oei (2406353225)
> - Vincentius Filbert Amadeo (2406351711)

### Table of Contents
- [MamiCoach Mobile](#mamicoach-mobile)
  - [Deskripsi Proyek](#deskripsi-proyek)
  - [Modul / Fitur di Flutter](#modul--fitur-di-flutter)
  - [Peran atau Aktor Pengguna](#peran-atau-aktor-pengguna)
  - [Alur Pengintegrasian dengan Web Service](#alur-pengintegrasian-dengan-web-service)
  - [Arsitektur Proyek Flutter](#arsitektur-proyek-flutter)
  - [Environment \& Konfigurasi Backend URL](#environment--konfigurasi-backend-url)
  - [Autentikasi: CookieRequest + Django Session](#autentikasi-cookierequest--django-session)
  - [Cara Menjalankan (Development)](#cara-menjalankan-development)
  - [Tech Stack](#tech-stack)
  - [Link Terkait (Backend \& Desain)](#link-terkait-backend--desain)

---

## Deskripsi Proyek
**MamiCoach** adalah platform yang menghubungkan pelatih profesional dengan pengguna yang ingin belajar langsung dari ahlinya. Pengguna dapat:

- Mencari dan memilih kelas dari pelatih berkualitas,
- Melakukan booking dan pembayaran kelas,
- Berkomunikasi dengan coach melalui fitur chat,
- Memberikan rating dan review setelah kelas selesai,
- Coach dapat mengelola kelas, jadwal, dan murid mereka.

Repositori ini berfokus pada **client Flutter** (Android, iOS, Web, Desktop) yang berkomunikasi dengan backend Django MamiCoach menggunakan session-based auth (cookie).

---

## Modul / Fitur di Flutter
Struktur fitur di Flutter dibuat agar mirip dengan modularisasi di backend Django:

### 1. Authentication & User Management
Natan Harum Panogu Silalahi  

**Fitur:**
- Login/Logout/Registrasi menggunakan session cookie dari backend Django,
- Role-based access control (User, Coach, Admin),
- Halaman profil pengguna dengan edit data pribadi,
- Integrasi dengan endpoint auth backend.

### 2. Class & Coach Management
Kevin Cornellius Widjaja  

**Fitur:**
- Menampilkan daftar kelas dengan filter dan search,
- Halaman detail kelas (deskripsi, rating, coach info),
- Coach dapat membuat, mengedit, dan menghapus kelas,
- Integrasi dengan endpoint class backend.

### 3. Booking & Schedule
Galih Nur Rizqy  

**Fitur:**
- Form booking dengan pilihan tanggal dan jam,
- Dashboard user untuk melihat daftar booking,
- Dashboard coach untuk mengelola sesi dan update status,
- Real-time availability dari coach.

### 4. Payment System
Vincentius Filbert Amadeo  

**Fitur:**
- Integrasi payment gateway (Midtrans/Xendit),
- Alur pembayaran melalui webview,
- Riwayat transaksi dan invoice,
- Status pembayaran real-time.

### 5. Chat & Review
Vincent Valentino Oei  

**Fitur:**
- Real-time chat antara user dan coach,
- Form rating dan review setelah kelas selesai,
- Tampilan review di halaman detail kelas,
- Integrasi dengan modul chat backend.

---

## Peran atau Aktor Pengguna

Aplikasi MamiCoach Mobile memiliki tiga peran utama dengan hak akses yang berbeda:

### 1. Pengguna (User)
Peran ini ditujukan untuk individu yang ingin belajar dan mengembangkan keterampilan baru.

**Hak Akses:**
- **Mencari & Menemukan Kelas:** Dapat menjelajahi semua kategori, mencari pelatih, dan memfilter kelas berdasarkan subjek, rating, atau harga.
- **Booking & Pembayaran:** Dapat melakukan booking kelas dan menyelesaikan transaksi pembayaran.
- **Chat dengan Coach:** Berkomunikasi dengan coach sebelum dan sesudah kelas.
- **Review & Rating:** Memberikan penilaian dan ulasan setelah menyelesaikan kelas untuk membantu pengguna lain.
- **Manajemen Profil:** Mengelola informasi profil pribadi dan melihat riwayat kelas.

### 2. Pelatih (Coach)
Peran ini untuk para profesional atau ahli di bidangnya yang ingin membagikan ilmunya.

**Hak Akses:**
- **Profil Terverifikasi:** Memiliki halaman profil publik yang menampilkan keahlian, pengalaman, dan badge verifikasi.
- **Kelola Kelas:** Dapat membuat, mengedit, dan menghapus kelas yang ditawarkan, termasuk menentukan harga dan jadwal.
- **Kelola Booking:** Melihat dan mengelola booking dari murid (confirm, reschedule, cancel).
- **Chat dengan Murid:** Berkomunikasi dengan murid yang sudah booking kelas.
- **Monitor Performa:** Melihat rating, review, dan statistik performa kelas.

### 3. Admin
Peran ini untuk pengelola platform yang bertanggung jawab menjaga kualitas dan operasional aplikasi.

**Hak Akses:**
- **Verifikasi Coach:** Meninjau dan memverifikasi pendaftaran coach baru serta memberikan status "Verified Coach".
- **Manajemen Pembayaran:** Mengelola alur keuangan, konfirmasi pembayaran, dan proses payout ke coach.
- **Manajemen Refund:** Memproses dan menyetujui permintaan pengembalian dana dari pengguna.
- **Monitoring Platform:** Memantau aktivitas pengguna, transaksi, dan performa aplikasi secara keseluruhan.

---

## Alur Pengintegrasian dengan Web Service

Aplikasi mobile MamiCoach terintegrasi dengan backend Django yang sudah dibuat pada Proyek Tengah Semester. Berikut adalah detail integrasinya:

### Arsitektur Komunikasi

```
[Flutter Mobile App]
        |
        | HTTP Request (JSON)
        |
        v
[Django REST API Backend]
        |
        | Query/Update Database
        |
        v
   [PostgreSQL]
        |
        | Response (JSON)
        |
        v
[Flutter Mobile App]
        |
        v
  [UI Update]
```

### Endpoint & Metode HTTP

**1. Authentication Module**
- `POST /auth/register/` - Registrasi user/coach baru
- `POST /auth/login/` - Login dengan username/password
- `POST /auth/logout/` - Logout dan hapus session
- `GET /auth/profile/` - Ambil data profil user
- `PUT /auth/profile/update/` - Update data profil

**2. Class & Coach Module**
- `GET /class/list/` - Ambil daftar semua kelas (dengan filter)
- `GET /class/<id>/` - Detail kelas spesifik
- `POST /class/create/` - Coach membuat kelas baru
- `PUT /class/<id>/update/` - Coach update kelas
- `DELETE /class/<id>/delete/` - Coach hapus kelas
- `GET /coach/list/` - Daftar semua coach

**3. Booking & Schedule Module**
- `GET /booking/availability/` - Cek ketersediaan jadwal coach
- `POST /booking/create/` - User membuat booking baru
- `GET /booking/user/` - Daftar booking user
- `GET /booking/coach/` - Daftar booking untuk coach
- `PATCH /booking/<id>/status/` - Update status booking

**4. Payment Module**
- `POST /payment/generate-link/` - Generate payment link (Midtrans/Xendit)
- `GET /payment/history/` - Riwayat transaksi user
- `POST /payment/webhook/` - Handle webhook dari payment gateway
- `GET /payment/status/<id>/` - Cek status pembayaran

**5. Chat & Review Module**
- `POST /chat/send/` - Kirim pesan chat
- `GET /chat/history/<booking_id>/` - Ambil history chat
- `POST /review/submit/` - Submit review dan rating
- `GET /review/class/<id>/` - Ambil review untuk kelas tertentu

### Mekanisme Autentikasi

**Session-Based Authentication:**
1. User login melalui aplikasi Flutter
2. Backend Django memverifikasi kredensial
3. Jika valid, Django mengirim `sessionid` cookie
4. Flutter menyimpan cookie di `SharedPreferences` via `CookieRequest`
5. Setiap request selanjutnya menyertakan cookie untuk autentikasi
6. Backend memvalidasi session dan memberikan akses sesuai role

### Format Data (JSON)

**Contoh Request (Login):**
```json
{
  "username": "johndoe",
  "password": "password123"
}
```

**Contoh Response (Login Success):**
```json
{
  "status": "success",
  "message": "Login successful",
  "user": {
    "id": 1,
    "username": "johndoe",
    "role": "user",
    "email": "john@example.com"
  }
}
```

**Contoh Response (Class List):**
```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "title": "Yoga untuk Pemula",
      "coach": "Jane Smith",
      "price": 150000,
      "rating": 4.8,
      "category": "Fitness"
    }
  ]
}
```

### Error Handling

Aplikasi menangani berbagai status HTTP:
- `200` - Success
- `201` - Created
- `400` - Bad Request (validasi gagal)
- `401` - Unauthorized (belum login)
- `403` - Forbidden (tidak punya akses)
- `404` - Not Found
- `500` - Internal Server Error

---

## Cara Menjalankan (Development)

### 1. Clone Repository
```bash
git clone https://github.com/pbp-kelompok-e02/mamicoach-mobile.git
cd mamicoach-mobile
```

### 2. Pastikan Backend Django Berjalan
Jalankan backend MamiCoach (repositori Django):

```bash
git clone https://github.com/pbp-kelompok-e02/mamicoach.git
cd mamicoach
# setup virtualenv, install requirements, migrate, lalu:
python manage.py runserver
```

Secara default backend akan berjalan di `http://127.0.0.1:8000/`.

### 3. Setup Environment
Salin contoh `.env`:

```bash
cp .env.example .env
# lalu edit nilai BACKEND_BASE_URL jika perlu
```

Contoh untuk emulator Android:
```
BACKEND_BASE_URL=http://10.0.2.2:8000
```

### 4. Install Dependency Flutter
```bash
flutter pub get
```

### 5. Jalankan Aplikasi

**Android (emulator/device)**
```bash
flutter run --dart-define=BACKEND_BASE_URL=http://10.0.2.2:8000
```

**Web (Chrome)**
```bash
flutter run -d chrome --dart-define=BACKEND_BASE_URL=http://localhost:8000
```

Sesuaikan URL dengan alamat backend Django Anda.

---

## Tech Stack

**Frontend:**
- Flutter
- Dart

**Backend (terpisah):**
- Django
- PostgreSQL

**Tools:**
- http / pbp_django_auth

---

## Link Terkait (Backend & Desain)

Link di bawah ini merujuk ke proyek backend & desain MamiCoach.

- **Repository Backend Django:** [https://github.com/pbp-kelompok-e02/mamicoach](https://github.com/pbp-kelompok-e02/mamicoach)
- **Deployment Backend:** [https://kevin-cornellius-mamicoach.pbp.cs.ui.ac.id/](https://kevin-cornellius-mamicoach.pbp.cs.ui.ac.id/)
- **Figma Design:** [https://www.figma.com/design/Ysa8K8heNxQcG8eyjdRAXD/TK-PBP-E02](https://www.figma.com/design/Ysa8K8heNxQcG8eyjdRAXD/TK-PBP-E02?node-id=0-1&t=q5cEKERHtkHz8QlB-1)
- **ERD (Entity Relationship Diagram):** [https://dbdiagram.io/d/68e6390fd2b621e422d55017](https://dbdiagram.io/d/68e6390fd2b621e422d55017)
- **APK Download:** [https://app.bitrise.io/app/4ce4a436-2137-4ff8-a52a-9c66c38e7575/installable-artifacts/6699d484f9b882a2/public-install-page/f76fc96d10478f06766ae8cf6eae499a](https://app.bitrise.io/app/4ce4a436-2137-4ff8-a52a-9c66c38e7575/installable-artifacts/6699d484f9b882a2/public-install-page/f76fc96d10478f06766ae8cf6eae499a)
