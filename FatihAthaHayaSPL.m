%% =====================================================================
%  PRAKTIKUM 05 - SISTEM PERSAMAAN LINEAR (SPL)         METODE NUMERIK
%  L0325024 - Fatih Atha Haya
%  ---------------------------------------------------------------------
%  Sistem (variabel p, q, r, s, t):
%      5p -  q -  r            = -1
%     -p + 5q -  r -  s        =  2
%     -p -  q + 4r -  s -  t   =  6
%            r + 4s - 2t       =  2
%            q -  r +  s + 4t  = -1
%
%  Soal 1 : Gauss, Gauss-Jordan, Dekomposisi LU, Jacobi, Gauss-Seidel
%           (iterasi maks = 20, toleransi = 0.001)
%  Soal 2 : Galat mutlak = |nilai eksak - nilai hampiran|
%  Soal 3 : Running time (tic toc) - hanya proses algoritma
%
%  Satu file, tanpa fungsi lokal  ->  jalan di MATLAB maupun Octave.
%% =====================================================================
clc; clear; close all;

%% ---------------------------- DATA -----------------------------------
A = [ 5 -1 -1  0  0;
     -1  5 -1 -1  0;
     -1 -1  4 -1 -1;
      0  0  1  4 -2;
      0  1 -1  1  4];
b    = [-1; 2; 6; 2; -1];
n    = size(A,1);
nama = {'p','q','r','s','t'};

nmax = 20;        % iterasi maksimum (petunjuk soal 1)
tol  = 0.001;     % batas toleransi error (petunjuk soal 1)
nrep = 2000;      % pengulangan proses agar waktu terukur stabil
                  % (waktu yang dilaporkan = total waktu / nrep)

fprintf('=============== SISTEM PERSAMAAN LINEAR ===============\n');
disp('Matriks augmented [A | b] :'); disp([A b]);

%% ================== 1. ELIMINASI GAUSS ===============================
tic;
for rep = 1:nrep
    Ab = [A b];
    for k = 1:n-1                                   % eliminasi maju
        for i = k+1:n
            m = Ab(i,k)/Ab(k,k);                    % faktor pengali
            Ab(i,k:n+1) = Ab(i,k:n+1) - m*Ab(k,k:n+1);
        end
    end
    xG = zeros(n,1);                                % substitusi mundur
    xG(n) = Ab(n,n+1)/Ab(n,n);
    for i = n-1:-1:1
        xG(i) = (Ab(i,n+1) - Ab(i,i+1:n)*xG(i+1:n))/Ab(i,i);
    end
end
tG = toc/nrep;

fprintf('\n=============== 1. ELIMINASI GAUSS ===============\n');
disp('Matriks segitiga atas [U | c] :'); disp(Ab);
for i = 1:n, fprintf('%s = %.8f\n', nama{i}, xG(i)); end

%% ================== 2. ELIMINASI GAUSS-JORDAN ========================
tic;
for rep = 1:nrep
    Ab = [A b];
    for k = 1:n
        Ab(k,:) = Ab(k,:)/Ab(k,k);                  % pivot dinormalkan = 1
        for i = 1:n
            if i ~= k
                Ab(i,:) = Ab(i,:) - Ab(i,k)*Ab(k,:); % nolkan kolom pivot
            end
        end
    end
    xGJ = Ab(:,n+1);
end
tGJ = toc/nrep;

fprintf('\n=============== 2. ELIMINASI GAUSS-JORDAN ===============\n');
disp('Matriks hasil akhir [I | x] :'); disp(Ab);
for i = 1:n, fprintf('%s = %.8f\n', nama{i}, xGJ(i)); end

%% ================== 3. DEKOMPOSISI LU (Doolittle) ====================
tic;
for rep = 1:nrep
    L = eye(n);  U = A;
    for k = 1:n-1
        for i = k+1:n
            L(i,k) = U(i,k)/U(k,k);                 % simpan pengali di L
            U(i,k:n) = U(i,k:n) - L(i,k)*U(k,k:n);
        end
    end
    U = triu(U);                                    % buang sisa ~0 di bawah diagonal
    y = zeros(n,1);                                 % L y = b (substitusi maju)
    for i = 1:n
        y(i) = b(i) - L(i,1:i-1)*y(1:i-1);
    end
    xLU = zeros(n,1);                               % U x = y (substitusi mundur)
    for i = n:-1:1
        xLU(i) = (y(i) - U(i,i+1:n)*xLU(i+1:n))/U(i,i);
    end
end
tLU = toc/nrep;

fprintf('\n=============== 3. DEKOMPOSISI LU ===============\n');
disp('Matriks L :'); disp(L);
disp('Matriks U :'); disp(U);
fprintf('Verifikasi max|A - L*U| = %.3e\n', max(max(abs(A - L*U))));
disp('Vektor y (hasil L y = b) :'); disp(y);
for i = 1:n, fprintf('%s = %.8f\n', nama{i}, xLU(i)); end

%% ================== 4. METODE JACOBI =================================
histJ = zeros(nmax,n);  errJ = zeros(nmax,1);
tic;
for rep = 1:nrep
    x = zeros(n,1);                                 % tebakan awal x(0) = 0
    iterJ = 0;
    for k = 1:nmax
        xn = zeros(n,1);
        for i = 1:n
            idx = [1:i-1, i+1:n];                   % semua kolom kecuali diagonal
            xn(i) = (b(i) - A(i,idx)*x(idx))/A(i,i);
        end
        err = max(abs(xn - x));                     % galat antar-iterasi
        x = xn;
        histJ(k,:) = x';  errJ(k) = err;  iterJ = k;
        if err < tol, break; end
    end
end
tJ = toc/nrep;  xJ = x;

fprintf('\n=============== 4. METODE JACOBI ===============\n');
fprintf('%4s %11s %11s %11s %11s %11s %11s\n','k','p','q','r','s','t','err');
for k = 1:iterJ
    fprintf('%4d %11.6f %11.6f %11.6f %11.6f %11.6f %11.6f\n', ...
            k, histJ(k,:), errJ(k));
end
fprintf('Konvergen pada iterasi ke-%d (err < %.3f)\n', iterJ, tol);

%% ================== 5. METODE GAUSS-SEIDEL ===========================
histS = zeros(nmax,n);  errS = zeros(nmax,1);
tic;
for rep = 1:nrep
    x = zeros(n,1);                                 % tebakan awal x(0) = 0
    iterS = 0;
    for k = 1:nmax
        xold = x;
        for i = 1:n
            idx = [1:i-1, i+1:n];
            x(i) = (b(i) - A(i,idx)*x(idx))/A(i,i); % langsung pakai nilai terbaru
        end
        err = max(abs(x - xold));
        histS(k,:) = x';  errS(k) = err;  iterS = k;
        if err < tol, break; end
    end
end
tS = toc/nrep;  xS = x;

fprintf('\n=============== 5. METODE GAUSS-SEIDEL ===============\n');
fprintf('%4s %11s %11s %11s %11s %11s %11s\n','k','p','q','r','s','t','err');
for k = 1:iterS
    fprintf('%4d %11.6f %11.6f %11.6f %11.6f %11.6f %11.6f\n', ...
            k, histS(k,:), errS(k));
end
fprintf('Konvergen pada iterasi ke-%d (err < %.3f)\n', iterS, tol);

%% ================== HIMPUNAN PENYELESAIAN ============================
fprintf('\n=============== HIMPUNAN PENYELESAIAN ===============\n');
fprintf('%-14s %11s %11s %11s %11s %11s\n','Metode','p','q','r','s','t');
fprintf('%-14s %11.6f %11.6f %11.6f %11.6f %11.6f\n','Gauss',        xG);
fprintf('%-14s %11.6f %11.6f %11.6f %11.6f %11.6f\n','Gauss-Jordan', xGJ);
fprintf('%-14s %11.6f %11.6f %11.6f %11.6f %11.6f\n','Dekomposisi LU',xLU);
fprintf('%-14s %11.6f %11.6f %11.6f %11.6f %11.6f\n','Jacobi',       xJ);
fprintf('%-14s %11.6f %11.6f %11.6f %11.6f %11.6f\n','Gauss-Seidel', xS);

%% ================== 2. GALAT (ERROR) =================================
% Nilai eksak = hasil metode analitik/langsung (Gauss).
% Galat mutlak = abs(nilai eksak - nilai hampiran).
xEks = xG;

galatJ   = abs(xEks - xJ);                 % galat Jacobi   (iterasi akhir)
galatS   = abs(xEks - xS);                 % galat Gauss-Seidel (iterasi akhir)
galatJ2  = abs(xEks - histJ(2,:)');        % galat Jacobi   pada iterasi ke-2
galatS2  = abs(xEks - histS(2,:)');        % galat G-Seidel pada iterasi ke-2
galatGJ  = abs(xEks - xGJ);                % pembanding: sesama metode langsung
galatLU  = abs(xEks - xLU);

fprintf('\n=============== 2. GALAT MUTLAK |eksak - hampiran| ===============\n');
fprintf('Nilai eksak (Gauss): ');  fprintf('%.8f  ', xEks);  fprintf('\n\n');
fprintf('%-6s %14s %14s %14s %14s\n','Var','Jacobi(akhir)','GSeidel(akhir)','Jacobi(it-2)','GSeidel(it-2)');
for i = 1:n
    fprintf('%-6s %14.6e %14.6e %14.6e %14.6e\n', nama{i}, ...
            galatJ(i), galatS(i), galatJ2(i), galatS2(i));
end
fprintf('%-6s %14.6e %14.6e %14.6e %14.6e\n','maks', ...
        max(galatJ), max(galatS), max(galatJ2), max(galatS2));
fprintf('\nGalat metode langsung terhadap Gauss : GJ = %.3e , LU = %.3e\n', ...
        max(galatGJ), max(galatLU));
fprintf('Residu ||A*x - b||_inf : Gauss=%.2e GJ=%.2e LU=%.2e Jacobi=%.2e GS=%.2e\n', ...
        norm(A*xG-b,inf), norm(A*xGJ-b,inf), norm(A*xLU-b,inf), ...
        norm(A*xJ-b,inf), norm(A*xS-b,inf));

%% ================== 3. RUNNING TIME ==================================
fprintf('\n=============== 3. RUNNING TIME (rata-rata %d pengulangan) ===============\n', nrep);
fprintf('%-16s %16s %12s\n','Metode','Waktu (detik)','Iterasi');
fprintf('%-16s %16.3e %12s\n','Gauss',         tG,  '-');
fprintf('%-16s %16.3e %12s\n','Gauss-Jordan',  tGJ, '-');
fprintf('%-16s %16.3e %12s\n','Dekomposisi LU',tLU, '-');
fprintf('%-16s %16.3e %12d\n','Jacobi',        tJ,  iterJ);
fprintf('%-16s %16.3e %12d\n','Gauss-Seidel',  tS,  iterS);

