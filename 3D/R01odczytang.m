% odczyt stosu plikow .ang
tic

clear; clc;

% parametry zewnetrzne
folder='G:\\Sonata Dane\\ZrO2\\3D EBSD\\';
filename='map';
% folder='E:\\Sonata Dane\\Cu\\3D Cu80\\ang\\';
% filename='Cu80 ';
% koniec parametrow zewnetrznych

% odczyt potrzebnych danych z 1. pliku
address=[folder filename '001.ang'];
fileID=fopen(address,'rt');
O1=textscan(fileID,'%f %f %f %f %f %*[^\n]','CommentStyle','#');
f=fclose(fileID);
O=cell2mat(O1);
l=size(O); % l(1)-dlugosc pliku
xstep=O(2,4); % krok x [um]
ystep=xstep; % krok y [um]
xmax=O(l(1),4)/xstep+1; % rozmiar x macierzy EulerAngles
ymax=O(l(1),5)/ystep+1; % rozmiar y macierzy EulerAngles
EulerAngles=zeros(ymax,xmax,1,5,'single'); % inicjalizacja macierzy EulerAngles
clear fileID O1 f xmax ymax;
% koniec odczytu potrzebnych danych z 1. pliku

% struktura EulerAngles: y,x,z,(x[um],y[um],phi1,PHI,phi2)
% przepisanie 1. pliku do raw data
for j=1:l(1)
    x=int16(O(j,4)/xstep+1);   % wspolrzedne x piksela
    y=int16(O(j,5)/ystep+1);   % wspolrzedne y piksela
    EulerAngles(y,x,1,1)=O(j,4);   % x[um]
    EulerAngles(y,x,1,2)=O(j,5);   % y[um]
    EulerAngles(y,x,1,3)=O(j,1);   % phi1
    EulerAngles(y,x,1,4)=O(j,2);   % PHI
    EulerAngles(y,x,1,5)=O(j,3);   % phi2
end
clear j O x y;
% koniec przepisywania 1. pliku

% odczyt i przepisanie pozostalych plikow
address=[folder filename '%03d.ang'];
n=sprintf(address,2);
z=2;
while exist(n,'file')
    fileID=fopen(n,'rt');
    O1=textscan(fileID,'%f %f %f %f %f %*[^\n]','CommentStyle','#');
    f=fclose(fileID);
    O=cell2mat(O1);
    clear n fileID O1 f;
    for j=1:l(1)
        x=int16(O(j,4)/xstep+1);   % wspolrzedne x piksela
        y=int16(O(j,5)/ystep+1);   % wspolrzedne y piksela
        EulerAngles(y,x,z,1)=O(j,4);   % x[um]
        EulerAngles(y,x,z,2)=O(j,5);   % y[um]
        EulerAngles(y,x,z,3)=O(j,1);   % phi1
        EulerAngles(y,x,z,4)=O(j,2);   % PHI
        EulerAngles(y,x,z,5)=O(j,3);   % phi2
    end
    clear O j x y;
    z=z+1;
    n=sprintf([folder filename '%03d.ang'],z);
end
ScanStep.xstep=xstep;
ScanStep.ystep=ystep;
clear n l xstep ystep z folder filename address;
%koniec odczytu i przepisania pozostalych plikow

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;