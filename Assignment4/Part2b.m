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
In0 = 0.001;

G = [1, 0, 0, 0, 0, 0, 0 ;
    -G2, G1+G2, -1, 0, 0, 0, 0 ;
    0, 1, 0, -1, 0, 0, 0;
    0, 0, -1, G3, 0, 0, 0;
    0, 0, 0, 0, -alpha, 1, 0;
    0, 0, 0, G3, -1, 0, 0; 
    0, 0, 0, 0, 0, -G4, G0+G4];
C1 = [0, 0, 0, 0, 0, 0, 0 ;
    -C, C, 0, 0, 0, 0, 0; 
    0, 0, -L, 0, 0, 0, 0; 
    0, 0, 0, Cn*10, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0; 
    0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0];
C2 = [0, 0, 0, 0, 0, 0, 0 ;
    -C, C, 0, 0, 0, 0, 0; 
    0, 0, -L, 0, 0, 0, 0; 
    0, 0, 0, Cn*100, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0; 
    0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0];
C3 = [0, 0, 0, 0, 0, 0, 0 ;
    -C, C, 0, 0, 0, 0, 0; 
    0, 0, -L, 0, 0, 0, 0; 
    0, 0, 0, Cn*1000, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0; 
    0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0];

T = 10000;
In = In0*randn(1,T);
Vin = @(t) exp(-(t-0.06).^2/(2*0.03^2));
F = @(t,k) [Vin(t), 0, 0, In(k), 0, 0, 0]';
V0 = 0;

dt = 1e-3;
A1 = C1/dt + G;
A2 = C2/dt + G;
A3 = C3/dt + G;
t = linspace(0,1,T);

V1 = zeros(T,7);
V1(1,:) = V0;
V2 = zeros(T,7);
V2(1,:) = V0;
V3 = zeros(T,7);
V3(1,:) = V0;
V4 = zeros(T,7);
V4(1,:) = V0;
for k=2:T
  V1(k,:) = A1\(C1*(V1(k-1,:)'/dt)+F(t(k),k));
  V2(k,:) = A2\(C2*(V2(k-1,:)'/dt)+F(t(k),k));
  V3(k,:) = A3\(C3*(V3(k-1,:)'/dt)+F(t(k),k));
end
figure(1);
plot(t,V1(:,7));
xlabel('t');
ylabel('V');
title('Vo (Cn=0.0001)');

figure(2);
plot(t,V2(:,7));
xlabel('t');
ylabel('V');
title('Vo (Cn=0.001)');

figure(3);
plot(t,V3(:,7));
xlabel('t');
ylabel('V');
title('Vo (Cn=0.01)');

dt1 = 1e-2;
A4 = C1/dt1 + G;
for k=2:T
  V4(k,:) = A4\(C1*(V1(k-1,:)'/dt1)+F(t(k),k));
end
figure(4);
plot(t,V4(:,7));
xlabel('t');
ylabel('V');
title('Vo (Timpe Step = 0.01)');

dt2 = 1e-1;
A5 = C1/dt2 + G;
for k=2:T
  V5(k,:) = A5\(C1*(V1(k-1,:)'/dt2)+F(t(k),k));
end
figure(5);
plot(t,V5(:,7));
xlabel('t');
ylabel('V');
title('Vo (Timpe Step = 0.1)');