clc       
clear all 
close all 

%% MODIF s�lectionner le filtre � g�n�rer
freqSignalAFiltrerInit = 39000; % d�finissez ici la fr�quence en Hz du signal a filtrer
freqMaxSignal = 41000;
incrementFreq = 500; % incr�ment de fr�quence � chaque boucle (�cart entre les fr�quences �mises)
freqEchantillonage = 128000; % (Hz)
tempsEchantillonage = 2e-3; %(S)
resolution = tempsEchantillonage*freqEchantillonage*4;

%% G�n�ration des quatres filtres RIF
filtrecos = zeros(resolution,5);
filtresin = zeros(resolution,5);
 
i =0;

for freq = freqSignalAFiltrerInit:incrementFreq:freqMaxSignal
	i = i +1;
	for k = 1:resolution
			filtrecos(k,i)=cos(2*pi*freq*k/freqEchantillonage);
            filtresin(k,i)=sin(2*pi*freq*k/freqEchantillonage);
	end
end

for freq=1:5
    id = 0;
    for i = 2:resolution
        if (filtrecos(1,freq) == filtrecos(i,freq))
            id = [i freq]
        end 
    end
end


figure
for i = 1:5
    f = filtrecos(1:256,i) - filtrecos(257:512,i);
    subplot(5,1,i)
    plot(f)
end

figure
for i = 1:5
    f = filtresin(1:256,i) - filtresin(257:512,i);
    subplot(5,1,i)
    plot(f)
end
