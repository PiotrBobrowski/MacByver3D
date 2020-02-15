% obliczanie normalnych do granic i ich rozkladu
tic

% wyznaczenie normalnych wszystkich granic
sBE=size(boundaryedges.D2.points);
BoundaryNormals=zeros(sBE(1),4); % inicjalizacja: y,x,z=0,atan(st)
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
    
    % wyznaczenie normalnych
        % struktura BoundaryNormals: y,x,z=0,atan
        % metoda: (y,x) => (-x,y)
    N=((y(2)-y(1))^2+(x(2)-x(1))^2)^0.5; % normalizacja
    BoundaryNormals(i,1)=(x(1)-x(2))/N; % Normal:y
    BoundaryNormals(i,2)=(y(2)-y(1))/N; % Normal:x
    if BoundaryNormals(i,2)==0
        BoundaryNormals(i,4)=90;
    else
        BoundaryNormals(i,4)=180/pi*atan(BoundaryNormals(i,1)/BoundaryNormals(i,2));
        if BoundaryNormals(i,4)<0
            BoundaryNormals(i,4)=BoundaryNormals(i,4)+180;
        end
    end

end
clear i x y N P1 P2;
% koniec wyznaczania normalnych wszystkich granic

% histogram normalnych

    % granice histogramu
    HistEdges=zeros(360,1);
    for i=1:360
        HistEdges(i)=i/180*pi;
    end
    clear i;
    
    % wyznaczenie histogramu normalnych
    GBNhist=zeros(360,1); % inicjalizacja
    for j=1:sBE(1)
        for i=1:360
            if (BoundaryNormals(j,4)>i-1 && BoundaryNormals(j,4)<i)
                GBNhist(i)=GBNhist(i)+BoundaryLengths(j);
                GBNhist(i+180)=GBNhist(i+180)+BoundaryLengths(j);
                break;
            end
        end
    end
    clear i j;
    % koniec wyznaczania histogramu normalnych
    
%     % srednia ruchoma histogramu
%     GBNhist2=zeros(360,1); % inicjalizacja
%     GBNhist2(1)=(GBNhist(359)+GBNhist(360)+GBNhist(1)+GBNhist(2)+GBNhist(3))/5;
%     GBNhist2(2)=(GBNhist(360)+GBNhist(1)+GBNhist(2)+GBNhist(3)+GBNhist(4))/5;
%     for i=3:358
%         GBNhist2(i)=(GBNhist(i-2)+GBNhist(i-1)+GBNhist(i)+GBNhist(i+1)+GBNhist(i+2))/5;
%     end
%     clear i;
%     GBNhist2(359)=(GBNhist(357)+GBNhist(358)+GBNhist(359)+GBNhist(360)+GBNhist(1))/5;
%     GBNhist2(360)=(GBNhist(358)+GBNhist(359)+GBNhist(360)+GBNhist(1)+GBNhist(2))/5;
%     GBNhist=GBNhist2;
%     clear GBNhist2;
%     % koniec sredniej ruchomej histogramu

    polar(HistEdges,GBNhist,'k-');
%     plot(HistEdges,GBNhist,'k-');
    
% koniec histogramu normalnych

clear sBE;
% axis equal;

toc