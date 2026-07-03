.data
#Deklarasi identitas kelompok 
    judul:      .asciiz "SE-49-03 Kelompok GUGUGAGA\n"
    nama1:      .asciiz "Fasha Azhi Putra  103022530020\n"
    nama2:      .asciiz "M. Hafizh Alaudin Dzaky 103022500119\n"
    nama3:      .asciiz "Raina Gilby Diawara  103022500118\n"
    nama4:      .asciiz "Gunawan Zaki Budi Santoso  103022500077\n\n"
    petunjuk:   .asciiz "Masukkan alas = 9009 untuk keluar dari program\n\n"

# Untuk input alas, tinggi & tprisma 
    input_alas:    .asciiz "Masukkan alas: "
    input_tinggi:  .asciiz "Masukkan tinggi segi tiga: "
    input_tprisma: .asciiz "Masukkan tinggi prisma: "

# Erorr handle
    err_negatif: .asciiz "Bilangan negatif/nol tidak diperbolehkan! Masukkan bilangan positif > 0.\n"

# String untuk output nilai
    txt_volume:   .asciiz "Volume prisma segi tiga = "
    txt_kategori: .asciiz "Kategori                = "
    kat_kecil:    .asciiz "PRISMA SEGI TIGA KECIL\n\n"
    kat_sedang:   .asciiz "PRISMA SEGI TIGA SEDANG\n\n"
    kat_besar:    .asciiz "PRISMA SEGI TIGA BESAR\n\n"
    newline:      .asciiz "\n"

.text
.globl main


#ini adalah program main nya yang mengeksekusi identitas kelompok
main:
    li   $v0, 4
    la   $a0, judul
    syscall
    li   $v0, 4
    la   $a0, nama1
    syscall
    li   $v0, 4
    la   $a0, nama2
    syscall
    li   $v0, 4
    la   $a0, nama3
    syscall
    li   $v0, 4
    la   $a0, nama4
    syscall
    li   $v0, 4
    la   $a0, petunjuk
    syscall

loop_utama:
    jal  MASUKAN # Mengambil nilai dan memvalidasi apakah s0=alas, $s1=tinggi, $s2=tinggi prisma, $s7=flag keluar
    beq  $s7, 1, selesai # jika flag keluar = 1, maka hentikan program

    jal  HITUNG # hitung volume & kategori dari $s4=volume, $s5=alamat string kategori
    jal  KELUARAN # tampilkan hasil

    j    loop_utama # Ngulang lagi

selesai:
    li   $v0, 10 # Keluar
    syscall
    
MASUKAN:
    li   $s7, 0 # reset

ulang_alas:
    li   $v0, 4
    la   $a0, input_alas
    syscall
    li   $v0, 5
    syscall
    move $s0, $v0 # Menyimpan ke alas

    li   $t0, 9009
    beq  $s0, $t0, tandai_keluar # cek  apakah kode keluar program

    blez $s0, err_input_alas # juga apakah alas harus positif (>0)

ulang_tinggi:
    li   $v0, 4
    la   $a0, input_tinggi
    syscall
    li   $v0, 5
    syscall
    move $s1, $v0 # simpan nilai ke tinggi segitiga

    blez $s1, err_input_tinggi # cek tinggi segitiga harus positif (>0)

ulang_tprisma:
    li   $v0, 4
    la   $a0, input_tprisma
    syscall
    li   $v0, 5
    syscall
    move $s2, $v0 # Menyimpan ke tinggi prisma

    blez $s2, err_input_tprisma # cek tinggi prisma harus positif (>0)

    jr   $ra # semua input valid harus balik ke main

tandai_keluar:
    li   $s7, 1
    jr   $ra

err_input_alas:
    li   $v0, 4
    la   $a0, err_negatif
    syscall
    j    ulang_alas

err_input_tinggi:
    li   $v0, 4
    la   $a0, err_negatif
    syscall
    j    ulang_tinggi

err_input_tprisma:
    li   $v0, 4
    la   $a0, err_negatif
    syscall
    j    ulang_tprisma
    
HITUNG:
# Mengkalikan alas x tinggi segitiga dengan penjumlahan
    li   $s3, 0 # hasil kali
    move $t0, $s1 # counter = tinggi segitiga

loop_kali:
    beqz $t0, bagi_dua # jika counter = 0, perkalian selesai
    add  $s3, $s3, $s0 # hasil kali = hasil kali + alas
    addi $t0, $t0, -1 # counter--
    j    loop_kali

bagi_dua:
    li   $t1, 2
    div  $s3, $t1 # (alas x tinggi) / 2
    mflo $s3 # ambil hasil bagi

# kalikan luas segitiga x tinggi prisma
    mul  $s4, $s3, $s2 # volume = luas segitiga x tinggi prisma

# tentukan kategori berdasarkan nilai volume
    li   $t2, 50
    li   $t3, 100
    blt  $s4, $t2, set_kecil # volume < 50 -> MAKA KECIL
    ble  $s4, $t3, set_sedang # 50 <= volume <= 100 -> MAKA SEDANG
    la   $s5, kat_besar # sisanya (volume > 100) -> MAKA BESAR
    jr   $ra

set_kecil:
    la   $s5, kat_kecil
    jr   $ra

set_sedang:
    la   $s5, kat_sedang
    jr   $ra

KELUARAN:
    li   $v0, 4
    la   $a0, txt_volume
    syscall
    li   $v0, 1 # cetak integer (volume)
    move $a0, $s4
    syscall
    li   $v0, 4
    la   $a0, newline
    syscall

    li   $v0, 4
    la   $a0, txt_kategori
    syscall
    li   $v0, 4 # cetak Kategori
    move $a0, $s5
    syscall

    jr   $ra
