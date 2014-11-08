function [ point ] = correlationMinErreur( inter1, inter2, inter3, min1, min2, min3, tab1, tab2, tab3 )
% correlation des 3 tableaux sur les intervalles fournis pour trouver un
% point commun correspondant à la position du drone
% indice du min d'erreur dans chaque tableau donné en param aussi

point = zeros(1,3);

% recherche d'un point commun aux 3 tableaux
continuer1 = 1;
continuer2 = 1;
continuer3 = 1;
i = min(inter1);
j = min(inter2);
k = min(inter3);
nbCalculs = 0;

while continuer1 % boucle sur l'intervalle 1
    while continuer2 % boucle sur l'intervalle 2
        while continuer3 % boucle sur l'intervalle 3
            nbCalculs = nbCalculs+1;
            if tab1(2,i)==tab2(2,j) && tab1(3,i)==tab2(3,j) && tab1(4,i)==tab2(4,j) && tab1(2,i)==tab3(2,k) && tab1(3,i)==tab3(3,k) && tab1(4,i)==tab3(4,k)
                continuer3 = 0;
                continuer2 = 0;
                continuer1 = 0;
                point(1,1) = tab1(2,i);
                point(1,2) = tab1(3,i);
                point(1,3) = tab1(4,i);
            else
                k = k+1;
            end;
            if k==max(inter3)
                k = min(inter3);
                continuer3 = 0;
            end;
        end;
        % fin boucle 3
        j = j+1;
        continuer3 = 1;
        if j==max(inter2)
            j = min(inter2);
            continuer2 = 0;
        end;
    end;
    % fin boucle 2
    continuer2 = 1;
    i = i+1;
    if i==max(inter1)
        continuer1 = 0;
    end;
end;
% fin boucle 1

% si aucun point trouvé, on prend la moyenne de la médiane de chaque
% intervalle (point présentant la plus petite erreur de chaque tdoa)
if point==zeros(1,3)
    barycentre = 1
    point(1,1) = floor((tab1(2,min1)+tab2(2,min2)+tab3(2,min3))/3);
    point(1,2) = floor((tab1(3,min1)+tab2(3,min2)+tab3(3,min3))/3);
    point(1,3) = floor((tab1(4,min1)+tab2(4,min2)+tab3(4,min3))/3);
end;

nbCalculs
%maxExplo = max(inter1)*max(inter2)*max(inter3)

end

