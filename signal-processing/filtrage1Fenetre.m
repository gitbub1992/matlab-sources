function [ coeffs ] = filtrage1Fenetre( Fe, dureeFenetre, signaux, filtres )
% fonction ayant pour param :
%   - Fe : fréquence d'échantillonage
%   - dureeFenetre : la durée d'une fenêtre d'observation (a donner en
%   secondes)
%   - signaux : les signaux a sommer puis filtrer
%   - filtres : une matrice contenant les 4 filtres utilisés (de
%   préférence par ordre croissant de fréquence)
%  
% retourne :
%   - les coeffs associés a chaque fréquence représentée par un filtre

%% initialisation des variables nécessaires
indiceDepart = 1; % indice minimum de départ
nbPoints = Fe*dureeFenetre; % nombre de points dans une fenêtre de durée dureeFenetre échantillonée a Fe
t = (indiceDepart:nbPoints)/Fe; % vecteur temps discret
afficherFiltres = 0; % activer l'affichage des filtres (0 si non, 1 si oui)
plotSignaux = 1; % activer l'affichage des signaux
plotFFT = 1; % activer l'affichage de la FFT

%% affichage des signaux et de leur somme

signal = zeros(1,nbPoints);
signal = signaux(1,:)+signaux(2,:)+signaux(3,:)+signaux(4,:);%+randn(1,nbPoints);
if plotSignaux==1
    figure;
    subplot(5,1,1),plot(t,signaux(1,:));
    title('signal 1');
    subplot(5,1,2),plot(t,signaux(2,:));
    title('signal 2');
    subplot(5,1,3),plot(t,signaux(3,:));
    title('signal 3');
    subplot(5,1,4),plot(t,signaux(4,:));
    title('signal 4');
    subplot(5,1,5),plot(t,signal);
    title('signal global étudié');
    if afficherFiltres>0
        figure;
        subplot(4,1,1),plot(t,filtres(1,:));
        title('filtre 1');
        subplot(4,1,2),plot(t,filtres(2,:));
        title('filtre 2');
        subplot(4,1,3),plot(t,filtres(3,:));
        title('filtre 3');
        subplot(4,1,4),plot(t,filtres(4,:));
        title('filtre 4');
    end;
end;
%% traçage de la FFT du signal a étudier (en kHz)

if plotFFT==1
    figure;
    diviseur = 4096;
    plot((0:Fe/diviseur:Fe-Fe/diviseur)/1000,abs(fft(signal,diviseur)));
    title('FFT signal');
    grid on;
    xlim([0,64]);
end;

%% filtrage

coeffs = zeros(4,1);
for j=indiceDepart:nbPoints
    for i=1:4
        coeffs(i) = coeffs(i) + signal(j)*filtres(i,j);
    end;
end;

coeffs = abs(coeffs);

end

