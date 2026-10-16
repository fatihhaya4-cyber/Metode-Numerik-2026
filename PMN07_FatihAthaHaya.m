% =====================================================================
% TUGAS SPNL 1 - Grafik Tunggal/Ganda, Biseksi, dan Regula-Falsi
% Cara pakai: simpan sebagai Tugas_SPNL.m, lalu jalankan:  Tugas_SPNL
% (Nama file harus sama dengan nama fungsi utama. Jalan di Octave & MATLAB)
% =====================================================================
function Tugas_SPNL()
  clear; clc; close all;
  Tugas1_Grafik();
  Tugas2_Akar();
end

% ---------------------------------------------------------------------
% TUGAS 1 - Metode Grafik Tunggal dan Grafik Ganda
% ---------------------------------------------------------------------
function Tugas1_Grafik()
  % ===== Persamaan 1: 3x^3 - 5x^2 + 4x - 7 = 1 =====
  x = linspace(0,3);
  f = @(x) 3*x.^3 - 5*x.^2 + 4*x - 8;
  figure(1); plot(x,f(x)); grid on
  line([0,3],[0,0],'Color','k'); line([0,0],[-10,50],'Color','k');
  title('Persamaan 1 - Grafik Tunggal'); xlabel('x'); ylabel('y');
  legend('y = 3x^3-5x^2+4x-8');

  f1 = @(x) 3*x.^3 - 5*x.^2 + 4*x - 7;
  f2 = @(x) ones(size(x));
  figure(2); plot(x,f1(x),x,f2(x)); grid on
  title('Persamaan 1 - Grafik Ganda'); xlabel('x'); ylabel('y');
  legend('y_1 = 3x^3-5x^2+4x-7','y_2 = 1');

  % ===== Persamaan 2: e^x - x^2 = 0 =====
  x = linspace(-2,2);
  f = @(x) exp(x) - x.^2;
  figure(3); plot(x,f(x)); grid on
  line([-2,2],[0,0],'Color','k'); line([0,0],[-4,8],'Color','k');
  title('Persamaan 2 - Grafik Tunggal'); xlabel('x'); ylabel('y');
  legend('y = e^x - x^2');

  f1 = @(x) exp(x);
  f2 = @(x) x.^2;
  figure(4); plot(x,f1(x),x,f2(x)); grid on
  title('Persamaan 2 - Grafik Ganda'); xlabel('x'); ylabel('y');
  legend('y_1 = e^x','y_2 = x^2');

  % ===== Persamaan 3: log(x+2) + 2x - 3 = 0 =====
  x = linspace(-1.5,3);
  f = @(x) log(x+2) + 2*x - 3;
  figure(5); plot(x,f(x)); grid on
  line([-1.5,3],[0,0],'Color','k'); line([0,0],[-8,5],'Color','k');
  title('Persamaan 3 - Grafik Tunggal'); xlabel('x'); ylabel('y');
  legend('y = log(x+2)+2x-3');

  f1 = @(x) log(x+2);
  f2 = @(x) -2*x + 3;
  figure(6); plot(x,f1(x),x,f2(x)); grid on
  title('Persamaan 3 - Grafik Ganda'); xlabel('x'); ylabel('y');
  legend('y_1 = log(x+2)','y_2 = -2x+3');
end

% ---------------------------------------------------------------------
% TUGAS 2 - Akar dengan Biseksi dan Regula-Falsi (n = 20, tol = 0.0001)
% ---------------------------------------------------------------------
function Tugas2_Akar()
  n   = 20;
  tol = 0.0001;

  % ===== Persamaan 1: f(x) = 3x^3 - 5x^2 + 4x - 8 =====
  disp('===== PERSAMAAN 1 =====');
  f = @(x) 3*x.^3 - 5*x.^2 + 4*x - 8;
  a = 1; b = 2;
  disp('--- Biseksi ---');
  c1_bis = Biseksi(f,a,b,n,tol)
  disp('--- Regula-Falsi ---');
  c1_rf  = RegulaFalsi(f,a,b,n,tol)

  % ===== Persamaan 2: e^x - x^2 = 0 =====
  disp('===== PERSAMAAN 2 =====');
  f = @(x) exp(x) - x.^2;
  a = -1; b = 0;
  disp('--- Biseksi ---');
  c2_bis = Biseksi(f,a,b,n,tol)
  disp('--- Regula-Falsi ---');
  c2_rf  = RegulaFalsi(f,a,b,n,tol)

  % ===== Persamaan 3: log(x+2) + 2x - 3 = 0 (log = ln di Octave/MATLAB) =====
  disp('===== PERSAMAAN 3 =====');
  f = @(x) log(x+2) + 2*x - 3;
  a = 0; b = 2;
  disp('--- Biseksi ---');
  c3_bis = Biseksi(f,a,b,n,tol)
  disp('--- Regula-Falsi ---');
  c3_rf  = RegulaFalsi(f,a,b,n,tol)
end

% ---------------------------------------------------------------------
% METODE BISEKSI
% ---------------------------------------------------------------------
function c = Biseksi(f,a,b,n,tol)
  fa = f(a);
  fb = f(b);

  % jika tanda sama, tidak ada jaminan akar di antara keduanya
  if fa*fb > 0
    error('Warning: sama tanda.')
  end

  fprintf('\nIter\ta\t\tb\t\tfa\t\tfb\t\tc\t\tfc\n');

  for i=1:n
    c = (a+b)/2;            % titik tengah = kandidat akar baru
    fc = f(c);
    fprintf('%d\t%f\t%f\t%f\t%f\t%f\t%f\n', i,a,b,fa,fb,c,fc);

    % berhenti saat error mencapai batas toleransi
    if abs(c-a) <= tol || abs(c-b) <= tol
      break;
    end

    if fa*fc == 0
      break;                % akar ditemukan
    elseif fa*fc < 0
      b = c;  fb = f(b);    % akar di antara a dan c
    else
      a = c;  fa = f(a);    % akar di antara c dan b
    end
  end
end

% ---------------------------------------------------------------------
% METODE REGULA-FALSI
% ---------------------------------------------------------------------
function c = RegulaFalsi(f,a,b,n,tol)
  fa = f(a);
  fb = f(b);

  if fa*fb > 0
    error('Warning: sama tanda.')
  end

  fprintf('\nIter\ta\t\tb\t\tfa\t\tfb\t\tc\t\tfc\n');

  for i=1:n
    c = (a*fb-b*fa)/(fb-fa);   % rumus regula-falsi
    fc = f(c);
    fprintf('%d\t%f\t%f\t%f\t%f\t%f\t%f\n', i,a,b,fa,fb,c,fc);

    if abs(c-a) <= tol || abs(c-b) <= tol
      break;
    end

    if fa*fc == 0
      break;
    elseif fa*fc < 0
      b = c;  fb = f(b);
    else
      a = c;  fa = f(a);
    end
  end
end

