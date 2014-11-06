clear all;
close all;
clc;

%% variables globales et constantes
Fs=128000;
L=2e-3;
min = 1;
max = Fs*L;
coeffBruit = 1;
Dfreq=-0;
freq1 = 39500+Dfreq;
freq2 = 40000+Dfreq;
freq3 = 40500+Dfreq;
freq4 = 41000+Dfreq;


%% création de 2 signaux de fréquence différente

t = [1:2000/max:2000]/1000;
t = (1:max)/Fs;



for i=min:max
    if i<200
        sig1(i) = 0;
    else
        sig1(i) = cos(2*pi*freq1*t(i));
    end;
    sig2(i) = cos(2*pi*freq2*t(i));
    sig3(i) = cos(2*pi*freq3*t(i));
    if i>400
        sig4(i) = 0;
    else
        sig4(i) = cos(2*pi*freq4*t(i));
    end;
end;
sig1 = cos(2*pi*freq1*t+pi/2).*(t>0.0e-3);
sig2 = cos(2*pi*freq2*t).*(t>0.0e-3);
sig3 = cos(2*pi*freq3*t).*(t<0.7e-3);
sig4 = cos(2*pi*freq4*t).*(t>0.0e-3);

 for k = 1:max
        h1(k)=exp(2*pi*t(k)*j*freq1);
        h2(k)=exp(2*pi*t(k)*j*freq2);
        h3(k)=exp(2*pi*t(k)*j*freq3);
        h4(k)=exp(2*pi*t(k)*j*freq4);
 end


 
%% somme des signaux

for i=min:max
    sig5(i) = sig1(i)+1*sig2(i)+1*sig3(i)+1*sig4(i)+0*randn(1,1)*coeffBruit;
end;
sig5 = sig1+sig2+sig3+sig4;
figure
sur = 4096;
plot((0:Fs/sur:Fs-Fs/sur)/1000,abs(fft(sig5,sur)))
%% affichage

figure;
subplot(5,1,1),plot(sig1);
subplot(5,1,2),plot(sig2);
subplot(5,1,3),plot(sig3);
subplot(5,1,4),plot(sig4);
subplot(5,1,5),plot(sig5);


%% filtre
sigFiltre = zeros(4,1);

for i=min:max
    sigFiltre(1) = sigFiltre(1) + sig5(i)*(h1(i));
    sigFiltre(2) = sigFiltre(2) + sig5(i)*(h2(i));
    sigFiltre(3) = sigFiltre(3) + sig5(i)*(h3(i));
    sigFiltre(4) = sigFiltre(4) + sig5(i)*(h4(i));
end;
sigFiltre = abs(sigFiltre);
sigFF=zeros(4,max);
sigFF(1,:) = filter(h1(end:-1:1),1,sig5)
sigFF(2,:) = filter(h2(end:-1:1),1,sig5)
sigFF(3,:) = filter(h3(end:-1:1),1,sig5)
sigFF(4,:) = filter(h4(end:-1:1),1,sig5)
figure 
plot(sigFF')
sigFiltre