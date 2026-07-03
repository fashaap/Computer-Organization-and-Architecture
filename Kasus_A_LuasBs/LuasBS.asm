.data
#Deklarasi identitas kelompok 
    judul:      .asciiz "SE-49-03 Kelompok GUGUGAGA\n"
    nama1:      .asciiz "Fasha Azhi Putra  103022530020\n"
    nama2:      .asciiz "M. Hafizh Alaudin Dzaky 103022500119\n"
    nama3:      .asciiz "Raina Gilby Diawara  103022500118\n"
    nama4:      .asciiz "Gunawan Zaki Budi Santoso  103022500077\n\n"
    petunjuk:   .asciiz "Masukkan sisi 1 = 1001 untuk keluar dari program\n\n"

#untuk input sisi 1 dan sisi 2
    input_s1:   .asciiz "Masukkan sisi 1: "
    input_s2:   .asciiz "Masukkan sisi 2: "

#untuk handle Error
    err_negatif: .asciiz "Bilangan negatif/nol tidak diperbolehkan! Masukkan bilangan positif > 0.\n"
    err_beda:    .asciiz "Sisi 1 dan sisi 2 harus sama! Silakan masukkan ulang.\n"

#String untuk output nilai
    txt_luas:    .asciiz "Luas bujur sangkar = "
    txt_kategori:.asciiz "Kategori           = "
    kat_kecil:   .asciiz "BUJUR SANGKAR KECIL\n\n"
    kat_sedang:  .asciiz "BUJUR SANGKAR SEDANG\n\n"
    kat_besar:   .asciiz "BUJUR SANGKAR BESAR\n\n"
    newline:     .asciiz "\n"

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
    jal  MASUKAN # Untuk mengambil nilai dan validasi input dari sisi 1 & 2   
    beq  $s7, 1, selesai # jika keluarnya angka 1, maka hentikan program

    jal  PROSES #Menghitung luas & kategori
    jal  KELUARAN # Mengeluarkan hasil atau tampilkan hasil

    j    loop_utama #Disini terjadi looping atau mengulangi lagi menerima input berikutnya

selesai:
    li   $v0, 10 #keluar
    syscall

MASUKAN:
    li   $s7, 0 #Reset flag keluar setiap MASUKAN dipanggil ulang s7 = 0 atau belum keluar

ulang_sisi1:
    li   $v0, 4
    la   $a0, input_s1
    syscall
    li   $v0, 5 # membaca integer
    syscall
    move $s0, $v0 #Lalu simpan ke sisi1

    li   $t0, 1001
    beq  $s0, $t0, tandai_keluar #Cek apakah kode keluar dari program

    blez $s0, err_input_s1 #cek apakag bilangan positif (>0)

ulang_sisi2:
    li   $v0, 4
    la   $a0, input_s2
    syscall
    li   $v0, 5
    syscall
    move $s1, $v0 #Lalu simpan ke sisi2

    blez $s1, err_input_s2 #cek apakah bilangan positif (>0)

    bne  $s0, $s1, err_input_beda #Cek kedua sisi nya harus sama

    jr   $ra #Jika input valid maka kembali ke menu

tandai_keluar:
    li   $s7, 1
    jr   $ra

err_input_s1:
    li   $v0, 4
    la   $a0, err_negatif
    syscall
    j    ulang_sisi1 #Erorr handle untuk menghandle input negatif pada sisi 1

err_input_s2:
    li   $v0, 4
    la   $a0, err_negatif
    syscall
    j    ulang_sisi2 #Erorr handle untuk menghandle input negatif pada sisi 2

err_input_beda:
    li   $v0, 4
    la   $a0, err_beda
    syscall
    j    ulang_sisi1 # ulangi dari sisi1 lagi

PROSES:
    li   $s2, 0 # luas = 0 (akumulator)
    move $t0, $s1 # counter = sisi2

loop_kali:
    beqz $t0, tentukan_kategori # jika counter = 0, perkalian selesai
    add  $s2, $s2, $s0 # luas = luas + sisi1
    addi $t0, $t0, -1 # counter--
    j    loop_kali

tentukan_kategori:
    li   $t1, 500
    li   $t2, 1000
    blt  $s2, $t1, set_kecil # luas < 500 MAKA KECIL
    blt  $s2, $t2, set_sedang  # 500 <= luas <1000 MAKA SEDANG
    la   $s3, kat_besar # luas >= 1000 MAKA BESAR
    jr   $ra

set_kecil:
    la   $s3, kat_kecil #Simpan alamat String "Bujur sangkar kecil" ke $s3
    jr   $ra #kembali ke pemanggil (main)

set_sedang:
    la   $s3, kat_sedang #Simpan alamat String "Bujur sangkar sedang" ke $s3
    jr   $ra #kembali ke pemanggil (main)

KELUARAN:
    li   $v0, 4
    la   $a0, txt_luas
    syscall
    li   $v0, 1 # cetak integer (luas)
    move $a0, $s2
    syscall
    li   $v0, 4
    la   $a0, newline
    syscall

    li   $v0, 4
    la   $a0, txt_kategori
    syscall
    li   $v0, 4 # cetak string kategori
    move $a0, $s3
    syscall

    jr   $ra