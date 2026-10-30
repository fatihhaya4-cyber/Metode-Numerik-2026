# Responsi 1 Praktikum Metode Numerik

Program MATLAB / GNU Octave untuk tiga kasus Metode Numerik: **Galat**, **Sistem Persamaan Linear (SPL)**, dan **Sistem Persamaan Non-Linear (SPNL)**. Ketiganya dijalankan berurutan dari satu file, `ResponsiFatih.m`.

| | |
|---|---|
| Nama | Fatih Atha Haya |
| NIM | L0325024 |
| Prodi | S1 Informatika PSDKU Kebumen, Universitas Sebelas Maret |
| Mata Kuliah | Praktikum Metode Numerik |

## Isi Repositori

```
.
├── ResponsiFatih.m   # Source code (Kasus 1, 2, 3)
├── .gitignore
└── README.md
```

## Cara Menjalankan

Kebutuhan: MATLAB atau GNU Octave, tanpa toolbox tambahan.

1. Download repositori ini (tombol **Code → Download ZIP**) atau clone lewat Git.
2. Buka folder hasil download di MATLAB / Octave, lalu jalankan di Command Window:
   ```matlab
   ResponsiFatih
   ```
3. Tabel hasil muncul di Command Window dan grafik terbuka otomatis.

Setiap kasus diawali `clear`, jadi variabel antar kasus tidak saling bertabrakan.

## Kasus 1: Galat (Error Pemotongan)

Visualisasi gelombang air laut:

```
h(t) = h0 * ( cos(t*v/lambda) + e^x )
```

Solusi eksak (fungsi bawaan `cos` dan `exp`) dibandingkan dengan pendekatan deret Taylor untuk batas iterasi **n = 23, 24, 25**.

| Parameter | Nilai |
|---|---|
| lambda | 12 |
| v | 36 |
| x | 10 |
| h0 | 5 |
| Rentang t | 0 sampai 5 (501 titik, langkah 0.01) |
| Toleransi galat relatif | 1% |

Deret yang dipakai:

```
cos(u) = sum_{i=0}^{n} (-1)^i * u^(2i) / (2i)!
e^x    = sum_{i=0}^{n} x^i / i!
```

Output: grafik eksak vs pendekatan, tabel rerata galat mutlak, galat maksimum, rerata galat relatif (%) beserta keterangan LAYAK/TIDAK, dan grafik batang rerata galat mutlak.

## Kasus 2: SPL (Harga Bahan Makanan per kg)

Menentukan harga per kg beras, telur, tepung, dan ayam dari total belanja empat orang (Adel, Briza, Caca, Dinda) yang satuannya berbeda-beda (kg, hg, dag, g). Semua data dikonversi ke kg lalu disusun menjadi `Ax = b`.

Langkah di kode:

1. Konversi satuan ke kg dan susun matriks `A` serta vektor `b` (total belanja dalam Rp).
2. Uji syarat metode iteratif: dominan diagonal dan jari-jari spektral Gauss-Seidel pada susunan asli.
3. Tukar baris (pivoting) supaya dominan diagonal, urutan: Briza, Dinda, Adel, Caca, lalu uji ulang.
4. Metode Gauss-Seidel (tebakan awal nol, toleransi `1e-6`, maksimum 100 iterasi) dengan tabel tiap iterasi.
5. Verifikasi dengan Gauss-Jordan (pivoting parsial).
6. Hasil akhir: perbandingan kedua metode dalam Rp/kg dan residu `||Ax - b||`.

## Kasus 3: SPNL (Bola dalam Tabung)

Bola berjari-jari `r` berada di dalam tabung berjari-jari `r` dan tinggi `2r`. Volume bola 300 cm³ dan `V_bola : V_tabung = 2 : 3`. Tentukan jari-jari bola.

```
V_bola   = (4/3) pi r^3
V_tabung = 2 pi r^3
V_luar   = V_tabung - V_bola = (2/3) pi r^3 = 150

f(r) = (2/3) pi r^3 - 150 = 0
```

Metode:

1. Metode grafik untuk nilai awal: `f(4) < 0` dan `f(5) > 0`, sehingga akar ada di selang `[4, 5]`.
2. Biseksi (toleransi `1e-6`, maksimum 100 iterasi).
3. Regula-Falsi sebagai pembanding.
4. Verifikasi dengan solusi analitik `r = (3 * V_luar / (2 pi))^(1/3)` serta pengecekan volume bola, tabung, dan ruang tabung di luar bola.

Output: tabel iterasi kedua metode, jumlah iterasi, jari-jari, tinggi tabung `t = 2r`, dan grafik `f(r)` dengan tebakan awal dan akar.

## Catatan

- Kompatibel dengan MATLAB dan GNU Octave.
- Kriteria berhenti iterasi: toleransi `1e-6`, maksimum 100 iterasi.
- Dibuat untuk keperluan tugas Responsi 1 Praktikum Metode Numerik, Informatika UNS.# Metode-Numerik-2026
