# ✈️ Travel Journal App

## 📱 Tentang Aplikasi

Travel Journal App adalah aplikasi mobile berbasis Flutter yang memungkinkan pengguna untuk mendokumentasikan setiap perjalanan secara personal, terstruktur, dan **offline-first**. Pengguna dapat mencatat jurnal perjalanan lengkap dengan foto, lokasi, tanggal, dan cerita — semua tersimpan aman di perangkat tanpa membutuhkan koneksi internet.

---

## ✨ Fitur Utama

| Fitur | Deskripsi |
|-------|-----------|
| 🔐 **Autentikasi Lokal** | Register & login dengan foto profil, session tersimpan otomatis di Hive |
| 📓 **CRUD Jurnal** | Tambah, lihat, edit, dan hapus jurnal perjalanan lengkap |
| 🔍 **Search Real-time** | Pencarian jurnal berdasarkan judul atau lokasi perjalanan |
| 📷 **Kamera & Galeri** | Upload foto langsung dari kamera atau galeri perangkat |
| 📊 **Travel Statistics** | Ringkasan perjalanan dengan summary card dan bar chart bulanan |
| 💾 **Offline-First** | Semua data tersimpan lokal — tidak butuh internet sama sekali |
| 🛡️ **Permission Handling** | Permintaan izin kamera & galeri dengan penjelasan yang informatif |
| 🎯 **Onboarding** | Tampilan onboarding 3 halaman, muncul hanya sekali saat pertama login |

---

## 📸 Screenshot

> *Tambahkan screenshot aplikasi di sini*

| Register | Login | Dashboard |
|----------|-------|-----------|
| ![Register](#) | ![Login](#) | ![Dashboard](#) |

| Add Journal | Detail | Stats |
|-------------|--------|-------|
| ![Add](#) | ![Detail](#) | ![Stats](#) |

---

## 🗂️ Struktur Aplikasi (8 Screen)

```
1. Register Screen    → Buat akun baru dengan nama, password, foto profil
2. Login Screen       → Masuk dengan akun yang sudah terdaftar
3. Onboarding Screen  → Pengenalan fitur (muncul sekali saat pertama login)
4. Dashboard Screen   → Daftar jurnal perjalanan + search bar
5. Add/Edit Journal   → Form input jurnal dengan validasi lengkap
6. Detail Journal     → Tampilan lengkap isi jurnal + opsi edit & hapus
7. Travel Stats       → Statistik perjalanan dengan bar chart
8. Profile Screen     → Profil user + ringkasan perjalanan + logout
```

---

## 🛠️ Tech Stack

### Framework & Language
| Teknologi | Versi | Kegunaan |
|-----------|-------|----------|
| **Flutter** | 3.x | Cross-platform mobile framework |
| **Dart** | 3.9.2 | Bahasa pemrograman utama |

### Package & Library
| Package | Versi | Kegunaan |
|---------|-------|----------|
| **hive** | ^2.2.3 | Local NoSQL database |
| **hive_flutter** | ^1.1.0 | Integrasi Hive dengan Flutter |
| **provider** | ^6.1.2 | State management reaktif |
| **image_picker** | ^1.1.2 | Akses kamera & galeri perangkat |
| **permission_handler** | ^11.3.1 | Manajemen izin perangkat |
| **google_fonts** | ^6.2.1 | Tipografi (Poppins & Inter) |
| **intl** | ^0.19.0 | Format tanggal & waktu |
| **path_provider** | ^2.1.3 | Akses direktori lokal perangkat |
| **go_router** | ^14.2.0 | Navigasi & routing |
| **lottie** | ^3.0.0 | Animasi JSON |
| **shimmer** | ^3.0.0 | Loading skeleton animation |
| **cupertino_icons** | ^1.0.8 | Icon set iOS style |

### Dev Dependencies
| Package | Versi | Kegunaan |
|---------|-------|----------|
| **hive_generator** | ^2.0.0 | Generate Hive TypeAdapter |
| **build_runner** | ^2.4.11 | Code generation tool |
| **flutter_lints** | ^5.0.0 | Linting & code quality |

---

## 🏗️ Arsitektur

Aplikasi menggunakan arsitektur **Offline-First** dengan pemisahan layer yang jelas:

```
┌─────────────────────────────────┐
│         UI Layer                │
│   (Screens & Widgets)           │
├─────────────────────────────────┤
│    State Management Layer       │
│  (Provider — JournalProvider,   │
│           AuthProvider)         │
├─────────────────────────────────┤
│         Data Layer              │
│  (Hive — Box<Journal>,          │
│   Box<User>, Box<Session>)      │
└─────────────────────────────────┘
```

### Struktur Folder

```
lib/
├── models/
│   ├── journal.dart          # Model data jurnal
│   ├── journal.g.dart        # Hive adapter (generated)
│   ├── user.dart             # Model data user
│   └── user.g.dart           # Hive adapter (generated)
├── providers/
│   ├── journal_provider.dart # State management jurnal
│   └── auth_provider.dart    # State management autentikasi
├── screens/
│   ├── register_screen.dart  # Halaman register
│   ├── login_screen.dart     # Halaman login
│   ├── onboarding_screen.dart# Halaman onboarding
│   ├── dashboard_screen.dart # Halaman utama/dashboard
│   ├── add_journal_screen.dart# Halaman tambah/edit jurnal
│   ├── detail_journal_screen.dart # Halaman detail jurnal
│   ├── stats_screen.dart     # Halaman statistik
│   └── profile_screen.dart   # Halaman profil
├── widgets/
│   ├── journal_card.dart     # Card jurnal reusable
│   ├── empty_state.dart      # Tampilan empty state
│   ├── stat_card.dart        # Card statistik reusable
│   └── custom_text_field.dart# Text field custom
├── utils/
│   ├── constants.dart        # Warna, tema, style
│   ├── date_formatter.dart   # Helper format tanggal
│   └── permission_handler.dart# Handler izin perangkat
└── main.dart                 # Entry point & routing
```

---

## 🎨 Design System

### Color Palette
| Nama | Hex | Kegunaan |
|------|-----|----------|
| **Deep Blue** | `#1A3A5C` | Warna utama (primary) |
| **Warm Gold** | `#D4A853` | Warna aksen |
| **Olive Green** | `#6B7C3E` | Warna pendukung |
| **Warm Sand** | `#F5F0E8` | Background utama |
| **White** | `#FFFFFF` | Surface/card |

### Typography
- **Heading** → Poppins (Bold)
- **Body** → Inter (Regular, line-height 1.6)
- **Label** → Inter (Medium)

---

## 🚀 Cara Menjalankan

### Prerequisites
- Flutter SDK (versi 3.x)
- Android Studio / VS Code
- Android device atau emulator

### Langkah

**1. Clone repository**
```bash
git clone https://github.com/Lnggaa/UAS_MobileComputing.git
cd UAS_MobileComputing
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Jalankan di Chrome (Web)**
```bash
flutter run -d chrome
```

**4. Jalankan di Android**
```bash
flutter run
```

**5. Build APK**
```bash
flutter build apk --release
```
APK tersedia di: `build/app/outputs/flutter-apk/app-release.apk`

---

## 📋 Pemenuhan Kriteria UAS

| No | Ketentuan Minimal | Status |
|----|-------------------|--------|
| 1 | Minimal 3 screen/halaman | ✅ 8 screen |
| 2 | Navigasi antarhalaman | ✅ Named routes + AuthGate |
| 3 | State management dasar | ✅ Provider (2 provider) |
| 4 | Penyimpanan data lokal (Hive) | ✅ 3 Hive Box |
| 5 | Penggunaan data lokal | ✅ CRUD jurnal & autentikasi |
| 6 | Fitur perangkat mobile (kamera) | ✅ image_picker + permission |
| 7 | Form input dan validasi | ✅ Validasi lengkap |
| 8 | Desain antarmuka (usability) | ✅ Design system konsisten |
| 9 | Struktur project rapi | ✅ 5 folder terstruktur |

---

## 👤 Developer

**Nama** : Muhamad Angga Prida Saputra  
**NIM** : 24110400013
**Prodi** : Sistem Teknologi & Informasi
**Mata Kuliah** : Mobile Computing  
**Tahun** : 2025/2026  

