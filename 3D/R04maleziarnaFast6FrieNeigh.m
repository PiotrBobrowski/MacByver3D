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

        % current voxel coordinates
        y=vtc(i,1);
        x=vtc(i,2);
        z=vtc(i,3);
        % end current voxel coordinates 
        
        % count neighbors' friends
        FriendsGN=[0 0 0 0 0 0]; % grain numbers for firends: z-1,z+1,y-1,x+1,y+1,x-1
        nFriends=[0 0 0 0 0 0]; % number of neighbors' friends: z-1,z+1,y-1,x+1,y+1,x-1
        if z-1>1 % z-1
            FriendsGN(1)=grainmap(y,x,z-1);
            if grainmap(y,x,z-1)==grainmap(y,x,z-2) % z-2
                nFriends(1)=nFriends(1)+1;
            end
            if (y>1 && grainmap(y,x,z-1)==grainmap(y-1,x,z-1)) % y-1,z-1
                nFriends(1)=nFriends(1)+1;
            end
            if (y<wymiary(1) && grainmap(y,x,z-1)==grainmap(y+1,x,z-1)) % y+1,z-1
                nFriends(1)=nFriends(1)+1;
            end
            if (x>1 && grainmap(y,x,z-1)==grainmap(y,x-1,z-1)) % x-1,z-1
                nFriends(1)=nFriends(1)+1;
            end
            if (x<wymiary(2) && grainmap(y,x,z-1)==grainmap(y,x+1,z-1))% x+1,z-1
                nFriends(1)=nFriends(1)+1;
            end
        end
        if z+1<wymiary(3) % z+1
            FriendsGN(2)=grainmap(y,x,z+1);
            if grainmap(y,x,z+1)==grainmap(y,x,z+2) % z+2
                nFriends(2)=nFriends(2)+1;
            end
            if (y>1 && grainmap(y,x,z+1)==grainmap(y-1,x,z+1))% y-1,z+1
                nFriends(2)=nFriends(2)+1;
            end
            if (y<wymiary(1) && grainmap(y,x,z+1)==grainmap(y+1,x,z+1))% y+1,z+1
                nFriends(2)=nFriends(2)+1;
            end
            if (x>1 && grainmap(y,x,z+1)==grainmap(y,x-1,z+1)) % x-1,z+1
                nFriends(2)=nFriends(2)+1;
            end
            if (x<wymiary(2) && grainmap(y,x,z+1)==grainmap(y,x+1,z+1))% x+1,z+1
                nFriends(2)=nFriends(2)+1;
            end
        end
        if y-1>1 % y-1
            FriendsGN(3)=grainmap(y-1,x,z);
            if (z>1 && grainmap(y-1,x,z)==grainmap(y-1,x,z-1)) % y-1,z-1
                nFriends(3)=nFriends(3)+1;
            end
            if (z<wymiary(3) && grainmap(y-1,x,z)==grainmap(y-1,x,z+1)) % y-1,z+1
                nFriends(3)=nFriends(3)+1;
            end
            if grainmap(y-1,x,z)==grainmap(y-2,x,z) % y-2
                nFriends(3)=nFriends(3)+1;
            end
            if (x>1 && grainmap(y-1,x,z)==grainmap(y-1,x-1,z)) % y-1,x-1
                nFriends(3)=nFriends(3)+1;
            end
            if (x<wymiary(2) && grainmap(y-1,x,z)==grainmap(y-1,x+1,z)) % y-1,x+1
                nFriends(3)=nFriends(3)+1;
            end
        end
        if x+1<wymiary(2) % x+1
            FriendsGN(4)=grainmap(y,x+1,z);
            if (z>1 && grainmap(y,x+1,z)==grainmap(y,x+1,z-1)) % x+1,z-1
                nFriends(4)=nFriends(4)+1;
            end
            if (z<wymiary(3) && grainmap(y,x+1,z)==grainmap(y,x+1,z+1)) % x+1,z+1
                nFriends(4)=nFriends(4)+1;
            end
            if (y>1 && grainmap(y,x+1,z)==grainmap(y-1,x+1,z)) % y-1,x+1
                nFriends(4)=nFriends(4)+1;
            end
            if (y<wymiary(1) && grainmap(y,x+1,z)==grainmap(y+1,x+1,z)) % y+1,x+1
                nFriends(4)=nFriends(4)+1;
            end
            if grainmap(y,x+1,z)==grainmap(y,x+2,z) % x+2
                nFriends(4)=nFriends(4)+1;
            end
        end
        if y+1<wymiary(1) % y+1
            FriendsGN(5)=grainmap(y+1,x,z);
            if (z>1 && grainmap(y+1,x,z)==grainmap(y+1,x,z-1)) % y+1,z-1
                nFriends(5)=nFriends(5)+1;
            end
            if (z<wymiary(3) && grainmap(y+1,x,z)==grainmap(y+1,x,z+1)) % y+1,z+1
                nFriends(5)=nFriends(5)+1;
            end
            if grainmap(y+1,x,z)==grainmap(y+2,x,z) % y+2
                nFriends(5)=nFriends(5)+1;
            end
            if (x>1 && grainmap(y+1,x,z)==grainmap(y+1,x-1,z)) % y+1,x-1
                nFriends(5)=nFriends(5)+1;
            end
            if (x<wymiary(2) && grainmap(y+1,x,z)==grainmap(y+1,x+1,z)) % y+1,x+1
                nFriends(5)=nFriends(5)+1;
            end
        end
        if x-1>1 % x-1
            FriendsGN(6)=grainmap(y,x-1,z);
            if (z>1 && grainmap(y,x-1,z)==grainmap(y,x-1,z-1)) % x-1,z-1
                nFriends(6)=nFriends(6)+1;
            end
            if (z<wymiary(3) && grainmap(y,x-1,z)==grainmap(y,x-1,z+1)) % x-1,z+1
                nFriends(6)=nFriends(6)+1;
            end
            if (y>1 && grainmap(y,x-1,z)==grainmap(y-1,x-1,z)) % y-1,x-1
                nFriends(6)=nFriends(6)+1;
            end
            if (y<wymiary(1) && grainmap(y,x-1,z)==grainmap(y+1,x-1,z)) % y+1,x-1
                nFriends(6)=nFriends(6)+1;
            end
            if grainmap(y,x-1,z)==grainmap(y,x-2,z) % x-2
                nFriends(6)=nFriends(6)+1;
            end
        end
        % end count neighbors' friends

        % usuniecie numerow ziaren do skasowania z listy sasiadow
        for j=6:-1:1 % petla po sasiadach
            graintokill=1;
            for k=1:nlargegrains % petla po duzych ziarnach
                if FriendsGN(j)==largegrains(k)
                    graintokill=0;
                    break;
                end
            end % koniec petli po duzych ziarnach
            if graintokill==1
                FriendsGN(j)=0; % usun sasiada z listy
                nFriends(j)=0; % usun sasiada z listy
            end
        end % koniec petli po sasiadach
        clear j k graintokill;
        % koniec usuwania ziaren do skasowania z listy sasiadow

        % find most friendly neighbor and get overwrite direction
        if ~isempty(nonzeros(nFriends)) % protection from unfriendly neighbors

            iFriends=find(nFriends==max(nonzeros(nFriends))); % get indices of most friendly neighbors
            if length(iFriends)==1 % only one most friendly neighbor

                nGNto=nGNto+1;
                GNto(nGNto,1:5)=[i y x z FriendsGN(iFriends)];
                if iFriends==1 % z-1
                    Mto(nGNto,1:3,1:3)=ormatrix(y,x,z-1,1:3,1:3);
                    Eto(nGNto,1:3)=EulerAngles(y,x,z-1,3:5);
                elseif iFriends==2 % z+1
                    Mto(nGNto,1:3,1:3)=ormatrix(y,x,z+1,1:3,1:3);
                    Eto(nGNto,1:3)=EulerAngles(y,x,z+1,3:5);
                elseif iFriends==3 % y-1
                    Mto(nGNto,1:3,1:3)=ormatrix(y-1,x,z,1:3,1:3);
                    Eto(nGNto,1:3)=EulerAngles(y-1,x,z,3:5);
                elseif iFriends==4 % x+1
                    Mto(nGNto,1:3,1:3)=ormatrix(y,x+1,z,1:3,1:3);
                    Eto(nGNto,1:3)=EulerAngles(y,x+1,z,3:5);
                elseif iFriends==5 % y+1
                    Mto(nGNto,1:3,1:3)=ormatrix(y+1,x,z,1:3,1:3);
                    Eto(nGNto,1:3)=EulerAngles(y+1,x,z,3:5);
                elseif iFriends==6 % x-1
                    Mto(nGNto,1:3,1:3)=ormatrix(y,x-1,z,1:3,1:3);
                    Eto(nGNto,1:3)=EulerAngles(y,x-1,z,3:5);
                end

            elseif length(iFriends)>1 % there are more most friendly neighbors, get the largest

                GSnearvoxels=[0 0 0 0 0 0]; % initialization: GS 1-6
                for j=1:length(iFriends) % loop on most firendly neighbors
                        % get grain sizes of most friendly neighbors
                    GSnearvoxels(iFriends(j))=grainsizevxl(FriendsGN(iFriends(j)));
                end % end loop on most firendly neighbors
                clear j;

                [mGS,iGS]=max(GSnearvoxels); % find largest firengly grain
                nGNto=nGNto+1;
                GNto(nGNto,1:5)=[i y x z iGS];
                if iFriends==1 % z-1
                    Mto(nGNto,1:3,1:3)=ormatrix(y,x,z-1,1:3,1:3);
                    Eto(nGNto,1:3)=EulerAngles(y,x,z-1,3:5);
                elseif iFriends==2 % z+1
                    Mto(nGNto,1:3,1:3)=ormatrix(y,x,z+1,1:3,1:3);
                    Eto(nGNto,1:3)=EulerAngles(y,x,z+1,3:5);
                elseif iFriends==3 % y-1
                    Mto(nGNto,1:3,1:3)=ormatrix(y-1,x,z,1:3,1:3);
                    Eto(nGNto,1:3)=EulerAngles(y-1,x,z,3:5);
                elseif iFriends==4 % x+1
                    Mto(nGNto,1:3,1:3)=ormatrix(y,x+1,z,1:3,1:3);
                    Eto(nGNto,1:3)=EulerAngles(y,x+1,z,3:5);
                elseif iFriends==5 % y+1
                    Mto(nGNto,1:3,1:3)=ormatrix(y+1,x,z,1:3,1:3);
                    Eto(nGNto,1:3)=EulerAngles(y+1,x,z,3:5);
                elseif iFriends==6 % x-1
                    Mto(nGNto,1:3,1:3)=ormatrix(y,x-1,z,1:3,1:3);
                    Eto(nGNto,1:3)=EulerAngles(y,x-1,z,3:5);
                end
            end

        end % protection from unfriendly neighbors
        % end find most friendly neighbor and get overwrite direction

    end
    clear FriendsGN nFriends GSnearvoxels iFriends mGS iGS;

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