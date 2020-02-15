% filtrowanie malych ziaren, przepisywanie orientacji
tic

% parametry zewnetrzne i zmienne globalne
mingrainvoxels=500; % d=10pix: pi/6*(10)^3=500, d=5pix: pi/6*(5)^3=65
wymiary=size(grainmap);

% obliczenie liczby voxeli w poszczegolnych ziarnach
status='obliczanie wielkosci ziaren'
grainsizevxl=zeros(grainnumber,1); % tablica rozmiarow ziaren
for y=1:wymiary(1)
    for x=1:wymiary(2)
        for z=1:wymiary(3)
            grainsizevxl(grainmap(y,x,z))=grainsizevxl(grainmap(y,x,z))+1;
        end
    end
end
clear y x z;
% koniec obliczania liczby voxeli w poszczegolnych ziarnach

% okreslenie duzych ziaren
status='okreslenie duzych ziaren'
largegrains=zeros(grainnumber,1); % inicjalizacja
nlargegrains=0; % licznik duzych ziaren
nvoxels=0; % licznik vokseli do zmiany

    % lista ziaren do pozostawienia
    for i=1:grainnumber
        if grainsizevxl(i)>=mingrainvoxels
            nlargegrains=nlargegrains+1; % licznik duzych ziaren
            largegrains(nlargegrains,1)=i; % lista duzych ziaren
        else
            nvoxels=nvoxels+grainsizevxl(i); % liczba voxeli do poprawienia
        end
    end
    largegrains(nlargegrains+1:grainnumber)=[];
    clear i mingrainvoxels;
    % koniec listy ziaren do pozostawienia
    
% koniec okreslania duzych ziaren

% tworzenie listy vokseli do zmiany
status='lista voxeli do zmiany'
vtc=zeros(nvoxels,4); % inicjalizacja listy vokseli do zmiany: y,x,z,GN
nvtc=0; % numerator vtc
for y=1:wymiary(1)
    for x=1:wymiary(2)
        for z=1:wymiary(3)
            voxeltochange=1;
            for i=1:nlargegrains
                if grainmap(y,x,z)==largegrains(i)
                    voxeltochange=0;
                    break;
                end
            end
            if voxeltochange==1
                nvtc=nvtc+1;
                vtc(nvtc,1:4)=[y x z grainmap(y,x,z)];
            end
        end
    end
end
clear nvoxels nvtc y x z voxeltochange i;
% koniec tworzenia listy vokseli do zmiany

% zamiana voxeli
ChangedVoxels=zeros(wymiary);
while ~isempty(vtc)
    status='poprawianie vokseli'
    svtc=size(vtc);
    GNto=zeros(svtc(1),5); % grain numbers to overwrite: i(svtc),y,x,z,newGN
    Mto=zeros(svtc(1),3,3); % matrices to overwrite
    Eto=zeros(svtc(1),4); % Eulers to overwrite: fi1,FI,fi2
    nGNto=0; % numerator GNto
    for i=1:svtc(1)
        y=vtc(i,1); % pobranie wsp.y voxela do zmiany
        x=vtc(i,2); % pobranie wsp.x voxela do zmiany
        z=vtc(i,3); % pobranie wsp.z voxela do zmiany
        
        nearvoxels=zeros(26,2); % inicjalizacja listy sasiadow: pozycja,GN
        nnearvoxels=0; % numerator
        
        % wypelnienie listy sasiadow
        % ----------
        % poziom z-1: C,N,NE,E,SE,S,SW,W,NW (1-9)
        % poziom z: N,NE,E,SE,S,SW,W,NW (10-17)
        % poziom z+1: C,N,NE,E,SE,S,SW,W,NW (18-26)
        % ----------
        if z>1 % poziom z-1
            nnearvoxels=nnearvoxels+1;
            nearvoxels(nnearvoxels,1:2)=[1 grainmap(y,x,z-1)]; % C(z-1)
            
            if y>1 % wiersz y-1 NW-N-NE(z-1)
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1:2)=[2 grainmap(y-1,x,z-1)]; % N(z-1)
                
                if x>1
                    nnearvoxels=nnearvoxels+1;
                    nearvoxels(nnearvoxels,1:2)=[9 grainmap(y-1,x-1,z-1)]; % NW(z-1)
                end
                
                if x<wymiary(2)
                    nnearvoxels=nnearvoxels+1;
                    nearvoxels(nnearvoxels,1:2)=[3 grainmap(y-1,x+1,z-1)]; % NE(z-1)
                end
            end % koniec wiersza y-1 NW-N-NE(z-1)
             
            if y<wymiary(1) % wiersz y+1 SW-S-SE(z-1)
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1:2)=[6 grainmap(y+1,x,z-1)]; % S(z-1)
                
                if x>1
                    nnearvoxels=nnearvoxels+1;
                    nearvoxels(nnearvoxels,1:2)=[7 grainmap(y+1,x-1,z-1)]; % SW(z-1)
                end
                
                if x<wymiary(2)
                    nnearvoxels=nnearvoxels+1;
                    nearvoxels(nnearvoxels,1:2)=[5 grainmap(y+1,x+1,z-1)]; % SE(z-1)
                end
            end % koniec wiersza y+1 SW-S-SE(z-1)
            
            if x>1
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1:2)=[8 grainmap(y,x-1,z-1)]; % W(z-1)
            end
            
            if x<wymiary(2)
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1:2)=[4 grainmap(y,x+1,z-1)]; % E(z-1)
            end
        end % koniec poziomu z-1
        
        if y>1 % poziom z, wiersz y-1 NW-N-NE(z=0)
            nnearvoxels=nnearvoxels+1;
            nearvoxels(nnearvoxels,1:2)=[10 grainmap(y-1,x,z)]; % N(z=0)
            
            if x>1
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1:2)=[17 grainmap(y-1,x-1,z)]; %NW(z=0)
            end
            if x<wymiary(2)
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1:2)=[11 grainmap(y-1,x+1,z)]; % NE(z=0)
            end
        end % koniec poziomu z, wiersza y-1 NW-N-NE(z=0)
        
        if y<wymiary(1) % poziom z, wiersz y+1 SW-S-SE(z=0)
            nnearvoxels=nnearvoxels+1;
            nearvoxels(nnearvoxels,1:2)=[14 grainmap(y+1,x,z)]; % S(z=0)
            
            if x>1
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1:2)=[15 grainmap(y+1,x-1,z)]; % SW(z=0)
            end
            if x<wymiary(2)
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1:2)=[13 grainmap(y+1,x+1,z)]; % SE(z=0)
            end
        end % koniec poziomu z, wiersza y+1 SW-S-SE(z=0)
        
        if x>1
            nnearvoxels=nnearvoxels+1;
            nearvoxels(nnearvoxels,1:2)=[16 grainmap(y,x-1,z)]; % W(z=0)
        end
        
        if x<wymiary(2)
            nnearvoxels=nnearvoxels+1;
            nearvoxels(nnearvoxels,1:2)=[12 grainmap(y,x+1,z)]; % E(z=0)
        end
        
        if z<wymiary(3) % poziom z+1
            nnearvoxels=nnearvoxels+1;
            nearvoxels(nnearvoxels,1:2)=[18 grainmap(y,x,z+1)]; % C(z+1)
            
            if y>1 % wiersz y-1 NW-N-NE(z+1)
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1:2)=[19 grainmap(y-1,x,z+1)]; % N(z+1)
                
                if x>1
                    nnearvoxels=nnearvoxels+1;
                    nearvoxels(nnearvoxels,1:2)=[26 grainmap(y-1,x-1,z+1)]; % NW(z+1)
                end
                
                if x<wymiary(2)
                    nnearvoxels=nnearvoxels+1;
                    nearvoxels(nnearvoxels,1:2)=[20 grainmap(y-1,x+1,z+1)]; % NE(z+1)
                end
            end % koniec wiersza y-1 NW-N-NE(z+1)
             
            if y<wymiary(1) % wiersz y+1 SW-S-SE(z+1)
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1:2)=[23 grainmap(y+1,x,z+1)]; % S(z+1)
                
                if x>1
                    nnearvoxels=nnearvoxels+1;
                    nearvoxels(nnearvoxels,1:2)=[24 grainmap(y+1,x-1,z+1)]; % SW(z+1)
                end
                
                if x<wymiary(2)
                    nnearvoxels=nnearvoxels+1;
                    nearvoxels(nnearvoxels,1:2)=[22 grainmap(y+1,x+1,z+1)]; % SE(z+1)
                end
            end % koniec wiersza y+1 SW-S-SE(z+1)
            
            if x>1
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1:2)=[25 grainmap(y,x-1,z+1)]; % W(z+1)
            end
            
            if x<wymiary(2)
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1:2)=[21 grainmap(y,x+1,z+1)]; % E(z+1)
            end
        end % koniec poziomu z+1
        
        nearvoxels(nnearvoxels+1:26,:)=[]; % usuniecie pustych linii
        % koniec wypelnienia listy sasiadow
        
        % usuniecie numerow ziaren do skasowania z listy sasiadow
        unearvoxels=unique(nearvoxels(:,2)); % unikatowe numery ziaren
        lunearvoxels=length(unearvoxels); % liczba unikatowych ziaren
        
        for j=lunearvoxels:-1:1 % petla po unikatowych sasiadach
            graintokill=1;
            for k=1:nlargegrains % petla po duzych ziarnach
                if unearvoxels(j)==largegrains(k)
                    graintokill=0;
                    break;
                end
            end
            if graintokill==1
                unearvoxels(j)=[];
            end
        end
        clear j k graintokill;
        % koniec usuwania ziaren do skasowania z listy sasiadow
        
        % wybor sasiada do przepisania i przepisanie danych
        lunearvoxels=length(unearvoxels); % liczba unikatowych sasiadow
        if lunearvoxels>0 % zabezpieczenie przed rozrostem falszywych  ziaren
            
            % wybor numeru sasiada do przepisania
            if lunearvoxels==1 % pojedynczy duzy sasiad
                GNoverwrite=unearvoxels(1);
            else % koniecznosc zrobienia histogramu

                % obliczenie histogramu liczby sasiadow
                hnearvoxels=zeros(lunearvoxels,2); % inicjalizacja
                for j=1:lunearvoxels % petla po liscie unikatow
                    hnearvoxels(j,1)=unearvoxels(j); % numer ziarna
                    for k=1:nnearvoxels % petla po liscie sasiadow
                        if nearvoxels(k,2)==hnearvoxels(j,1)
                            hnearvoxels(j,2)=hnearvoxels(j,2)+1; % czestosc wystapienia
                        end
                    end
                end
                clear j k;
                % koniec obliczania histogramu liczby sasiadow

                % wytypowanie ziarna do przepisania
                [mhnearvoxels,ihnearvoxels]=max(hnearvoxels(:,2)); % najwieksza wartosc histogramu
                nmhnearvoxels=find(hnearvoxels(:,2)==mhnearvoxels); % maksima histogramu

                if length(nmhnearvoxels)==1 % pojedyncze maksimum
                    GNoverwrite=hnearvoxels(ihnearvoxels,1);
                else % rozstrzygniecie ewentualnego remisu
                    remis=zeros(length(nmhnearvoxels),2); % inicjalizacja
                    for j=1:length(nmhnearvoxels)
                        remis(j,1)=hnearvoxels(nmhnearvoxels(j),1);% numer ziarna
                        remis(j,2)=grainsizevxl(hnearvoxels(nmhnearvoxels(j),1));% rozmiar ziarna
                    end
                    [mremis,iremis]=max(remis(:,2)); % najwieksze ziarno
                    GNoverwrite=remis(iremis,1); % wynik
                    clear remis mremis iremis j;
                end
                clear hnearvoxels mhnearvoxels ihnearvoxels nmhnearvoxels;
                % koniec typowania ziarna do przepisania
                
            end
            % koniec wyboru numeru sasiada do przepisania
            
            % zapisanie nowych danych voxela do zmiany
            Pto=find(nearvoxels(:,2)==GNoverwrite,1);
            nGNto=nGNto+1;
            GNto(nGNto,1:5)=[i y x z GNoverwrite];
            if nearvoxels(Pto,1)==1
                Mto(nGNto,1:3,1:3)=ormatrix(y,x,z-1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y,x,z-1,3:5);
            elseif nearvoxels(Pto,1)==2
                Mto(nGNto,1:3,1:3)=ormatrix(y-1,x,z-1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y-1,x,z-1,3:5);
            elseif nearvoxels(Pto,1)==3
                Mto(nGNto,1:3,1:3)=ormatrix(y-1,x+1,z-1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y-1,x+1,z-1,3:5);
            elseif nearvoxels(Pto,1)==4
                Mto(nGNto,1:3,1:3)=ormatrix(y,x+1,z-1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y,x+1,z-1,3:5);
            elseif nearvoxels(Pto,1)==5
                Mto(nGNto,1:3,1:3)=ormatrix(y+1,x+1,z-1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y+1,x+1,z-1,3:5);
            elseif nearvoxels(Pto,1)==6
                Mto(nGNto,1:3,1:3)=ormatrix(y+1,x,z-1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y+1,x,z-1,3:5);
            elseif nearvoxels(Pto,1)==7
                Mto(nGNto,1:3,1:3)=ormatrix(y+1,x-1,z-1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y+1,x-1,z-1,3:5);
            elseif nearvoxels(Pto,1)==8
                Mto(nGNto,1:3,1:3)=ormatrix(y,x-1,z-1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y,x-1,z-1,3:5);
            elseif nearvoxels(Pto,1)==9
                Mto(nGNto,1:3,1:3)=ormatrix(y-1,x-1,z-1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y-1,x-1,z-1,3:5);
            elseif nearvoxels(Pto,1)==10
                Mto(nGNto,1:3,1:3)=ormatrix(y-1,x,z,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y-1,x,z,3:5);
            elseif nearvoxels(Pto,1)==11
                Mto(nGNto,1:3,1:3)=ormatrix(y-1,x+1,z,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y-1,x+1,z,3:5);
            elseif nearvoxels(Pto,1)==12
                Mto(nGNto,1:3,1:3)=ormatrix(y,x+1,z,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y,x+1,z,3:5);
            elseif nearvoxels(Pto,1)==13
                Mto(nGNto,1:3,1:3)=ormatrix(y+1,x+1,z,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y+1,x+1,z,3:5);
            elseif nearvoxels(Pto,1)==14
                Mto(nGNto,1:3,1:3)=ormatrix(y+1,x,z,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y+1,x,z,3:5);
            elseif nearvoxels(Pto,1)==15
                Mto(nGNto,1:3,1:3)=ormatrix(y+1,x-1,z,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y+1,x-1,z,3:5);
            elseif nearvoxels(Pto,1)==16
                Mto(nGNto,1:3,1:3)=ormatrix(y,x-1,z,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y,x-1,z,3:5);
            elseif nearvoxels(Pto,1)==17
                Mto(nGNto,1:3,1:3)=ormatrix(y-1,x-1,z,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y-1,x-1,z,3:5);
            elseif nearvoxels(Pto,1)==18
                Mto(nGNto,1:3,1:3)=ormatrix(y,x,z+1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y,x,z+1,3:5);
            elseif nearvoxels(Pto,1)==19
                Mto(nGNto,1:3,1:3)=ormatrix(y-1,x,z+1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y-1,x,z+1,3:5);
            elseif nearvoxels(Pto,1)==20
                Mto(nGNto,1:3,1:3)=ormatrix(y-1,x+1,z+1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y-1,x+1,z+1,3:5);
            elseif nearvoxels(Pto,1)==21
                Mto(nGNto,1:3,1:3)=ormatrix(y,x+1,z+1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y,x+1,z+1,3:5);
            elseif nearvoxels(Pto,1)==22
                Mto(nGNto,1:3,1:3)=ormatrix(y+1,x+1,z+1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y+1,x+1,z+1,3:5);
            elseif nearvoxels(Pto,1)==23
                Mto(nGNto,1:3,1:3)=ormatrix(y+1,x,z+1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y+1,x,z+1,3:5);
            elseif nearvoxels(Pto,1)==24
                Mto(nGNto,1:3,1:3)=ormatrix(y+1,x-1,z+1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y+1,x-1,z+1,3:5);
            elseif nearvoxels(Pto,1)==25
                Mto(nGNto,1:3,1:3)=ormatrix(y,x-1,z+1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y,x-1,z+1,3:5);
            else
                Mto(nGNto,1:3,1:3)=ormatrix(y-1,x-1,z+1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y-1,x-1,z+1,3:5);
            end
            clear Pto;
            % koniec zapisu nowych danych voksela do zmiany
 
            clear i y x sptc GNoverwrite;
        end
        clear nearvoxels nnearvoxels unearvoxels lunearvoxels;
    end

    % aktualizacja grainmap, ormatrix i EulerAngles
    status='aktualizacja grainmap, ormatrix i EulerAngles'
    svtc=size(vtc); % to jest potrzebne w linii 255
    lvtc=svtc(1); % licznik niepoprawionych voxeli
    
    % zapisanie aktualnych informacji
    for i=1:nGNto
        y=GNto(i,2);
        x=GNto(i,3);
        z=GNto(i,4);
        ChangedVoxels(y,x,z)=1;
        grainmap(y,x,z)=GNto(i,5);
        ormatrix(y,x,z,1:3,1:3)=Mto(i,1:3,1:3);
        EulerAngles(y,x,z,3:5)=Eto(i,1:3);
        vtc(GNto(i,1),1:4)=[0 0 0 0];
        lvtc=lvtc-1;
    end
    clear i y x nGNto GNto Mto Eto;
    % koniec zapisu aktualnych informacji

    % aktualizacja listy voxeli do poprawy
    vtc2=vtc; % kopia robocza tablicy vtc
    vtc=zeros(lvtc,3); % reinicjalizacja vtc
    nvtc=0; % numerator nowego vtc
    for i=1:svtc(1) % petla po starym vtc2
        if vtc2(i,1)~=0
            nvtc=nvtc+1;
            vtc(nvtc,1:3)=vtc2(i,1:3);
        end
    end
    clear i vtc2 nvtc svtc lvtc;
    % koniec aktualizacji listy voxeli do poprawy
    
end
clear vtc largegrains nlargegrains;    
% koniec zmiany vokseli

% obliczanie wielkosci ziaren po czyszczeniu
grainsizevxl=zeros(grainnumber,1); % tablica rozmiarow ziaren
for y=1:wymiary(1)
    for x=1:wymiary(2)
        for z=1:wymiary(3)
            voxel=grainmap(y,x,z);
            grainsizevxl(voxel)=grainsizevxl(voxel)+1;
        end
    end
end
clear y x z voxel;
% koniec obliczania wielkosci ziaren po czyszczeniu

% poprawianie numeracji ziaren
j=0;
grainnumtab=zeros(grainnumber,1);
for i=1:grainnumber % wyznaczenie tablicy z poprawnymi numerami
    if grainsizevxl(i)>0
        j=j+1;
        grainnumtab(i)=j;
    end 
end
grainnumber=j;
clear grainsizevxl i j;

for x=1:wymiary(2) % poprawienie numeracji ziaren
    for y=1:wymiary(1)
        for z=1:wymiary(3)
            grainmap(y,x,z)=grainnumtab(grainmap(y,x,z));
        end
    end
end
clear grainnumtab y x z wymiary;
% koniec poprawiania numeracji ziaren

clear status;

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;