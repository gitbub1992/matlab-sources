function [ point ] = correlationMinErreur( inter1, inter2, inter3, tab1, tab2, tab3 )
% correlation des 3 tableaux sur les intervalles fournis pour trouver un
% point commun correspondant à la position du drone

point = zeros(1,3);

% recherche d'un point commun aux 3 tableaux
continuer1 = 1;
continuer2 = 1;
continuer3 = 1;
i = min(inter1);
j = min(inter2);
k = min(inter3);
nbExplo = 0;

while continuer1 % boucle sur l'intervalle 1 (arbitraire)
    while continuer2
        while continuer3
            nbExplo = nbExplo+1;
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
        j = j+1;
        continuer3 = 1;
        if j==max(inter2)
            j = min(inter2);
            continuer2 = 0;
        end;
    end;
    continuer2 = 1;
    i = i+1;
    if i==max(inter1)
        continuer1 = 0;
    end;
end;

nbExplo

end

