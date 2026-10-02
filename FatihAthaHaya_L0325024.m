clc;
clear;
format compact;

%% =========================================================
%  SISTEM PERSAMAAN LINEAR
%  2x1 + x2 - x3 = 3
%  4x1 + 3x2 + x3 = 9
%  -2x1 + x2 + 2x3 = 4
% ==========================================================

fprintf('====================================================\n');
fprintf('       FATIH ATHA HAYA (L0325024)\n');
fprintf('====================================================\n');

A = [ 2  1 -1;
      4  3  1;
     -2  1  2 ];

b = [3; 9; 4];

n = length(b);

fprintf('====================================================\n');
fprintf('       PENYELESAIAN SISTEM PERSAMAAN LINEAR\n');
fprintf('====================================================\n');

fprintf('\nMatriks A:\n');
disp(A);

fprintf('Matriks b:\n');
disp(b);


%% =========================================================
% A. ELIMINASI GAUSS
% ==========================================================

fprintf('\n\n====================================================\n');
fprintf('A. ELIMINASI GAUSS\n');
fprintf('====================================================\n');

% Membuat matriks augmented
M = [A b];

fprintf('\nMatriks augmented awal [A|b]:\n');
disp(M);

% Forward elimination
for k = 1:n-1

    fprintf('\n--- Langkah pivot ke-%d ---\n', k);

    for i = k+1:n

        % Menghitung pengali
        m = M(i,k) / M(k,k);

        fprintf('m(%d,%d) = %g\n', i, k, m);

        % Operasi baris
        M(i,:) = M(i,:) - m*M(k,:);

        fprintf('Setelah R%d = R%d - (%g)R%d:\n', ...
                i, i, m, k);
        disp(M);

    end
end

fprintf('\nMatriks segitiga atas [U|b]:\n');
disp(M);

% Backward substitution
x_gauss = zeros(n,1);

for i = n:-1:1

    x_gauss(i) = (M(i,end) - ...
        M(i,i+1:n)*x_gauss(i+1:n)) / M(i,i);

end

fprintf('\nHasil Eliminasi Gauss:\n');
fprintf('x1 = %.4f\n', x_gauss(1));
fprintf('x2 = %.4f\n', x_gauss(2));
fprintf('x3 = %.4f\n', x_gauss(3));


%% =========================================================
% B. ELIMINASI GAUSS-JORDAN
% ==========================================================

fprintf('\n\n====================================================\n');
fprintf('B. ELIMINASI GAUSS-JORDAN\n');
fprintf('====================================================\n');

% Mulai dari matriks augmented awal
GJ = [A b];

fprintf('\nMatriks augmented awal:\n');
disp(GJ);

% Forward + backward elimination
for i = 1:n

    % Membuat pivot menjadi 1
    GJ(i,:) = GJ(i,:) / GJ(i,i);

    fprintf('\nPivot baris %d dijadikan 1:\n', i);
    disp(GJ);

    % Membuat elemen lain pada kolom pivot menjadi 0
    for j = 1:n

        if j ~= i

            faktor = GJ(j,i);

            GJ(j,:) = GJ(j,:) - faktor*GJ(i,:);

            fprintf('R%d = R%d - (%g)R%d\n', ...
                    j, j, faktor, i);

            disp(GJ);

        end
    end
end

fprintf('\nMatriks akhir Gauss-Jordan [I|x]:\n');
disp(GJ);

% Solusi langsung dibaca dari kolom terakhir
x_gj = GJ(:,end);

fprintf('\nHasil Eliminasi Gauss-Jordan:\n');
fprintf('x1 = %.4f\n', x_gj(1));
fprintf('x2 = %.4f\n', x_gj(2));
fprintf('x3 = %.4f\n', x_gj(3));


%% =========================================================
% C. DEKOMPOSISI LU
% ==========================================================

fprintf('\n\n====================================================\n');
fprintf('C. DEKOMPOSISI LU\n');
fprintf('====================================================\n');

% Inisialisasi L dan U
L = eye(n);
U = A;

fprintf('\nMatriks U awal:\n');
disp(U);

% Forward elimination untuk mendapatkan L dan U
for k = 1:n-1

    for i = k+1:n

        % Pengali
        m = U(i,k) / U(k,k);

        % Simpan pengali ke L
        L(i,k) = m;

        % Eliminasi pada U
        U(i,:) = U(i,:) - m*U(k,:);

        fprintf('\nm(%d,%d) = %g\n', i, k, m);

        fprintf('U setelah eliminasi:\n');
        disp(U);

    end
end

fprintf('\nMatriks L:\n');
disp(L);

fprintf('Matriks U:\n');
disp(U);


%% =========================================================
% VERIFIKASI A = L * U
% ==========================================================

fprintf('\nVerifikasi A = L * U:\n');

LU = L * U;

disp(LU);

fprintf('Selisih A - LU:\n');
disp(A - LU);


%% =========================================================
% MENYELESAIKAN Ly = b
% ==========================================================

fprintf('\n\n--- Menyelesaikan Ly = b ---\n');

y = zeros(n,1);

for i = 1:n

    y(i) = (b(i) - L(i,1:i-1)*y(1:i-1)) / L(i,i);

    fprintf('y%d = %.4f\n', i, y(i));

end

fprintf('\nVector y:\n');
disp(y);


%% =========================================================
% MENYELESAIKAN Ux = y
% ==========================================================

fprintf('\n--- Menyelesaikan Ux = y ---\n');

x_lu = zeros(n,1);

for i = n:-1:1

    x_lu(i) = (y(i) - U(i,i+1:n)*x_lu(i+1:n)) / U(i,i);

    fprintf('x%d = %.4f\n', i, x_lu(i));

end


%% =========================================================
% HASIL AKHIR
% ==========================================================

fprintf('\n\n====================================================\n');
fprintf('              PERBANDINGAN HASIL\n');
fprintf('====================================================\n');

fprintf('\n                 x1          x2          x3\n');

fprintf('Gauss        %10.4f %10.4f %10.4f\n', ...
        x_gauss(1), x_gauss(2), x_gauss(3));

fprintf('Gauss-Jordan %10.4f %10.4f %10.4f\n', ...
        x_gj(1), x_gj(2), x_gj(3));

fprintf('LU           %10.4f %10.4f %10.4f\n', ...
        x_lu(1), x_lu(2), x_lu(3));


%% =========================================================
% CEK HASIL
% ==========================================================

fprintf('\n====================================================\n');
fprintf('SOLUSI AKHIR\n');
fprintf('====================================================\n');

fprintf('x1 = %.4f = -2/5\n', x_gauss(1));
fprintf('x2 = %.4f = 18/5\n', x_gauss(2));
fprintf('x3 = %.4f = -1/5\n', x_gauss(3));

fprintf('\nSemua metode menghasilkan solusi yang sama.\n');
