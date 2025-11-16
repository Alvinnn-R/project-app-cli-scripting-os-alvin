#!/bin/bash

# Aplikasi CLI Manajemen Pengeluaran Harian
# Aplikasi terminal untuk mencatat pengeluaran harian, mengelola kategori, Filtering time range, dan melakukan analisis keuangan.

declare -a nama
declare -a jumlah
declare -a kategori
declare -a tanggal
declare -a kategori_list=("Makanan" "Transportasi" "Hiburan" "Tagihan" "Lainnya")

total_pengeluaran=0
data=0;

tambahData() {
    clear

    echo -e "\n=== Tambah Pengeluaran Baru ==="
    echo -e "Masukkan Nama Pengeluaran: \c"
    read nama_baru

    # Validasi input jumlah harus angka
    while true; do
        echo -e "Masukkan Jumlah Pengeluaran (Rp): \c"
        read jumlah_baru
        if [[ $jumlah_baru =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            break
        else
            echo "Error: Masukkan angka yang valid!"
        fi
    done

    echo -e "Pilih Kategori Pengeluaran:"
    select kat in "${kategori_list[@]}"; do
        if [[ -n $kat ]]; then
            kategori_baru=$kat
            break
        else
            echo "Pilihan tidak valid. Silakan coba lagi."
        fi
    done

    # Validasi format tanggal
    while true; do
        echo -e "Masukkan Tanggal Pengeluaran (YYYY-MM-DD): \c"
        read tanggal_baru
        if [[ $tanggal_baru =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
            break
        else
            echo "Error: Format tanggal salah! Gunakan YYYY-MM-DD"
        fi
    done

    nama+=("$nama_baru")
    jumlah+=("$jumlah_baru")
    kategori+=("$kategori_baru")
    tanggal+=("$tanggal_baru")

    # PERBAIKAN: Perhitungan yang benar
    total_pengeluaran=$(awk "BEGIN {print $total_pengeluaran + $jumlah_baru}")

    echo "Pengeluaran berhasil ditambahkan!"
    printf "Total Pengeluaran Saat Ini: Rp %.2f\n" $total_pengeluaran
    ((data++))
}

editData(){
    clear

    tampilkanData;

    echo -e "\n\nMasukkan nomor data: \c"
    read id

    if ((id < 1 || id > data)); then
        echo "ID tidak valid!"
        return
    fi

    index=$((id - 1))

    echo -e "\n=== Edit Pengeluaran ID $id ==="
    echo -e "\nNama Saat Ini: ${nama[$index]}"
    echo -e "Masukkan Nama Baru (tekan enter untuk melewati): \c"
    read nama_baru
    [[ -n $nama_baru ]] && nama[$index]=$nama_baru

    echo -e "\nJumlah Saat Ini: Rp ${jumlah[$index]}"
    echo -e "Masukkan Jumlah Baru (tekan enter untuk melewati): \c"
    read jumlah_baru
    if [[ -n $jumlah_baru ]]; then
        total_pengeluaran=$(awk "BEGIN {print $total_pengeluaran - ${jumlah[$index]} + $jumlah_baru}")
        jumlah[$index]=$jumlah_baru
    fi

    echo -e "\nKategori Saat Ini: ${kategori[$index]}"
    echo -e "Pilih Kategori Baru (tekan enter untuk melewati):"
    select kat in "${kategori_list[@]}"; do
        if [[ -n $kat ]]; then
            kategori[$index]=$kat
            break
        else
            echo "Pilihan tidak valid. Silakan coba lagi."
        fi
    done

    echo -e "\nTanggal Saat Ini: ${tanggal[$index]}"
    echo -e "Masukkan Tanggal Baru (YYYY-MM-DD) (tekan enter untuk melewati): \c"
    read tanggal_baru
    [[ -n $tanggal_baru ]] && tanggal[$index]=$tanggal_baru

    echo "Data pengeluaran berhasil diperbarui!"
}

hapusData() {
    clear

    id=$1
    if ((id < 1 || id > data)); then
        echo "ID tidak valid!"
        return
    fi

    index=$((id - 1))
    total_pengeluaran=$(awk "BEGIN {print $total_pengeluaran - ${jumlah[$index]}}")

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

    echo "Data pengeluaran berhasil dihapus!"
    printf "Total Pengeluaran Saat Ini: Rp %.2f\n" $total_pengeluaran
}


# Fungsi Search (Linear Search & Binary Search siap digunakan)
searchData() {
    while true; do
        clear

        echo -e "\n=== Tampilkan atau Cari Data Pengeluaran ==="
        echo "1. Cari berdasarkan Nama"
        echo "2. Cari berdasarkan Kategori"
        echo "3. Cari berdasarkan Tanggal"
        echo "4. Tampilkan Semua Data Pengeluaran"
        echo "5. Kembali ke Menu Utama"
        echo -e "Pilih: \c"
        read search_option

        case $search_option in
            1) # Linear Search by Name
                echo -e "Masukkan nama pengeluaran: \c"
                read keyword
                found=0
                echo -e "\n=== Hasil Pencarian ==="
                printf "%-4s %-20s %-15s %-15s %-12s\n" "No" "Nama" "Jumlah (Rp)" "Kategori" "Tanggal"
                echo "-----------------------------------------------------------------------"
                for ((i=0; i<$data; i++)); do
                    if [[ "${nama[$i]}" == *"$keyword"* ]]; then
                        printf "%-4s %-20s %-15.2f %-15s %-12s\n" "$((i+1))" "${nama[$i]}" "${jumlah[$i]}" "${kategori[$i]}" "${tanggal[$i]}"
                        ((found++))
                    fi
                done
                [ $found -eq 0 ] && echo "Data tidak ditemukan."
                echo -e "\nTekan Enter untuk kembali ke menu pencarian..."
                read
                ;;
            2) # Search by Category
                echo -e "Pilih kategori:"
                select kat in "${kategori_list[@]}"; do
                    found=0
                    echo -e "\n=== Hasil Pencarian ==="
                    printf "%-4s %-20s %-15s %-15s %-12s\n" "No" "Nama" "Jumlah (Rp)" "Kategori" "Tanggal"
                    echo "-----------------------------------------------------------------------"
                    for ((i=0; i<$data; i++)); do
                        if [[ "${kategori[$i]}" == "$kat" ]]; then
                            printf "%-4s %-20s %-15.2f %-15s %-12s\n" "$((i+1))" "${nama[$i]}" "${jumlah[$i]}" "${kategori[$i]}" "${tanggal[$i]}"
                            ((found++))
                        fi
                    done
                    [ $found -eq 0 ] && echo "Data tidak ditemukan."
                    echo -e "\nTekan Enter untuk kembali ke menu pencarian..."
                    read
                    break
                done
                ;;
            3) # Filter by Date
                echo -e "Masukkan tanggal (YYYY-MM-DD): \c"
                read search_date
                found=0
                echo -e "\n=== Hasil Pencarian ==="
                printf "%-4s %-20s %-15s %-15s %-12s\n" "No" "Nama" "Jumlah (Rp)" "Kategori" "Tanggal"
                echo "-----------------------------------------------------------------------"
                for ((i=0; i<$data; i++)); do
                    if [[ "${tanggal[$i]}" == "$search_date" ]]; then
                        printf "%-4s %-20s %-15.2f %-15s %-12s\n" "$((i+1))" "${nama[$i]}" "${jumlah[$i]}" "${kategori[$i]}" "${tanggal[$i]}"
                        ((found++))
                    fi
                done
                [ $found -eq 0 ] && echo "Data tidak ditemukan."
                echo -e "\nTekan Enter untuk kembali ke menu pencarian..."
                read
                ;;
            4) # Show All Data
                clear
                tampilkanData
                echo -e "\nTekan Enter untuk kembali ke menu pencarian..."
                read
                ;;
            5) break ;;
            *) echo "Pilihan tidak valid!" 
            sleep 2
            ;;
        esac
    done
}

tampilkanData() {
    echo -e "\n=== Data Pengeluaran Harian ==="
    printf "%-4s %-20s %-15s %-15s %-12s\n" "No" "Nama" "Jumlah (Rp)" "Kategori" "Tanggal"
    echo "-----------------------------------------------------------------------"
    for ((i=0; i<$data; i++)); do
        printf "%-4s %-20s %-15.2f %-15s %-12s\n" "$((i+1))" "${nama[$i]}" "${jumlah[$i]}" "${kategori[$i]}" "${tanggal[$i]}"
    done
}

analisisKeuangan() {
    clear

    echo -e "\n=== Analisis Keuangan ==="
    echo "Total Pengeluaran: Rp $total_pengeluaran"

    declare -A kategori_total
    for kat in "${kategori_list[@]}"; do
        kategori_total[$kat]=0
    done

    for ((i=0; i<$data; i++)); do
        kategori_total["${kategori[$i]}"]=$(awk "BEGIN {print ${kategori_total["${kategori[$i]}"]} + ${jumlah[$i]}}")
    done

    echo -e "\nPengeluaran per Kategori:"
    for kat in "${kategori_list[@]}"; do
        printf "%-15s : Rp %.2f\n" "$kat" "${kategori_total[$kat]}"
    done
}

main() {
    while true; do
        clear
        echo -e "\n=== Aplikasi Manajemen Pengeluaran Harian ==="
        echo "1. Tambah Pengeluaran"
        echo "2. Tampilkan/Search Data"
        echo "3. Edit Data"
        echo "4. Hapus Data"
        echo "5. Analisis Keuangan"
        echo "7. Keluar"
        echo -e "Pilih menu: \c"
        read menu

        case $menu in
            1) tambahData ;;
            2) searchData ;;
            3) editData ;;
            4) echo -e "Masukkan nomor data: \c"; read id; hapusData $id ;;
            5) analisisKeuangan ;;
            7) echo "Terima kasih!" ; exit ;;
            *) echo "Pilihan tidak valid!" ;;
        esac
    done
}

main