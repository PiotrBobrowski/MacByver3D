% wyznaczenie rozkladu geometrii granic miedzyziarnowych

% zmienne globalne i parametry zewnetrzne
sD2p=size(boundaryedges.D2.points);
przelicznik=180/pi;
theta=zeros(sD2p(1),1); % inicjalizacja tablicy katow nachylen
boundarylengths=zeros(sD2p(1),1); % inicjalizacja tablicy dlugosci granic
D2boundarydistribution=zeros(180,1); % inicjalizacja rozkladu

% petla glowna
for i=1:sD2p(1)
    
    % pobranie wspolrzednych punktow odcinka krawedziowego
    P1(1:2)=boundaryedges.D2.points(i,1:2); % typ i numer P1
    P2(1:2)=boundaryedges.D2.points(i,3:4); % typ i numer P2
    
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
    
    % obliczanie dlugosci granic i wektorow normalnych
    
        % obliczenie dlugosci odcinka
        dy=yx1(1)-yx2(1);
        dx=yx1(2)-yx2(2);
        boundarylengths(i)=(dy^2+dx^2)^0.5;
        if dy<0
            dy=-dy;
            dx=-dx;
        end
        % koniec obliczania dlugosci odcinka
        
        % obliczanie wektora normalnego
        Vx=-dy;
        Vy=dx;
        if Vy<0
            Vx=-Vx;
            Vy=-Vy;
        end    
        % koniec obliczania wektora normalnego
        
        % obliczanie kata nachylenia wektora normalnego
        if Vx==0
            theta(i)=int16(90);
        else
            theta(i)=przelicznik*atan(Vy/Vx);
            if theta(i)<0
                theta(i)=theta(i)+180;
            end
            theta(i)=int16(theta(i));
        end
        % koniec obliczania nachylenia wektora normalnego
        
    % obliczanie dlugosci granic i wektorow normalnych      
end
clear i P1 P2 yx1 yx2 dy dx y x Vx Vy przelicznik;
% koniec petli glownej

% wyznaczenie histogramu
bins=zeros(180,1);
for i=1:180 % inicjalizacja binow
    bins(i)=i-1;
end
for i=1:sD2p(1)
    D2boundarydistribution(theta(i)+1)=D2boundarydistribution(theta(i)+1)+boundarylengths(i);
end
clear i theta;
plot(bins,D2boundarydistribution,'-k');
axis([0 180 0 max(D2boundarydistribution)]);
clear bins boundarylengths;
% koniec wyznaczania histogramu

clear sD2p i;