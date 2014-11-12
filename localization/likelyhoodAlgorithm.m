%% algorithme de localisation basé sur la vraissemblance

clear all;
close all;
clc;

% appel du script localization pour créer les tableaux nécessaires
localization

%% init

dist = zeros(1,4); % tableau des distances aux émetteurs
tdoa = [1e-3,0e-3,2e-3]; % tableau contenant les différents TDOA en seconde (entre sig1 et sig2,3,4)
% tdoa<0 <=> drone + près de émetteur 1 que de x
seuilRechercheErreur = 3e-4; % valeur de l'erreur a fournir a 
% la fonction de recherche d'un intervalle de points sous un seuil d'erreur
plot3dOn = 1; % activer le plot en 3D : 0 pour non, 1 pour oui
dicoOn = 0; % faire la recherche et le plot des résultats par dicotomie (0 pour non, 1 pour oui)
resultInterOn = 1; % afficher les résultats intermédiaires (0 : non, 1 : oui)
algoPersoOn = 0; % lancer l'algo de corrélation perso (mix fingerprint-likelihood) : 0 non, 1 oui

%% recherche par dicotomie dans les tableaux pour trouver le point auquel est le drone

if dicoOn==1
    p2 = zeros(1,3); % point trouvé pour le tdoa1-2
    p3 = zeros(1,3); % point trouvé pour le tdoa1-3
    p4 = zeros(1,3); % point trouvé pour le tdoa1-4

    p2 = rechercheDicotomique(tdoa(1),tab2)*coteCube
    p3 = rechercheDicotomique(tdoa(2),tab3)*coteCube
    p4 = rechercheDicotomique(tdoa(3),tab4)*coteCube
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
    P = simplifiedLikelyhood(t2raw,t3raw,t4raw,tdoa)*coteCube
else
    if algoPersoOn==1
        p = correlationMinErreurV2(i2,i3,i4,min2,min3,min4,tab2,tab3,tab4)*coteCube;
    end;
    P = simplifiedLikelyhood(t2raw,t3raw,t4raw,tdoa)*coteCube;
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

if dicoOn
    % matrice contenant les coordonnées des points trouvés par dicotomie
    ps=zeros(3);
    ps(1,:)=p2;
    ps(2,:)=p3;
    ps(3,:)=p4;
end;


% affichage 3D des points trouvés (a revoir)
if plot3dOn==1
    if dicoOn
        figure;
        plot3(ps(:,1),ps(:,2),ps(:,3),'+');
        axis([0,dim(1),0,dim(2),0,dim(3)]);
        title('points trouvés par dicotomie')
        grid on;
    end;
    
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