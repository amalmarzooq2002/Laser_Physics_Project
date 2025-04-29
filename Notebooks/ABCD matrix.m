% Constants:
R1 = 10000; % radius of curvature of the first mirror
R2 = 24; % radius of curvature of the second mirror
nb = 1.5; % Brewster mirror index of refraction
na = 1.03; % Active medium index of refraction
t = 0.0001; % Thickness of Brewster mirror
nc = 1; % Index of refraction of the cavity
La = 12.7; % Path length in the active medium
Lc = 0.5; % Path length in the cavity

% The ABCD matrices:
Mr1 = [1, 0; -2/R1, 1]; % Mirror 1 
Mr2 = [1, 0; -2/R2, 1]; % Mirror 2
MB = [1, t/nb*cos(atan(nb/nc)); 0, 1]; % Brewster mirror
Ma = [1, La/na; 0, 1]; % Active medium path
Mc = [1, Lc/nc; 0, 1]; % Cavity path

% Full ABCD matrix of a round trip:
Mf = Mr1*Mc*Ma*MB*Mc*Mr2*Mc*MB*Ma*Mc;

% Is the cavity stable (|(A+D)/2| < 1)?
A = Mf(1,1);
D = Mf(2,2);

if abs((A+D)/2) < 1
    disp("The cavity is stable!")
else
    disp("The cavity is NOT stable!")
end