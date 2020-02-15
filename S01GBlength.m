% obliczanie dlugosci granic miedzyziarnowych i ich rozkladu
tic

% zmienne globalne i parametry zewnetrzne
HistType=2; % 0-nic, 1-liczbowy, 2-dlugosciowy
PlotType=2; % 1-simple, 2-spline
NumberOfBins=30;


% obliczenie dlugosci wszystkich granic
sBE=size(boundaryedges.D2.points);
BoundaryLengths=zeros(sBE(1),1);
BoundaryLengthsTotal=0;
for i=1:sBE(1)
    
    % pobranie wspolrzednych punktow odcinka krawedziowego
    P1(1:2)=boundaryedges.D2.points(i,1:2); % typ i numer P1
    P2(1:2)=boundaryedges.D2.points(i,3:4); % typ i numer P2
    
    % wspolrzedne pierwszego konca P1
    if P1(1)==23
        y(1)=boundarypoints.P23.coord(P1(2),1);
        x(1)=boundarypoints.P23.coord(P1(2),2);
    elseif P1(1)==12
        y(1)=boundarypoints.P12.coord(P1(2),1);
        x(1)=boundarypoints.P12.coord(P1(2),2);
    elseif P1(1)==22
        y(1)=boundarypoints.P22.coord(P1(2),1);
        x(1)=boundarypoints.P22.coord(P1(2),2);
    elseif P1(1)==25
        y(1)=boundarypoints.P25.coord(P1(2),1);
        x(1)=boundarypoints.P25.coord(P1(2),2);
    elseif P1(1)==24
        y(1)=boundarypoints.P24.coord(P1(2),1);
        x(1)=boundarypoints.P24.coord(P1(2),2);
    end

    % wspolrzedne drugiego konca P2
    if P2(1)==23
        y(2)=boundarypoints.P23.coord(P2(2),1);
        x(2)=boundarypoints.P23.coord(P2(2),2);
    elseif P2(1)==12
        y(2)=boundarypoints.P12.coord(P2(2),1);
        x(2)=boundarypoints.P12.coord(P2(2),2);
    elseif P2(1)==22
        y(2)=boundarypoints.P22.coord(P2(2),1);
        x(2)=boundarypoints.P22.coord(P2(2),2);
    elseif P2(1)==25
        y(2)=boundarypoints.P25.coord(P2(2),1);
        x(2)=boundarypoints.P25.coord(P2(2),2);
    elseif P2(1)==24
        y(2)=boundarypoints.P24.coord(P2(2),1);
        x(2)=boundarypoints.P24.coord(P2(2),2);
    end
    
    % obliczenie dlugosci granicy
    BoundaryLengths(i)=((y(1)-y(2))^2+(x(1)-x(2))^2)^0.5;
    BoundaryLengthsTotal=BoundaryLengthsTotal+BoundaryLengths(i);
end
clear i P1 P2 y x;
BoundaryLengths=BoundaryLengths*ScanStep.xstep;
BoundaryLengthsTotal=BoundaryLengthsTotal*ScanStep.xstep;
% koniec obliczania dlugosci wszystkich granic

% histogram dlugosci granic
GBLmax=ceil(max(BoundaryLengths)); % najdluzsza granica
binwidth=GBLmax/NumberOfBins; % szerokosc przedzialow
    
    % granice przedzialow
    GBLhist=zeros(NumberOfBins+1,2); % inicjalizacja
    for i=2:NumberOfBins+1
        GBLhist(i,1)=GBLhist(i-1,1)+binwidth;
    end
    clear i;
    % koniec kranic przedzialow
    
    % wyznaczanie histogramu
    if HistType==1 % histogram liczbowy
        GBLhist(:,2)=hist(BoundaryLengths,GBLhist(:,1)); % wyznaczenie histogramu
        GBLhist(:,2)=GBLhist(:,2)/length(BoundaryLengths); % normalizacja number fraction   
    elseif HistType==2 % histogram dlugosciowy
        for i=1:sBE(1) % petla po wszystkich granicach
            for j=1:NumberOfBins
                if (BoundaryLengths(i)>GBLhist(j,1) && BoundaryLengths(i)<GBLhist(j+1,1))
                    GBLhist(j,2)=GBLhist(j,2)+BoundaryLengths(i);
                    break;
                end
            end
        end
        clear i j;
        GBLhist(:,2)=GBLhist(:,2)/BoundaryLengthsTotal; % normalizacja length fraction
    end
    % koniec wyznaczania historamu
    
clear binwidth sBE;
% koniec histogramu dlugosci granic

% wykres histogramu
if PlotType==1 % prosty
    plot(GBLhist(:,1),GBLhist(:,2),'k.-');
elseif PlotType==2 % spline
    x=GBLhist(1,1):0.1*GBLhist(2,1):GBLhist(length(GBLhist),1); % zakres x do resamplingu
    y=spline(GBLhist(:,1),GBLhist(:,2));
    plot(GBLhist(:,1),GBLhist(:,2),'k.',x,ppval(y,x),'k-');
    clear x y;
end
ymax=1.1*max(GBLhist(:,2)); % okreslenie pionowej skali wykresu
axis([0 GBLmax 0 ymax]); % okreslenie skali wykresu
clear ymax GBLmax;
% koniec wykresu histogramu

% czyszczenie pamieci
clear HistType PlotType NumberOfBins;

toc