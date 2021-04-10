clear;
close all;
Vin = linspace(-10, 10,20); 
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
    0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0; 
    0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0];

for l = 1:20
F = [Vin(l); 0; 0; 0; 0; 0; 0];
V = G\F
Vo(l)=V(7);
V3(l)=V(4);
end
figure(1);
plot (Vin, Vo,Vin,V3)
legend('Vo', 'V3');
xlabel('Vin (V)')
ylabel('Voltage ') 

f =linspace (0,15,10000)*2*pi;
F = [1; 0; 0; 0; 0; 0; 0];
for l = 1:size(f, 2)
   V =  (G+j*f(l)*C)\F;
   Vabso(l)=(abs(V(7)));
   Vabs3(l)=(abs(V(4)));
end 
figure(2)
plot (f, Vabso,f,Vabs3)
legend('Vo', 'V3')
xlim([0 100])
xlabel('w')
ylabel('V')

F = [1 0 0 0 0 0 0]';
F1 = @(t) (t > 0.03);
F2 = @(t) sin(2*pi/0.03*t);
F3 = @(t) exp(-(t-0.06).^2/(2*0.03^2));
V0 = 0;

dt = 1e-3;
A = C/dt + G;
t = linspace(0,1,1000);

V1 = zeros(1000,7);
V1(1,:) = V0;
V2 = zeros(1000,7);
V2(1,:) = V0;
V3 = zeros(1000,7);
V3(1,:) = V0;
for k=2:1000
  V1(k,:) = A\(C*(V1(k-1,:)'/dt)+F*F1(t(k)));
  V2(k,:) = A\(C*(V2(k-1,:)'/dt)+F*F2(t(k)));
  V3(k,:) = A\(C*(V3(k-1,:)'/dt)+F*F3(t(k)));
end
figure(3);
plot(t,F1(t),t,V1(:,7));
xlabel('t');
ylabel('V');
title('Vin & Vo (Unit Step)');

figure(4);
plot(t,F2(t),t,V2(:,7));
xlabel('t');
ylabel('V');
title('Vin & Vo (Sine Function)');

figure(5);
plot(t,F3(t),t,V3(:,7));
xlabel('t');
ylabel('V');
title('Vin & Vo (Gaussian Pulse)');

Fmax = 500; 
Vf1 = fft(V1);
Vf1 = fftshift(abs(Vf1(:,7)));
Vf2 = fft(V2);
Vf2 = fftshift(abs(Vf2(:,7)));
Vf3 = fft(V3);
Vf3 = fftshift(abs(Vf3(:,7)));
Vf11 = fft(F1(t));
Vf11 = fftshift(abs(Vf11));
Vf21 = fft(F2(t));
Vf21 = fftshift(abs(Vf21));
Vf31 = fft(F3(t));
Vf31 = fftshift(abs(Vf31));
f = linspace(-Fmax,Fmax,1000);

figure(6);
semilogy(f,Vf11,f,Vf1);
xlabel('f');
ylabel('V');
title(' Fourier Transform (Unit Step)');

figure(7);
semilogy(f,Vf21,f,Vf2);
xlabel('f');
ylabel('V');
title('Fourier Transform (Sine Function)');

figure(8);
semilogy(f,Vf31,f,Vf3);
xlabel('f');
ylabel('V');
title('Fourier Transform (Gaussian Pulse)');