%% algorithme de localisation basé sur la vraissemblance

clear all;
close all;
clc;

% appel du script localization pour créer les tableaux nécessaires
localization

%% recherche par dicotomie dans les tableaux pour trouver le point auquel est le drone

p2 = zeros(1,3); % point trouvé pour le tdoa1-2
p3 = zeros(1,3); % point trouvé pour le tdoa1-3
p4 = zeros(1,3); % point trouvé pour le tdoa1-4

p2 = rechercheDicotomique(tdoa(1),tab2)*0.25
p3 = rechercheDicotomique(tdoa(2),tab3)*0.25
p4 = rechercheDicotomique(tdoa(3),tab4)*0.25

i2 = rechercheIntervalleMinErr(tdoa(1),0.3e-3,tab2);
i3 = rechercheIntervalleMinErr(tdoa(2),0.3e-3,tab3);
i4 = rechercheIntervalleMinErr(tdoa(3),0.3e-3,tab4);

p = correlationMinErreur(i2,i3,i4,tab2,tab3,tab4)*0.25

ps=zeros(3);
ps(1,:)=p2;
ps(2,:)=p3;
ps(3,:)=p4;

figure;
plot3(ps(:,1),ps(:,2),ps(:,3),'-+');
title('points trouvés par dicotomie')
grid on;
figure;
plot3(p(1),p(2),p(3),'-+');
title('premier point trouvé par correlation sur la recherche par erreur min')
grid on;