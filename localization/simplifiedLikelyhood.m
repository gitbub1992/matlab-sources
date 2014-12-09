function [ points, min ] = simplifiedLikelyhood( t1, t2, t3, TDOAs , indDebut, indFin)
% fonction de recherche par vraissemblance :
% recherche le point ayant le plus de proba d'être celui qui correspond aux
% tdoas donnés en paramètres

%% construction du tableau qui servira a choisir les points les plus vraissemblables

tabLikely = zeros(4,length(t1));
% on place les coordonnées des points de la pièce dans ce tableau
tabLikely (2,:) = t1(2,:);
tabLikely (3,:) = t1(3,:);
tabLikely (4,:) = t1(4,:);

%% calcul du coeff associé a chaque point de la pièce

% le coeff associé a un point pour un tdoa est |tdoa_théorique-tdoa_mesuré|
% le coeff global est la somme des coeff associés a chaque tdoa
% cela revient a considérer une variance de 1 sur les gaussiennes
% si l'on veut prendre en compte une variance, il faudrait diviser chaque
% coeff par sa variance associée

% boucle de calcul des coeffs
for i=1:length(t1)
    tabLikely(1,i) = abs(t1(1,i)-TDOAs(1)) + abs(t2(1,i)-TDOAs(2)) + abs(t3(1,i)-TDOAs(3));
end;

%% classement du tableau pour récupérer les points les plus vraisemblables

% plus le coefficient d'un point est petit, plus il est vraisemblable
% (somme des erreurs sur les TDOAs la plus faible)
minV = 10000;
indMin = 0;
for i=indDebut:indFin
    if(tabLikely(1,i)<minV)
        minV = tabLikely(1,i);
        indMin = i;
    end;
end;
min = [tabLikely(2,indMin),tabLikely(3,indMin),tabLikely(4,indMin)];
tabLikely = sortrows(tabLikely');
tabLikely = tabLikely';

%% sélection des points les plus probables : on en garde 10

points = zeros(3,10);
for i=1:3
    points(i,:) = tabLikely(i+1,1:10);
end;

end

