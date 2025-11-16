#!/bin/bash

# ==========================================
# Aplikasi CLI Manajemen Pengeluaran Harian
# ==========================================
# Aplikasi terminal untuk mencatat pengeluaran harian, mengelola kategori, 
# filtering time range, dan melakukan analisis keuangan.
# 
# Fitur:
# - Tambah, Edit, Hapus pengeluaran
# - Cari/Filter data berdasarkan nama, kategori, tanggal
# - Analisis keuangan per kategori
# - Validasi input (nama, jumlah, tanggal)
# ==========================================

# ANSI Color Codes untuk estetika terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Deklarasi Variable Global
# Array untuk menyimpan data pengeluaran (struktur data dinamis)
declare -a nama
declare -a jumlah
declare -a kategori
declare -a tanggal

# Daftar kategori yang tersedia
declare -a kategori_list=("Makanan" "Transportasi" "Hiburan" "Tagihan" "Lainnya")

# Variable untuk tracking total dan jumlah data
total_pengeluaran=0
data=0

# Fungsi: Tambah Data Pengeluaran
# Menambah data pengeluaran baru dengan validasi input
tambahData() {
    clear

    echo -e "${BLUE}\n=== Tambah Pengeluaran Baru ===${NC}"
    
    # Validasi nama tidak boleh kosong
    while true; do
        echo -e "${CYAN}\nMasukkan Nama Pengeluaran: ${NC}\c"
        read nama_baru
        if [[ -z $nama_baru ]]; then
            echo -e "${RED}Error: Nama pengeluaran tidak boleh kosong!${NC}"
        else
            break
        fi
    done

    # Validasi input jumlah harus angka (integer atau float), tidak boleh kosong atau 0
    while true; do
        echo -e "${CYAN}Masukkan Jumlah Pengeluaran (Rp): ${NC}\c"
        read jumlah_baru
        if [[ -z $jumlah_baru ]]; then
            echo -e "${RED}Error: Jumlah pengeluaran tidak boleh kosong!${NC}"
        elif [[ $jumlah_baru =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            # Cek apakah jumlah adalah 0 menggunakan awk
            if (( $(awk "BEGIN {print ($jumlah_baru == 0)}") )); then
                echo -e "${RED}Error: Jumlah pengeluaran tidak boleh 0!${NC}"
            else
                break
            fi
        else
            echo -e "${RED}Error: Masukkan angka yang valid!${NC}"
        fi
    done

    # Input kategori menggunakan select menu
    echo -e "${CYAN}\nPilih Kategori Pengeluaran:${NC}"
    select kat in "${kategori_list[@]}"; do
        if [[ -n $kat ]]; then
            kategori_baru=$kat
            break
        else
            echo -e "${RED}Pilihan tidak valid. Silakan coba lagi.${NC}"
        fi
    done

    # Validasi format tanggal DD-MM-YYYY
    while true; do
        echo -e "${CYAN}\nMasukkan Tanggal Pengeluaran (DD-MM-YYYY): ${NC}\c"
        read tanggal_baru
        if [[ $tanggal_baru =~ ^[0-9]{2}-[0-9]{2}-[0-9]{4}$ ]]; then
            break
        else
            echo -e "${RED}Error: Format tanggal salah! Gunakan DD-MM-YYYY${NC}"
        fi
    done

    # Tambahkan data ke array
    nama+=("$nama_baru")
    jumlah+=("$jumlah_baru")
    kategori+=("$kategori_baru")
    tanggal+=("$tanggal_baru")

    # Hitung total pengeluaran (operator aritmatika)
    total_pengeluaran=$(awk "BEGIN {print $total_pengeluaran + $jumlah_baru}")

    echo -e "${GREEN}\nPengeluaran berhasil ditambahkan!${NC}"
    printf "${YELLOW}Total Pengeluaran Saat Ini: Rp %.2f${NC}\n" $total_pengeluaran
    ((data++))

    echo -e "${CYAN}\nTekan Enter untuk kembali ke menu utama...${NC}"
    read
}

# Fungsi: Edit Data Pengeluaran
# Mengedit data pengeluaran berdasarkan ID
editData(){
    clear

    tampilkanData;
    
    echo -e "${CYAN}\n\nMasukkan nomor data: ${NC}\c"
    read id

    id=$1

    # Validasi ID (operator perbandingan)
    if ((id < 1 || id > data)); then
        echo -e "${RED}\nID tidak valid!${NC}"
        echo -e "${CYAN}\nTekan Enter untuk kembali ke menu utama...${NC}"
        read
        return
    fi

    index=$((id - 1))

    echo -e "${BLUE}\n=== Edit Pengeluaran ID $id ===${NC}"
    
    # Edit Nama (opsional)
    while true; do
        echo -e "${YELLOW}\nNama Saat Ini: ${NC}${nama[$index]}"
        echo -e "${CYAN}\nMasukkan Nama Baru (tekan enter untuk melewati): ${NC}\c"
        read nama_baru
        if [[ -z $nama_baru || -n $nama_baru ]]; then
            break
        else
            echo -e "${RED}Error: Nama pengeluaran tidak boleh kosong!${NC}"
        fi
    done
    [[ -n $nama_baru ]] && nama[$index]=$nama_baru

    # Edit Jumlah dengan validasi
    while true; do
        echo -e "${YELLOW}\nJumlah Saat Ini: ${NC}Rp ${jumlah[$index]}"
        echo -e "${CYAN}Masukkan Jumlah Baru (tekan enter untuk melewati): ${NC}\c"
        read jumlah_baru
        if [[ -z $jumlah_baru ]]; then
            break
        elif [[ $jumlah_baru =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            # Cek apakah jumlah adalah 0 menggunakan awk
            if (( $(awk "BEGIN {print ($jumlah_baru == 0)}") )); then
                echo -e "${RED}Error: Jumlah pengeluaran tidak boleh 0!${NC}"
            else
                break
            fi
        else
            echo -e "${RED}Error: Masukkan angka yang valid!${NC}"
        fi
    done
    # Update total jika jumlah berubah (operator aritmatika)
    if [[ -n $jumlah_baru ]]; then
        total_pengeluaran=$(awk "BEGIN {print $total_pengeluaran - ${jumlah[$index]} + $jumlah_baru}")
        jumlah[$index]=$jumlah_baru
    fi

    # Edit Kategori
    echo -e "${YELLOW}\nKategori Saat Ini: ${NC}${kategori[$index]}"
    echo -e "${CYAN}Pilih Kategori Baru (0 untuk melewati):${NC}"
    select kat in "${kategori_list[@]}"; do
        if [[ $REPLY == "0" ]]; then
            break
        elif [[ -n $kat ]]; then
            kategori[$index]=$kat
            break
        else
            echo -e "${RED}Pilihan tidak valid. Silakan coba lagi.${NC}"
        fi
    done

    # Edit Tanggal dengan validasi
    while true; do
        echo -e "${YELLOW}\nTanggal Saat Ini: ${NC}${tanggal[$index]}"
        echo -e "${CYAN}Masukkan Tanggal Baru (DD-MM-YYYY) (tekan enter untuk melewati): ${NC}\c"
        read tanggal_baru
        if [[ -z $tanggal_baru || $tanggal_baru =~ ^[0-9]{2}-[0-9]{2}-[0-9]{4}$ ]]; then
            break
        else
            echo -e "${RED}Error: Format tanggal salah! Gunakan DD-MM-YYYY${NC}"
        fi
    done
    [[ -n $tanggal_baru ]] && tanggal[$index]=$tanggal_baru

    echo -e "${GREEN}\nData pengeluaran berhasil diperbarui!${NC}"

    sleep 2
}

# Fungsi: Hapus Data Pengeluaran (function dengan parameter)
# Parameter: $1 = ID data yang akan dihapus
hapusData() {
    clear
    tampilkanData

    id=$1
    
    # Validasi ID (operator perbandingan)
    if ((id < 1 || id > data)); then
        echo -e "${RED}\nID tidak valid!${NC}"
        echo -e "${CYAN}\nTekan Enter untuk kembali ke menu utama...${NC}"
        read
        return
    fi

    index=$((id - 1))
    
    # Kurangi total pengeluaran (operator aritmatika)
    total_pengeluaran=$(awk "BEGIN {print $total_pengeluaran - ${jumlah[$index]}}")

    # Hapus elemen dari array
    unset nama[$index]
    unset jumlah[$index]
    unset kategori[$index]
    unset tanggal[$index]

    # Reindex arrays
    nama=("${nama[@]}")
    jumlah=("${jumlah[@]}")
    kategori=("${kategori[@]}")
    tanggal=("${tanggal[@]}")

    ((data--))

    echo -e "${GREEN}Data pengeluaran berhasil dihapus!${NC}"
    printf "${YELLOW}Total Pengeluaran Saat Ini: Rp %.2f${NC}\n" $total_pengeluaran

    echo -e "${CYAN}\nTekan Enter untuk kembali ke menu utama...${NC}"
    read
}


# Fungsi: Search dan Filter Data
# Mencari/filter data berdasarkan nama, kategori, atau tanggal (Linear Search)
searchData() {
    while true; do
        clear

        echo -e "${BLUE}\n=== Tampilkan atau Cari Data Pengeluaran ===${NC}"
        echo -e "${MAGENTA}1.${NC} Cari berdasarkan Nama"
        echo -e "${MAGENTA}2.${NC} Cari berdasarkan Kategori"
        echo -e "${MAGENTA}3.${NC} Cari berdasarkan Tanggal"
        echo -e "${MAGENTA}4.${NC} Tampilkan Semua Data Pengeluaran"
        echo -e "${MAGENTA}5.${NC} Kembali ke Menu Utama"
        echo -e "${CYAN}Pilih: ${NC}\c"
        read search_option

        case $search_option in
            1) # Linear Search by Name
                echo -e "${CYAN}\nMasukkan nama pengeluaran: ${NC}\c"
                read keyword
                found=0
                
                echo -e "${BLUE}\n=== Hasil Pencarian ===${NC}"
                printf "${MAGENTA}%-4s %-20s %-15s %-15s %-12s${NC}\n" "No" "Nama" "Jumlah (Rp)" "Kategori" "Tanggal"
                echo "-----------------------------------------------------------------------"
                
                # Cari keyword dalam nama (operator perbandingan string)
                for ((i=0; i<$data; i++)); do
                    if [[ "${nama[$i]}" == *"$keyword"* ]]; then
                        printf "%-4s %-20s %-15.2f %-15s %-12s\n" "$((i+1))" "${nama[$i]}" "${jumlah[$i]}" "${kategori[$i]}" "${tanggal[$i]}"
                        ((found++))
                    fi
                done
                
                [ $found -eq 0 ] && echo -e "${YELLOW}Data tidak ditemukan.${NC}"
                
                echo -e "${CYAN}\nTekan Enter untuk kembali ke menu pencarian...${NC}"
                read
                ;;
            2) # Search by Category
                echo -e "${CYAN}\nPilih kategori:${NC}"
                select kat in "${kategori_list[@]}"; do
                    found=0
                    echo -e "${BLUE}\n=== Hasil Pencarian ===${NC}"
                    printf "${MAGENTA}%-4s %-20s %-15s %-15s %-12s${NC}\n" "No" "Nama" "Jumlah (Rp)" "Kategori" "Tanggal"
                    echo "-----------------------------------------------------------------------"
                    
                    # Cari data berdasarkan kategori
                    for ((i=0; i<$data; i++)); do
                        if [[ "${kategori[$i]}" == "$kat" ]]; then
                            printf "%-4s %-20s %-15.2f %-15s %-12s\n" "$((i+1))" "${nama[$i]}" "${jumlah[$i]}" "${kategori[$i]}" "${tanggal[$i]}"
                            ((found++))
                        fi
                    done
                    
                    [ $found -eq 0 ] && echo -e "${YELLOW}Data tidak ditemukan.${NC}"
                    echo -e "${CYAN}\nTekan Enter untuk kembali ke menu pencarian...${NC}"
                    read
                    break
                done
                ;;
            3) # Filter by Date
                # Validasi format tanggal
                while true; do
                    echo -e "${CYAN}\nMasukkan tanggal (DD-MM-YYYY): ${NC}\c"
                    read search_date
                    if [[ $search_date =~ ^[0-9]{2}-[0-9]{2}-[0-9]{4}$ ]]; then
                        break
                    else
                        echo -e "${RED}Error: Format tanggal salah! Gunakan DD-MM-YYYY${NC}"
                    fi
                done
                
                found=0
                echo -e "${BLUE}\n=== Hasil Pencarian ===${NC}"
                printf "${MAGENTA}%-4s %-20s %-15s %-15s %-12s${NC}\n" "No" "Nama" "Jumlah (Rp)" "Kategori" "Tanggal"
                echo "-----------------------------------------------------------------------"
                
                # Cari data berdasarkan tanggal
                for ((i=0; i<$data; i++)); do
                    if [[ "${tanggal[$i]}" == "$search_date" ]]; then
                        printf "%-4s %-20s %-15.2f %-15s %-12s\n" "$((i+1))" "${nama[$i]}" "${jumlah[$i]}" "${kategori[$i]}" "${tanggal[$i]}"
                        ((found++))
                    fi
                done
                
                [ $found -eq 0 ] && echo -e "${YELLOW}Data tidak ditemukan.${NC}"
                echo -e "${CYAN}\nTekan Enter untuk kembali ke menu pencarian...${NC}"
                read
                ;;
            4) # Show All Data
                clear
                tampilkanData
                echo -e "${CYAN}\nTekan Enter untuk kembali ke menu pencarian...${NC}"
                read
                ;;
            5) break ;;
            *) 
                echo -e "${RED}Pilihan tidak valid!${NC}"
                sleep 2
                ;;
        esac
    done
}

# Fungsi: Tampilkan Semua Data
# Menampilkan semua data pengeluaran dalam bentuk tabel
tampilkanData() {
    echo -e "${BLUE}\n=== Data Pengeluaran Harian ===${NC}"
    printf "${MAGENTA}%-4s %-20s %-15s %-15s %-12s${NC}\n" "No" "Nama" "Jumlah (Rp)" "Kategori" "Tanggal"
    echo "-----------------------------------------------------------------------"
    
    # Iterasi semua data dalam array
    for ((i=0; i<$data; i++)); do
        printf "%-4s %-20s %-15.2f %-15s %-12s\n" "$((i+1))" "${nama[$i]}" "${jumlah[$i]}" "${kategori[$i]}" "${tanggal[$i]}"
    done
}

# Fungsi: Analisis Keuangan
# Menampilkan analisis pengeluaran per kategori
analisisKeuangan() {
    clear

    echo -e "${BLUE}\n=== Analisis Keuangan ===${NC}"
    printf "${YELLOW}Total Pengeluaran: Rp %.2f${NC}\n" $total_pengeluaran

    # Associative array untuk total per kategori
    declare -A kategori_total
    
    # Inisialisasi semua kategori dengan 0
    for kat in "${kategori_list[@]}"; do
        kategori_total[$kat]=0
    done

    # Hitung total per kategori (operator aritmatika)
    for ((i=0; i<$data; i++)); do
        kategori_total["${kategori[$i]}"]=$(awk "BEGIN {print ${kategori_total["${kategori[$i]}"]} + ${jumlah[$i]}}")
    done

    echo -e "${CYAN}\nPengeluaran per Kategori:${NC}"
    for kat in "${kategori_list[@]}"; do
        printf "${MAGENTA}%-15s${NC} : Rp %.2f\n" "$kat" "${kategori_total[$kat]}"
    done

    echo -e "${CYAN}\nTekan Enter untuk kembali ke menu utama...${NC}"
    read
}

# Fungsi: Menu Utama
# Menampilkan menu utama dan mengatur alur program (sequensial)
main() {
    while true; do
        clear
        echo -e "${BLUE}\n==============================================${NC}"
        echo -e "${BLUE}|   Aplikasi Manajemen Pengeluaran Harian    |${NC}"
        echo -e "${BLUE}==============================================${NC}"
        echo -e "${MAGENTA}1.${NC} Tambah Pengeluaran"
        echo -e "${MAGENTA}2.${NC} Tampilkan/Search Data"
        echo -e "${MAGENTA}3.${NC} Edit Data"
        echo -e "${MAGENTA}4.${NC} Hapus Data"
        echo -e "${MAGENTA}5.${NC} Analisis Keuangan"
        echo -e "${MAGENTA}7.${NC} Keluar"
        echo -e "${CYAN}Pilih menu: ${NC}\c"
        read menu

        case $menu in
            1) tambahData ;;
            2) searchData ;;
            3) editData ;;
            4) 
                tampilkanData
                echo -e "\n${RED}Masukkan nomor data yang akan dihapus: ${NC}\c"
                read id
                hapusData $id
                ;;
            5) analisisKeuangan ;;
            7) 
                clear
                echo -e "${GREEN}Terima kasih telah menggunakan aplikasi!${NC}"
                exit
                ;;
            *) 
                echo -e "${RED}Pilihan tidak valid!${NC}"
                sleep 2
                ;;
        esac
    done
}

# Program Entry Point
main