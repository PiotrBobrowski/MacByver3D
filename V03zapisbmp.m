% zapis wynikow w postaci mapy .bmp

% zmienne globalne i parametry zewnetrzne
if exist('grainmap','var')
    wymiary=size(grainmap);
else
    wymiary=size(EulerAngles);
end

punkty=0; % 0-nic, 1-tak
krawedzie=4; % 0-nic, 1-xmisor, 2-ymisor, 3-P22, 4-Bresenham, 5-x+y-misor
piksele=1; % 0-nic(biale), 1-Euler, 2-IPF, 3-random
korektaEulera=1; % korekta kolorow Eulera

    % kolory punktow
    if punkty==1
        colorP23=[0 0 127];
        colorP24=[127 0 0];
        colorP25=[255 255 0];
        colorP12=[0 127 0];
    end
    % koniec kolorow punktow
    
    % kierunek odniesienia IPF
    if piksele==2
        IPF=3; % 1-RD, 2-TD, 3-ND
    end
    % koniec kierunku odniesienia IPF
% koniec zmiennych globalnych i parametrow zewnetrznych

% wykres barwny
if piksele==0 % pusta biala mapa
    mapbmp=255*ones(wymiary(1),wymiary(2),3);
else % jakies kolorowanie
    if ~exist('mapbmp','var')
        disp('obliczam mape kolorow');
        mapbmp=ones(wymiary(1),wymiary(2),3); % inicjalizacja
        
        if piksele==1 % mapa katow Eulera
            if exist('EulerAngles','var')
                for y=1:wymiary(1)
                    for x=1:wymiary(2)
                        mapbmp(y,x,1)=EulerAngles(y,x,3)*255/(2*pi)*4; % tworzenie mapy
                        mapbmp(y,x,2)=EulerAngles(y,x,4)*255/(2*pi)*2; % tworzenie mapy
                        mapbmp(y,x,3)=EulerAngles(y,x,5)*255/(2*pi)*4; % tworzenie mapy
                    end
                end
                clear y x;
        
                % korekta kolorow
                if korektaEulera==1        
                    Rmin=min(min(mapbmp(:,:,1)));
                    Gmin=min(min(mapbmp(:,:,2)));
                    Bmin=min(min(mapbmp(:,:,3)));
                    Rmax=max(max(mapbmp(:,:,1)));
                    Gmax=max(max(mapbmp(:,:,2)));
                    Bmax=max(max(mapbmp(:,:,3)));
                    dR=Rmax-Rmin;
                    dG=Gmax-Gmin;
                    dB=Bmax-Bmin;
                    Rcontrast=floor(255/dR);
                    Gcontrast=floor(255/dG);
                    Bcontrast=floor(255/dB);
                    for y=1:wymiary(1)
                        for x=1:wymiary(2)
                            mapbmp(y,x,1)=floor((mapbmp(y,x,1)-Rmin)*Rcontrast);
                            mapbmp(y,x,2)=floor((mapbmp(y,x,2)-Gmin)*Gcontrast);
                            mapbmp(y,x,3)=floor((mapbmp(y,x,3)-Bmin)*Bcontrast);
                        end
                    end
                    clear y x;
                    clear Rmin Gmin Bmin Rmax Gmax Bmax dR dG dB;
                    clear Rcontrast Gcontrast Bcontrast;
                end
                % koniec korekty kolorow
        
            else
                disp('brakuje zmiennej: EulerAngles');
            end
        elseif piksele==2 % mapa IPF
            if exist('ormatrix','var')
                % definicja glownych kierunkow w ukladzie krystalitu C z uzwg. symetrii
                % V1=[001], V2=[101], V3=[111]
                V1=[0 0 1;0 1 0;1 0 0];
                V2=[1 0 1;1 1 0;0 1 1;-1 0 1;-1 1 0;0 -1 1];
                V3=[1 1 1;1 1 -1;1 -1 1;-1 1 1];
                % koniec definicji glownych kierunkow

                % obliczenie katow do glownych osi
                alfa=zeros(wymiary(1),wymiary(2),3); %macierz min. katow do gl. kier. C
                for y=1:wymiary(1)
                    for x=1:wymiary(2)
                        %obliczenie kata do [001]
                        alfa1=zeros(3,1);
                        for v1=1:3
                            NcxV1(1)=ormatrix(y,x,2,IPF)*V1(v1,3)-ormatrix(y,x,3,IPF)*V1(v1,2);
                            NcxV1(2)=ormatrix(y,x,3,IPF)*V1(v1,1)-ormatrix(y,x,1,IPF)*V1(v1,3);
                            NcxV1(3)=ormatrix(y,x,1,IPF)*V1(v1,2)-ormatrix(y,x,2,IPF)*V1(v1,1);
                            alfa1(v1)=180/pi*asin(sqrt(NcxV1(1)^2+NcxV1(2)^2+NcxV1(3)^2));
                        end
                        alfa(y,x,1)=min(alfa1);
                        clear v1 alfa1 NcxV1;
                        % koniec obliczania kata do [001]

                        % obliczenie kata do [101]
                        alfa2=zeros(6,1);
                        for v2=1:6
                            NcxV2(1)=ormatrix(y,x,2,IPF)*V2(v2,3)-ormatrix(y,x,3,IPF)*V2(v2,2);
                            NcxV2(2)=ormatrix(y,x,3,IPF)*V2(v2,1)-ormatrix(y,x,1,IPF)*V2(v2,3);
                            NcxV2(3)=ormatrix(y,x,1,IPF)*V2(v2,2)-ormatrix(y,x,2,IPF)*V2(v2,1);
                            alfa2(v2)=180/pi*asin(sqrt((NcxV2(1)^2+NcxV2(2)^2+NcxV2(3)^2)/2));
                        end
                        alfa(y,x,2)=min(alfa2);
                        clear v2 alfa2 NcxV2;
                        % koniec obliczania kata do [101]

                        %obliczenie kata do [111]
                        alfa3=zeros(4,1);
                        for v3=1:4
                            NcxV3(1)=ormatrix(y,x,2,IPF)*V3(v3,3)-ormatrix(y,x,3,IPF)*V3(v3,2);
                            NcxV3(2)=ormatrix(y,x,3,IPF)*V3(v3,1)-ormatrix(y,x,1,IPF)*V3(v3,3);
                            NcxV3(3)=ormatrix(y,x,1,IPF)*V3(v3,2)-ormatrix(y,x,2,IPF)*V3(v3,1);
                            alfa3(v3)=180/pi*asin(sqrt((NcxV3(1)^2+NcxV3(2)^2+NcxV3(3)^2)/3));
                        end
                        alfa(y,x,3)=min(alfa3);
                        clear v3 alfa3 NcxV3;
                        % koniec obliczania kata do [111]
                    end
                end
                clear x y V1 V2 V3;
                % koniec obliczania katow do glownych osi

                % wyszukiwanie maksimum 'alfa' na piechote
                mx(1)=0;
                mx(2)=0;
                mx(3)=0;
                for y=1:wymiary(1)
                    for x=1:wymiary(2)
                        if alfa(y,x,1)>mx(1)
                            mx(1)=alfa(y,x,1);
                        end
                        if alfa(y,x,2)>mx(2)
                            mx(2)=alfa(y,x,2);
                        end
                        if alfa(y,x,3)>mx(3)
                            mx(3)=alfa(y,x,3);
                        end
                    end
                end
                clear x y;
                % koniec wyszukiwania maksimum 'alfa'

                % tworzenie mapy IPF
                for y=1:wymiary(1)
                    for x=1:wymiary(2)
                        mapbmp(y,x,1)=255-(alfa(y,x,1)/54.74)*255; % R
                        mapbmp(y,x,2)=255-(alfa(y,x,2)/45.00)*255; % G
                        mapbmp(y,x,3)=255-(alfa(y,x,3)/54.74)*255; % B
                    end
                end
                clear y x mx alfa;
                % koniec tworzenia mapy IPF

                % normalizacja jasnosci
                mx=0;
                for y=1:wymiary(1)
                    for x=1:wymiary(2)
                        for z=1:3
                            if mapbmp(y,x,z)>mx
                                mx=mapbmp(y,x,z);
                            end
                        end
                        norm=255/mx;
                        mapbmp(y,x,1)=mapbmp(y,x,1)*norm;
                        mapbmp(y,x,2)=mapbmp(y,x,2)*norm;
                        mapbmp(y,x,3)=mapbmp(y,x,3)*norm;
                        mx=0;
                        norm=0;
                    end
                end
                clear y x z norm mx IPF;
                % koniec normalizacji jasnosci
            else
                disp('brakuje zmiennej: ormatrix');
            end
        elseif piksele==3 % losowe kolory ziaren
            if exist('grainmap','var')

                % generowanie losowych kolorow dla ziaren
                randomy=ceil(rand(grainnumber,1)*16581375);
                colors=zeros(grainnumber,3);
                for i=1:grainnumber
                    RGB(1)=floor(randomy(i)/65025); % R
                    k=randomy(i)-RGB(1)*65025;
                    RGB(2)=floor(k/255); % G
                    RGB(3)=k-RGB(2)*255; % B
        %             RGB(3)=k-colors(i,2)*255; % B
                    mRGB=max(RGB);
                    RGB=ceil(255*RGB/mRGB);
                    colors(i,1:3)=RGB(1:3);
                end
                clear randomy i k RGB mRGB;            
                % koniec generowania losowych kolorow

                % tworzenie mapy
                for y=1:wymiary(1)
                    for x=1:wymiary(2)
                        mapbmp(y,x,1:3)=colors(grainmap(y,x),1:3);
                    end
                end
                clear y x colors;
                % koniec tworzenia mapy
            else
                disp('brakuje zbioru grainmap');
            end
        end
    else
        disp('korzystam z gotowej mapy kolorow');
    end
end
% koniec wykresu barwnego

% wykres granic
if krawedzie==1 % xmisor
    if exist('misor','var')
        for y=1:wymiary(1)
            for x=1:wymiary(2)-1
                if misor.dx(y,x)>1
                    mapbmp(y,x,1:3)=127;
                end
            end
        end
        clear y x;
    else
        disp('brakuje zmiennej misor');
    end
elseif krawedzie==2 % ymisor
    if exist('misor','var')
        for y=1:wymiary(1)-1
            for x=1:wymiary(2)
                if misor.dy(y,x)>1
                    mapbmp(y,x,1:3)=127;
                end
            end
        end
        clear y x;
    else
        disp('brakuje zmiennej misor');
    end
elseif krawedzie==3 % P22
    if isfield(boundarypoints,'P22')
        P22c=boundarypoints.P22.coord;
        sP22=size(P22c);
        for i=1:sP22(1)
            if P22c(i,1)>0
                if P22c(i,2)>0
                    mapbmp(P22c(i,1),P22c(i,2),1:3)=127;
                end
            end
        end
        clear P22c sP22 i;
    else
        disp('brakuje zmiennej P22');
    end
elseif krawedzie==4
    if exist('boundaryedges','var')
        sBE=size(boundaryedges.D2.points);
        for i=1:sBE(1)
            % wsp. pierwszego punktu (y1,x1)
            if boundaryedges.D2.points(i,1)==23
                x1=boundarypoints.P23.coord(boundaryedges.D2.points(i,2),2);
                y1=boundarypoints.P23.coord(boundaryedges.D2.points(i,2),1);
            elseif boundaryedges.D2.points(i,1)==12
                x1=boundarypoints.P12.coord(boundaryedges.D2.points(i,2),2);
                y1=boundarypoints.P12.coord(boundaryedges.D2.points(i,2),1);
            elseif boundaryedges.D2.points(i,1)==22
                x1=boundarypoints.P22.coord(boundaryedges.D2.points(i,2),2);
                y1=boundarypoints.P22.coord(boundaryedges.D2.points(i,2),1);
            elseif boundaryedges.D2.points(i,1)==25
                x1=boundarypoints.P25.coord(boundaryedges.D2.points(i,2),2);
                y1=boundarypoints.P25.coord(boundaryedges.D2.points(i,2),1);
            elseif boundaryedges.D2.points(i,1)==24
                x1=boundarypoints.P24.coord(boundaryedges.D2.points(i,2),2);
                y1=boundarypoints.P24.coord(boundaryedges.D2.points(i,2),1);
            
            end
            
            % wsp. drugiego punktu (y2,x2)
            if boundaryedges.D2.points(i,3)==23
                x2=boundarypoints.P23.coord(boundaryedges.D2.points(i,4),2);
                y2=boundarypoints.P23.coord(boundaryedges.D2.points(i,4),1);
            elseif boundaryedges.D2.points(i,3)==12
                x2=boundarypoints.P12.coord(boundaryedges.D2.points(i,4),2);
                y2=boundarypoints.P12.coord(boundaryedges.D2.points(i,4),1);
            elseif boundaryedges.D2.points(i,3)==22
                x2=boundarypoints.P22.coord(boundaryedges.D2.points(i,4),2);
                y2=boundarypoints.P22.coord(boundaryedges.D2.points(i,4),1);
            elseif boundaryedges.D2.points(i,3)==25
                x2=boundarypoints.P25.coord(boundaryedges.D2.points(i,4),2);
                y2=boundarypoints.P25.coord(boundaryedges.D2.points(i,4),1);
            elseif boundaryedges.D2.points(i,3)==24
                x2=boundarypoints.P24.coord(boundaryedges.D2.points(i,4),2);
                y2=boundarypoints.P24.coord(boundaryedges.D2.points(i,4),1);
            end
            
            % ustalenie kierunku rysowania x
            if x1<x2
                xi=1;
                xkrok=x2-x1;
            else
                xi=-1;
                xkrok=x1-x2;
            end
            
            % ustalenie kierunku rysowania y
            if y1<y2;
                yi=1;
                ykrok=y2-y1;
            else
                yi=-1;
                ykrok=y1-y2;
            end
            
            % punkt poczatkowy
            x=x1;
            y=y1;
            if y>0 && x>0 
                mapbmp(y,x,1:3)=0;
            end
            
            % os wiodaca OX
            if xkrok>ykrok
                ai=(ykrok-xkrok)*2;
                bi=ykrok*2;
                d=bi-xkrok;
                while x~=x2
                    if d>=0
                        x=x+xi;
                        y=y+yi;
                        d=d+ai;
                    else
                        d=d+bi;
                        x=x+xi;
                    end
                    if x>0 && y>0
                        mapbmp(y,x,1:3)=0;
                    end
                end
            % os wiodaca OY
            else
                ai=(xkrok-ykrok)*2;
                bi=xkrok*2;
                d=bi-ykrok;
                while y~=y2
                    if d >= 0
                        x=x+xi;
                        y=y+yi;
                        d=d+ai;
                    else
                        d=d+bi;
                        y=y+yi;
                    end
                    if x>0 && y>0
                        mapbmp(y,x,1:3)=0;
                    end
                end
            end
        end
        clear x1 x2 y1 y2;
        clear ai bi d i sBE x y xi yi xkrok ykrok;
    else
        disp('brakuje zmiennej boundaryedges');
    end
elseif krawedzie==5
    if exist('misor','var')
        for y=1:wymiary(1)
            for x=1:wymiary(2)-1
                if misor.dx(y,x)~=0
                    mapbmp(y,x,1:3)=0;
                end
            end
        end
        for y=1:wymiary(1)-1
            for x=1:wymiary(2)
                if misor.dy(y,x)~=0
                    mapbmp(y,x,1:3)=0;
                end
            end
        end
        clear y x;
    else
        disp('brakuje xmisor lub ymisor');
    end
end
% koniec wykresu granic

% wykres punktow
if punkty==1
    if isfield(boundarypoints,'P23')
        P23c=boundarypoints.P23.coord; % zmienna dziala szybciej niz struktura
        nP23c=size(P23c);
        for i=1:nP23c(1)
            if P23c(i,1)==0 % zabezpierzenie przed zerowymi wsp.
                mapbmp(P23c(i,1)+1,P23c(i,2),1:3)=colorP23(1:3);
            elseif P23c(i,2)==0
                mapbmp(P23c(i,1),P23c(i,2)+1,1:3)=colorP23(1:3);
            else
                mapbmp(P23c(i,1),P23c(i,2),1:3)=colorP23(1:3);
            end
        end
        clear i P23c nP23c;
    else
        disp('brakuje zmiennej P23');
    end
    if isfield(boundarypoints,'P24')
        P24c=boundarypoints.P24.coord; % zmienna dziala szybciej niz struktura
        nP24c=size(P24c);
        if nP24c(1)>0
            for i=1:nP24c(1)
                mapbmp(P24c(i,1),P24c(i,2),1:3)=colorP24(1:3);
            end
        end
        clear i P24c nP24c;
    end
    if isfield(boundarypoints,'P25')
        P25c=boundarypoints.P25.coord; % zmienna dziala szybciej niz struktura
        nP25c=size(P25c);
        if nP25c(1)>0
            for i=1:nP25c(1)
                mapbmp(P25c(i,1),P25c(i,2),1:3)=colorP25(1:3);
            end
        end
        clear i P25c nP25c;
    end 
    if isfield(boundarypoints,'P12')
        P12c=boundarypoints.P12.coord; % zmienne dziala szybciej niz struktura
        nP12c=size(P12c);
        for i=1:nP12c(1)
            if P12c(i,1)==0 % zabezpieczenie przed zerowymi wspolrzednymi
                mapbmp(P12c(i,1)+1,P12c(i,2),1:3)=colorP12(1:3);
            elseif P12c(i,2)==0
                mapbmp(P12c(i,1),P12c(i,2)+1,1:3)=colorP12(1:3);
            else
                mapbmp(P12c(i,1),P12c(i,2),1:3)=colorP12(1:3);
            end
        end
        clear i P12c nP12c;
    else
        disp('brakuje zmiennej P12');
    end
end
clear colorP23 colorP24 colorP25 colorP12;
% koniec wykresu punktow

% zapis wyniku
mapbmp=uint8(mapbmp);
imwrite(mapbmp,'mapbmp.bmp','bmp');
% koniec zapisu wyniku

clear wymiary piksele korektaEulera krawedzie punkty status;