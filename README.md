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

![Primary Purple](https://img.shields.io/badge/Primary_Purple-%239B72CF?style=for-the-badge)
![Primary Light](https://img.shields.io/badge/Primary_Light-%23B794E0?style=for-the-badge)
![Accent Pink](https://img.shields.io/badge/Accent_Pink-%23FF85A2?style=for-the-badge)
![Pink Light](https://img.shields.io/badge/Pink_Light-%23FFB3C6?style=for-the-badge)
![Completed](https://img.shields.io/badge/Completed-%235CD6A0?style=for-the-badge)
![Background](https://img.shields.io/badge/Background-%23F8F5FF?style=for-the-badge&labelColor=F8F5FF)

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

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)
![Hive](https://img.shields.io/badge/Hive_CE-FFB347?style=flat-square)
![Lottie](https://img.shields.io/badge/Lottie-00DDB3?style=flat-square)
![Google Fonts](https://img.shields.io/badge/Google_Fonts-4285F4?style=flat-square&logo=google&logoColor=white)

</div>

| Teknologi | Kegunaan |
|:---|:---|
| **Flutter** | Framework UI cross-platform |
| **Dart** | Bahasa pemrograman |
| **Hive CE** | Penyimpanan data lokal |
| **Flutter Local Notifications** | Notifikasi pengingat |
| **Lottie** | Animasi splash screen |
| **Google Fonts (Poppins)** | Tipografi |
| **Table Calendar** | Widget kalender |
| **Timezone** | Penjadwalan notifikasi |

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

## 📋 Prioritas Tugas

<div align="center">

![Tinggi](https://img.shields.io/badge/🔴_Tinggi-FF6B8A?style=for-the-badge&logoColor=white)
![Sedang](https://img.shields.io/badge/🟡_Sedang-FFB347?style=for-the-badge&logoColor=white)
![Rendah](https://img.shields.io/badge/🔵_Rendah-7EC8E3?style=for-the-badge&logoColor=white)

</div>

| Prioritas | Keterangan |
|:---:|:---|
| **Tinggi** | Tugas mendesak, segera kerjakan |
| **Sedang** | Tugas biasa, kerjakan sesuai jadwal |
| **Rendah** | Tugas santai, bisa dikerjakan nanti |

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

*Atur Tugasmu, Raih Prestasimu!*

<br/>

[![GitHub](https://img.shields.io/badge/GitHub-aliciamonika5408--rgb-9B72CF?style=flat-square&logo=github)](https://github.com/aliciamonika5408-rgb)

</div>
