%% TDOA based localization algorithm (2D implementation for tests)
clear all;
close all;
clc;

%% init

plotTdoaOn = 0; % afficher les TDOA calculés pour chaque émetteur (0 pour non, 1 pour oui)
generateFiles = 1; % générer les fichiers de tdoa (0 pour non, 1 pour oui)
v = 340; % vitesse du son en m/s
dim = [4.2,6.6,2.9]; % dimensions de la pièce en m (x y z)
coteCube = 0.2; % longueur du coté des cubes en quoi la pièce sera divisée
m = floor(dim(1)/coteCube); % taille de la matrice selon x
n = floor(dim(2)/coteCube); % taille de la matrice selon y
p = floor(dim(3)/coteCube); % taille de la matrice selon z
% les tailles précédentes peuvent ignorer une partie de la pièce à cause
% de l'utilisation de floor -> réduit possiblement d'un cube la pièce
beacons = [0,0,dim(3); dim(1),0,dim(3); dim(1),dim(2),dim(3); 0,dim(2),dim(3)]; % position des émetteurs
% creation de variables depuis tableau beacons :
x1 = beacons(1,1); y1 = beacons(1,2); z1 = beacons(1,3); % coordonnées x, y et z du beacon 1
x2 = beacons(2,1); y2 = beacons(2,2); z2 = beacons(2,3); % coordonnées x, y et z du beacon 2
x3 = beacons(3,1); y3 = beacons(3,2); z3 = beacons(3,3); % coordonnées x, y et z du beacon 3
x4 = beacons(4,1); y4 = beacons(4,2); z4 = beacons(4,3); % coordonnées x, y et z du beacon 4

%% création de la BDD de TDOA

room2 = zeros(m,n,p); % matrice contenant les TDOA entre les signaux 1 et 2 sur l'ensemble de la pièce
room3 = zeros(m,n,p); % matrice contenant les TDOA entre les signaux 1 et 3 sur l'ensemble de la pièce
room4 = zeros(m,n,p); % matrice contenant les TDOA entre les signaux 1 et 4 sur l'ensemble de la pièce

% calcul des TDOA pour chaque cube
for i=1:m
    for j=1:n
        for k=1:p
            room2(i,j,k) = (sqrt((i*coteCube-x1)^2+(j*coteCube-y1)^2+(k*coteCube-z1)^2)-sqrt((i*coteCube-x2)^2+(j*coteCube-y2)^2+(k*coteCube-z2)^2))/v;
            room3(i,j,k) = (sqrt((i*coteCube-x1)^2+(j*coteCube-y1)^2+(k*coteCube-z1)^2)-sqrt((i*coteCube-x3)^2+(j*coteCube-y3)^2+(k*coteCube-z3)^2))/v;
            room4(i,j,k) = (sqrt((i*coteCube-x1)^2+(j*coteCube-y1)^2+(k*coteCube-z1)^2)-sqrt((i*coteCube-x4)^2+(j*coteCube-y4)^2+(k*coteCube-z4)^2))/v;
        end;
    end;
end;

%% transformation des matrices 3D de TDOA en matrice 2D associant les TDOA et les coordonnées correspondantes

tabR2 = zeros(1,m*n*p); % tableau des TDOA sig1 sig2
tabR3 = zeros(1,m*n*p); % tableau des TDOA sig1 sig3
tabR4 = zeros(1,m*n*p); % tableau des TDOA sig1 sig4
tabPointsR2 = zeros(3,m*n*p); % tableau des coordonnées correspondantes pour le TDOA sig1 sig2
tabPointsR3 = zeros(3,m*n*p); % tableau des coordonnées correspondantes pour le TDOA sig1 sig3
tabPointsR4 = zeros(3,m*n*p); % tableau des coordonnées correspondantes pour le TDOA sig1 sig4

% transfo des matrices en tableau :
%   pour une surface, on copie chaque colone correspondante
i = 1;
j = 1;
for ind=1:n*m
    tabR2((ind-1)*p+1:ind*p) = room2(i,j,:);
    tabR3((ind-1)*p+1:ind*p) = room3(i,j,:);
    tabR4((ind-1)*p+1:ind*p) = room4(i,j,:);
    for k =1:p
        tabPointsR2(1,p*(ind-1)+k) = i;
        tabPointsR2(2,p*(ind-1)+k) = j;
        tabPointsR2(3,p*(ind-1)+k) = k;
        tabPointsR3(1,p*(ind-1)+k) = i;
        tabPointsR3(2,p*(ind-1)+k) = j;
        tabPointsR3(3,p*(ind-1)+k) = k;
        tabPointsR4(1,p*(ind-1)+k) = i;
        tabPointsR4(2,p*(ind-1)+k) = j;
        tabPointsR4(3,p*(ind-1)+k) = k;
    end;
    if j < n
        j = j+1;
    else
        j = 1;
        i = i+1;
    end;
end;

% regroupement des tableaux de TDOA et matrice de coordonnées en 1 matrice
% TDOA-coordonnées associées
tab2 = zeros(4,m*n*p);
tab3 = zeros(4,m*n*p);
tab4 = zeros(4,m*n*p);
for i=2:4
    tab2(i,:)=tabPointsR2(i-1,:);
    tab3(i,:)=tabPointsR3(i-1,:);
    tab4(i,:)=tabPointsR4(i-1,:);
end;

tab2(1,:)=tabR2;
tab3(1,:)=tabR3;
tab4(1,:)=tabR4;

% on garde en mémoire les tableaux non ordonnés (coordonnées des points au
% même endroit, plages de points à z constant)
t2raw = tab2;
t3raw = tab3;
t4raw = tab4;
% classement des tableaux par plans à z constant
% t2
t2raw(1,:)=tab2(4,:);
t2raw(4,:)=tab2(1,:);
t2raw = sortrows(t2raw');
t2raw = t2raw';
t2bis = t2raw(1,:);
t2raw(1,:) = t2raw(4,:);
t2raw(4,:) = t2bis;
% t3
t3raw(1,:)=tab3(4,:);
t3raw(4,:)=tab3(1,:);
t3raw = sortrows(t3raw');
t3raw = t3raw';
t3bis = t3raw(1,:);
t3raw(1,:) = t3raw(4,:);
t3raw(4,:) = t3bis;
% t4
t4raw(1,:)=tab4(4,:);
t4raw(4,:)=tab4(1,:);
t4raw = sortrows(t4raw');
t4raw = t4raw';
t4bis = t4raw(1,:);
t4raw(1,:) = t4raw(4,:);
t4raw(4,:) = t4bis;

%% tri des matrices par ordre croissant de TDOA

tab2 = sortrows(tab2');
tab2 = tab2';
tab3 = sortrows(tab3');
tab3 = tab3';
tab4 = sortrows(tab4');
tab4 = tab4';

% affichage des tdoas calculés pour chaque émetteur
if plotTdoaOn==1
    figure;
    subplot(3,1,1),plot(tab2(1,:));
    title('tdoa 1-2');
    grid on;
    subplot(3,1,2),plot(tab3(1,:));
    title('tdoa 1-3');
    grid on;
    subplot(3,1,3),plot(tab4(1,:));
    title('tdoa 1-4');
    grid on;
end;

%% génération des fichiers sous le format suivant :
% nombre_de_points
% tdoa1,x,y,z
% ...
% tdoan,x,y,z
%

if generateFiles==1
    for i=1:3
        switch i
            case 1,
                nomFichier = 'tdoa1-2.txt';
            case 2,
                nomFichier = 'tdoa1-3.txt';
            case 3,
                nomFichier = 'tdoa1-4.txt';
            otherwise,
                bugSwitchFileName = 1
                nomFichier = 'error.txt';
        end;
        fileID = fopen([nomFichier], 'w');
        if i==1
            fprintf(fileID,'%d %d %d %d %f\n',n*m*p, m, n, p, coteCube);
        end;
        for j=1:m*n*p
            switch i
                case 1,
                fprintf(fileID,'%f,%f,%f,%f\n',t2raw(1,j)*1000,t2raw(2,j)*coteCube,t2raw(3,j)*coteCube,t2raw(4,j)*coteCube);
                case 2,
                fprintf(fileID,'%f,%f,%f,%f\n',t3raw(1,j)*1000,t3raw(2,j)*coteCube,t3raw(3,j)*coteCube,t3raw(4,j)*coteCube);
                case 3,
                fprintf(fileID,'%f,%f,%f,%f\n',t4raw(1,j)*1000,t4raw(2,j)*coteCube,t4raw(3,j)*coteCube,t4raw(4,j)*coteCube);
                otherwise,
                bugSwitch = 1
            end;
        end;
        fclose(fileID);
    end;
end;

