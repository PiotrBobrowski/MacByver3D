% filtrowanie malych ziaren, przepisywanie orientacji
tic

% parametry zewnetrzne i zmienne globalne
    % d=5pix: pi/6*(5)^3=65
    % d=10pix: pi/6*(10)^3=500
    % d=15pix: pi/6*(15)^3=1800
mingrainvoxels=500;
wymiary=size(grainmap);
% koniec parametrow zewnetrznych i zmiennych globalnych

% obliczenie liczby voxeli w poszczegolnych ziarnach
disp('Obliczanie wielkosci ziaren');
grainsizevxl=zeros(grainnumber,1,'uint32'); % tablica rozmiarow ziaren
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
disp('Okreslenie duzych ziaren');
largegrains=zeros(grainnumber,1,'uint32'); % inicjalizacja
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
disp('Tworzenie listy voxeli do zmiany');
vtc=zeros(nvoxels,4,'uint32'); % inicjalizacja listy vokseli do zmiany: y,x,z,GN
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
ChangedVoxels=zeros(wymiary,'uint32');
while ~isempty(vtc)
    disp('Poprawianie vokseli');
    svtc=size(vtc);
    GNto=zeros(svtc(1),5,'uint32'); % grain numbers to overwrite: i(svtc),y,x,z,newGN
    Mto=zeros(svtc(1),3,3,'single'); % matrices to overwrite
    Eto=zeros(svtc(1),4,'single'); % Eulers to overwrite: fi1,FI,fi2
    nGNto=0; % numerator GNto
    for i=1:svtc(1)
        y=vtc(i,1); % pobranie wsp.y voxela do zmiany
        x=vtc(i,2); % pobranie wsp.x voxela do zmiany
        z=vtc(i,3); % pobranie wsp.z voxela do zmiany
        
        nearvoxels=zeros(6,2,'uint32'); % inicjalizacja listy sasiadow: pozycja,GN
        nnearvoxels=0; % numerator
        
        % wypelnienie listy sasiadow
        % ----------
        % C(z-1),N,E,S,W,C(z+1)
        % ----------
        if z>1 % C(z-1)
            nnearvoxels=nnearvoxels+1;
            nearvoxels(nnearvoxels,1:2)=[1 grainmap(y,x,z-1)]; % C(z-1)
        end 
        if y>1 % N
            nnearvoxels=nnearvoxels+1;
            nearvoxels(nnearvoxels,1:2)=[2 grainmap(y-1,x,z)]; % N(z=0)
        end         
        if y<wymiary(1) % S
            nnearvoxels=nnearvoxels+1;
            nearvoxels(nnearvoxels,1:2)=[4 grainmap(y+1,x,z)]; % S(z=0)
        end
        if x>1 % W
            nnearvoxels=nnearvoxels+1;
            nearvoxels(nnearvoxels,1:2)=[5 grainmap(y,x-1,z)]; % W(z=0)
        end        
        if x<wymiary(2) % E
            nnearvoxels=nnearvoxels+1;
            nearvoxels(nnearvoxels,1:2)=[3 grainmap(y,x+1,z)]; % E(z=0)
        end
        if z<wymiary(3) % C(z+1)
            nnearvoxels=nnearvoxels+1;
            nearvoxels(nnearvoxels,1:2)=[6 grainmap(y,x,z+1)]; % C(z+1)
        end
        nearvoxels(nnearvoxels+1:6,:)=[]; % usuniecie pustych linii
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
                hnearvoxels=zeros(lunearvoxels,2,'uint32'); % inicjalizacja
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
                    remis=zeros(length(nmhnearvoxels),2,'uint32'); % inicjalizacja
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
            if nearvoxels(Pto,1)==1 % C(z-1)
                Mto(nGNto,1:3,1:3)=ormatrix(y,x,z-1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y,x,z-1,3:5);
            elseif nearvoxels(Pto,1)==2 % N
                Mto(nGNto,1:3,1:3)=ormatrix(y-1,x,z,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y-1,x,z,3:5);
            elseif nearvoxels(Pto,1)==3 % E
                Mto(nGNto,1:3,1:3)=ormatrix(y,x+1,z,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y,x+1,z,3:5);
            elseif nearvoxels(Pto,1)==4 % S
                Mto(nGNto,1:3,1:3)=ormatrix(y+1,x,z,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y+1,x,z,3:5);
            elseif nearvoxels(Pto,1)==5 % W
                Mto(nGNto,1:3,1:3)=ormatrix(y,x-1,z,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y,x-1,z,3:5);
            elseif nearvoxels(Pto,1)==6 % C(z+1)
                Mto(nGNto,1:3,1:3)=ormatrix(y,x,z+1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y,x,z+1,3:5);
            end
            clear Pto;
            % koniec zapisu nowych danych voksela do zmiany
 
            clear i y x sptc GNoverwrite;
        end
        clear nearvoxels nnearvoxels unearvoxels lunearvoxels;
    end

    % aktualizacja grainmap, ormatrix i EulerAngles
    disp('Aktualizacja grainmap, ormatrix i EulerAngles');
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
    vtc=zeros(lvtc,3,'uint32'); % reinicjalizacja vtc
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

% wizualizacja zmian
[Vy,Vx,Vz]=ind2sub(wymiary,find(ChangedVoxels));
plot3(Vy,Vx,Vz,'.k');
axis equal; grid on;
clear Vy Vx Vz ChangedVoxels;
% koniec wizualizacji zmian

% obliczanie wielkosci ziaren po czyszczeniu
grainsizevxl=zeros(grainnumber,1,'uint32'); % tablica rozmiarow ziaren
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
grainnumtab=zeros(grainnumber,1,'uint32');
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