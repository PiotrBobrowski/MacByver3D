% czyszczenie malych ziaren
tic

% parametry zewnetrzne i zmienne globalne
mingrainvoxels=50; % d=5pix: pi/4*(5)^2=20; d=10pix: pi/4*(10)^2=79
wymiary=size(grainmap);
LoopCount=0;

% obliczanie wielkosci ziaren
disp('obliczanie wielkosci ziaren');
grainsizevxl=zeros(grainnumber,1); % tablica rozmiarow ziaren
for y=1:wymiary(1)
    for x=1:wymiary(2)
        pixel=grainmap(y,x);
        grainsizevxl(pixel)=grainsizevxl(pixel)+1;
    end
end
clear y x pixel;
% koniec obliczania wielkosci ziaren

% okreslenie duzych ziaren
disp('okreslenie duzych ziaren');
nlargegrains=0; % licznik duzych ziaren
largegrains=zeros(grainnumber,1); % inicjalizacja
npixels=0; % licznik pikseli do zmiany
for i=1:grainnumber % lista ziaren nie do usuniecia
    if grainsizevxl(i)>=mingrainvoxels 
        nlargegrains=nlargegrains+1; % licznik duzych ziaren
        largegrains(nlargegrains,1)=i; % lista duzych ziaren
    else
        npixels=npixels+grainsizevxl(i); % liczba pixeli do poprawienia
    end
end
largegrains(nlargegrains+1:grainnumber)=[];
clear i mingrainvoxels;
% koniec okreslania duzych ziaren

% tworzenie listy pikseli do zmiany
disp('lista pikseli do zmiany');
ptc=zeros(npixels,3); % inicjalizacja listy pikseli do zmiany: y,x,GN
nptc=0; % numerator ptc
for y=1:wymiary(1)
    for x=1:wymiary(2)
        pixeltochange=1;
        for i=1:nlargegrains
            if grainmap(y,x)==largegrains(i)
                pixeltochange=0;
                break;
            end
        end
        if pixeltochange==1
            nptc=nptc+1;
            ptc(nptc,1:3)=[y x grainmap(y,x)];
        end
    end
end
clear npixels nptc i y x pixeltochange;
% koniec tworzenia listy pikseli do zmiany

% zmiana pikseli
while ~isempty(ptc)
    sptc=size(ptc);
    GNto=zeros(sptc(1),4); % grain numbers to overwrite: i(sptc),y,x,newGN
    Mto=zeros(sptc(1),3,3); % matrices to overwrite
    Eto=zeros(sptc(1),3); % Eulers to overwrite: fi1,FI,fi2
    nGNto=0; % numerator GNto
    for i=1:sptc(1)
        y=ptc(i,1); % pobranie wsp.y piksela do zmiany
        x=ptc(i,2); % pobranie wsp.x piksela do zmiany
        nearpixels=zeros(4,2); % inicjalizacja listy sasiadow: pozycja,GN
        nnearpixels=0;
        
        % kontrola dzialania
        LoopCount=LoopCount+1;
        if LoopCount==1000
            clc;
            disp('poprawianie pikseli, i= ');
            disp(i);
            LoopCount=0;
        end
        % koniec kontroli dzialania
        
        % wypelnienie listy sasiadow:N,E,S,W
        if y>1 % N
            nnearpixels=nnearpixels+1;
            nearpixels(nnearpixels,1)=1; % position
            nearpixels(nnearpixels,2)=grainmap(y-1,x); % GN
        end
        if x<wymiary(2) % E
            nnearpixels=nnearpixels+1;
            nearpixels(nnearpixels,1)=2; % position
            nearpixels(nnearpixels,2)=grainmap(y,x+1); % GN
        end        
        if y<wymiary(1) % S
            nnearpixels=nnearpixels+1;
            nearpixels(nnearpixels,1)=3; % position
            nearpixels(nnearpixels,2)=grainmap(y+1,x); % GN
        end
        if x>1
            nnearpixels=nnearpixels+1;
            nearpixels(nnearpixels,1)=4; % position
            nearpixels(nnearpixels,2)=grainmap(y,x-1); % GN
        end
        if nnearpixels<4
            nearpixels(nnearpixels+1:4,:)=[]; % usuniecie pustych linii
        end
        % koniec wypelnienia listy sasiadow
        
        % usuniecie numerow ziaren do skasowania z listy sasiadow
        unearpixels=unique(nearpixels(:,2)); % unikatowe numery ziaren
        lunearpixels=length(unearpixels); % liczba unikatowych ziaren
        
        for j=lunearpixels:-1:1 % petla po unikatowych sasiadach
            graintokill=1;
            for k=1:nlargegrains % petla po duzych ziarnach
                if unearpixels(j)==largegrains(k)
                    graintokill=0;
                    break;
                end
            end
            if graintokill==1
                unearpixels(j)=[];
            end
        end
        clear j k graintokill;
        % koniec usuwania ziaren do skasowania z listy sasiadow

        % wybor sasiada do przepisania i przepisanie danych
        lunearpixels=length(unearpixels); % liczba unikatowych sasiadow
        if lunearpixels>0 % zabezpieczenie przed rozrostem falszywych ziaren

            % wybor numeru sasiada do przepisania
            if lunearpixels==1 % pojedynczy duzy sasiad
                GNoverwrite=unearpixels(1);
            else % koniecznosc zrobienia histogramu

                % obliczenie histogramu liczby sasiadow
                hnearpixels=zeros(lunearpixels,2); % inicjalizacja
                for j=1:lunearpixels % petla po liscie unikatow
                    hnearpixels(j,1)=unearpixels(j); % numer ziarna
                    for k=1:nnearpixels % petla po liscie sasiadow
                        if nearpixels(k,2)==hnearpixels(j,1)
                            hnearpixels(j,2)=hnearpixels(j,2)+1; % czestosc wystapienia
                        end
                    end
                end
                clear j k;
                % koniec obliczania histogramu liczby sasiadow
                
                % wytypowanie ziarna do przepisania
                [mhnearpixels,ihnearpixels]=max(hnearpixels(:,2)); % najwieksza wartosc histogramu
                nmhnearpixels=find(hnearpixels(:,2)==mhnearpixels); % maksima histogramu

                if length(nmhnearpixels)==1 % pojedyncze maksimum
                    GNoverwrite=hnearpixels(ihnearpixels,1);
                else % rozstrzygniecie ewentualnego remisu
                    remis=zeros(length(nmhnearpixels),2); % inicjalizacja
                    for j=1:length(nmhnearpixels)
                        remis(j,1)=hnearpixels(nmhnearpixels(j),1);% numer ziarna
                        remis(j,2)=grainsizevxl(hnearpixels(nmhnearpixels(j),1));% rozmiar ziarna
                    end
                    [mremis,iremis]=max(remis(:,2)); % najwieksze ziarno
                    GNoverwrite=remis(iremis,1); % wynik
                    clear remis mremis iremis j;
                end
                clear hnearpixels mhnearpixels ihnearpixels nmhnearpixels;
                % koniec typowania ziarna do przepisania
            end
            % koniec wyboru numeru sasiada do przepisania
            
            % zapisanie nowych danych pixela do zmiany
            Pto=find(nearpixels(:,2)==GNoverwrite,1);
            nGNto=nGNto+1;
            if nearpixels(Pto,1)==1
                GNto(nGNto,1:4)=[i y x GNoverwrite];
                Mto(nGNto,1:3,1:3)=ormatrix(y-1,x,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y-1,x,3:5);
            elseif nearpixels(Pto,1)==2
                GNto(nGNto,1:4)=[i y x GNoverwrite];
                Mto(nGNto,1:3,1:3)=ormatrix(y,x+1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y,x+1,3:5);
            elseif nearpixels(Pto,1)==3
                GNto(nGNto,1:4)=[i y x GNoverwrite];
                Mto(nGNto,1:3,1:3)=ormatrix(y+1,x,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y+1,x,3:5);
            else
                GNto(nGNto,1:4)=[i y x GNoverwrite];
                Mto(nGNto,1:3,1:3)=ormatrix(y,x-1,1:3,1:3);
                Eto(nGNto,1:3)=EulerAngles(y,x-1,3:5);
            end
            clear Pto;
            % koniec zapisu nowych danych piksela do zmiany
            clear i y x sptc GNoverwrite;    
        end
        clear nearpixels nnearpixels unearpixels lunearpixels;
    end
    
    % aktualizacja grainmap, ormatrix i EulerAngles
    sptc=size(ptc); % to jest potrzebne w linii 255
    lptc=sptc(1); % licznik niepoprawionych pixeli
    for i=1:nGNto
        
        % kontrola dzialania
        LoopCount=LoopCount+1;
        if LoopCount==1000
            clc;
            disp('aktualizacja grainmap, ormatrix i EulerAngles, i= ');
            disp(i);
            LoopCount=0;
        end
        % koniec kontroli dzialania
        
        % zapisanie aktualnych informacji
        y=GNto(i,2);
        x=GNto(i,3);
        grainmap(y,x)=GNto(i,4);
        ormatrix(y,x,1:3,1:3)=Mto(i,1:3,1:3);
        EulerAngles(y,x,3:5)=Eto(i,1:3);
        ptc(GNto(i,1),:)=[0 0 0];
        lptc=lptc-1;
        % koniec zapisania informacji
    end
    clear i y x nGNto GNto Mto Eto;
    
        % aktualizacja listy pixeli do poprawy
        ptc2=ptc; % kopia robocza tablicy ptc
        ptc=zeros(lptc,3); % reinicjalizacja ptc
        nptc=0; % numerator nowego ptc
        for i=1:sptc(1) % petla po starym ptc2
            if ptc2(i,1)~=0
                nptc=nptc+1;
                ptc(nptc,1:3)=ptc2(i,1:3);
            end
        end
        clear i ptc2 nptc sptc lptc;
        % koniec aktualizacji listy pixeli do poprawy
        
    % koniec aktualizacji danych
end
clear ptc largegrains nlargegrains;
% koniec zmiany pikseli

% obliczanie wielkosci ziaren po czyszczeniu
grainsizevxl=zeros(grainnumber,1); % tablica rozmiarow ziaren
for y=1:wymiary(1)
    for x=1:wymiary(2)
        pixel=grainmap(y,x);
        grainsizevxl(pixel)=grainsizevxl(pixel)+1;
    end
end
clear y x pixel;
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
        grainmap(y,x)=grainnumtab(grainmap(y,x));
    end
end
clear grainnumtab y x wymiary LoopCount;
% koniec poprawiania numeracji ziaren

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;