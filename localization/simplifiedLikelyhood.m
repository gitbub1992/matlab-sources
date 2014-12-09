function [ points, min ] = simplifiedLikelyhood( t1, t2, t3, TDOAs , indDebut, indFin)
% fonction de recherche par vraissemblance :
% recherche le point ayant le plus de proba d'�tre celui qui correspond aux
% tdoas donn�s en param�tres

%% construction du tableau qui servira a choisir les points les plus vraissemblables

tabLikely = zeros(4,length(t1));
% on place les coordonn�es des points de la pi�ce dans ce tableau
tabLikely (2,:) = t1(2,:);
tabLikely (3,:) = t1(3,:);
tabLikely (4,:) = t1(4,:);

%% calcul du coeff associ� a chaque point de la pi�ce

% le coeff associ� a un point pour un tdoa est |tdoa_th�orique-tdoa_mesur�|
% le coeff global est la somme des coeff associ�s a chaque tdoa
% cela revient a consid�rer une variance de 1 sur les gaussiennes
% si l'on veut prendre en compte une variance, il faudrait diviser chaque
% coeff par sa variance associ�e

% boucle de calcul des coeffs
for i=1:length(t1)
    tabLikely(1,i) = abs(t1(1,i)-TDOAs(1)) + abs(t2(1,i)-TDOAs(2)) + abs(t3(1,i)-TDOAs(3));
end;

%% classement du tableau pour r�cup�rer les points les plus vraisemblables

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

%% s�lection des points les plus probables : on en garde 10

points = zeros(3,10);
for i=1:3
    points(i,:) = tabLikely(i+1,1:10);
end;

end

