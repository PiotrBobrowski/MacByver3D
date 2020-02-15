% obliczanie kolorow pikseli do map
tic

% parametry zewnetrzne i zmienne globalne
wymiary=size(grainmap);
piksele=2; % 0-nic(biale), 1-Euler, 2-IPF, 3-random
IPFdirection=3; % 1-RD, 2-TD, 3=ND
korektaEulera=1;

% petla glowna
if piksele>0
    mapRGB=ones(wymiary(1),wymiary(2),3); % inicjalizacja
    
    % mapa kolorow mapRGB
    if piksele==1 % mapa katow Eulera
        if exist('rawdata','var')
            for y=1:wymiary(1)
                for x=1:wymiary(2)
                    mapRGB(y,x,1)=rawdata(y,x,3)/(2*pi)*4; % tworzenie mapy
                    mapRGB(y,x,2)=rawdata(y,x,4)/(2*pi)*2; % tworzenie mapy
                    mapRGB(y,x,3)=rawdata(y,x,5)/(2*pi)*4; % tworzenie mapy
                    
                end
            end
            clear y x;
            
            % korekta kolorow Eulera
            if korektaEulera==1        
                Rmin=min(min(mapRGB(:,:,1)));
                Gmin=min(min(mapRGB(:,:,2)));
                Bmin=min(min(mapRGB(:,:,3)));
                Rmax=max(max(mapRGB(:,:,1)));
                Gmax=max(max(mapRGB(:,:,2)));
                Bmax=max(max(mapRGB(:,:,3)));
                dR=Rmax-Rmin;
                dG=Gmax-Gmin;
                dB=Bmax-Bmin;
                Rcontrast=1/dR;
                Gcontrast=1/dG;
                Bcontrast=1/dB;
                for y=1:wymiary(1)
                    for x=1:wymiary(2)
                        mapRGB(y,x,1)=(mapRGB(y,x,1)-Rmin)*Rcontrast;
                        mapRGB(y,x,2)=(mapRGB(y,x,2)-Gmin)*Gcontrast;
                        mapRGB(y,x,3)=(mapRGB(y,x,3)-Bmin)*Bcontrast;
                    end
                end
                clear y x;
                clear Rmin Gmin Bmin Rmax Gmax Bmax dR dG dB;
                clear Rcontrast Gcontrast Bcontrast;
            end
            % koniec korekty kolorow
        else
            disp('brakuje zmiennej: rawdata');
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
                        NcxV1(1)=ormatrix(y,x,2,IPFdirection)*V1(v1,3)-ormatrix(y,x,3,IPFdirection)*V1(v1,2);
                        NcxV1(2)=ormatrix(y,x,3,IPFdirection)*V1(v1,1)-ormatrix(y,x,1,IPFdirection)*V1(v1,3);
                        NcxV1(3)=ormatrix(y,x,1,IPFdirection)*V1(v1,2)-ormatrix(y,x,2,IPFdirection)*V1(v1,1);
                        alfa1(v1)=180/pi*asin(sqrt(NcxV1(1)^2+NcxV1(2)^2+NcxV1(3)^2));
                    end
                    alfa(y,x,1)=min(alfa1);
                    clear v1 alfa1 NcxV1;
                    % koniec obliczania kata do [001]
                
                    % obliczenie kata do [101]
                    alfa2=zeros(6,1);
                    for v2=1:6
                        NcxV2(1)=ormatrix(y,x,2,IPFdirection)*V2(v2,3)-ormatrix(y,x,3,IPFdirection)*V2(v2,2);
                        NcxV2(2)=ormatrix(y,x,3,IPFdirection)*V2(v2,1)-ormatrix(y,x,1,IPFdirection)*V2(v2,3);
                        NcxV2(3)=ormatrix(y,x,1,IPFdirection)*V2(v2,2)-ormatrix(y,x,2,IPFdirection)*V2(v2,1);
                        alfa2(v2)=180/pi*asin(sqrt((NcxV2(1)^2+NcxV2(2)^2+NcxV2(3)^2)/2));
                    end
                    alfa(y,x,2)=min(alfa2);
                    clear v2 alfa2 NcxV2;
                    % koniec obliczania kata do [101]

                    %obliczenie kata do [111]
                    alfa3=zeros(4,1);
                    for v3=1:4
                        NcxV3(1)=ormatrix(y,x,2,IPFdirection)*V3(v3,3)-ormatrix(y,x,3,IPFdirection)*V3(v3,2);
                        NcxV3(2)=ormatrix(y,x,3,IPFdirection)*V3(v3,1)-ormatrix(y,x,1,IPFdirection)*V3(v3,3);
                        NcxV3(3)=ormatrix(y,x,1,IPFdirection)*V3(v3,2)-ormatrix(y,x,2,IPFdirection)*V3(v3,1);
                        alfa3(v3)=180/pi*asin(sqrt((NcxV3(1)^2+NcxV3(2)^2+NcxV3(3)^2)/3));
                    end
                    alfa(y,x,3)=min(alfa3);
                    clear v3 alfa3 NcxV3;
                    % koniec obliczania kata do [111]
                end
            end
            clear x y V1 V2 V3;
            % koniec obliczania katow do glownych osi
            
            % wyszukiwanie maksimum 'alfa' na piechote, bo max() jest zjebana
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
                    mapRGB(y,x,1)=1-(alfa(y,x,1)/54.74); % R
                    mapRGB(y,x,2)=1-(alfa(y,x,2)/45.00); % G
                    mapRGB(y,x,3)=1-(alfa(y,x,3)/54.74); % B
                end
            end
            clear y x mx alfa;
            % koniec tworzenia mapy IPF
            
            % normalizacja jasnosci
            mx=0;
            for y=1:wymiary(1)
                for x=1:wymiary(2)
                    for z=1:3
                        if mapRGB(y,x,z)>mx
                            mx=mapRGB(y,x,z);
                        end
                    end
                    norm=1/mx;
                    mapRGB(y,x,1)=mapRGB(y,x,1)*norm;
                    mapRGB(y,x,2)=mapRGB(y,x,2)*norm;
                    mapRGB(y,x,3)=mapRGB(y,x,3)*norm;
                    mx=0;
                    norm=0;
                end
            end
            clear y x z norm mx;
            % koniec normalizacji jasnosci
        else
            disp('brakuje zmiennej: ormatrix');
        end
    elseif piksele==3 % losowe kolory ziaren
        if exist('grainmap','var')
            
            % generowanie losowych kolorow dla ziaren
            colors=rand(grainnumber,3);
            % koniec generowania losowych kolorow

            % tworzenie mapy
            for y=1:wymiary(1)
                for x=1:wymiary(2)
                    mapRGB(y,x,1:3)=colors(grainmap(y,x),1:3);
                end
            end
            clear y x colors;
            % koniec tworzenia mapy
        else
            disp('brakuje zbioru grainmap');
        end
    end
    % koniec mapy kolorow mapRGB
end
% koniec petli glownej

% czyszczenie pamieci
clear korektaEulera IPFdirection piksele wymiary;

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;