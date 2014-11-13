function bucherAlgorithm
% Explanation of some algorithms :
% https://www.wpi.edu/Images/CMS/PPL/tdoa-frls-030923.pdf

%% Initializations
clear all
close all
clc

% Speed of an ultrasonic wave in the air
SoundSpeed = 340; % m/s

% X, Y and Z coordinates of the four beacons in the room in meters
BX = [0 0 6 6];
BY = [0 3 3 0];
BZ = [3 3 3 3];

%% Generation of a valid sample
TheoricalX = 1.5; % m
TheoricalY = 4.1; % m
TheoricalZ = 1.9; % m

% Sample of a TDOA in µs
Sample = zeros(1,4);
DistanceToBeacon = zeros(1,4);
for id = 1 : 4
    DistanceToBeacon(id) = sqrt( (BX(id)-TheoricalX)^2 + (BY(id)-TheoricalY)^2 + (BZ(id)-TheoricalZ)^2 );
end
Sample = DistanceToBeacon / SoundSpeed * 1e6; % µs
Sample = Sample - min(Sample);
clear DistanceToBeacon

%% Functions to derive differences with an easy-to-read aspect
    function diff = TDOA(id1, id2)
        diff = Sample(id1) - Sample(id2);
    end

    function diff = diffX(id1, id2)
        diff = BX(id1) - BX(id2);
    end

    function diff = diffY(id1, id2)
        diff = BY(id1) - BY(id2);
    end

    function diff = diffZ(id1, id2)
        diff = BZ(id1) - BZ(id2);
    end

%% Bucher algorithm from
% http://srbuenaf.webs.ull.es/potencia/hyperbolic%20location/project.html

% Id for each beacon
i = 1; j = 2; k = 3; l = 4;

% Conversion to distance
Sample = Sample * 1e-6 * SoundSpeed; % m

% y = Ax + Bz + C
num = (TDOA(i,k)*diffX(j,i) - TDOA(i,j)*diffX(k,i));
den = (TDOA(i,j)*diffY(k,i) - TDOA(i,k)*diffY(j,i));
A = num / den;
clear num den

num = (TDOA(i,k)*diffZ(j,i) - TDOA(i,j)*diffZ(k,i));
den = (TDOA(i,j)*diffZ(k,i) - TDOA(i,k)*diffY(j,i));
B = num / den;
clear num den

num =       TDOA(i,k) * (TDOA(i,j)^2 + BX(i)^2-BX(j)^2 + BY(i)^2-BY(j)^2 + BZ(i)^2-BZ(j)^2);
num = num - TDOA(i,j) * (TDOA(i,k)^2 + BX(i)^2-BX(k)^2 + BY(i)^2-BY(k)^2 + BZ(i)^2-BZ(k)^2);
den = 2 * (TDOA(i,j)*diffY(k,i) - TDOA(i,k)*diffY(j,i));
C = num / den;
clear num den

% y = DX + EY + F
num = (TDOA(k,l)*diffX(j,k) - TDOA(k,j)*diffX(l,k));
den = (TDOA(k,j)*diffY(l,k) - TDOA(k,l)*diffY(j,k));
D = num / den;
clear num den

num = (TDOA(k,l)*diffZ(j,k) - TDOA(k,j)*diffZ(l,i));
den = (TDOA(k,j)*diffY(l,k) - TDOA(k,l)*diffY(j,k));
E = num / den;
clear num den

num =       TDOA(k,l) * (TDOA(k,j)^2 + BX(k)^2-BX(j)^2 + BY(k)^2-BY(j)^2 + BZ(k)^2-BZ(j)^2);
num = num - TDOA(k,j) * (TDOA(k,l)^2 + BX(k)^2-BX(l)^2 + BY(k)^2-BY(l)^2 + BZ(k)^2-BZ(l)^2);
den = 2 * (TDOA(k,j)*diffY(l,k) - TDOA(k,l)*diffY(j,k));
F = num / den;
clear num den

% x = Gz + H
G = (E - B) / (A - D);
H = (F - C) / (A - D);

% y = Iz + J
I = A*G + B;
J = A*H + C;

% ... = LZ + K
K = TDOA(i,k)^2 + BX(i)^2-BX(k)^2 + BY(i)^2-BY(k)^2 + BZ(i)^2-BZ(k)^2 + 2*diffX(k,i)*H + 2*diffY(k,i)*J;
L = 2 * (diffX(k,i)*G + diffY(k,i)*I + 2*diffZ(k,i));

% Mz² - Mz + O = 0
M = (4 * TDOA(i,k)^2 * (G^2 + I^2 + 1)) - L^2;
N = (8 * TDOA(i,k)^2 * (G*(BX(i)-H) + I*(BY(i)-J) + BZ(i))) + 2* L * K;
O = (4 * TDOA(i,k)^2 * ((BX(i)-H)^2 + (BY(i)-J)^2 + BZ(i)^2)) - K^2;

% Solution for Z
Ns2M = N / (2*M);
z1 = Ns2M + sqrt(Ns2M^2 - O/M);
z2 = Ns2M - sqrt(Ns2M^2 - O/M);
if ((z1 < 3.0001) && (z1 > -0.0001))
    z = z1;
else
    z = z2;
end
%  z = [abs(z1);abs(z2)];
clear z1 z2

% Solution for X
x = G*z + H;

% Solution for Y
y = I*z + J;

% Final position
Position = [x y z]

%% Plot of the position
figure
hold all
plot3(BX, BY, BZ, '*r')
plot3(Position(1), Position(2), Position(3), 'o')
plot3(TheoricalX, TheoricalY, TheoricalZ, 'xg')
xlim([min(BX) max(BX)])
ylim([min(BY) max(BY)])
zlim([0       max(BZ)])
xlabel('X (m)')
ylabel('Y (m)')
zlabel('Z (m)')
title('Position  du drone dans l espace')
grid on
rotate3d on

end