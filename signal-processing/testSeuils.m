clear all
close all

load('fenetreGlissante.mat')
sampleToFilter = fenetreGlissante(1001:10000,:);
nbSamples = 10000-1001+1;

result = sampleToFilter;

% Plot
figure
hold all
plot(result(50:end,1),'bx-')
plot(result(50:end,2),'gx-')
plot(result(50:end,3),'rx-')
plot(result(50:end,4),'cx-')

% Passe-bas
samples = result;
for i = 1:4
    for j = 8:nbSamples
        result(j,i) = (samples(j,i) + samples(j-1,i) + samples(j-2,i) + samples(j-3,i) + samples(j-4,i) + samples(j-5,i) + samples(j-6,i) + samples(j-7,i))/8;
    end
end

% Dérivée
samples = result;
for i = 2:nbSamples
    result(i,:) = samples(i,:) - samples(i-1,:);
end

% Sélection front descendant
samples = result;
for i = 1:4
    for j = 1:nbSamples
        if (samples(j,i) > 0)
            result(j,i) = 0;
        else
            result(j,i) = samples(j,i);
        end
    end
end
result = abs(result);

% Normalisation
samples = result;
for i = 1:4
    minN = min(samples(50:end,i));
    result(:,i) = samples(:,i) - minN;
    maxN = max(result(50:end,i));
    result(:,i) = result(:,i) / maxN * 100;
end

% Plot
figure
hold all
plot(result(50:end,1),'bx-')
plot(result(50:end,2),'gx-')
plot(result(50:end,3),'rx-')
plot(result(50:end,4),'cx-')