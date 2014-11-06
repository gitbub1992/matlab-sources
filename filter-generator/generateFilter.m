%%______________________________________________
% Conception d'un filtre FIR de la forme
%         _ N-1
%  s(k) = \        a(n).e(k-n)
%         /_ n=0
% Et g�n�ration du code C associ� � ce filtre

clc       % efface la console
clear all % efface les variables du workspace
close all % ferme toutes les fen�tres graphiques



%% MODIF s�lectionner le filtre � g�n�rer
freqSignalAFiltrerInit = 39500; % d�finissez ici la fr�quence en Hz du signal a filtrer
freqMaxSignal = 41000;
incrementFreq = 500; % incr�ment de fr�quence � chaque boucle (�cart entre les fr�quences �mises)
freqEchantillonage = 128000; % d�finissez ici la fr�quence en Hz d'�chantillonage

%% MODIF donner un nom au .c � g�n�rer
Nom_Fich1='cos_39500.c';
Nom_Fich2='cos_40000.c';
Nom_Fich3='cos_40500.c';
Nom_Fich4='cos_41000.c';

%% Votre propre design de filtre
%_______________________________________________________________

M=256;    % MODIF facteur de sur�chantillonnage (nombre de points pris sur la fen�tre : on �chantillonne a 128k sur 2ms -> calcul a faire)
Ns=1;   % MODIF facteur d'�talement
N = M*Ns;

for freq = freqSignalAFiltrerInit:incrementFreq:freqMaxSignal
    % h = 1; %MODIF r�ponse impulsionelle en N �chantillons
    for k = 1:N
        h(k)=sin(2*pi*freq*k/freqEchantillonage);
    end
%_________________________________________________________________________

    %% g�n�ration ddu fichier .c avec les coefficients
    %_________________________________________________________________________
    disp('G�n�re les coefficients suivants :');
    disp(h);
    if freq==39500
        Nom_Fich = Nom_Fich1;
    end;
    if freq==40000
        Nom_Fich = Nom_Fich2;
    end;
    if freq==40500
        Nom_Fich = Nom_Fich3;
    end;
    if freq==41000
        Nom_Fich = Nom_Fich4;
    end;

    disp(['Dans le fichier ' Nom_Fich]);

    fileID = fopen([Nom_Fich], 'w');
      fprintf(fileID,'#include "stm32f10x.h"\n');
     fprintf(fileID,'#include "FIR_Filter.h"\n');
     fprintf(fileID,'\n');
     fprintf(fileID,'\n');
     fprintf(fileID,'//_________________________________________________');
     fprintf(fileID,'\n');
     fprintf(fileID,'//      DESCRIPTION DU FILTRE FIR_0, 8.24 \n');
     fprintf(fileID,'//_________________________________________________');
     fprintf(fileID,'\n');
     fprintf(fileID,'\n');

     fprintf(fileID,'const u16 N_0 = %d; \n', N); 
     fprintf(fileID,'s16 TabE_0[%d]; \n', N); 
     fprintf(fileID,'s16 *Ptr_Tab_E_0; \n');  
     fprintf(fileID,'\n');
     fprintf(fileID,'const s32 h_0[%d]= {\n',N); 

     for  k = 1: N
         fprintf(fileID,'K_8_24*%d,\n',h(k)); % K_8_24 -> coeff d�calage des valeurs pour le code STM (define dans FIR_Filter.h)
     end
     fprintf(fileID,'};\n'); 

     fclose(fileID);
 
end;
  
    
  