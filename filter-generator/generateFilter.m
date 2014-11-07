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
Nom_Fich1='exp_39500.h';
Nom_Fich2='exp_40000.h';
Nom_Fich3='exp_40500.h';
Nom_Fich4='exp_41000.h';

%% Génération des quatres filtres RIF
filtrecos = zeros(256,4);
filtresin = zeros(256,4);
 
i =0;

for freq = freqSignalAFiltrerInit:incrementFreq:freqMaxSignal
	i = i +1;
	for k = 1:resolution
			filtrecos(k,i)=floor(4096*cos(2*pi*freq*k/freqEchantillonage));
            filtresin(k,i)=floor(4096*sin(2*pi*freq*k/freqEchantillonage));
	end
end


%% Génération des fichiers .h contenant les différents exponentielle

% Génération du fichier cos_39500
fileID = fopen([Nom_Fich1], 'w');
fprintf(fileID,'\n');
fprintf(fileID,'// Exponential filter for the frequency 39,5 kHz\n');
fprintf(fileID,'\n');
fprintf(fileID,'#include "global.h"\n');
fprintf(fileID,'\n');
fprintf(fileID,'const int32_t cos_39500[%d]= {\n',resolution); 
for  k = 1: resolution
	 fprintf(fileID,'%d,\n',filtrecos(k,1)); % coeff décalage des valeurs pour le code STM (define dans FIR_Filter.h)
end
fprintf(fileID,'};\n'); 
fprintf(fileID,'const int32_t sin_39500[%d]= {\n',resolution); 
for  k = 1: resolution
	 fprintf(fileID,'%d,\n',filtresin(k,1)); % coeff décalage des valeurs pour le code STM (define dans FIR_Filter.h)
end
fprintf(fileID,'};\n'); 
fclose(fileID);
 
% Génération du fichier exp_40000
fileID = fopen([Nom_Fich2], 'w');
fprintf(fileID,'\n');
fprintf(fileID,'// Exponential filter for the frequency 40,0 kHz\n');
fprintf(fileID,'\n');
fprintf(fileID,'#include "global.h"\n');
fprintf(fileID,'\n');
fprintf(fileID,'const int32_t cos_40000[%d]= {\n',resolution); 
for  k = 1: resolution
	 fprintf(fileID,'%d,\n',filtrecos(k,2)); % coeff décalage des valeurs pour le code STM (define dans FIR_Filter.h)
end
fprintf(fileID,'};\n'); 
fprintf(fileID,'const int32_t sin_40000[%d]= {\n',resolution); 
for  k = 1: resolution
	 fprintf(fileID,'%d,\n',filtresin(k,2)); % coeff décalage des valeurs pour le code STM (define dans FIR_Filter.h)
end
fprintf(fileID,'};\n'); 
fclose(fileID);


% Génération du fichier exp_40500
fileID = fopen([Nom_Fich3], 'w');
fprintf(fileID,'\n');
fprintf(fileID,'// Exponential filter for the frequency 40,5 kHz\n');
fprintf(fileID,'\n');
fprintf(fileID,'#include "global.h"\n');
fprintf(fileID,'\n');
fprintf(fileID,'const int32_t cos_40500[%d]= {\n',resolution); 
for  k = 1: resolution
	 fprintf(fileID,'%d,\n',filtrecos(k,3)); % coeff décalage des valeurs pour le code STM (define dans FIR_Filter.h)
end
fprintf(fileID,'};\n'); 
fprintf(fileID,'const int32_t sin_40500[%d]= {\n',resolution); 
for  k = 1: resolution
	 fprintf(fileID,'%d,\n',filtresin(k,3)); % coeff décalage des valeurs pour le code STM (define dans FIR_Filter.h)
end
fprintf(fileID,'};\n'); 
fclose(fileID);


% Génération du fichier cos_41000
fileID = fopen([Nom_Fich4], 'w');
fprintf(fileID,'\n');
fprintf(fileID,'// Exponential filter for the frequency 39,5 kHz\n');
fprintf(fileID,'\n');
fprintf(fileID,'#include "global.h"\n');
fprintf(fileID,'\n');
fprintf(fileID,'const int32_t cos_41000[%d]= {\n',resolution); 
for  k = 1: resolution
	 fprintf(fileID,'%d,\n',filtrecos(k,4)); % coeff décalage des valeurs pour le code STM (define dans FIR_Filter.h)
end
fprintf(fileID,'};\n'); 
fprintf(fileID,'const int32_t_41000[%d]= {\n',resolution); 
for  k = 1: resolution
	 fprintf(fileID,'%d,\n',filtresin(k,4)); % coeff décalage des valeurs pour le code STM (define dans FIR_Filter.h)
end
fprintf(fileID,'};\n'); 
fclose(fileID);
 
  
    
  