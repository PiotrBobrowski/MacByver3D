% wyszukiwanie wszystkich typow punktow granicznych

% ----------
% bez przetwarzania P38, bez przetwarzania ani sortowania P24
% dodanie P10 na narozach, bez kasowania dubli
% ----------
tic

% ----------
% struktura coord: y,x,z
% typy punktow: 3D: P32(powierzchnia granic),
%                   P33(krawedzie granic),
%                   P34(narozniki ziaren),
%                   P38(punkty wielokrotne)
%               2D: P22(powierzchnia granic),
%                   P23(krawedzie granic)
%                   P24(punkty wielokrotne)
%               1D: P12(punkty graniczne na krawedziach)
%               0D: P10(naroza ROI)
% ----------

% parametry zewnetrzne i zmienne globalne
wymiary=size(grainmap);
total3=wymiary(1)*wymiary(2)*wymiary(3); % liczba vox
total2=wymiary(1)*wymiary(2); % liczba pix

% czyszczenie starych danych
if exist('boundarypoints','var')
    clear boundarypoints;
end
% koniec czyszczenia starych danych

% inicjalizacja tablic wynikowych
    disp('inicjalizacja');

    % wskazniki tablic
    n32=0; % 3D wskaznik listy punktow 2 krotnych
    n33=0; % 3D wskaznik listy punktow 3 krotnych
    n34=0; % 3D wskaznik listy punktow 4 krotnych
    n38=0; % 3D wskaznik listy punktow 8 krotnych
    n22=0; % 2D wskaznik listy punktow 2 krotnych
    n23=0; % 2D wskaznik listy punktow 3 krotnych
    n24=0; % 2D wskaznik listy punktow 4 krotnych
    n12=0; % wskaznik listy punktow krawedziowych

    % inicjalizacja P32
    P32.coord=zeros(total3,3,'uint32');
    P32.grainno=zeros(total3,2,'uint32');

    % inicjalizacja P33
    P33.coord=zeros(total3,3,'uint32');
    P33.grainno=zeros(total3,3,'uint32');

    % inicjalizacja P34
    P34.coord=zeros(total3,3,'uint32'); 
    P34.grainno=zeros(total3,4,'uint32');

    % P38 nie wymaga inicjalizacji bo jest go malo
    
    % inicjalizacja P22
    P22.coord=zeros(total2,3,'uint32');
    P22.grainno=zeros(total2,2,'uint32');

    % inicjalizacja P23
    P23.coord=zeros(total2,3,'uint32');
    P23.grainno=zeros(total2,3,'uint32');

    % inicjalizacja P24
    P24.coord=zeros(wymiary(1),3,'uint32');
    P24.grainno=zeros(wymiary(1),3,'uint32');

    % inicjalizacja P12
    P12.coord=zeros(wymiary(1),3,'uint32');
    P12.grainno=zeros(wymiary(1),2,'uint32');
% koniec inicjalizacji tablic wynikowych

% tablica zawierajaca voxele graniczne
disp('tworzenie listy voxeli do sprawdzenia');
BoundaryVoxels=zeros(wymiary,'uint32');
for y=1:wymiary(1)-1
    for x=1:wymiary(2)
        for z=1:wymiary(3)
            if grainmap(y,x,z)~=grainmap(y+1,x,z)
                BoundaryVoxels(y,x,z)=grainmap(y,x,z);
                BoundaryVoxels(y+1,x,z)=grainmap(y+1,x,z);
            end
        end
    end
end
for y=1:wymiary(1)
    for x=1:wymiary(2)-1
        for z=1:wymiary(3)
            if grainmap(y,x,z)~=grainmap(y,x+1,z)
                BoundaryVoxels(y,x,z)=grainmap(y,x,z);
                BoundaryVoxels(y,x+1,z)=grainmap(y,x+1,z);
            end
        end
    end
end
for y=1:wymiary(1)
    for x=1:wymiary(2)
        for z=1:wymiary(3)-1
            if grainmap(y,x,z)~=grainmap(y,x,z+1)
                BoundaryVoxels(y,x,z)=grainmap(y,x,z);
                BoundaryVoxels(y,x,z+1)=grainmap(y,x,z+1);
            end
        end
    end
end
[Vy,Vx,Vz]=ind2sub(wymiary,find(BoundaryVoxels));
clear y x z BoundaryVoxels;
% koniec tablicy zawierajacej voxele graniczne

% petla glowna 3D
disp('szukanie P4 w 3D');
lVy=length(Vy);
LoopCount=0;
for i=1:lVy
    y=Vy(i);
    x=Vx(i);
    z=Vz(i);

    if y<wymiary(1)
        if x<wymiary(2)
            if z<wymiary(3)
                l=[0 0 0 0 0 0 0 0];

                l(1)=grainmap(y,x,z);
                l(2)=grainmap(y,x+1,z);
                l(3)=grainmap(y+1,x+1,z);
                l(4)=grainmap(y+1,x,z);
                l(5)=grainmap(y,x,z+1);
                l(6)=grainmap(y,x+1,z+1);
                l(7)=grainmap(y+1,x+1,z+1);
                l(8)=grainmap(y+1,x,z+1);

                lu=unique(l); % unikatowe numery ziaren
                krotnosc=length(lu); % liczba ziaren

                if krotnosc==2 % obsluga punktow 2 krotnych
                    n32=n32+1;
                    P32.coord(n32,1:3)=[y x z];
                    P32.grainno(n32,1:2)=lu;
                elseif krotnosc==3 % obsluga punktow 3 krotnych
                    n33=n33+1;
                    P33.coord(n33,1:3)=[y x z];
                    P33.grainno(n33,1:3)=lu;
                elseif krotnosc==4 % obsluga punktow 4 krotnych
                    n34=n34+1;
                    P34.coord(n34,1:3)=[y x z];
                    P34.grainno(n34,1:4)=lu;
                elseif krotnosc>=5 % obsluga punktow 8 krotnych
                    n38=n38+1;
                    P38.coord(n38,1:3)=[y x z];
                    P38.grainno(n38,1:krotnosc)=lu(1:krotnosc);    
                end
            end
        end
    end
    
    % monitorowanie dzialania
    LoopCount=LoopCount+1;
    if LoopCount==10000
        clc
        fprintf('postep: %6d/%6d\n',i,lVy); % wskaznik postepu
        LoopCount=0;
    end
    % koniec monitorowania dzialania

end
clear z y x l lu krotnosc LoopCount;
clear Vx Vy Vz lVy;
% koniec petli glownej 3D

% petla glowna 2D
l=[0 0 0 0]; % inicjalizacja

    % z=0
    disp('sprawdzanie z=0');
    for y=1:wymiary(1)-1
        for x=1:wymiary(2)-1
            l(1)=grainmap(y,x,1);
            l(2)=grainmap(y,x+1,1);
            l(3)=grainmap(y+1,x+1,1);
            l(4)=grainmap(y+1,x,1);
            lu=unique(l); % unikatowe numery ziaren
            krotnosc=length(lu); % liczba ziaren

            if krotnosc==2 % obsluga punktow 2 krotnych
                n22=n22+1;
                P22.coord(n22,1:3)=[y x 0];
                P22.grainno(n22,1:2)=lu;
            elseif krotnosc==3 % obsluga punktow 3 krotnych
                n23=n23+1;
                P23.coord(n23,1:3)=[y x 0];
                P23.grainno(n23,1:3)=lu;
            elseif krotnosc==4 % obsluga punktow 4 krotnych
                n24=n24+1;
                P24.coord(n24,1:3)=[y x 0];
                P24.grainno(n24,1:4)=l(1:4);
            end
        end
    end
    % koniec z=0

    % z=max
    disp('sprawdzanie z=max');
    for y=1:wymiary(1)-1
        for x=1:wymiary(2)-1
            l(1)=grainmap(y,x,wymiary(3));
            l(2)=grainmap(y,x+1,wymiary(3));
            l(3)=grainmap(y+1,x+1,wymiary(3));
            l(4)=grainmap(y+1,x,wymiary(3));
            lu=unique(l); % unikatowe numery ziaren
            krotnosc=length(lu); % liczba ziaren

            if krotnosc==2 % obsluga punktow 2 krotnych
                n22=n22+1;
                P22.coord(n22,1:3)=[y x wymiary(3)];
                P22.grainno(n22,1:2)=lu;
            elseif krotnosc==3 % obsluga punktow 3 krotnych
                n23=n23+1;
                P23.coord(n23,1:3)=[y x wymiary(3)];
                P23.grainno(n23,1:3)=lu;
            elseif krotnosc==4 % obsluga punktow 4 krotnych
                n24=n24+1;
                P24.coord(n24,1:3)=[y x wymiary(3)];
                P24.grainno(n24,1:4)=l(1:4);
            end
        end
    end
    % koniec z=max
    
    % y=0
    disp('sprawdzanie y=0');
    for z=1:wymiary(3)-1
        for x=1:wymiary(2)-1
            l(1)=grainmap(1,x,z);
            l(2)=grainmap(1,x+1,z);
            l(3)=grainmap(1,x+1,z+1);
            l(4)=grainmap(1,x,z+1);
            lu=unique(l);
            krotnosc=length(lu);

            if krotnosc==2 % obsluga punktow 2 krotnych
                n22=n22+1;
                P22.coord(n22,1:3)=[0 x z];
                P22.grainno(n22,1:2)=lu;
            elseif krotnosc==3 % obsluga punktow 3 krotnych
                n23=n23+1;
                P23.coord(n23,1:3)=[0 x z];
                P23.grainno(n23,1:3)=lu;
            elseif krotnosc==4 % obsluga punktow 4 krotnych
                n24=n24+1;
                P24.coord(n24,1:3)=[0 x z];
                P24.grainno(n24,1:4)=l(1:4);
            end
        end
    end
    % koniec y=0
    
    % y=max
    disp('sprawdzanie y=max');
    for z=1:wymiary(3)-1
        for x=1:wymiary(2)-1
            l(1)=grainmap(wymiary(1),x,z);
            l(2)=grainmap(wymiary(1),x+1,z);
            l(3)=grainmap(wymiary(1),x+1,z+1);
            l(4)=grainmap(wymiary(1),x,z+1);
            lu=unique(l);
            krotnosc=length(lu);

            if krotnosc==2 % obsluga punktow 2 krotnych
                n22=n22+1;
                P22.coord(n22,1:3)=[wymiary(1) x z];
                P22.grainno(n22,1:2)=lu;
            elseif krotnosc==3 % obsluga punktow 3 krotnych
                n23=n23+1;
                P23.coord(n23,1:3)=[wymiary(1) x z];
                P23.grainno(n23,1:3)=lu;
            elseif krotnosc==4 % obsluga punktow 4 krotnych
                n24=n24+1;
                P24.coord(n24,1:3)=[wymiary(1) x z];
                P24.grainno(n24,1:4)=l(1:4);
            end
        end
    end
    % koniec y=max
    
    % dla x=0
    disp('sprawdzanie x=0');
    for z=1:wymiary(3)-1
        for y=1:wymiary(1)-1
            l(1)=grainmap(y,1,z);
            l(2)=grainmap(y+1,1,z);
            l(3)=grainmap(y+1,1,z+1);
            l(4)=grainmap(y,1,z+1);
            lu=unique(l);
            krotnosc=length(lu);

            if krotnosc==2 % obsluga punktow 2 krotnych
                n22=n22+1;
                P22.coord(n22,1:3)=[y 0 z];
                P22.grainno(n22,1:2)=lu;
            elseif krotnosc==3 % obsluga punktow 3 krotnych
                n23=n23+1;
                P23.coord(n23,1:3)=[y 0 z];
                P23.grainno(n23,1:3)=lu;
            elseif krotnosc==4 % obsluga punktow 4 krotnych
                n24=n24+1;
                P24.coord(n24,1:3)=[y 0 z];
                P24.grainno(n24,1:4)=l(1:4);
            end
        end
    end
    % koniec x=0

    % x=max
    disp('sprawdzanie x=max');
    for z=1:wymiary(3)-1
        for y=1:wymiary(1)-1
            l(1)=grainmap(y,wymiary(2),z);
            l(2)=grainmap(y+1,wymiary(2),z);
            l(3)=grainmap(y+1,wymiary(2),z+1);
            l(4)=grainmap(y,wymiary(2),z+1);
            lu=unique(l);
            krotnosc=length(lu);

            if krotnosc==2 % obsluga punktow 2 krotnych
                n22=n22+1;
                P22.coord(n22,1:3)=[y wymiary(2) z];
                P22.grainno(n22,1:2)=lu;
            elseif krotnosc==3 % obsluga punktow 3 krotnych
                n23=n23+1;
                P23.coord(n23,1:3)=[y wymiary(2) z];
                P23.grainno(n23,1:3)=lu;
            elseif krotnosc==4 % obsluga punktow 4 krotnych
                n24=n24+1;
                P24.coord(n24,1:3)=[y wymiary(2) z];
                P24.grainno(n24,1:4)=l(1:4);
            end
        end
    end
    % koniec x=max

clear y x z l lu krotnosc;
% koniec petli glownej 2D

% petla glowna 1D
disp('sprawdzanie krawedzi');
    % wzdloz x
    for x=1:wymiary(2)-1 
        % 0,x,0
        if grainmap(1,x+1,1)~=grainmap(1,x,1) 
            n12=n12+1;
            P12.coord(n12,1:3)=[0 x 0];
            P12.grainno(n12,1)=grainmap(1,x,1);
            P12.grainno(n12,2)=grainmap(1,x+1,1);
        end
        
        % max,x,0
        if grainmap(wymiary(1),x+1,1)~=grainmap(wymiary(1),x,1) 
            n12=n12+1;
            P12.coord(n12,1:3)=[wymiary(1) x 0];
            P12.grainno(n12,1)=grainmap(wymiary(1),x,1);
            P12.grainno(n12,2)=grainmap(wymiary(1),x+1,1);
        end
        
        % 0,x,max
        if grainmap(1,x+1,wymiary(3))~=grainmap(1,x,wymiary(3))
            n12=n12+1;
            P12.coord(n12,1:3)=[0 x wymiary(3)];
            P12.grainno(n12,1)=grainmap(1,x,wymiary(3));
            P12.grainno(n12,2)=grainmap(1,x+1,wymiary(3));
        end
        
        % max,x,max
        if grainmap(wymiary(1),x+1,wymiary(3))~=grainmap(wymiary(1),x,wymiary(3))
            n12=n12+1;
            P12.coord(n12,1:3)=[wymiary(1) x wymiary(3)];
            P12.grainno(n12,1)=grainmap(wymiary(1),x,wymiary(3));
            P12.grainno(n12,2)=grainmap(wymiary(1),x+1,wymiary(3));
        end
    end
    clear x;
    % koniec wzdloz x

    % wzdloz y
    for y=1:wymiary(1)-1
        % y,0,0
        if grainmap(y+1,1,1)~=grainmap(y,1,1)
            n12=n12+1;
            P12.coord(n12,1:3)=[y 0 0];
            P12.grainno(n12,1)=grainmap(y,1,1);
            P12.grainno(n12,2)=grainmap(y+1,1,1);
        end

        % y,max,0
        if grainmap(y+1,wymiary(2),1)~=grainmap(y,wymiary(2),1)
            n12=n12+1;
            P12.coord(n12,1:3)=[y wymiary(2) 0];
            P12.grainno(n12,1)=grainmap(y,wymiary(2),1);
            P12.grainno(n12,2)=grainmap(y+1,wymiary(2),1);
        end

        % y,0,max
        if grainmap(y+1,1,wymiary(3))~=grainmap(y,1,wymiary(3))
            n12=n12+1;
            P12.coord(n12,1:3)=[y 0 wymiary(3)];
            P12.grainno(n12,1)=grainmap(y,1,wymiary(3));
            P12.grainno(n12,2)=grainmap(y+1,1,wymiary(3));
        end

        % y,max,max
        if grainmap(y+1,wymiary(2),wymiary(3))~=grainmap(y,wymiary(2),wymiary(3))
            n12=n12+1;
            P12.coord(n12,1:3)=[y wymiary(2) wymiary(3)];
            P12.grainno(n12,1)=grainmap(y,wymiary(2),wymiary(3));
            P12.grainno(n12,2)=grainmap(y+1,wymiary(2),wymiary(3));
        end
    end
    clear y;
    % koniec wzdloz y

    % wzdloz z
    for z=1:wymiary(3)-1
        % 0,0,z
        if grainmap(1,1,z+1)~=grainmap(1,1,z)
            n12=n12+1;
            P12.coord(n12,1:3)=[0 0 z];
            P12.grainno(n12,1)=grainmap(1,1,z);
            P12.grainno(n12,2)=grainmap(1,1,z+1);
        end

        % max,0,z
        if grainmap(wymiary(1),1,z+1)~=grainmap(wymiary(1),1,z)
            n12=n12+1;
            P12.coord(n12,1:3)=[wymiary(1) 0 z];
            P12.grainno(n12,1)=grainmap(wymiary(1),1,z);
            P12.grainno(n12,2)=grainmap(wymiary(1),1,z+1);
        end

        % 0,max,z
        if grainmap(1,wymiary(2),z+1)~=grainmap(1,wymiary(2),z)
            n12=n12+1;
            P12.coord(n12,1:3)=[0 wymiary(2) z];
            P12.grainno(n12,1)=grainmap(1,wymiary(2),z);
            P12.grainno(n12,2)=grainmap(1,wymiary(2),z+1);
        end

        % max,max,z
        if grainmap(wymiary(1),wymiary(2),z+1)~=grainmap(wymiary(1),wymiary(2),z)
            n12=n12+1;
            P12.coord(n12,1:3)=[wymiary(1) wymiary(2) z];
            P12.grainno(n12,1)=grainmap(wymiary(1),wymiary(2),z);
            P12.grainno(n12,2)=grainmap(wymiary(1),wymiary(2),z+1);
        end
    end
    clear z;
    % koniec wzdloz z
% koniec petli glownej 1D

% petla glowna 0D
P10c1=[0 0 0; 0 wymiary(2) 0; wymiary(1) wymiary(2) 0; wymiary(1) 0 0; 0 0 wymiary(3)];
P10c2=[0 wymiary(2) wymiary(3); wymiary(1) wymiary(2) wymiary(3); wymiary(1) 0 wymiary(3)];
P10g1=[grainmap(1,1,1); grainmap(1,wymiary(2),1); grainmap(wymiary(1),wymiary(2),1)];
P10g2=[grainmap(wymiary(1),1,1); grainmap(1,1,wymiary(3)); grainmap(1,wymiary(2),wymiary(3))];
P10g3=[grainmap(wymiary(1),wymiary(2),wymiary(3)); grainmap(wymiary(1),1,wymiary(3))];
boundarypoints.P10.coord=[P10c1;P10c2];
boundarypoints.P10.grainno=[P10g1;P10g2;P10g3];
clear P10c1 P10c2 P10g1 P10g2 P10g3;
% koniec petli glownej 0D

% porzadkowanie danych
disp('porzadkowanie zbioru punktow');

    % usuwanie niepotrzebnych 0
    P32.coord(n32+1:total3,:)=[];
    P32.grainno(n32+1:total3,:)=[];
    P33.coord(n33+1:total3,:)=[];
    P33.grainno(n33+1:total3,:)=[];
    P34.coord(n34+1:total3,:)=[];
    P34.grainno(n34+1:total3,:)=[];
    if n22<total2
        P22.coord(n22+1:total2,:)=[];
        P22.grainno(n22+1:total2,:)=[];
    end
    if n23<total2
        P23.coord(n23+1:total2,:)=[];
        P23.grainno(n23+1:total2,:)=[];
    end
    if n24<wymiary(1)
        P24.coord(n24+1:wymiary(1),:)=[];
        P24.grainno(n24+1:wymiary(1),:)=[];
    end
    if n12<wymiary(1)
        P12.coord(n12+1:wymiary(1),:)=[];
        P12.grainno(n12+1:wymiary(1),:)=[];
    end
    % koniec usuwania nipotrzebnych 0
    
    % sortowanie P12
    for i=1:length(P12.coord) % sortowanie numerow ziaren
        if P12.grainno(i,1)>P12.grainno(i,2)
            j=P12.grainno(i,1);
            P12.grainno(i,1)=P12.grainno(i,2);
            P12.grainno(i,2)=j;
        end
    end
    clear i j;
    % koniec sortowania P12
% koniec porzadkowania danych

% konwersja danych do struktury
boundarypoints.P12.coord=P12.coord;
boundarypoints.P12.grainno=P12.grainno;
boundarypoints.P22.coord=P22.coord;
boundarypoints.P22.grainno=P22.grainno;
boundarypoints.P23.coord=P23.coord;
boundarypoints.P23.grainno=P23.grainno;
boundarypoints.P32.coord=P32.coord;
boundarypoints.P32.grainno=P32.grainno;
boundarypoints.P33.coord=P33.coord;
boundarypoints.P33.grainno=P33.grainno;
boundarypoints.P34.coord=P34.coord;
boundarypoints.P34.grainno=P34.grainno;
if n24>0
    boundarypoints.P24.coord=P24.coord;
    boundarypoints.P24.grainno=P24.grainno;
end
if n38>0
    boundarypoints.P38.coord=P38.coord;
    boundarypoints.P38.grainno=P38.grainno;
end
clear P12 P32 P33 P34 P38 P22 P23 P24;
clear n12 n32 n33 n34 n38 n22 n23 n24;
% koniec konwersji danych do struktury

% czyszczenie parametrow zewnetrznych i globalnych
clear wymiary total3 total2;

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;