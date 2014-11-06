clear all;
close all;
clc;

%% init
load('acquisition_2014-06-11.mat');
Fe = 128000; % fr�quence d'�chantillonage � donner en Hz
L = 2e-3; % dur�e de la fen�tre d'observation � donner en seconde
freqs = [39500:500:41000]; % tableau contenant les 4 fr�quences utilis�es
nbPoints = 1024; % nombre de points de l'�chantillon
t = (1:(Fe*L))/Fe; % vecteur temps utilis� pour cr�er les filtres
intervalle = 32; % intervalle duquel la fen�tre glisse (en nombre de points )
filtres = zeros(4,Fe*L); % matrice contenant les filtres utilis�s sur 1 fen�tre
sig = zeros(1,1024);

%% choix et affichage du signal

sig = arret_1024_1;
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

coeffs = zeros(4,(nbPoints-Fe*L)/intervalle);
indCoeff = 1;

% on d�cale la fen�tre de 32 points a chaque fois (choisi arbitrairement
% parmi les puissances de 2)
for ind=1:intervalle:nbPoints-Fe*L
    for j=1:Fe*L
        for i=1:4
            coeffs(i,indCoeff) = coeffs(i,indCoeff) + sig(j+ind)*filtres(i,j);
        end;
    end;
    indCoeff = indCoeff +1;
end;

coeffs = abs(coeffs)

figure;
subplot(4,1,1),plot(coeffs(1,:));
title('coeffs sig1 au cours du temps');
grid on;
subplot(4,1,2),plot(coeffs(2,:));
title('coeffs sig2 au cours du temps');
grid on;
subplot(4,1,3),plot(coeffs(3,:));
title('coeffs sig3 au cours du temps');
grid on;
subplot(4,1,4),plot(coeffs(4,:));
title('coeffs sig4 au cours du temps');
grid on;