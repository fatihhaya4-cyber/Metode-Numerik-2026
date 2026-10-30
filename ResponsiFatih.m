%% RESPONSI 1 PRAKTIKUM METODE NUMERIK : GALAT, SPL, SPNL (SATU FILE)
% Menjalankan ketiga kasus secara berurutan (Kasus 1, 2, 3).
% Kompatibel dengan MATLAB dan GNU Octave (tidak memakai fungsi lokal).
% Setiap kasus diawali "clear" agar variabelnya tidak saling bertabrakan.
close all; clear; clc;

%% KASUS 1 : GALAT (ERROR PEMOTONGAN)
% Visualisasi gelombang air laut  h = h0*(cos(t*v/lambda) + e^x)
% Perbandingan hasil eksak vs deret Taylor (cos dan e^x) dengan n = 23, 24, 25
clear;
fprintf('==================== KASUS 1 : GALAT ====================\n');

%% 1. Parameter masalah
lambda = 12;  v = 36;  x = 10;  h0 = 5;
N      = [23 24 25];          % batas iterasi deret Taylor
toleransi = 1;                % toleransi galat relatif = 1 persen

%% 2. Vektor waktu 0 <= t <= 5
t = linspace(0, 5, 501);      % 501 titik -> langkah 0.01
u = t*v/lambda;               % argumen cosinus (satuan radian)

%% 3. Solusi eksak (fungsi bawaan)
h_eksak = h0*(cos(u) + exp(x));

%% 4. Solusi pendekatan (deret Taylor) untuk tiap n
h_aprx = zeros(numel(N), numel(t));
for k = 1:numel(N)
    n = N(k);
    c_aprx = zeros(size(u));                 % deret cos(u)
    for i = 0:n
        c_aprx = c_aprx + (-1)^i * u.^(2*i) / factorial(2*i);
    end
    e_aprx = 0;                              % deret e^x
    for i = 0:n
        e_aprx = e_aprx + x^i / factorial(i);
    end
    h_aprx(k,:) = h0*(c_aprx + e_aprx);
end

%% 5. Grafik perbandingan keempat fungsi dalam satu plot
figure('Name','Perbandingan eksak vs pendekatan','Color','w');
plot(t, h_eksak, 'k-',  'LineWidth', 2.5); hold on;
plot(t, h_aprx(1,:), 'r--', 'LineWidth', 1.5);
plot(t, h_aprx(2,:), 'g-.', 'LineWidth', 1.5);
plot(t, h_aprx(3,:), 'b:',  'LineWidth', 2);
grid on; xlabel('t'); ylabel('h(t)');
title('Gelombang air laut: eksak vs pendekatan deret Taylor');
legend('f_{eksak}','f_{n=23}','f_{n=24}','f_{n=25}','Location','best');
ylim([min(h_eksak)-30, max(h_eksak)+30]);   % perbesar agar selisih terlihat

%% 6. Galat mutlak, rerata, dan galat relatif
fprintf('%-6s %-18s %-18s %-20s %-10s\n', 'n', 'Rerata |galat|', ...
        'Galat maks', 'Rerata galat rel (%)', 'Layak?');
rerata = zeros(1,3);
for k = 1:numel(N)
    galat_mutlak = abs(h_eksak - h_aprx(k,:));
    galat_rel    = galat_mutlak ./ abs(h_eksak) * 100;     % dalam persen
    rerata(k)    = mean(galat_mutlak);
    if mean(galat_rel) < toleransi, ket = 'LAYAK'; else, ket = 'TIDAK'; end
    fprintf('%-6d %-18.6f %-18.6f %-20.8f %-10s\n', N(k), rerata(k), ...
            max(galat_mutlak), mean(galat_rel), ket);
end

%% 7. Grafik galat mutlak (pelengkap)
figure('Name','Galat mutlak','Color','w');
bar(N, rerata); grid on;
xlabel('n'); ylabel('Rerata galat mutlak');
title('Rerata galat mutlak terhadap solusi eksak');

%% KASUS 2 : SPL (HARGA BAHAN MAKANAN PER KG)
clear;
fprintf('\n==================== KASUS 2 : SPL ====================\n');

%% 1. Data belanja SUDAH dikonversi ke kg
% kolom: beras, telur, tepung, ayam  (1 hg = 0.1 kg, 1 dag = 0.01 kg, 1 g = 0.001 kg)
% Adel : 2.5 kg | 1500 g | 5 kg   | 500 g
% Briza: 40 hg  | 0.75 kg| 1000 g | 2 kg
% Caca : 2000 g | 15 hg  | 50 dag | 6000 g
% Dinda: 1 kg   | 4250 g | 20 hg  | 9 hg
A = [2.5        1500/1000   5          500/1000;      % Adel
     40/10      0.75        1000/1000  2;             % Briza
     2000/1000  15/10       50/100     6000/1000;     % Caca
     1          4250/1000   20/10      9/10];         % Dinda
b = [161000; 149000; 251500; 173000];                 % total belanja (Rp)
nama = {'Beras','Telur','Tepung','Ayam'};

disp('Matriks koefisien A (kg):'); disp(A);
disp('Vektor b (Rp):');            disp(b);

%% 2. Uji syarat metode iteratif: dominan diagonal & jari-jari spektral
% rhoGS(M): jari-jari spektral matriks iterasi Gauss-Seidel T = -(D+L)^-1 U
rhoGS = @(M) max(abs(eig(-(diag(diag(M)) + tril(M,-1)) \ triu(M,1))));

disp('Cek dominan diagonal - susunan ASLI:');
d = abs(diag(A));  o = sum(abs(A),2) - d;
for i = 1:4
    if d(i) > o(i), s = 'terpenuhi'; else, s = 'TIDAK terpenuhi'; end
    fprintf('  baris %d: |a_ii| = %.2f  vs  sum|a_ij| = %.2f  -> %s\n', i, d(i), o(i), s);
end
fprintf('Jari-jari spektral Gauss-Seidel (susunan asli) = %.4f\n\n', rhoGS(A));

%% 3. Penataan ulang baris (pivoting) -> dominan diagonal
% baris 2 (Briza)->pers.1, baris 4 (Dinda)->pers.2, baris 1 (Adel)->pers.3, baris 3 (Caca)->pers.4
urut = [2 4 1 3];
A2 = A(urut,:);  b2 = b(urut);

disp('Cek dominan diagonal - susunan SETELAH ditukar:');
d = abs(diag(A2));  o = sum(abs(A2),2) - d;
for i = 1:4
    if d(i) > o(i), s = 'terpenuhi'; else, s = 'TIDAK terpenuhi'; end
    fprintf('  baris %d: |a_ii| = %.2f  vs  sum|a_ij| = %.2f  -> %s\n', i, d(i), o(i), s);
end
fprintf('Jari-jari spektral Gauss-Seidel (susunan baru) = %.4f\n\n', rhoGS(A2));

%% 4. Metode Gauss-Seidel
tol = 1e-6;  maxit = 100;
xk = zeros(4,1);                       % tebakan awal
fprintf('Iterasi Gauss-Seidel:\n');
fprintf('%-4s %-12s %-12s %-12s %-12s %-12s\n','k','Beras','Telur','Tepung','Ayam','Galat maks');
for k = 1:maxit
    xlama = xk;
    for i = 1:4
        s = A2(i,:)*xk - A2(i,i)*xk(i);          % jumlah a_ij*x_j, j ~= i
        xk(i) = (b2(i) - s)/A2(i,i);              % nilai terbaru langsung dipakai
    end
    galat = max(abs(xk - xlama));
    fprintf('%-4d %-12.4f %-12.4f %-12.4f %-12.4f %-12.3e\n', k, xk, galat);
    if galat < tol, break; end
end

%% 5. Verifikasi dengan Gauss-Jordan
aug = [A b];
for j = 1:4
    [~,p] = max(abs(aug(j:end,j))); p = p + j - 1;      % pivoting parsial
    aug([j p],:) = aug([p j],:);
    aug(j,:) = aug(j,:)/aug(j,j);
    for i = [1:j-1, j+1:4]
        aug(i,:) = aug(i,:) - aug(i,j)*aug(j,:);
    end
end
x_GJ = aug(:,end);

%% 6. Hasil akhir
fprintf('\n%-8s %-18s %-18s %-18s\n','Bahan','Gauss-Seidel','Gauss-Jordan','Rp/kg');
for i = 1:4
    fprintf('%-8s %-18.6f %-18.6f Rp %d\n', nama{i}, xk(i), x_GJ(i), round(xk(i)));
end
fprintf('Residu ||Ax-b|| = %.3e\n', norm(A*xk - b));

%% KASUS 3 : PERSAMAAN NON-LINEAR (BOLA DALAM TABUNG)
clear;
fprintf('\n==================== KASUS 3 : SPNL ====================\n');

%% 1. Perumusan persamaan
% Bola jari-jari r ada di dalam tabung -> tabung jari-jari r, tinggi t = 2r
% V_bola = 4/3 pi r^3 ; V_tabung = pi r^2 (2r) = 2 pi r^3
% V_bola : V_tabung = 2 : 3  ->  V_tabung = 3/2 * 300 = 450
% V_luar = V_tabung - V_bola = 150  = 2/3 pi r^3
Vbola = 300;
Vluar = Vbola/2;                         % = 150
f = @(r) (2/3)*pi*r.^3 - Vluar;          % f(r) = 0  -> persamaan nonlinear

%% 2. Metode grafik untuk nilai awal
r = linspace(0, 8, 400);
figure('Name','Metode grafik','Color','w');
plot(r, f(r), 'b-', 'LineWidth', 2); hold on;
plot([0 8], [0 0], 'k-'); grid on;
xlabel('r (cm)'); ylabel('f(r)');
title('Grafik f(r) = (2/3)\pi r^3 - 150');
rg = 0:1:8;
fprintf('%-4s %-12s\n','r','f(r)'); fprintf('%-4d %-12.4f\n',[rg; f(rg)]);
% f(4) < 0 dan f(5) > 0 -> akar di antara 4 dan 5
a = 4;  b = 5;
plot([a b],[f(a) f(b)],'ro','MarkerFaceColor','r');

%% 3. Metode Biseksi
tol = 1e-6;  maxit = 100;
fa = f(a);  fb = f(b);
assert(fa*fb < 0, 'Tebakan awal tidak mengapit akar!');
fprintf('\nBISEKSI\n%-4s %-10s %-10s %-12s %-12s %-12s\n','i','a','b','c','f(c)','|b-a|');
ab = a; bb = b;
for i = 1:maxit
    c  = (ab+bb)/2;  fc = f(c);
    fprintf('%-4d %-10.6f %-10.6f %-12.8f %-12.3e %-12.3e\n', i, ab, bb, c, fc, bb-ab);
    if abs(fc) < tol || (bb-ab)/2 < tol, break; end
    if f(ab)*fc < 0, bb = c; else, ab = c; end
end
r_bis = c;  it_bis = i;

%% 4. Metode Regula-Falsi (pembanding)
fprintf('\nREGULA-FALSI\n%-4s %-10s %-10s %-12s %-12s\n','i','a','b','c','f(c)');
ar = a; br = b; cl = inf;
for i = 1:maxit
    c  = (ar*f(br) - br*f(ar))/(f(br) - f(ar));
    fc = f(c);
    fprintf('%-4d %-10.6f %-10.6f %-12.8f %-12.3e\n', i, ar, br, c, fc);
    if abs(fc) < tol || abs(c-cl) < tol, break; end
    if f(ar)*fc < 0, br = c; else, ar = c; end
    cl = c;
end
r_rf = c;  it_rf = i;

%% 5. Hasil dan verifikasi
r_eksak = (3*Vluar/(2*pi))^(1/3);
Vb = 4/3*pi*r_bis^3;  Vt = 2*pi*r_bis^3;  Vl = Vt - Vb;
fprintf('\nJari-jari (biseksi)      = %.6f cm  (%d iterasi)\n', r_bis, it_bis);
fprintf('Jari-jari (regula-falsi) = %.6f cm  (%d iterasi)\n', r_rf,  it_rf);
fprintf('Jari-jari (analitik)     = %.6f cm\n', r_eksak);
fprintf('Tinggi tabung t = 2r     = %.6f cm\n', 2*r_bis);
fprintf('V bola = %.4f | V tabung = %.4f | V tabung di luar bola = %.4f cm^3\n', Vb, Vt, Vl);
plot(r_bis, 0, 'g*', 'MarkerSize', 12);
legend('f(r)','sumbu r','tebakan awal','akar','Location','northwest');
