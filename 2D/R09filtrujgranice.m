% filtrowanie krotkich granic
tic
% ----------
% Algorytm po kolei sprawdza wszystkie odcinki graniczne, czy sa
% odpowiednio dlugie. Gdy odcinek jest za krotki to od razu zostaje
% zmodyfikowany. Modyfikacji ulegaja wszystkie odcinki wychodzace z punktow
% koncowych P1 i P2 kasowanego odcinka poprzez przypisanie im sredniej
% pozycji obu punktow koncowych (tworzony jest nowy punkt P25), 
% przy czym on sam ulega redukcji do dlugosci 0. 
% W przypadku odcinka na krawedzi mapy, jego jedyny punkt P23 zostaje
% przeniesiony na P12.
% Na koniec algorytm kasuje odcinki zerowe.
% Poprawienie 'boundarypoints' polega na utworzeniu listy punktow P25 
% zawierajacej nowo utworzone punkty.
% ----------

%zmienne globalne i parametry zewnetrzne
minedgelength=4; % optimum: 4
% wymiary=size(grainmap);
% lBE=size(boundaryedges);

% tablice robocze
sBE=size(boundaryedges.D2.points);
D2p=boundaryedges.D2.points;
D2g=boundaryedges.D2.grainno;
ETD2=zeros(sBE(1),1); % wektor z granicami do skasowania

if isfield(boundarypoints,'P25')
    sP25=size(boundarypoints.P25.grainno);
    nP25=sP25(1); % numerator tablicy z nowymi punktami
    clear sP25;
else
    nP25=0; % numerator tablicy z nowymi punktami
end

% petla glowna filtrowania
for i=1:sBE(1)
    
    % pobranie wspolrzednych punktow odcinka krawedziowego
    P1(1:2)=D2p(i,1:2); % typ i numer P1
    P2(1:2)=D2p(i,3:4); % typ i numer P2
    
        % wspolrzedne pierwszego konca yx1
    if P1(1)==23
        yx1(1:2)=boundarypoints.P23.coord(P1(2),1:2);
    elseif P1(1)==12
        yx1(1:2)=boundarypoints.P12.coord(P1(2),1:2);
    elseif P1(1)==22
        yx1(1:2)=boundarypoints.P22.coord(P1(2),1:2);
    elseif P1(1)==25
        yx1(1:2)=boundarypoints.P25.coord(P1(2),1:2);
    elseif P1(1)==24
        yx1(1:2)=boundarypoints.P24.coord(P1(2),1:2);
    end

        % wspolrzedne drugiego konca yx2
    if P2(1)==23
        yx2(1:2)=boundarypoints.P23.coord(P2(2),1:2);
    elseif P2(1)==12
        yx2(1:2)=boundarypoints.P12.coord(P2(2),1:2);
    elseif P2(1)==22
        yx2(1:2)=boundarypoints.P22.coord(P2(2),1:2);
    elseif P2(1)==25
        yx2(1:2)=boundarypoints.P25.coord(P2(2),1:2);
    elseif P2(1)==24
        yx2(1:2)=boundarypoints.P24.coord(P2(2),1:2);
    end
    % koniec pobierania wspolrzednych
    
    % obliczenie dlugosci odcinka
    dy=yx1(1)-yx2(1);
    dx=yx1(2)-yx2(2);
    dl=(dy^2+dx^2)^0.5;
    % koniec obliczania dlugosci odcinka
    
    % gdy odcinek jest zbyt krotki
    if dl<minedgelength
        ETD2(i)=1; % oznaczenie granicy do skasowania
        
        % jezeli P1 kasowanego odcinka lezy na krawedzi
        if P1(1)==12
            for j=1:sBE(1)
                % poprawienie P1 sasiedniego odcinka
                if (D2p(j,1)==P2(1) && D2p(j,2)==P2(2))
                    D2p(j,1:2)=P1(1:2);
                end
                % poprawienie P2 sasiedniego odcinka
                if (D2p(j,3)==P2(1) && D2p(j,4)==P2(2))
                    D2p(j,3:4)=P1(1:2);
                end
            end
            clear j;

        % jezeli P2 kasowanego odcinka lezy na krawedzi
        elseif P2(1)==12
            for j=1:sBE(1)
                % poprawienie P1 sasiedniego odcinka
                if (D2p(j,1)==P1(1) && D2p(j,2)==P1(2))
                    D2p(j,1:2)=P2(1:2);
                end
                % poprawienie P2 sasiedniego odcinka
                if (D2p(j,3)==P1(1) && D2p(j,4)==P1(2))
                    D2p(j,3:4)=P2(1:2);
                end
            end
            clear j;

        % jezeli kasowany odcinek jest we wnetrzu mapy
        else
            % utworzenie nowego punktu P25
            nP25=nP25+1;
            newy=ceil((yx1(1)+yx2(1))/2); % srednie y kasowanego odcinka
            newx=ceil((yx1(2)+yx2(2))/2); % srednie x kasowanego odcinka
            boundarypoints.P25.coord(nP25,1:2)=[newy newx];
            % koniec tworzenia nowego punktu P25
            
            % wpisanie nowego P25 do listy granic
            % ----------
            % lista ziaren: za kazdym razem gdy P23 zostaje nadpisany przez
            % P25, do listy P25.grainno zapisane zostaja numery ziaren od
            % P23, lista ta moze zawierac powtorzenia, wiec trzeba ja
            % na koniec wyczyscic
            % ----------
            nD2g=0; % numerator listy ziaren
            for j=1:sBE(1)
                if (D2p(j,1)==P1(1) && D2p(j,2)==P1(2))
                    D2p(j,1:2)=[25 nP25]; % nadpisanie P23 przez P25
                    nD2g=nD2g+2;
                    boundarypoints.P25.grainno(nP25,nD2g-1:nD2g)=D2g(j,1:2);
                elseif (D2p(j,1)==P2(1) && D2p(j,2)==P2(2))
                    D2p(j,1:2)=[25 nP25]; % nadpisanie P23 przez P25
                    nD2g=nD2g+2;
                    boundarypoints.P25.grainno(nP25,nD2g-1:nD2g)=D2g(j,1:2);
                elseif (D2p(j,3)==P1(1) && D2p(j,4)==P1(2))
                    D2p(j,3:4)=[25 nP25]; % nadpisanie P23 przez P25
                    nD2g=nD2g+2;
                    boundarypoints.P25.grainno(nP25,nD2g-1:nD2g)=D2g(j,1:2);
                elseif (D2p(j,3)==P2(1) && D2p(j,4)==P2(2))
                    D2p(j,3:4)=[25 nP25]; % nadpisanie P23 przez P25
                    nD2g=nD2g+2;
                    boundarypoints.P25.grainno(nP25,nD2g-1:nD2g)=D2g(j,1:2);
                end
            end
            clear j newy newx nD2g;
            % koniec wpisywania nowego P25 do listy granic
        end
    end
    clear dy dx dl;
end
clear i P1 P2 yx1 yx2 nP25;
% koniec petli glownej filtrowania

% porzadkowanie boundarypoints.P25.grainno
sP25g=size(boundarypoints.P25.grainno);
grainno=zeros(sP25g(1),3);
for i=1:sP25g(1)
    GN(1,:)=boundarypoints.P25.grainno(i,:);
    uGN=unique(GN);
    if uGN(1)==0
        uGN(1)=[];
    end
    for j=1:length(uGN) 
        grainno(i,j)=uGN(j);
    end
end
boundarypoints.P25.grainno=grainno;
clear sP25g grainno i GN uGN j;
% koniec porzadkowania boundarypoints.P25.grainno

% kasowanie odcinkow
for i=sBE(1):-1:1
    if ETD2(i)==1
        D2p(i,:)=[];
        D2g(i,:)=[];
    end
end
clear i ETD2 sBE;
% koniec kasowania odcinkow

% tworzenie zbioru wynikowego
boundaryedges.D2.points=D2p;
boundaryedges.D2.grainno=D2g;
clear D2p D2g;
% koniec wtorzenia zbioru wynikowego

clear minedgelength; % wymiary;

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;