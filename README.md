<div align="center">

# 💜 StudyPlan 💗

### Catatan Tugas Sekolah

<img src="icon.png" width="200" alt="StudyPlan Logo"/>

<br/>

[![Flutter](https://img.shields.io/badge/Flutter-3.x-9B72CF?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-FF85A2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Android](https://img.shields.io/badge/Android-Ready-B794E0?style=for-the-badge&logo=android&logoColor=white)](https://developer.android.com)
[![License](https://img.shields.io/badge/License-MIT-FFB3C6?style=for-the-badge)](LICENSE)

<br/>

> *Atur Tugasmu, Raih Prestasimu!*

Aplikasi manajemen tugas sekolah yang membantu kamu mencatat, mengatur, dan menyelesaikan tugas tepat waktu dengan tampilan yang cute dan simple.

<br/>

---

</div>

## ✨ Fitur Utama

| Fitur | Deskripsi |
|:---:|:---|
| 📝 **Manajemen Tugas** | Tambah, edit, dan hapus tugas dengan mudah |
| 🔔 **Pengingat Otomatis** | Notifikasi sebelum deadline (1 jam, 1 hari, 3 hari) |
| 📅 **Kalender** | Lihat tugas berdasarkan tanggal di kalender |
| ✅ **Status Tugas** | Tandai tugas selesai / belum selesai |
| 📊 **Statistik** | Pantau progress belajar di halaman profil |
| 💾 **Penyimpanan Lokal** | Data tersimpan offline menggunakan Hive |
| 🎨 **UI Cute** | Desain purple & pink yang simple dan aesthetic |

---

## 🎨 Palet Warna

<div align="center">

| Warna | Hex | Preview |
|:---|:---|:---:|
| Primary Purple | `#9B72CF` | ![#9B72CF](https://via.placeholder.com/80x30/9B72CF/9B72CF) |
| Primary Light | `#B794E0` | ![#B794E0](https://via.placeholder.com/80x30/B794E0/B794E0) |
| Accent Pink | `#FF85A2` | ![#FF85A2](https://via.placeholder.com/80x30/FF85A2/FF85A2) |
| Pink Light | `#FFB3C6` | ![#FFB3C6](https://via.placeholder.com/80x30/FFB3C6/FFB3C6) |
| Completed | `#5CD6A0` | ![#5CD6A0](https://via.placeholder.com/80x30/5CD6A0/5CD6A0) |
| Background | `#F8F5FF` | ![#F8F5FF](https://via.placeholder.com/80x30/F8F5FF/F8F5FF) |

</div>

---

## 📱 Screenshots

<div align="center">

| Splash Screen | Home Screen | Detail Tugas | Profil |
|:---:|:---:|:---:|:---:|
| Animasi kucing | Daftar tugas | Info lengkap | Statistik |

</div>

---

## 🏗️ Arsitektur Proyek

```
lib/
├── main.dart                  # Entry point & navigasi
├── models/
│   └── task_model.dart        # Model data tugas
├── screens/
│   ├── splash_screen.dart     # Splash dengan Lottie animation
│   ├── home_screen.dart       # Halaman utama
│   ├── add_task_screen.dart   # Form tambah tugas
│   ├── detail_task_screen.dart# Detail & status tugas
│   ├── calendar_screen.dart   # Kalender tugas
│   ├── completed_screen.dart  # Daftar tugas selesai
│   └── profile_screen.dart    # Statistik & profil
├── services/
│   ├── storage_service.dart   # CRUD dengan Hive
│   └── notification_service.dart # Notifikasi lokal
├── theme/
│   ├── app_colors.dart        # Palet warna purple & pink
│   └── app_theme.dart         # Konfigurasi tema
└── widgets/
    ├── task_card.dart          # Card tugas
    ├── summary_card.dart       # Card ringkasan
    ├── priority_badge.dart     # Badge prioritas
    └── empty_state.dart        # State kosong
```

---

## 🛠️ Tech Stack

<div align="center">

| Teknologi | Kegunaan |
|:---|:---|
| **Flutter** | Framework UI cross-platform |
| **Dart** | Bahasa pemrograman |
| **Hive CE** | Penyimpanan data lokal |
| **Flutter Local Notifications** | Notifikasi pengingat |
| **Lottie** | Animasi splash screen |
| **Google Fonts** | Tipografi Poppins |
| **Table Calendar** | Widget kalender |
| **Timezone** | Penjadwalan notifikasi |

</div>

---

## 🚀 Cara Menjalankan

### Prasyarat
- Flutter SDK 3.x
- Android SDK
- Perangkat Android / Emulator

### Langkah-langkah

```bash
# 1. Clone repository
git clone https://github.com/aliciamonika5408-rgb/StudyPlan_Mobile.git

# 2. Masuk ke direktori
cd StudyPlan_Mobile

# 3. Install dependencies
flutter pub get

# 4. Generate launcher icon
dart run flutter_launcher_icons

# 5. Jalankan aplikasi
flutter run
```

### Build APK

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
```

---

## 📋 Fitur Prioritas

<div align="center">

| Prioritas | Warna | Keterangan |
|:---:|:---:|:---|
| 🔴 **Tinggi** | Pink | Tugas mendesak, segera kerjakan |
| 🟡 **Sedang** | Kuning | Tugas biasa, kerjakan sesuai jadwal |
| 🔵 **Rendah** | Biru | Tugas santai, bisa dikerjakan nanti |

</div>

---

## 🔔 Pengingat

Aplikasi akan mengirim notifikasi pengingat sebelum deadline:

- **1 Jam** sebelum deadline
- **1 Hari** sebelum deadline  
- **3 Hari** sebelum deadline
- Bisa dinonaktifkan per tugas

---

## 🤝 Kontribusi

Kontribusi sangat diterima! Silakan:

1. Fork repository ini
2. Buat branch fitur baru (`git checkout -b fitur-baru`)
3. Commit perubahan (`git commit -m 'Tambah fitur baru'`)
4. Push ke branch (`git push origin fitur-baru`)
5. Buat Pull Request

---

<div align="center">

### 💜 Made with love by Alicia Monika 💗

<br/>

*Atur Tugasmu, Raih Prestasimu!*

<br/>

[![GitHub](https://img.shields.io/badge/GitHub-aliciamonika5408--rgb-9B72CF?style=flat-square&logo=github)](https://github.com/aliciamonika5408-rgb)

</div>
