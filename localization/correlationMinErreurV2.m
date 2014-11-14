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
toleranceMin = 0; % tolérance de départ pour l'algo
tolerance = toleranceMin; % tolérance sur la corrélation (en nombre de cubes)
% correspond au nombre de cubes d'erreur dans une direction que l'on peut
% admettre comme erreur (ex : 1 cube de tolérance consiste a rechercher un
% cube et tous les cubes qui lui sont adjacents)
% indication : utiliser une tolérance de 1 au minimum, 0 est trop
% restrictif et pourra conduire a une recherche ne donnant aucun résultat
% (perte de temps)
toleranceMax = 2; % tolérance maximale jusqu'a laquelle aller si on 
% ne trouve pas de points communs avant
% ajuster cette valeur en fonction de la précision souhaitée et de la
% confiance dans les valeurs de TDOA étudiées (plus les valeurs de TDOA
% sont fiables, plus la tolérance maximale peut être faible et inversement

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

continuer = 1; % booleen indiquant l'arret de la tentative de corrélation
% on continue a essayer de correler tant qu'on a pas trouvé au moins 1
% point et qu'on a pas atteint toleranceMax (tolerance incrémenté si on ne
% trouve pas de point commun)
while continuer

    % affichage du nombre de passage dans la boucle de corrélation
    nombre_tentative_correlation = tolerance
    
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
            if (tabMin(2,i)==tabMoy(2,j) || tabMin(2,i)==tabMoy(2,j)+tolerance || tabMin(2,i)==tabMoy(2,j)-tolerance) && (tabMin(3,i)==tabMoy(3,j) || tabMin(3,i)==tabMoy(3,j)+tolerance || tabMin(3,i)==tabMoy(3,j)-tolerance) && (tabMin(4,i)==tabMoy(4,j) || tabMin(4,i)==tabMoy(4,j)+tolerance || tabMin(4,i)==tabMoy(4,j)-tolerance)
                % on l'ajoute a la liste des communs et on quitte la boucle sur
                % l'intervalle moyen a ce moment la (inutile d'aller plus loin
                % car le point est déjà validé)
                % comme on peut passer plusieurs fois dans cette boucle a
                % cause de la tolérance, on recherche d'abord si le point
                % n'a pas déjà été ajouté
                if tolerance>toleranceMin % au premier passage sur la tolérance, aucun point dans le tableau donc pas besoin de vérifier s'il existe déjà
                    recherche = 1;
                    pt = 1;
                    while recherche==1
                        if indCommuns(1,pt)==i
                            recherche = 0;
                            existe = 1;
                        else
                            pt = pt+1;
                            if pt>=ptrCom
                                existe = 0;
                                recherche = 0;
                            end;
                        end;
                    end;
                    if existe==0
                        indCommuns(1,ptrCom) = i;
                        ptrCom = ptrCom+1;
                    end;
                else
                    indCommuns(1,ptrCom) = i;
                    ptrCom = ptrCom+1;
                end;
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
    indCommunsFin = indCommuns;

    % même fonctionnement que précédemment mais en prenant comme base les
    % points communs issus de la recherche précédente
    for i=1:ptrCom-1
        ind = indCommunsFin(1,i);
        while continuerMax
            nbCalculs = nbCalculs+1;
            if (tabMin(2,ind)==tabMax(2,k) || tabMin(2,ind)==tabMax(2,k)+tolerance || tabMin(2,ind)==tabMax(2,k)-tolerance) && (tabMin(3,ind)==tabMax(3,k) || tabMin(3,ind)==tabMax(3,k)+tolerance || tabMin(3,ind)==tabMax(3,k)-tolerance) && (tabMin(4,ind)==tabMax(4,k) || tabMin(4,ind)==tabMax(4,k)+tolerance || tabMin(4,ind)==tabMax(4,k)-tolerance)
                continuerMax = 0;
            else
                k = k+1;
                if k==max(itMax)+1
                    continuerMax = 0;
                    indCommunsFin(1,i) = 0;
                end;
            end;
        end;
        continuerMax = 1;
        k = min(itMax);
    end;

    if resultFinOn==1
        % affichage du nombre total de calculs
        nb_calculs_final_correlation = nbCalculs
    end;

    % parcours du tableau des indices des points communs pour trouver les points communs aux 3 tableaux et leur nombre

    % comptage des points communs
    tCommuns = 0;
    for i=1:ptrCom-1
        if indCommunsFin(1,i)>0
            tCommuns = tCommuns+1;
        end;
    end;

    % on teste si la corrélation a réussi
    if tCommuns>0
        % si oui on peut sortir de la boucle
        continuer = 0;
    else
        % sinon
        if tolerance<toleranceMax
            % on incrémente tolérance si elle est inférieure au max défini et on recommence
            tolerance = tolerance+1;
        else
            % si elle est égale au max, on arrête l'algo
            continuer = 0;
        end;
    end;
end;

%% construction du résultat

% si au moins un point commun on le renvoie
if tCommuns>0
    ptr = 1;
    pointsCommuns = zeros(3,tCommuns); % tableau contenant les points communs
    for i=1:ptrCom-1
        if indCommunsFin(1,i)>0
            pointsCommuns(:,ptr) = [tabMin(2,indCommunsFin(1,i));tabMin(3,indCommunsFin(1,i));tabMin(4,indCommunsFin(1,i))];
            ptr = ptr+1;
        end;
    end;
else % sinon on calcule le barycentre des points ayant l'erreur minimale sur chaque intervalle (erreur probable sur un TDOA)
    correlation_echoue_barycentre_calcule = 1
    pointsCommuns = zeros(3,1);
    pointsCommuns(1,1) = floor((tab1(2,min1)+tab2(2,min2)+tab3(2,min3))/3);
    pointsCommuns(2,1) = floor((tab1(3,min1)+tab2(3,min2)+tab3(3,min3))/3);
    pointsCommuns(3,1) = floor((tab1(4,min1)+tab2(4,min2)+tab3(4,min3))/3);
end;

end

