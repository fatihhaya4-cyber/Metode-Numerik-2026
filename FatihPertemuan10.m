% Tugas: dy/dx = (4x^3 - 2x + 1)/(2 + y), y(0) = 1, cari y(2), n = 15
clc; clear; close all;

f    = @(x,y) (4*x.^3 - 2*x + 1) ./ (2 + y);   % dy/dx
yeks = @(x) -2 + sqrt(2*x.^4 - 2*x.^2 + 2*x + 9); % solusi eksak

x0 = 0; y0 = 1; xn = 2; n = 15;
h  = (xn - x0)/n;
x  = x0:h:xn;

yE = zeros(1,n+1); yH = zeros(1,n+1); yR = zeros(1,n+1);
yE(1) = y0; yH(1) = y0; yR(1) = y0;

for i = 1:n
  % Euler
  yE(i+1) = yE(i) + h*f(x(i), yE(i));
  % Heun
  k1 = f(x(i), yH(i));
  k2 = f(x(i+1), yH(i) + h*k1);
  yH(i+1) = yH(i) + (h/2)*(k1 + k2);
  % Runge-Kutta orde-4
  k1 = f(x(i), yR(i));
  k2 = f(x(i)+h/2, yR(i) + (h/2)*k1);
  k3 = f(x(i)+h/2, yR(i) + (h/2)*k2);
  k4 = f(x(i+1), yR(i) + h*k3);
  yR(i+1) = yR(i) + (h/6)*(k1 + 2*k2 + 2*k3 + k4);
end

yK = yeks(x);
printf('h = %.6f\n\n', h);
printf('%3s %8s %12s %12s %12s %12s\n','i','x','Eksak','Euler','Heun','RK4');
for i = 1:n+1
  printf('%3d %8.4f %12.6f %12.6f %12.6f %12.6f\n', i-1, x(i), yK(i), yE(i), yH(i), yR(i));
end

Y = yK(end);
met = {'Euler','Heun','RK4'}; yap = [yE(end) yH(end) yR(end)];
printf('\ny(2) eksak = %.8f\n\n', Y);
printf('%-8s %12s %14s %14s\n','Metode','y(2)','Galat Absolut','Galat Relatif');
for k = 1:3
  ga = abs(Y - yap(k)); gr = ga/abs(Y)*100;
  printf('%-8s %12.6f %14.8f %12.6f %%\n', met{k}, yap(k), ga, gr);
end
