% ========================================================
% Praktikum 03 - Looping
% Nama  : Atha
% NIM   : L0325024
% ========================================================

% --- For loop kondisi 1 ---
disp('--- For loop kondisi 1 (m = k^3) ---')
for k = 1:5
    m = k^3
end

% --- For loop kondisi 2 ---
disp('--- For loop kondisi 2 (s = n*3) ---')
for n = 2:0.5:5
    s = n*3
end

% --- While loop ---
disp('--- While loop ---')
m = 2;
while (m <= 15)
    s = m^2 + 3
    m = m + 3;
end

% --- Continue ---
disp('--- Continue (lewati k genap) ---')
for k = 1:6
    if (mod(k,2) == 0)
        continue
    end
    m = k^2
end

% --- Break ---
disp('--- Break (berhenti saat k == 5) ---')
for k = 1:6
    if (k == 5)
        break
    end
    m = k^3
end
% ========================================================
% Praktikum 03 - Differensial (fungsi simbolik)
% Nama  : Atha
% NIM   : L0325024
% ========================================================

pkg load symbolic
syms x

f_asli = sym(input('Masukkan bentuk persamaan f(x) = ', 's'));

f_turunan = diff(f_asli, x);

disp('Fungsi asli:')
disp(f_asli)

disp('Turunan:')
disp(f_turunan)
% ========================================================
% Praktikum 03 - Integral (fungsi simbolik)
% Nama  : Atha
% NIM   : L0325024
% ========================================================

pkg load symbolic
syms x

f = input('Masukkan bentuk persamaan f(x) = ');
f_asli = sym(f)
f_integral = int(f_asli, 'x')
% ========================================================
% Praktikum 03 - Function
% Nama  : Atha
% NIM   : L0325024
% ========================================================

function FatiAthaHaya2()

    disp('--- Function dengan 1 nilai return ---')
    a = triple(5)

    disp('--- Function dengan beberapa nilai return ---')
    [x, y] = kalkulasi(4, 6)

    disp('--- Function dengan perintah return di dalamnya ---')
    b = cekGenap(8)
    c = cekGenap(7)

end


function result = triple(param)
    result = 3 * param;
end


function [hasil1, hasil2] = kalkulasi(a, b)
    hasil1 = a + b;
    hasil2 = a * b;
end


function result = cekGenap(param)

    if mod(param, 2) == 0
        result = 1;
        return
    end

    result = 0;

end
% ========================================================
% Praktikum 03 - Anonymous Function
% Nama  : Atha
% NIM   : L0325024
% ========================================================

kubik = @(x) x.^3
kubik(4)
kubik(1:3)

perkalian = @(x,y) x*y
perkalian(6,7)
% ========================================================
% Praktikum 03 - Grafik Garis 2D
% Nama  : Atha
% NIM   : -
% ========================================================

pkg load symbolic  % tidak dipakai di sini, hanya konsisten environment
graphics_toolkit('gnuplot')

% --- Grafik 2D sederhana ---
x = 0:5:100;
y = x.^2 - 3*x + 5;
figure(1)
plot(x,y)
title('Grafik persamaan y = x^2 - 3x + 5')
xlabel('Sumbu X')
ylabel('Sumbu Y')
print(1, 'grafik2d_1.png', '-dpng')

% --- Grafik 2D dengan linspace + label ---
x2 = linspace(0,15);
y2 = cos(x2/2) .* exp(-x2/5);
figure(2)
plot(x2,y2)
xlabel('Sumbu X')
ylabel('Sumbu Y')
title('Grafik persamaan f(x)=cos(x/2).*exp(-x/5)')
print(2, 'grafik2d_2.png', '-dpng')

% --- Dua grafik dalam satu plot ---
x3 = 0:0.01:2*pi;
y3 = -8*sin(3*x3) - 5*cos(2*x3);
z3 = 6*sin(4*x3) .* -3 .* cos(8*x3);
figure(3)
plot(x3,y3,x3,z3)
title('Dua kurva dalam satu grafik')
print(3, 'grafik2d_3.png', '-dpng')

disp('Grafik 2D selesai dibuat.')
% ========================================================
% Praktikum 03 - Grafik Garis 3D (line, mesh, contour)
% Nama  : Atha
% NIM   : -
% ========================================================

graphics_toolkit('gnuplot')

% --- Line plot 3D ---
t = 0:0.1:4*pi;
x = cos(t);
y = sin(t);
z = 0.3*t;
figure(1)
plot3(x,y,z,'b','linewidth',1.5);
grid on
xlabel('x'); ylabel('y'); zlabel('z');
title('Grafik Garis 3D - Line Plot');
print(1, 'grafik3d_line.png', '-dpng')

% --- Mesh plot ---
xr = -5:0.25:5;
yr = xr;
[X, Y] = meshgrid(xr, yr);
R = sqrt(X.^2 + Y.^2);
Z = cos(R) ./ (R + 1);
figure(2)
mesh(X, Y, Z);
xlabel('x'); ylabel('y'); zlabel('z');
title('Grafik Garis 3D - Mesh Plot');
print(2, 'grafik3d_mesh.png', '-dpng')

% --- Contour plot ---
xc = -3:0.25:3;
yc = -3:0.25:3;
[Xc, Yc] = meshgrid(xc, yc);
Zc = 2.2 .^ (-1.4*sqrt(Xc.^2 + Yc.^2)) .* cos(0.4*Yc) .* sin(Xc);
figure(3)
contour3(Xc, Yc, Zc, 12);
xlabel('x'); ylabel('y'); zlabel('z');
title('Grafik Garis 3D - Contour Plot');
print(3, 'grafik3d_contour.png', '-dpng')

disp('Grafik 3D selesai dibuat.')

