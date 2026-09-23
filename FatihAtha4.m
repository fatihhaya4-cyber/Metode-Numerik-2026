 fprintf('Tugas 1 - Galat e^(0.3) dengan Deret Taylor\n')
x = 0.3;
eksak = exp(x);
n_list = [0 1 2 3 4];

fprintf('n\tPendekatan\t\tGalat\n');
for n = n_list
  p = 0;
  for i = 0:n
    p = p + (x^i)/factorial(i);
  end
  galat = abs(eksak - p);
  fprintf('%d\t%.15f\t%.15f\n', n, p, galat);
 end
 fprintf('Nilai eksak = %.15f\n', eksak);


 fprintf('Tugas 2 - Galat penjumlahan 1/1 + 1/2 + ... + 1/20\n')
k = 1:20;

% a. Perhitungan secara eksak (presisi penuh)
s_eksak = 0;
for i = k
    s_eksak = s_eksak + 1/i;
end

% b. Masing-masing pembagian dibulatkan (4 desimal)
s_bulat = 0;
for i = k
    s_bulat = s_bulat + round((1/i)*10000)/10000;
end

% c. Tanpa looping (menggunakan fungsi sum)
  s_sum = sum(1./k);

galat_b = abs(s_eksak - s_bulat);
galat_c = abs(s_eksak - s_sum);

fprintf('a. Eksak (loop)     = %.15f\n', s_eksak);
fprintf('b. Dibulatkan       = %.15f, galat = %.15f\n', s_bulat, galat_b);
fprintf('c. sum() (no loop)  = %.15f, galat = %.15f\n', s_sum, galat_c);


 fprintf('Tugas 3 - Galat sin(1) dengan Deret Taylor\n')
x = 1;
eksak = sin(x);
N_list = [1 2 3 4 5];

fprintf('N\tPendekatan\t\tGalat\n');
for N = N_list
    p = 0;
    for n = 0:N
        p = p + ((-1)^n) * (x^(2*n+1)) / factorial(2*n+1);
    end
    galat = abs(eksak - p);
    fprintf('%d\t%.15f\t%.15f\n', N, p, galat);
end
fprintf('Nilai eksak = %.15f\n', eksak);

