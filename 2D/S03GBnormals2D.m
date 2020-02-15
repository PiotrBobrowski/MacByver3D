% obliczenie normalnych polamanych granic 2D

% zmienne globalne i parametry zewnetrzne
sD2p=size(boundaryedges.D2.points);
boundarynormals=zeros(sD2p(1),2);
boundarylengths=zeros(sD2p(1),1);
przelicznik=180/pi;
alfa=zeros(sD2p(1),1); % inicjalizacja tablicy katow nachylen
dl=zeros(sD2p(1),1); % inicjalizacja tablicy dlugosci granic
D2planedistribution=zeros(180,1); % inicjalizacja rozkladu

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
    
    % obliczanie wektorow normalnych i dlugosci granic
    
        % obliczenie dlugosci odcinka
    dy=yx1(1)-yx2(1);
    dx=yx1(2)-yx2(2);
    dl(i)=(dy^2+dx^2)^0.5;
        % koniec obliczania dlugosci odcinka
    if dx<0
        dy=-dy;
        dx=-dx;
    end
    
    subplot(1,2,1);
    x(1)=0;
    x(2)=dx;
    y(1)=0;
    y(2)=dy;
    plot(x,y,'k-'); hold on;
    plot(x,y,'b.'); hold on;
        
        % obliczanie wektora normalnego
    Vx=-dy;
    Vy=dx;
    if Vx<0
        Vx=-Vx;
        Vy=-Vy;
    end  
        
    subplot(1,2,2);
    x(1)=0;
    x(2)=Vx;
    y(1)=0;
    y(2)=Vy;
    plot(x,y,'k-'); hold on;
    plot(x,y,'b.'); hold on;
        % koniec obliczania wektora normalnego
        
        % obliczanie kata nachylenia wektora normalnego
    alfa(i)=floor(przelicznik*atan(Vy/Vx));
end
clear i P1 P2 yx1 yx2 dy dx y x Vx Vy
% koniec petli glownej

% % wyznaczenie histogramu
% bins=zeros(180,1);
% for i=1:181
%     bins(i)=i-91;
% end
% clear i;
% GB2Dplanedistribution=histc(alfa,bins);
% % koniec wyznaczania histogramu


clear sD2p i dl;


% ----------
% obliczyc kat nachylenia: atan(Vy/Vx)
% zrobic histogram katow nachylenia
%   przeliczyc radiany na stopnie
%   wykorzystac instrukcje hist