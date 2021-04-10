clear;
close all;
R1 = 1;
C = 0.25;
R2 = 2;
L = 0.2;
R3 = 10;
R4 = 0.1;
alpha = 100;
R0 = 1000;
Cn = 0.00001;
G1=1/R1;
G2=1/R2;
G3=1/R3;
G4=1/R4;
G0=1/R0;
G = [1, 0, 0, 0, 0, 0, 0 ;
    -G2, G1+G2, -1, 0, 0, 0, 0 ;
    0, 1, 0, -1, 0, 0, 0;
    0, 0, -1, G3, 0, 0, 0;
    0, 0, 0, 0, -alpha, 1, 0;
    0, 0, 0, G3, -1, 0, 0; 
    0, 0, 0, 0, 0, -G4, G0+G4];
C = [0, 0, 0, 0, 0, 0, 0 ;
    -C, C, 0, 0, 0, 0, 0; 
    0, 0, -L, 0, 0, 0, 0; 
    0, 0, 0, Cn, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0; 
    0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0];

In0 = 0.001;
T = 10000;
In = In0*randn(1,T);
Vin = @(t) exp(-(t-0.06).^2/(2*0.03^2));
F = @(t,k) [Vin(t), 0, In(k), 0, 0, 0, 0]';
V0 = 0;

dt = 1e-3;
A = C/dt + G;
t = linspace(0,1,T);

V = zeros(T,7);
V(1,:) = V0;
for k=2:T
  V(k,:) = A\(C*(V(k-1,:)'/dt)+F(t(k),k));
end
figure(9);
plot(t,V(:,7));
xlabel('t');
ylabel('V');
title('Vout with noise source (Gaussian Pulse)');

Fmax = 1/(2*dt);
Vf = fftshift(abs(fft(V(:,7))));
f = linspace(-Fmax,Fmax,T);
figure(10);
semilogy(f,Vf);
xlabel('f (Hz)');
ylabel('V');
title('Fourier Transform with noise source (Gaussian Pulse)');