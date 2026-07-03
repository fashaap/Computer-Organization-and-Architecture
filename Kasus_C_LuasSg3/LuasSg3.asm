.data
# Deklarasi identitas kelompok 
    judul:      .asciiz "SE-49-03 Kelompok GUGUGAGA\n"
    nama1:      .asciiz "Fasha Azhi Putra  103022530020\n"
    nama2:      .asciiz "M. Hafizh Alaudin Dzaky 103022500119\n"
    nama3:      .asciiz "Raina Gilby Diawara  103022500118\n"
    nama4:      .asciiz "Gunawan Zaki Budi Santoso  103022500077\n\n"
    petunjuk:   .asciiz "Masukkan alas = 3003 untuk keluar dari program\n\n"

# untuk input alas dan tinggi
    input_alas:     .asciiz "Masukkan alas: "
    input_tinggi:   .asciiz "Masukkan tinggi: "

# untuk handle error
    err_negatif:    .asciiz "Bilangan negatif/nol tidak diperbolehkan! Masukkan bilangan positif > 0.\n"

# String untuk output nilai
    txt_luas:       .asciiz "Luas segi tiga = "
    txt_kategori:   .asciiz "Kategori       = "
    kat_tinggi:     .asciiz "SEGI TIGA TINGGI\n\n"
    kat_sedang:     .asciiz "SEGI TIGA SEDANG\n\n"
    kat_rendah:     .asciiz "SEGI TIGA RENDAH\n\n"
    newline:        .asciiz "\n"

.text
.globl main

# ini adalah program main nya yang mengeksekusi identitas kelompok
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
    jal  MASUKAN # mengambil nilai dari memvalidasi apakah $s0=alas, $s1=tinggi, $s7=flag keluar
    beq  $s7, 1, selesai # jika flag keluar = 1, maka hentikan program

    jal  HITUNG # disini memanggil hitung untuk menghitung $s2=luas, $s3=alamat string kategori
    jal  KELUARAN # tampilkan hasil dari perhitungan

    j    loop_utama # ulangi lagi menerima input berikutnya

selesai:
    li   $v0, 10 # keluar
    syscall

#Jika masukan alas = 3003 maka akan keluar program, jika bilangan = 0 maka minta input ulang 
MASUKAN:
    li   $s7, 0 # reset keluar setiap MASUKAN dipanggil ulang

ulang_alas:
    li   $v0, 4
    la   $a0, input_alas
    syscall
    li   $v0, 5
    syscall
    move $s0, $v0 # simpan ke alas

    li   $t0, 3003
    beq  $s0, $t0, tandai_keluar # cek kode keluar program

    blez $s0, err_input_alas # cek alas harus positif, alas > 0

ulang_tinggi:
    li   $v0, 4
    la   $a0, input_tinggi
    syscall
    li   $v0, 5
    syscall
    move $s1, $v0 # simpan ke tinggi

    blez $s1, err_input_tinggi # cek tinggi harus positif, tinggi > 0 tidak boleh negatif

    jr   $ra # input valid maka kemabali ke main

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


HITUNG:
# kalikan alas x tinggi dengan penjumlahan berulang 
    li   $s2, 0 # hasil kali = 0 (akumulator)
    move $t0, $s1 # counter = tinggi

loop_kali:
    beqz $t0, bagi_dua # jika counter = 0, maka perkalian selesai
    add  $s2, $s2, $s0 # hasil kali = hasil kali + alas
    addi $t0, $t0, -1 # counter -- berkurang 1
    j    loop_kali

#bagi hasil kali dengan 2
bagi_dua:
    li   $t1, 2
    div  $s2, $t1 # hasil kali / 2
    mflo $s2 # ambil hasil bagi ke $s2 = luas

#tentukan kategori dari perbandingan alas & tinggi
    blt  $s0, $s1, set_tinggi # alas < tinggi -> MAKA SEGI TIGA TINGGI
    beq  $s0, $s1, set_sedang # alas = tinggi -> MAKA  SEGI TIGA SEDANG
    la   $s3, kat_rendah # sisanya (alas > tinggi) -> Maka SEGI TIGA RENDAH
    jr   $ra

set_tinggi:
    la   $s3, kat_tinggi
    jr   $ra

set_sedang:
    la   $s3, kat_sedang
    jr   $ra
    
#Menampilkan luas dan kategori nya
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