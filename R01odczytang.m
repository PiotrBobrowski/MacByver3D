% odczyt pliku .ang
tic

clear; clc;

% parametry zewnetrzne
% folder='G:\\Dane\\ZrO2\\3D EBSD\\';
% filename='map001.ang';
folder='E:\Sonata Dane\Al\2D Al80\\';
filename='Al80 2D.ang';
% folder='G:\\Dane\\Al\\2D Al80H\\';
% filename='Al80H 2D.ang';

% odczyt potrzebnych danych z pliku
address=[folder filename];
fileID=fopen(address,'rt');
O1=textscan(fileID,'%f %f %f %f %f %*[^\n]','CommentStyle','#');
f=fclose(fileID);
O=cell2mat(O1);
s=size(O); % s(1)-dlugosc pliku
xstep=O(2,4); % krok x [um]
ystep=xstep; % krok y [um]
xmax=O(s(1),4)/xstep+1; % rozmiar x macierzy EulerAngles
ymax=O(s(1),5)/ystep+1; % rozmiar y macierzy EulerAngles
EulerAngles=zeros(ymax,xmax,5); % inicjalizacja macierzy EulerAngles
clear fileID O1 f xmax ymax;
clear folder filename address;
% koniec odczytu potrzebnych danych z pliku

% struktura EulerAngles: y,x,(x[um],y[um],phi1,PHI,phi2)
% przepisanie pliku do EulerAngles
for j=1:s(1)
    x=int16(O(j,4)/xstep+1);   % wspolrzedne x piksela
    y=int16(O(j,5)/ystep+1);   % wspolrzedne y piksela
    EulerAngles(y,x,1)=O(j,4);   % x
    EulerAngles(y,x,2)=O(j,5);   % y
    EulerAngles(y,x,3)=O(j,1);   % phi1
    EulerAngles(y,x,4)=O(j,2);   % PHI
    EulerAngles(y,x,5)=O(j,3);   % phi2
end
clear j x y s O;
% koniec przepisywania pliku do EulerAngles

% zapis danych do struktury
ScanStep.xstep=xstep;
ScanStep.ystep=ystep;
clear xstep ystep;

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;