%% utilisation de la fonction filtrage1Fenetre pour simuler une fenetre glissante

clear all;
close all;
clc;

%% d�finition des signaux et des variables n�cessaires

Fe = 128000; % fr�quence d'�chantillonage � donner en Hz
L = 2e-3; % dur�e de la fen�tre d'observation � donner en seconde
freqs = [39500:500:41000]; % tableau contenant les 4 fr�quences utilis�es
nbPoints = Fe*L; % nombre de points pris sur une fenetre de dur�e L �chantillonn�e a Fe
t = (1:nbPoints)/Fe; % vecteur temps utilis� pour cr�er les signaux
filtres = zeros(4,nbPoints); % matrice contenant les filtres utilis�s sur 1 fen�tre
signaux = zeros(4,nbPoints*2); % matrice contenant les signaux que l'on �tudiera
% 2 fois plus de points que les filtres pour pouvoir d�caler les signaux
% dans le temps
sigInter = zeros(4,nbPoints); % matrice contenant les cos correspondant aux signaux �mis

%% cr�ation des filtres
% remarque : transformer en filtres sin+cos

for i=1:4
    filtres(i,:) = exp(2*pi*j*freqs(i)*t);
end;

%% cr�ation des signaux tels qu'ils sont �mis

for i=1:4
    sigInter(i,:) = cos(2*pi*freqs(i)*t);
end;

%% cr�ation et affichage des signaux re�us simul�s

signaux(1,[33:33+nbPoints-1]) = sigInter(1,:);
signaux(2,[97:97+nbPoints-1]) = sigInter(2,:);
signaux(3,[197:197+nbPoints-1]) = sigInter(3,:);
signaux(4,[126:126+nbPoints-1]) = sigInter(4,:);

figure;
subplot(4,1,1),plot(signaux(1,:));
title('signaux re�us simul�s');
subplot(4,1,2),plot(signaux(2,:));
subplot(4,1,3),plot(signaux(3,:));
subplot(4,1,4),plot(signaux(4,:));

%% simu fenetre glissante

coeffs = zeros(4,9);
indCoeff = 1;

for ind=1:32:nbPoints+1
    coeffs(:,indCoeff) = filtrage1Fenetre(Fe,L,signaux(:,[0+ind:nbPoints+ind-1]),filtres);
    indCoeff = indCoeff +1;
end;

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
