# 💰 Aplikasi CLI Manajemen Pengeluaran Harian

![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

Aplikasi terminal berbasis CLI untuk mencatat dan mengelola pengeluaran harian dengan fitur CRUD lengkap, pencarian, dan analisis keuangan. Dibuat menggunakan Bash Scripting sebagai mini project **Backend Golang Batch 3 Bootcamp - Lumoshive Academy**.

## 📺 Video Demo & Penjelasan

**[▶️ Tonton Video Demo & Penjelasan Lengkap di YouTube](https://youtu.be/SVhyxtO0-U8)**

---

## ✨ Fitur Utama

- ✅ **CRUD Operations** - Tambah, Tampilkan, Edit, Hapus pengeluaran
- 🔍 **Linear Search** - Cari berdasarkan Nama, Kategori, atau Tanggal
- 📊 **Analisis Keuangan** - Breakdown pengeluaran per kategori
- 🎨 **ANSI Color Codes** - UI terminal yang menarik dan colorful
- ✔️ **Input Validation** - Validasi format, non-empty, non-zero
- 💵 **Float Support** - Perhitungan uang dengan desimal menggunakan AWK
- 📅 **Date Format** - DD-MM-YYYY dengan regex validation

---

## 🎯 Konsep Programming yang Diimplementasikan

### 1. **Variables & Data Types**

- Global variables: `total_pengeluaran`, `data`
- Array variables: `nama[]`, `jumlah[]`, `kategori[]`, `tanggal[]`
- Color constants: `RED`, `GREEN`, `BLUE`, dll

### 2. **Array**

- **Indexed Arrays**: Menyimpan data pengeluaran secara paralel
- **Associative Arrays**: Agregasi total per kategori

### 3. **Operators**

- **Aritmatika**: `+`, `-`, `++`, `--` (dengan AWK untuk float)
- **Perbandingan**: `>`, `<`, `==`, `!=`, `-z`, `-n`
- **Logika**: `&&`, `||`
- **Regex**: `=~` untuk pattern matching

### 4. **Conditional Statements**

- `if-elif-else` untuk validasi input
- `case` statement untuk menu routing
- Nested conditionals untuk validasi kompleks

### 5. **Looping**

- `while` loop untuk input validation
- `for` loop untuk iterasi data
- `select` loop untuk interactive menu

### 6. **Functions**

- **7+ Functions**: `tambahData()`, `editData()`, `hapusData()`, `searchData()`, `tampilkanData()`, `analisisKeuangan()`, `main()`
- **Function dengan Parameter**: `hapusData($id)` - menerima ID sebagai parameter

### 7. **Linear Search Algorithm**

- Search by name (substring matching)
- Search by category (exact match)
- Search by date (exact match dengan whitespace trimming)

### 8. **Input Validation**

- Non-empty validation: `[[ -z $var ]]`
- Regex format: `[[ $var =~ ^pattern$ ]]`
- Zero check dengan AWK: `(( $(awk "BEGIN {print ($var == 0)}") ))`

---

## 🚀 Cara Menggunakan

### Prerequisites

- Bash shell (Linux, macOS, Git Bash on Windows)
- AWK (biasanya sudah terinstall di sistem Unix-like)

### Instalasi

1. **Clone repository**

   ```bash
   git clone https://github.com/Alvinnn-R/project-app-cli-scripting-os-alvin.git
   cd "project-app-cli-scripting-os-alvin"
   ```

2. **Beri permission execute**

   ```bash
   chmod +x app.sh
   ```

3. **Jalankan aplikasi**
   ```bash
   ./app.sh
   ```

---

## 📖 Panduan Penggunaan

### Menu Utama

```
==============================================
|   Aplikasi Manajemen Pengeluaran Harian    |
==============================================
1. Tambah Pengeluaran
2. Tampilkan/Search Data
3. Edit Data
4. Hapus Data
5. Analisis Keuangan
7. Keluar
```

### 1. Tambah Pengeluaran

- Input nama pengeluaran (tidak boleh kosong)
- Input jumlah pengeluaran (angka > 0, support desimal)
- Pilih kategori dari menu
- Input tanggal (format: DD-MM-YYYY)

### 2. Tampilkan/Search Data

- **Cari berdasarkan Nama**: Substring matching
- **Cari berdasarkan Kategori**: Exact match
- **Cari berdasarkan Tanggal**: Exact match (DD-MM-YYYY)
- **Tampilkan Semua Data**: List semua pengeluaran

### 3. Edit Data

- Pilih nomor data yang akan diedit
- Tekan Enter untuk skip field yang tidak ingin diubah
- Untuk kategori, input `0` untuk skip

### 4. Hapus Data

- Pilih nomor data yang akan dihapus
- Total pengeluaran otomatis terupdate

### 5. Analisis Keuangan

- Tampilkan total pengeluaran keseluruhan
- Breakdown pengeluaran per kategori

---

## 🎨 Tampilan/UI

### Menu Utama

```
==============================================
|   Aplikasi Manajemen Pengeluaran Harian    |
==============================================
1. Tambah Pengeluaran
2. Tampilkan/Search Data
3. Edit Data
4. Hapus Data
5. Analisis Keuangan
7. Keluar
```

### Tampilan Data

```
=== Data Pengeluaran Harian ===
No   Nama                 Jumlah (Rp)     Kategori        Tanggal
-----------------------------------------------------------------------
1    Makan Siang          25000.00        Makanan         16-11-2025
2    Bensin Motor         50000.00        Transportasi    16-11-2025
3    Nonton Bioskop       75000.00        Hiburan         15-11-2025
```

---

## 💻 Teknologi yang Digunakan

- **Bash Shell Scripting** - Bahasa pemrograman utama
- **AWK** - Operasi aritmatika floating-point
- **Git & GitHub** - Version control

---

## 📁 Struktur File

```
.
├── app.sh          # Main application file
└── README.md       # Dokumentasi project
```

---

## 🎓 Learning Outcomes

Project ini mengajarkan:

- ✅ Bash scripting fundamental
- ✅ Array manipulation
- ✅ Function design dengan parameters
- ✅ Input validation patterns
- ✅ Linear search algorithm
- ✅ AWK untuk numeric operations
- ✅ Terminal UI dengan ANSI colors
- ✅ Git version control

---

## 👨‍💻 Author

**Alvin Rama Saputra**

- 💻 GitHub: [@alvinrama](https://github.com/alvinrama)

---

## 📝 License

This project is for educational purposes as part of Lumoshive Academy Bootcamp.

---

## 🙏 Acknowledgments

- Lumoshive Academy - Backend Golang Batch 3 Bootcamp
- Instructor & Mentors
- Fellow bootcamp participants

---

**📺 [Tonton Video Penjelasan Lengkap](https://youtu.be/SVhyxtO0-U8)**
