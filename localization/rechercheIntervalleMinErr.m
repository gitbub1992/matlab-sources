function [ intervalle ] = rechercheIntervalleMinErr( valeur, erreur, tableau )
% recherche d'un intervalle d'indice dans un tableau ordonn�e
% cet intervalle contient les valeurs proche a erreur pr�s de valeur

indDebut = 0;
indFin = 0;
ind = 1;
continuer = 1;
while continuer==1
    if (abs(valeur-tableau(1,ind))<erreur)
        if indDebut==0
            indDebut = ind;
        end;
    else
        if indDebut>0
            indFin = ind;
        end;
    end;
    ind = ind+1;
    if (indDebut>0 && indFin>0) || ind == length(tableau)
        continuer = 0;
    end;
end;

intervalle=(indDebut:indFin);

end

