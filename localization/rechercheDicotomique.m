function [ point ] = rechercheDicotomique( valeur, tableau )
% fonction de recherche dicotomique dans un tableau
% renvoie les coordonn�es voulues (utilisable uniquement pour l'algo de
% localisation

ind = floor(length(tableau)/2); % indice qui coupera le tableau en 2
inter = (1:length(tableau)); % longueur de l'intervalle de base (du tableau)

% d�roulement de l'algo
while length(inter)>1 % tant que le tableau contient plus d'un �l�ment
    if valeur>tableau(1,ind) % prochaine recherche dans moiti� droite si valeur>valeurM�diane
        ind = floor((max(inter)+ind)/2);
        inter = (ind:max(inter));
    else % sinon a gauche
        ind = floor((min(inter)+ind)/2);
        inter = (min(inter):ind);
    end;
end;

% retourne les coordonn�es du point trouv�
point(1,1) = tableau(2,ind);
point(1,2) = tableau(3,ind);
point(1,3) = tableau(4,ind);

end

