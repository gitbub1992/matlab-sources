function [ pointsCommuns ] = correlationMinErreurV2( inter1, inter2, inter3, min1, min2, min3, tab1, tab2, tab3 )
% correlation des 3 tableaux sur les intervalles fournis pour trouver un
% intervalle de points communs correspondant à la position du drone
% indice du min d'erreur dans chaque tableau donné en param aussi
% renvoie :
%   un intervalle de points si la corrélation donne un résultat
%   le barycentre des min sinon (mauvais) -> ne doit jamais arriver si TDOA
%   valides

%% init

resultInterOn = 0; % afficher nbCalculs et points trouvés a la moitié de l'algo
resultFinOn = 1; % afficher nbCalculs a la fin de l'algo
% 0 : non, 1 : oui pour les 2 précédents
nbCalculs = 0; % nombre de calculs effectués par l'algo

%% classement des intervalles selon leur taille

% recherche de l'intervalle de plus petite taille
if length(inter1)<length(inter2)
    if length(inter1)<length(inter3)
        itMin = inter1;
        if length(inter2)<length(inter3)
            itMoy = inter2;
            itMax = inter3;
        else
            itMoy = inter3;
            itMax = inter2;
        end;
    else
        itMin = inter3;
        itMoy = inter1;
        itMax = inter2;
    end;
else
    if length(inter2)<length(inter3)
        itMin = inter2;
        if length(inter1)<length(inter3)
            itMoy = inter1;
            itMax = inter3;
        else
            itMoy = inter3;
            itMax = inter1;
        end;
    else
        itMin = inter3;
        itMoy = inter2;
        itMax = inter1;
    end;
end;

% classement des tableaux selon le même ordre que les intervalles
if min(itMin)==min(inter1) && max(itMin)==max(inter1) % peut pas égaliser direct les intervalles sans risquer d'erreur de dimension
    tabMin = tab1;
    if min(itMoy)==min(inter2) && max(itMoy)==max(inter2)
        tabMoy = tab2;
        tabMax = tab3;
    else
        tabMoy = tab3;
        tabMax = tab2;
    end;
else
    if min(itMin)==min(inter2) && max(itMin)==max(inter2)
        tabMin = tab2;
        if min(itMoy)==min(inter1) && max(itMoy)==max(inter1)
            tabMoy = tab1;
            tabMax = tab3;
        else
            tabMoy = tab3;
            tabMax = tab1;
        end;
    else
        tabMin = tab3;
        if min(itMoy)==min(inter2) && max(itMoy)==max(inter2)
            tabMoy = tab2;
            tabMax = tab1;
        else
            tabMoy = tab1;
            tabMax = tab2;
        end;
    end;
end;

%% recherche de points communs aux 3 intervalles

% on cherchera les points communs parmi les points du plus petit intervalle
% cela réduit le nombre de points à chercher et les calculs effectués
indCommuns = zeros(1,length(itMin)); % initialisation du tableau contenant les indices (dans tabMin) des points communs
ptrCom = 1; % pointeur indiquant la prochaine case libre dans le tableau indCommuns

continuerMoy = 1;
j = min(itMoy);

% on commence par chercher dans l'intervalle de taille moyenne les points
% communs avec l'intervalle de taille minimale
% on laisse une marge d'erreur d'un cube pour dire qu'un point soit commun
% pour prendre en compte les imprécisions de détermination du TDOA
for i=itMin % boucle sur tous les éléments du petit intervalle
    while continuerMoy % boucle sur tous les éléments de l'intervalle moyen
        nbCalculs = nbCalculs+1;
        % si un cube ou un cube directement adjaçent est présent dans les 2
        % intervalles
        if (tabMin(2,i)==tabMoy(2,j) || tabMin(2,i)==tabMoy(2,j)+1 || tabMin(2,i)==tabMoy(2,j)-1) && (tabMin(3,i)==tabMoy(3,j) || tabMin(3,i)==tabMoy(3,j)+1 || tabMin(3,i)==tabMoy(3,j)-1) && (tabMin(4,i)==tabMoy(4,j) || tabMin(4,i)==tabMoy(4,j)+1 || tabMin(4,i)==tabMoy(4,j)-1)
            % on l'ajoute a la liste des communs et on quitte la boucle sur
            % l'intervalle moyen a ce moment la (inutile d'aller plus loin
            % car le point est déjà validé)
            indCommuns(1,ptrCom) = i;
            ptrCom = ptrCom+1;
            continuerMoy = 0;
        else
            % sinon on incrémente l'indice de l'intervalle moyen jusqu'a en
            % atteindre la fin
            j = j+1;
            if j==max(itMoy)+1
                continuerMoy = 0;
            end;
        end;
    end;
    continuerMoy = 1;
    j = min(itMoy);
end;

if resultInterOn==1
    % affichage des données concernant les points communs aux intervalle min et
    % moy : nombre de calculs, points trouvés
    nbCalculs
    indPtsCommunsItMinItMoy=indCommuns(1,[1:ptrCom-1])
end;
continuerMax = 1;
k = min(itMax);

% même fonctionnement que précédemment mais en prenant comme base les
% points communs issus de la recherche précédente
for i=1:ptrCom-1
    ind = indCommuns(1,i);
    while continuerMax
        nbCalculs = nbCalculs+1;
        if (tabMin(2,ind)==tabMax(2,k) || tabMin(2,ind)==tabMax(2,k)+1 || tabMin(2,ind)==tabMax(2,k)-1) && (tabMin(3,ind)==tabMax(3,k) || tabMin(3,ind)==tabMax(3,k)+1 || tabMin(3,ind)==tabMax(3,k)-1) && (tabMin(4,ind)==tabMax(4,k) || tabMin(4,ind)==tabMax(4,k)+1 || tabMin(4,ind)==tabMax(4,k)-1)
            continuerMax = 0;
        else
            k = k+1;
            if k==max(itMax)+1
                continuerMax = 0;
                indCommuns(1,i) = 0;
            end;
        end;
    end;
    continuerMax = 1;
    k = min(itMax);
end;

if resultFinOn==1
    % affichage du nombre total de calculs
    nb_calcul_final_correlation = nbCalculs
end;

%% parcours du tableau des indices des points communs pour trouver les points communs aux 3 tableaux et leur nombre

% comptage des points communs
tCommuns = 0;
for i=1:ptrCom
    if indCommuns(1,i)>0
        tCommuns = tCommuns+1;
    end;
end;

% si au moins un point commun on le renvoie
if tCommuns>0
    ptr = 1;
    pointsCommuns = zeros(3,tCommuns); % tableau contenant les points communs
    for i=1:ptrCom
        if indCommuns(1,i)>0
            pointsCommuns(:,ptr) = [tabMin(2,indCommuns(1,i));tabMin(3,indCommuns(1,i));tabMin(4,indCommuns(1,i))];
            ptr = ptr+1;
        end;
    end;
else % sinon on calcule le barycentre des points ayant l'erreur minimale sur chaque intervalle (erreur probable sur un TDOA)
    barycentre = 1
    pointsCommuns = zeros(3,1);
    pointsCommuns(1,1) = floor((tab1(2,min1)+tab2(2,min2)+tab3(2,min3))/3);
    pointsCommuns(2,1) = floor((tab1(3,min1)+tab2(3,min2)+tab3(3,min3))/3);
    pointsCommuns(3,1) = floor((tab1(4,min1)+tab2(4,min2)+tab3(4,min3))/3);
end;

end

