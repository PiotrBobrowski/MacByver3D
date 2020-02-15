% filtrowanie malych ziaren, srednie macierze
tic

% parametry zewnetrzne i zmienne globalne
mingrainvoxels=500; % d=10pix: pi/6*(10)^3=500, d=5pix: pi/6*(5)^3=65
wymiary=size(grainmap);

% obliczenie liczby voxeli w poszczegolnych ziarnach
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
% koniec obliczania liczby voxeli w poszczegolnych ziarnach

% tworzenie listy malych ziaren
smallgrains=zeros(grainnumber,1); % lista malych ziaren
nsmallgrains=0; % licznik listy malych ziaren
nvoxels=0; % licznik vokseli do zmiany
for i=1:grainnumber % tworzenie listy ziaren do usuniecia
    if grainsizevxl(i)<mingrainvoxels 
        nsmallgrains=nsmallgrains+1; % przyrost licznika malych ziaren
        smallgrains(nsmallgrains,1)=i; % lista malych ziaren
        nvoxels=nvoxels+grainsizevxl(i); % liczba voxeli do poprawienia
    end
end
smallgrains(nsmallgrains+1:grainnumber)=[]; % usuniecie niepotrzebnych zer
clear i mingrainvoxels;
% koniec koniec tworzenia listy malych ziaren

% tworzenie listy vokseli do zmiany
vtc=zeros(nvoxels,4); % inicjalizacja listy vokseli do zmiany: y,x,z,GN
nvtc=0; % numerator vtc
for i=1:length(smallgrains)
    voxels=find(grainmap==smallgrains(i)); % wyszukanie voxeli i-tego ziarna
    [yvxl,xvxl,zvxl]=ind2sub(wymiary,voxels); % konwersja wskaznikow
    lyvxl=length(yvxl);
    vtc(nvtc+1:nvtc+lyvxl,1)=yvxl(1:lyvxl); % wsp.y voxela
    vtc(nvtc+1:nvtc+lyvxl,2)=xvxl(1:lyvxl); % wsp.x voxela
    vtc(nvtc+1:nvtc+lyvxl,3)=zvxl(1:lyvxl); % wsp.z voxela
    vtc(nvtc+1:nvtc+lyvxl,4)=smallgrains(i); % GN do skasowania
    nvtc=nvtc+lyvxl;
end
clear nvoxels nvtc i voxels lyvxl yvxl xvxl zvxl;
% koniec tworzenia listy vokseli do zmiany

% zamiana voxeli
ChangedVoxelsMAver=zeros(wymiary);
while ~isempty(vtc)
    svtc=size(vtc);
    GNto=zeros(svtc(1),5); % grain numbers to overwrite: i(svtc),y,x,z,newGN
    Mto=zeros(svtc(1),3,3); % matrices to overwrite
    nGNto=0; % numerator GNto
    for i=1:svtc(1)
        y=vtc(i,1); % pobranie wsp.y voxela do zmiany
        x=vtc(i,2); % pobranie wsp.x voxela do zmiany
        z=vtc(i,3); % pobranie wsp.z voxela do zmiany
        
        nearvoxels=zeros(26,2); % inicjalizacja listy sasiadow: pozycja,GN
        matrices=zeros(26,3,3); % inicjalizacja macierzy orientacji
        nnearvoxels=0; % numerator
        
        % wypelnienie listy sasiadow
        % ----------
        % poziom z-1: C,N,NE,E,SE,S,SW,W,NW (1-9)
        % poziom z: N,NE,E,SE,S,SW,W,NW (10-17)
        % poziom z+1: C,N,NE,E,SE,S,SW,W,NW (18-26)
        % ----------
        if z>1 % poziom z-1
            nnearvoxels=nnearvoxels+1;
            nearvoxels(nnearvoxels,1)=1;
            nearvoxels(nnearvoxels,2)=grainmap(y,x,z-1);
            matrices(nnearvoxels,1:3,1:3)=ormatrix(y,x,z-1,1:3,1:3);
            
            if y>1 % wiersz y-1
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1)=2;
                nearvoxels(nnearvoxels,2)=grainmap(y-1,x,z-1);
                matrices(nnearvoxels,1:3,1:3)=ormatrix(y-1,x,z-1,1:3,1:3);
                
                if x>1
                    nnearvoxels=nnearvoxels+1;
                    nearvoxels(nnearvoxels,1)=9;
                    nearvoxels(nnearvoxels,2)=grainmap(y-1,x-1,z-1);
                    matrices(nnearvoxels,1:3,1:3)=ormatrix(y-1,x-1,z-1,1:3,1:3);
                end
                
                if x<wymiary(2)
                    nnearvoxels=nnearvoxels+1;
                    nearvoxels(nnearvoxels,1)=3;
                    nearvoxels(nnearvoxels,2)=grainmap(y-1,x+1,z-1);
                    matrices(nnearvoxels,1:3,1:3)=ormatrix(y-1,x+1,z-1,1:3,1:3);
                end
            end % koniec wiersza y-1
             
            if y<wymiary(1) % wiersz y+1
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1)=6;
                nearvoxels(nnearvoxels,2)=grainmap(y+1,x,z-1);
                matrices(nnearvoxels,1:3,1:3)=ormatrix(y+1,x,z-1,1:3,1:3);
                
                if x>1
                    nnearvoxels=nnearvoxels+1;
                    nearvoxels(nnearvoxels,1)=7;
                    nearvoxels(nnearvoxels,2)=grainmap(y+1,x-1,z-1);
                    matrices(nnearvoxels,1:3,1:3)=ormatrix(y+1,x-1,z-1,1:3,1:3);
                end
                
                if x<wymiary(2)
                    nnearvoxels=nnearvoxels+1;
                    nearvoxels(nnearvoxels,1)=5;
                    nearvoxels(nnearvoxels,2)=grainmap(y+1,x+1,z-1);
                    matrices(nnearvoxels,1:3,1:3)=ormatrix(y+1,x+1,z-1,1:3,1:3);
                end
            end % koniec wiersza y+1
            
            if x>1
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1)=8;
                nearvoxels(nnearvoxels,2)=grainmap(y,x-1,z-1);
                matrices(nnearvoxels,1:3,1:3)=ormatrix(y,x-1,z-1,1:3,1:3);
            end
            
            if x<wymiary(2)
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1)=4;
                nearvoxels(nnearvoxels,2)=grainmap(y,x+1,z-1);
                matrices(nnearvoxels,1:3,1:3)=ormatrix(y,x+1,z-1,1:3,1:3);
            end
        end % koniec poziomu z-1
        
        if y>1 % poziom z, wiersz y-1
            nnearvoxels=nnearvoxels+1;
            nearvoxels(nnearvoxels,1)=10;
            nearvoxels(nnearvoxels,2)=grainmap(y-1,x,z);
            matrices(nnearvoxels,1:3,1:3)=ormatrix(y-1,x,z,1:3,1:3);
            
            if x>1
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1)=17;
                nearvoxels(nnearvoxels,2)=grainmap(y-1,x-1,z);
                matrices(nnearvoxels,1:3,1:3)=ormatrix(y-1,x-1,z,1:3,1:3);
            end
            if x<wymiary(2)
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1)=11;
                nearvoxels(nnearvoxels,2)=grainmap(y-1,x+1,z);
                matrices(nnearvoxels,1:3,1:3)=ormatrix(y-1,x+1,z,1:3,1:3);
            end
        end % koniec poziomu z, wiersza y-1
        
        if y<wymiary(1) % poziom z, wiersz y+1
            nnearvoxels=nnearvoxels+1;
            nearvoxels(nnearvoxels,1)=14;
            nearvoxels(nnearvoxels,2)=grainmap(y+1,x,z);
            matrices(nnearvoxels,1:3,1:3)=ormatrix(y+1,x,z,1:3,1:3);
            
            if x>1
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1)=15;
                nearvoxels(nnearvoxels,2)=grainmap(y+1,x-1,z);
                matrices(nnearvoxels,1:3,1:3)=ormatrix(y+1,x-1,z,1:3,1:3);
            end
            if x<wymiary(2)
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1)=13;
                nearvoxels(nnearvoxels,2)=grainmap(y+1,x+1,z);
                matrices(nnearvoxels,1:3,1:3)=ormatrix(y+1,x+1,z,1:3,1:3);
            end
        end % koniec poziomu z, wiersza y+1
        
        if x>1
            nnearvoxels=nnearvoxels+1;
            nearvoxels(nnearvoxels,1)=16;
            nearvoxels(nnearvoxels,2)=grainmap(y,x-1,z);
            matrices(nnearvoxels,1:3,1:3)=ormatrix(y,x-1,z,1:3,1:3);
        end
        
        if x<wymiary(2)
            nnearvoxels=nnearvoxels+1;
            nearvoxels(nnearvoxels,1)=12;
            nearvoxels(nnearvoxels,2)=grainmap(y,x+1,z);
            matrices(nnearvoxels,1:3,1:3)=ormatrix(y,x+1,z,1:3,1:3);
        end
        
        if z<wymiary(3) % poziom z+1
            nnearvoxels=nnearvoxels+1;
            nearvoxels(nnearvoxels,1)=18;
            nearvoxels(nnearvoxels,2)=grainmap(y,x,z+1);
            matrices(nnearvoxels,1:3,1:3)=ormatrix(y,x,z+1,1:3,1:3);
            
            if y>1 % wiersz y-1
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1)=19;
                nearvoxels(nnearvoxels,2)=grainmap(y-1,x,z+1);
                matrices(nnearvoxels,1:3,1:3)=ormatrix(y-1,x,z+1,1:3,1:3);
                
                if x>1
                    nnearvoxels=nnearvoxels+1;
                    nearvoxels(nnearvoxels,1)=26;
                    nearvoxels(nnearvoxels,2)=grainmap(y-1,x-1,z+1);
                    matrices(nnearvoxels,1:3,1:3)=ormatrix(y-1,x-1,z+1,1:3,1:3);
                end
                
                if x<wymiary(2)
                    nnearvoxels=nnearvoxels+1;
                    nearvoxels(nnearvoxels,1)=20;
                    nearvoxels(nnearvoxels,2)=grainmap(y-1,x+1,z+1);
                    matrices(nnearvoxels,1:3,1:3)=ormatrix(y-1,x+1,z+1,1:3,1:3);
                end
            end % koniec wiersza y-1
             
            if y<wymiary(1) % wiersz y+1
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1)=23;
                nearvoxels(nnearvoxels,2)=grainmap(y+1,x,z+1);
                matrices(nnearvoxels,1:3,1:3)=ormatrix(y+1,x,z+1,1:3,1:3);
                
                if x>1
                    nnearvoxels=nnearvoxels+1;
                    nearvoxels(nnearvoxels,1)=24;
                    nearvoxels(nnearvoxels,2)=grainmap(y+1,x-1,z+1);
                    matrices(nnearvoxels,1:3,1:3)=ormatrix(y+1,x-1,z+1,1:3,1:3);
                end
                
                if x<wymiary(2)
                    nnearvoxels=nnearvoxels+1;
                    nearvoxels(nnearvoxels,1)=22;
                    nearvoxels(nnearvoxels,2)=grainmap(y+1,x+1,z+1);
                    matrices(nnearvoxels,1:3,1:3)=ormatrix(y+1,x+1,z+1,1:3,1:3);
                end
            end % koniec wiersza y+1
            
            if x>1
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1)=25;
                nearvoxels(nnearvoxels,2)=grainmap(y,x-1,z+1);
                matrices(nnearvoxels,1:3,1:3)=ormatrix(y,x-1,z+1,1:3,1:3);
            end
            
            if x<wymiary(2)
                nnearvoxels=nnearvoxels+1;
                nearvoxels(nnearvoxels,1)=21;
                nearvoxels(nnearvoxels,2)=grainmap(y,x+1,z+1);
                matrices(nnearvoxels,1:3,1:3)=ormatrix(y,x+1,z+1,1:3,1:3);
            end
        end % koniec poziomu z+1
        
        nearvoxels(nnearvoxels+1:26,:)=[]; % usuniecie pustych linii
        matrices(nnearvoxels+1:26,:,:)=[]; % usuniecie pustych linii
        % koniec wypelnienia listy sasiadow
        
        % obliczenie histogramu liczby sasiadow
        unearvoxels=unique(nearvoxels(:,2)); % unikatowe numery ziaren
        lunearvoxels=length(unearvoxels); % liczba unikatowych ziaren
        hnearvoxels=zeros(lunearvoxels,2); % inicjalizacja histogramu
        for j=1:lunearvoxels % petla po liscie unikatow
            hnearvoxels(j,1)=unearvoxels(j); % numer ziarna
            for k=1:nnearvoxels % petla po liscie sasiadow
                if nearvoxels(k,2)==hnearvoxels(j,1)
                    hnearvoxels(j,2)=hnearvoxels(j,2)+1; % czestosc wystapienia
                end
            end
        end
        clear nnearvoxels unearvoxels lunearvoxels j k;
        % koniec obliczania histogramu liczby sasiadow
        
        % usuniecie z histogramu numerow ziaren do skasowania
        shnearvoxels=size(hnearvoxels); % wielkosc histogamu
        for j=1:shnearvoxels(1) % petla po elementach histogramu
            for k=1:nsmallgrains % petla po ziarnach do skaskowania
                if hnearvoxels(j,1)==smallgrains(k)
                    hnearvoxels(j,1:2)=[0 0]; % zerowanie histogramu
                end
            end
        end
        for j=shnearvoxels(1):-1:1 % kasowanie zer z histogarmu
            if hnearvoxels(j,1)==0
                hnearvoxels(j,:)=[];
            end
        end
        clear shnearvoxels j k;
        % koniec usuwania numerow ziaren do skasowania
        
        if ~isempty(hnearvoxels) % zabezpieczenie przed rozrostem falszywych ziaren
            
            % wytypowanie ziarna do przepisania
            [mhnearvoxels,ihnearvoxels]=max(hnearvoxels(:,2)); % najwieksza wartosc histogramu
            nmhnearvoxels=find(hnearvoxels(:,2)==mhnearvoxels); % maksima histogramu
            if length(nmhnearvoxels)>1 % rozstrzygniecie ewentualnego remisu
                remis=zeros(length(nmhnearvoxels),2); % inicjalizacja
                for j=1:length(nmhnearvoxels)
                    remis(j,1)=hnearvoxels(nmhnearvoxels(j),1);% numer ziarna
                    remis(j,2)=grainsizevxl(hnearvoxels(nmhnearvoxels(j),1));% rozmiar ziarna
                end
                [mremis,iremis]=max(remis(:,2)); % najwieksze ziarno
                GNoverwrite=remis(iremis,1); % wynik
                clear remis mremis iremis j;
            else
                GNoverwrite=hnearvoxels(ihnearvoxels,1);
            end
            clear hnearvoxels mhnearvoxels ihnearvoxels nmhnearvoxels;
            % koniec typowania ziarna do przepisania
            
            % wybranie macierzy do usrednienia
            snearvoxels=size(nearvoxels);
            nmatrices2=0;
            for j=1:snearvoxels(1)
                if nearvoxels(j,2)==GNoverwrite
                    nmatrices2=nmatrices2+1;
                    matrices2(nmatrices2,1:3,1:3)=matrices(j,1:3,1:3);
                end
            end
            clear matrices;
            matrices=matrices2;
            clear nearvoxels snearvoxels matrices2 nmatrices2 j;
            % koniec wybierania macierzy do usredniania
            
            % obliczenie sredniej macierzy orientacji
            smatrices=size(matrices);
            averagematrix=zeros(3);
            for j=1:smatrices(1)
                for k1=1:3
                    for k2=1:3
                        averagematrix(k1,k2)=averagematrix(k1,k2)+matrices(j,k1,k2);
                    end
                end
            end
            averagematrix=averagematrix/smatrices(1);
            clear matrices smatrices j k1 k2;
            % koniec obliczania sredniej macierzy orientacji
            
            % zapisanie nowych danych voxela do zmiany
            nGNto=nGNto+1;
            GNto(nGNto,1:5)=[i y x z GNoverwrite];
            Mto(nGNto,1:3,1:3)=averagematrix(1:3,1:3);
            % koniec zapisu nowych danych voxsela do zmiany
            
            clear i y x z svtc GNoverwrite averagematrix;
        end
    end
    
    % aktualizacja grainmap, ormatrix i rawdata
    for i=nGNto:-1:1
        y=GNto(i,2);
        x=GNto(i,3);
        z=GNto(i,4);
        ChangedVoxelsMAver(y,x,z)=1;
        grainmap(y,x,z)=GNto(i,5);
        vtc(GNto(i,1),:)=[];

        ormatrix(y,x,z,1:3,1:3)=Mto(i,1:3,1:3);

        euler(2)=acos(ormatrix(y,x,z,3,3));
        euler(1)=atan(-ormatrix(y,x,z,3,1)/ormatrix(y,x,z,3,2));
        euler(3)=atan(ormatrix(y,x,z,1,3)/ormatrix(y,x,z,2,3));
        if euler(1)<0
            euler(1)=-euler(1);
        end        
        if euler(3)<0
            euler(3)=-euler(3);
        end
        rawdata(y,x,z,3:5)=euler(1:3);
    end
    clear i y x z nGNto GNto Mto euler;
    % koniec aktualizacji danych
    toc
end
clear vtc smallgrains nsmallgrains;
% koniec zmiany voxeli

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

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;