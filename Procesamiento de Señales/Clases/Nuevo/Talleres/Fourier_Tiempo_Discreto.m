%Prueas iniciales sore la señal sinusoidal
close all
clc
clear all

%% Creación de la señal Seno con un periodo
omega=2*pi/128; N=128; %frecuencia y período

NP=1; %numero de periodos deseados en la función
n1=0:1:N*NP; %eje de tiempo discreto

y1=sin(omega*n1); %funció sinusoidal para un período

%Diujo de la función
figure, stem(n1,y1)
title(['Función Sen(\Omega_0*n) - Numero Periodos = ' num2str(NP)'] )
xlabel('n')
ylabel('Valor')

%% Creación de la señal Seno con dos períodos
NP=2; %numero de periodos deseados en la función
n2=0:1:N*NP; %eje de tiempo discreto

y2=sin(omega*n2); %funció sinusoidal para un período

%Diujo de la función
figure, stem(n2,y2)
title(['Función Sen(\Omega_0*n) - Numero Periodos = ' num2str(NP)'] )
xlabel('n')
ylabel('Valor')

%% Creación de la señal Seno con tres períodos
NP=3; %numero de periodos deseados en la función
n3=0:1:N*NP; %eje de tiempo discreto

y3=sin(omega*n3); %funció sinusoidal para un período

%Diujo de la función
figure, stem(n3,y3)
title(['Función Sen(\Omega_0*n) - Numero Periodos = ' num2str(NP)'] )
xlabel('n')
ylabel('Valor')

%% Creación de la Señal Seno para cualquier número de períodos
% NPg numero de períodos deseado
NPg=7;
ng=0:1:N*NPg;
yg=sin(omega*ng); %funció sinusoidal

%Diujo de la función
figure, stem(ng,yg)
title(['Función Sen(\Omega_0*n) - Numero Periodos = ' num2str(NPg)'] )
xlabel('n')
ylabel('Valor')

%% Calculo de la FFT utilizando el software Matla
%y código de la DFT
%1. Utilizando código de la expresión DFT

%determinamos el numero de muestras que deseamos

per=1;
if per<=3
    N=length(eval(['n' num2str(per)]))-1;
    y=eval(['y' num2str(per)]);
else
    N=length(ng)-1;
    y=yg;
end

contt=0;% conteo de operaciones
ck1=zeros(1,N);%Acumulador para la sumatoria
for k=0:N-1, %lazo para "k"
    for n=0:N-1, %lazo para la "n"
        %formula con acumulacion
        ck1(1,k+1)=ck1(1,k+1)+(1/N)*y(1,n+1)*exp(-1j*k*((2*pi)/N)*n);
    contt=contt+1;%incremento del contador
    end
end
kk=0:N-1;
figure, stem(kk, real(ck1))
title(['DFT - Parte Real - para ' num2str(per) ' período, con N = ' num2str(N)])
figure, stem(kk,imag(ck1))
title(['DFT - Parte Imaginaria - para ' num2str(per) ' período, con N = ' num2str(N)])
contt

%% 

%como la señal es y
y_fft=fft(y);
isreal(y_fft)%es una señal con componentes complejas

%dibujamos las dos componentes (real - imaginario)
figure,stem(real(y_fft))
title('Parte real de la FFT')
figure,stem(imag(y_fft))
title('Parte imaginaria de la FFT')

%Con FFT Shift
y_fft2=fftshift(y_fft);
%dibujamos las dos componentes de FFTSHIFT (real - imaginario)
figure,stem(real(y_fft2))
title('Parte real de la FFT SHIFT')
figure,stem(imag(y_fft2))
title('Parte imaginaria de la FFT SHIFT')



%dividimos entre el numero de muestras - SIN FFTSHIFT
figure,stem((1/floor(length(y_fft)))*real(y_fft))
title('Parte real de la FFT')
figure,stem((1/floor(length(y_fft)))*imag(y_fft))
title('Parte imaginaria de la FFT')
figure, stem((1/floor(length(y_fft)))*abs(y_fft))
title('Magnitud de la FFT')

%dividimos entre el numero de muestras - CON FFTSHIFT
figure,stem((1/floor(length(y_fft2)))*real(y_fft2))
title('Parte real de la FFTSHIFT')
figure,stem((1/floor(length(y_fft2)))*imag(y_fft2))
title('Parte imaginaria de la FFTSHIFT')
figure, stem((1/floor(length(y_fft2)))*abs(y_fft2))
title('Magnitud de la FFTSHIFT')



%tenemos que construir el eje de frecuencias
fs=200;
freq_eje=(fs)*linspace(0,1,length(y_fft));

figure,stem(freq_eje,(1/floor(length(y_fft)))*abs(y_fft))
