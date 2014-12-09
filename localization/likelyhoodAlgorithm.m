%% algorithme de localisation basé sur la vraissemblance

clear all;
close all;
clc;

% appel du script localization pour créer les tableaux nécessaires
localization

%% init

dist = zeros(1,4); % tableau des distances aux émetteurs
tdoa = [(0)*1e-3,(0)*1e-3,(0)*1e-3]; % tableau contenant les différents TDOA en seconde (entre sig1 et sig2,3,4)
% tdoa<0 <=> drone + près de émetteur 1 que de x
seuilRechercheErreur = 3e-4; % valeur de l'erreur a fournir a 
% la fonction de recherche d'un intervalle de points sous un seuil d'erreur

plot3dOn = 0; % activer le plot en 3D : 0 pour non, 1 pour oui
resultInterOn = 0; % afficher les résultats intermédiaires (0 : non, 1 : oui)
algoPersoOn = 0; % lancer l'algo de corrélation perso (mix fingerprint-likelihood) : 0 non, 1 oui
tdoaKnowPositionOn = 1; % activer le caclul des TDOAs a partir d'une position connue, 1 oui, 0 non

%% Fixation des TDOA en utilisant une position connue

if tdoaKnowPositionOn==1
    % coordonnées du drone sur chacun des axes, donner les valeurs voulues
    X = 2.1;
    Y = 3.3;
    Z = 0.2;
    ind1 = (floor(Z/coteCube)-1)*m*n
    if ind1==0
        ind1=1;
    end;
    ind2 = (floor(Z/coteCube)+1)*m*n
    tdoa(1) = (sqrt((x1-X)^2+(y1-Y)^2+(z1-Z)^2) - sqrt((x2-X)^2+(y2-Y)^2+(z2-Z)^2))/v;
    tdoa(2) = (sqrt((x1-X)^2+(y1-Y)^2+(z1-Z)^2) - sqrt((x3-X)^2+(y3-Y)^2+(z3-Z)^2))/v;
    tdoa(3) = (sqrt((x1-X)^2+(y1-Y)^2+(z1-Z)^2) - sqrt((x4-X)^2+(y4-Y)^2+(z4-Z)^2))/v;    
    tdoa
    %tdoa = tdoa +rand(1,3)*1e-3-rand(1,3)*1e-3
end;

%% recherche d'un intervalle de points en dessous d'une certaine erreur dans les 3 tableaux

if algoPersoOn==1
    % lancement de la recherche
    [i2,min2] = rechercheIntervalleMinErr(tdoa(1),seuilRechercheErreur,tab2);
    [i3,min3] = rechercheIntervalleMinErr(tdoa(2),seuilRechercheErreur,tab3);
    [i4,min4] = rechercheIntervalleMinErr(tdoa(3),seuilRechercheErreur,tab4);

    if resultInterOn==1
        % affichage des points minimum trouvés
        mintab2=[tab2(1,min2), tab2(2,min2), tab2(3,min2), tab2(4,min2)]
        mintab3=[tab3(1,min3), tab3(2,min3), tab3(3,min3), tab3(4,min3)]
        mintab4=[tab4(1,min4), tab4(2,min4), tab4(3,min4), tab4(4,min4)]
    end;
end;

% lancement de la corrélation sur les intervalles issus de la recherche
% précédente et conversion en m des résultats obtenus
if resultInterOn==1
    if algoPersoOn==1
        p = correlationMinErreurV2(i2,i3,i4,min2,min3,min4,tab2,tab3,tab4)*coteCube
    end;
    [P,m] = simplifiedLikelyhood(t2raw,t3raw,t4raw,tdoa,ind1,ind2)%*coteCube
else
    if algoPersoOn==1
        p = correlationMinErreurV2(i2,i3,i4,min2,min3,min4,tab2,tab3,tab4)*coteCube;
    end;
    [P,m] = simplifiedLikelyhood(t2raw,t3raw,t4raw,tdoa,ind1,ind2);%*coteCube;
    P = P*coteCube
    m = m*coteCube
end;

% calcul et affichage de la distance du drone a chaque émetteur pour chaque
% point trouvé
if algoPersoOn==1
    lp = size(p);
    lp = lp(2);
    if lp<2
        dist(1,1) = sqrt((x1-p(1))^2+(y1-p(2))^2+(z1-p(3))^2);
        dist(1,2) = sqrt((x2-p(1))^2+(y2-p(2))^2+(z2-p(3))^2);
        dist(1,3) = sqrt((x3-p(1))^2+(y3-p(2))^2+(z3-p(3))^2);
        dist(1,4) = sqrt((x4-p(1))^2+(y4-p(2))^2+(z4-p(3))^2);
        if resultInterOn==1
            dist
        end;
    else
        for i=1:lp
            dist(1,1) = sqrt((x1-p(1,i))^2+(y1-p(2,i))^2+(z1-p(3,i))^2);
            dist(1,2) = sqrt((x2-p(1,i))^2+(y2-p(2,i))^2+(z2-p(3,i))^2);
            dist(1,3) = sqrt((x3-p(1,i))^2+(y3-p(2,i))^2+(z3-p(3,i))^2);
            dist(1,4) = sqrt((x4-p(1,i))^2+(y4-p(2,i))^2+(z4-p(3,i))^2);
            if resultInterOn==1
                dist
            end;
        end;
    end;
end;

for i=1:10
    dist(1,1) = sqrt((x1-P(1,i))^2+(y1-P(2,i))^2+(z1-P(3,i))^2);
    dist(1,2) = sqrt((x2-P(1,i))^2+(y2-P(2,i))^2+(z2-P(3,i))^2);
    dist(1,3) = sqrt((x3-P(1,i))^2+(y3-P(2,i))^2+(z3-P(3,i))^2);
    dist(1,4) = sqrt((x4-P(1,i))^2+(y4-P(2,i))^2+(z4-P(3,i))^2);
    if resultInterOn==1
        dist
    end;
end;

%% affichage en 3D des points trouvés par les différents algos

% affichage 3D des points trouvés
if plot3dOn==1
    
    PT = P';
    
    if algoPersoOn==1
        figure;
        pT = p';
        plot3(pT(:,1),pT(:,2),pT(:,3),'+');
        axis([0,dim(1),0,dim(2),0,dim(3)]);
        title('points trouvé par correlation sur la recherche par erreur min')
        grid on;
        hold on;
        plot3(PT(:,1),PT(:,2),PT(:,3),'r+');
    else
        figure;
        plot3(PT(1,1),PT(1,2),PT(1,3),'r+');
        hold on;
        plot3(PT(2:5,1),PT(2:5,2),PT(2:5,3),'m+');
        hold on;
        plot3(PT(5:10,1),PT(5:10,2),PT(5:10,3),'b+');
        axis([0,dim(1),0,dim(2),0,dim(3)]);
        title('points trouvé par algo vraisemblance')
        grid on;
    end;
end;