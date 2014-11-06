clear all;
close all;
clc;

%% init
load('acquisition_2014-06-11.mat');
Fe = 128000; % fréquence d'échantillonage à donner en Hz
L = 2e-3; % durée de la fenêtre d'observation à donner en seconde
freqs = [39500:500:41000]; % tableau contenant les 4 fréquences utilisées
nbPoints = Fe*L; % nombre de points pris sur une fenetre de durée L échantillonnée a Fe
t = (1:nbPoints)/Fe; % vecteur temps utilisé pour créer les signaux
filtres = zeros(4,nbPoints); % matrice contenant les filtres utilisés sur 1 fenêtre
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