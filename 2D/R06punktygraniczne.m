% wyszukiwanie punktow granicznych na mapie
tic

% ----------
% struktura coord: y,x
% typy punktow: 2D: P22(granice): z1,z2
%                   P23(punkty potrojne): z1,z2,z3
%                   P24(punkty wielokrotne): (z1,z2,z3)x4
%               1D: P12(punkty graniczne na krawedziach): z1,z2
% ----------

% parametry zewnetrzne i zmienne globalne
wymiary=size(grainmap);
total2=wymiary(1)*wymiary(2); % liczba pix

% inicjalizacja tablic wynikowych

    % wskazniki tablic
    n22=0; % 2D wskaznik listy punktow 2 krotnych
    n23=0; % 2D wskaznik listy punktow 3 krotnych
    n24=0; % 2D wskaznik listy punktow 4 krotnych
    n12=0; % wskaznik listy punktow krawedziowych

    % inicjalizacja P22
    P22.coord=zeros(total2,2);
    P22.grainno=zeros(total2,2);

    % inicjalizacja P23
    P23.coord=zeros(total2,2);
    P23.grainno=zeros(total2,3);

    % inicjalizacja P24
    P24.coord=zeros(wymiary(1),2);
    P24.grainno=zeros(wymiary(1),4);

    % inicjalizacja P12
    P12.coord=zeros(wymiary(1),2);
    P12.grainno=zeros(wymiary(1),2);
    
% koniec inicjalizacji tablic wynikowych

% petla glowna 2D
for y=1:wymiary(1)-1
    for x=1:wymiary(2)-1
        l(1)=grainmap(y,x);
        l(2)=grainmap(y,x+1);
        l(3)=grainmap(y+1,x+1);
        l(4)=grainmap(y+1,x);
        lu=unique(l); % wyszukanie unikatowych ziaren
        krotnosc=length(lu);
        
        if krotnosc==2 % obsluga punktow 2 krotnych
            n22=n22+1;
            P22.coord(n22,1:2)=[y x];
            P22.grainno(n22,1:2)=lu;
        elseif krotnosc==3 % obsluga punktow 3 krotnych
            n23=n23+1;
            P23.coord(n23,1:2)=[y x];
            P23.grainno(n23,1:3)=lu;
        elseif krotnosc==4 % obsluga punktow 4 krotnych
            n24=n24+1;
            P24.coord(n24,1:2)=[y x];
            P24.grainno(n24,1:4)=sort([l(1) l(2) l(3) l(4)]);
        end
    end
end
clear y x l lu krotnosc;
% koniec petli glownej 2D

% petla glowna 1D
for x=1:wymiary(2)-1 % 0,x,0
    if grainmap(1,x+1)~=grainmap(1,x)
        n12=n12+1;
        P12.coord(n12,1:2)=[0 x];
        P12.grainno(n12,1)=grainmap(1,x);
        P12.grainno(n12,2)=grainmap(1,x+1);
    end
end
for x=1:wymiary(2)-1 % max,x,0
    if grainmap(wymiary(1),x+1)~=grainmap(wymiary(1),x)
        n12=n12+1;
        P12.coord(n12,1:2)=[wymiary(1) x];
        P12.grainno(n12,1)=grainmap(wymiary(1),x);
        P12.grainno(n12,2)=grainmap(wymiary(1),x+1);
    end
end
for y=1:wymiary(1)-1 % y,0,0
    if grainmap(y+1,1)~=grainmap(y,1)
        n12=n12+1;
        P12.coord(n12,1:2)=[y 0];
        P12.grainno(n12,1)=grainmap(y,1);
        P12.grainno(n12,2)=grainmap(y+1,1);
    end
end
for y=1:wymiary(1)-1 % y,max,0
    if grainmap(y+1,wymiary(2))~=grainmap(y,wymiary(2))
        n12=n12+1;
        P12.coord(n12,1:2)=[y wymiary(2)];
        P12.grainno(n12,1)=grainmap(y,wymiary(2));
        P12.grainno(n12,2)=grainmap(y+1,wymiary(2));
    end
end
clear x y;
% koniec petli glownej 1D

% porzadkowanie wynikow

    % usuwanie niepotrzebnych 0
    P22.coord(n22+1:total2,:)=[];
    P22.grainno(n22+1:total2,:)=[];
    P23.coord(n23+1:total2,:)=[];
    P23.grainno(n23+1:total2,:)=[];
    P24.coord(n24+1:wymiary(1),:)=[];
    P24.grainno(n24+1:wymiary(1),:)=[];
    P12.coord(n12+1:wymiary(1),:)=[];
    P12.grainno(n12+1:wymiary(1),:)=[];
    % koniec usuwania niepotrzebnych 0

    % sortowanie P12
    for i=1:length(P12.grainno) % sortowanie numerow ziaren
        if P12.grainno(i,1)>P12.grainno(i,2)
            j=P12.grainno(i,1);
            P12.grainno(i,1)=P12.grainno(i,2);
            P12.grainno(i,2)=j;
        end
    end
    clear i j;
    % koniec sortowania P12

%     % kasowanie powtorzen w P23
%     nD2=0;
%     for i=1:n23-1
%         for j=i+1:n23
%             if P23.grainno(i,1)~=0
%                 if P23.grainno(j,1)==P23.grainno(i,1)
%                     if P23.grainno(j,2)==P23.grainno(i,2)
%                         if P23.grainno(j,3)==P23.grainno(i,3)
%                             nD2=nD2+1;
%                             duble23.coord(nD2,1:2)=P23.coord(j,1:2);
%                             duble23.grainno(nD2,1:3)=P23.grainno(j,1:3);
%                             P23.coord(j,1:2)=[0 0];
%                             P23.grainno(j,1:3)=[0 0 0];
%                         end
%                     end
%                 end
%             end
%         end
%     end
%     clear i j;
%     for i=n23:-1:1
%         if P23.grainno(i,1)==0
%             P23.coord(i,:)=[];
%             P23.grainno(i,:)=[];
%         end
%     end
%     clear i;
%     
%         % tablica rodzicow dubli
%         duble23.parent=zeros(nD2,2);
%         for j=1:nD2
%             for i=1:n23
%                 if duble23.grainno(j,1)==P23.grainno(i,1)
%                     if duble23.grainno(j,2)==P23.grainno(i,2)
%                         if duble23.grainno(j,3)==P23.grainno(i,3)
%                             duble23.parent(j,1:2)=[23 i];
%                             break;
%                         end
%                     end
%                 end
%             end
%         end
%         clear nD2;
%         % koniec tablicy rodzicow dubli
%       
%     % koniec kasowania powtorzen w P23
    
% koniec porzadkowania wynikow

% konwersja danych do struktury
boundarypoints.P12.coord=P12.coord;
boundarypoints.P12.grainno=P12.grainno;
boundarypoints.P22.coord=P22.coord;
boundarypoints.P22.grainno=P22.grainno;
boundarypoints.P23.coord=P23.coord;
boundarypoints.P23.grainno=P23.grainno;
if n24>0
    boundarypoints.P24.coord=P24.coord;
    boundarypoints.P24.grainno=P24.grainno;
end
clear P12 P22 P23 P24;
clear n12 n22 n23 n24;
% koniec konwersji danych do struktury

% czyszczenie parametrow zewnetrznych i globalnych
clear wymiary total2;

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;