%% Conception d'un filtre FIR de la forme
%         _ N-1
%  s(k) = \        a(n).e(k-n)
%         /_ n=0
% Et génération du code C associé à ce filtre

clc       
clear all 
close all 

%% MODIF sélectionner le filtre à générer
freqSignalAFiltrerInit = 39500; % définissez ici la fréquence en Hz du signal a filtrer
freqMaxSignal = 41000;
incrementFreq = 500; % incrément de fréquence à chaque boucle (écart entre les fréquences émises)
freqEchantillonage = 128000; % (Hz)
tempsEchantillonage = 2e-3; %(S)
resolution = tempsEchantillonage*freqEchantillonage;

%% MODIF donner un nom au .h à générer
Nom_Fich1='cos_39500.h';
Nom_Fich2='cos_40000.h';
Nom_Fich3='cos_40500.h';
Nom_Fich4='cos_41000.h';

%% Génération des quatres filtres RIF
filtre = zeros(256,4);
i =0;

for freq = freqSignalAFiltrerInit:incrementFreq:freqMaxSignal
	i = i +1;
	for k = 1:resolution
			filtre(k,i)=floor(4096*cos(2*pi*freq*k/freqEchantillonage));
	end
end

%% Génération des fichiers .h contenant les différents exponentielle

% Génération du fichier cos_39500
fileID = fopen([Nom_Fich1], 'w');
fprintf(fileID,'\n');
fprintf(fileID,'\n');
fprintf(fileID,'\n');
fprintf(fileID,'const sint32_t cos_39500[%d]= {\n',resolution); 
for  k = 1: resolution
	 fprintf(fileID,'%d,\n',filtre(k,1)); % coeff décalage des valeurs pour le code STM (define dans FIR_Filter.h)
end
fprintf(fileID,'};\n'); 
fclose(fileID);
 
% Génération du fichier cos_40000
fileID = fopen([Nom_Fich2], 'w');
fprintf(fileID,'\n');
fprintf(fileID,'\n');
fprintf(fileID,'\n');
fprintf(fileID,'const sint32_t cos_40000[%d]= {\n',resolution); 
for  k = 1: resolution
	 fprintf(fileID,'%d,\n',filtre(k,2)); % coeff décalage des valeurs pour le code STM (define dans FIR_Filter.h)
end
fprintf(fileID,'};\n'); 
fclose(fileID);
 
 % Génération du fichier cos_40500
fileID = fopen([Nom_Fich3], 'w');
fprintf(fileID,'\n');
fprintf(fileID,'\n');
fprintf(fileID,'\n');
fprintf(fileID,'const sint32_t cos_40500[%d]= {\n',resolution); 
for  k = 1: resolution
	 fprintf(fileID,'%d,\n',filtre(k,3)); % coeff décalage des valeurs pour le code STM (define dans FIR_Filter.h)
end
fprintf(fileID,'};\n'); 
fclose(fileID);
 
 % Génération du fichier cos_41000
fileID = fopen([Nom_Fich4], 'w');
fprintf(fileID,'\n');
fprintf(fileID,'\n');
fprintf(fileID,'\n');
fprintf(fileID,'const sint32_t cos_41000[%d]= {\n',resolution); 
for  k = 1: resolution
	 fprintf(fileID,'%d,\n',filtre(k,4)); % coeff décalage des valeurs pour le code STM (define dans FIR_Filter.h)
end
fprintf(fileID,'};\n'); 
fclose(fileID);
 
  
    
  