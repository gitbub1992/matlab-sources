clear all;
close all;
clc;

%% init
load('acquisition_2014-06-11.mat');
Fe = 128000; % fr�quence d'�chantillonage � donner en Hz
L = 2e-3; % dur�e de la fen�tre d'observation � donner en seconde
freqs = [39500:500:41000]; % tableau contenant les 4 fr�quences utilis�es
nbPoints = Fe*L; % nombre de points pris sur une fenetre de dur�e L �chantillonn�e a Fe
t = (1:nbPoints)/Fe; % vecteur temps utilis� pour cr�er les signaux
filtres = zeros(4,nbPoints); % matrice contenant les filtres utilis�s sur 1 fen�tre
sig = zeros(1,256);

%% choix signal
sig = arret3;
%sig(256) = mean(bruit2);
sig = sig - mean(sig);
sig = sig / max(abs(sig));
plot(sig);
figure;
diviseur = 4096;
plot((0:Fe/diviseur:Fe-Fe/diviseur)/1000,abs(fft(sig,diviseur)));
xlim([0,64]);
grid on;
%% filtrage
for i=1:4
    filtres(i,:) = exp(2*pi*j*freqs(i)*t);
end;

coeffs = zeros(4,1);
for j=1:256
    for i=1:4
        coeffs(i) = coeffs(i) + sig(j)*filtres(i,j);
    end;
end;

coeffs = abs(coeffs)