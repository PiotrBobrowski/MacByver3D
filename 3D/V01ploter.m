% ploter 3D

% external parameters and global variables
wymiary=size(grainmap);

    % objects to plot
    cubes=0; % 0-none, 1-voxels IPF, 2-grains IPF, 3-grains random
    punkty=0; % 0-nic, 1-tak
    linie=0; % 0-nic, 1-tak
    granice=1; % 0-nic, 1-tak
    % end objects to plot

    % control variables
    if cubes>0
        if ~exist('Grain','var')
            disp('grains to plot were not defined, plotting one random');
            Grain=ceil(grainnumber*rand(1));
        end
    end
    if punkty>0
        P3D=1; % punkty 3D: 0-nic, 1-tak
        P2D=1; % punkty 2D: 0-nic, 1-tak
        P1D=1; % punkty 1D: 0-nic, 1-tak
        A2D=0; % srednie 2D: 0-nic, 1-tak
    end
    if linie>0
        L3=1; % linie 3D: 0-nic, 1-tak
        L2=1; % linie 2D: 0-nic, 1-tak
        L1=1; % linie 2D: 0-nic, 1-tak
    end
    if granice>0
        T3=1; % trojkaty 3D: 0-nic, 1-tak
        T2=0; % trojkaty 2D: 0-nic, 1-tak

        % face coloring:
        % 0 - green contour
        % 1 - green triangles
        % 2 - grain IPF color
        % 3 - grain random color
        % 4 - triangle normal IPF
        % 5 - grain average misorientation
        kolorgranic=3;
    end
    % end control variables

% end external parameters and global variables

% plot cubes
if cubes>0
    if cubes==1 % IPF colored individual voxels

        if ~(exist('Colors','var') && isfield(Colors,'IPFvoxels'))
            V04IPFcolorsVoxels;
        end
        facecolors=Colors.IPFvoxels;

    elseif cubes==2 % grain average IPF colors

        if ~(exist('Colors','var') && isfield(Colors,'IPFgrains'))
            V05IPFcolorsGrains;
        end

        % create color palette for voxels
        wymiary=size(grainmap);
        IPF=Colors.IPFgrains; % load data
        facecolors=zeros(wymiary(1),wymiary(2),wymiary(3),3); % initialization
        for z=1:wymiary(3)
            for x=1:wymiary(2)
                for y=1:wymiary(1)
                    facecolors(y,x,z,1:3)=IPF(grainmap(y,x,z),1:3);
                end
            end
        end
        clear y x z IPF;
        % end create color palette for voxels

    elseif cubes==3 % randomly colored grains

        if ~(exist('Colors','var') && isfield(Colors,'RandomGrains'))
            V06RandomColorsGrains;
        end

        % create color palette for voxels
        CRG=Colors.RandomGrains; % load data
        facecolors=zeros(wymiary(1),wymiary(2),wymiary(3),3); % initialization
        for z=1:wymiary(3)
            for x=1:wymiary(2)
                for y=1:wymiary(1)
                    facecolors(y,x,z,1:3)=CRG(grainmap(y,x,z),1:3);
                end
            end
        end
        clear y x z CRG;
        % end create color palette for voxels

    end

    % plotting cubes
        % declare faces
        ver=[0 0 0;1 0 0;1 1 0;0 1 0;0 0 1;1 0 1;1 1 1;0 1 1];
        facxmin=[1 4 8 5];
        facxmax=[2 3 7 6];
        facymin=[1 2 6 5];
        facymax=[3 4 8 7];
        faczmin=[1 2 3 4];
        faczmax=[5 6 7 8];
        % end declare faces
        
        % main loop
        lGrain=length(Grain);
        wymiary=size(grainmap);
        for i=1:lGrain % loop on grains
            for z=1:wymiary(3)
                for y=1:wymiary(1)
                    for x=1:wymiary(2)
                        if grainmap(y,x,z)==Grain(i)
                            cube=[ver(:,1)+x-1,ver(:,2)+y-1,ver(:,3)+z-1];

                            if y>1
                                if grainmap(y,x,z)~=grainmap(y-1,x,z)
                                    patch('Faces',facymin,'Vertices',cube,'FaceColor',facecolors(y,x,z,1:3)); hold on;
                                end
                            else
                                patch('Faces',facymin,'Vertices',cube,'FaceColor',facecolors(y,x,z,1:3)); hold on;
                            end

                            if y<wymiary(1)
                                if grainmap(y,x,z)~=grainmap(y+1,x,z)
                                    patch('Faces',facymax,'Vertices',cube,'FaceColor',facecolors(y,x,z,1:3)); hold on;
                                end
                            else
                                patch('Faces',facymax,'Vertices',cube,'FaceColor',facecolors(y,x,z,1:3)); hold on;
                            end

                            if x>1
                                if grainmap(y,x,z)~=grainmap(y,x-1,z)
                                    patch('Faces',facxmin,'Vertices',cube,'FaceColor',facecolors(y,x,z,1:3)); hold on;
                                end
                            else
                                patch('Faces',facxmin,'Vertices',cube,'FaceColor',facecolors(y,x,z,1:3)); hold on;
                            end

                            if x<wymiary(2)
                                if grainmap(y,x,z)~=grainmap(y,x+1,z)
                                    patch('Faces',facxmax,'Vertices',cube,'FaceColor',facecolors(y,x,z,1:3)); hold on;
                                end
                            else
                                patch('Faces',facxmax,'Vertices',cube,'FaceColor',facecolors(y,x,z,1:3)); hold on;
                            end

                            if z>1
                                if grainmap(y,x,z)~=grainmap(y,x,z-1)
                                    patch('Faces',faczmin,'Vertices',cube,'FaceColor',facecolors(y,x,z,1:3)); hold on;
                                end
                            else
                                patch('Faces',faczmin,'Vertices',cube,'FaceColor',facecolors(y,x,z,1:3)); hold on;
                            end

                            if z<wymiary(3)
                                if grainmap(y,x,z)~=grainmap(y,x,z+1)
                                    patch('Faces',faczmax,'Vertices',cube,'FaceColor',facecolors(y,x,z,1:3)); hold on;
                                end
                            else
                                patch('Faces',faczmax,'Vertices',cube,'FaceColor',facecolors(y,x,z,1:3)); hold on;
                            end
                        end
                    end
                end
            end
        end % end loop on grains
        clear i z y x;
        clear facxmin facxmax facymin facymax faczmin faczmax;
        clear ver cube lGrain facecolors;
        % end main loop
    % end plotting cubes
end
clear cubes;
% end plot cubes

% plotowanie punktow
if punkty>0

    % wykres punktow w 3D
    if P3D==1
        
        % wykres punktow poczwornych P34
        sP34=size(boundarypoints.P34.coord);
        x=zeros(sP34(1),1);
        y=zeros(sP34(1),1);
        z=zeros(sP34(1),1);
        for i=1:sP34(1)
            x(i)=boundarypoints.P34.coord(i,2);
            y(i)=boundarypoints.P34.coord(i,1);
            z(i)=boundarypoints.P34.coord(i,3);
        end
        plot3(x,y,z,'k.'); hold on;
        clear sP34 i x y z;
        % koniec wykresu punktow poczwornych P34
        
        % wykres punktow wielokrotnych P38
        if isfield(boundarypoints,'P38')
            sP38=size(boundarypoints.P38.coord);
            x=zeros(sP38(1),1);
            y=zeros(sP38(1),1);
            z=zeros(sP38(1),1);
            for i=1:sP38(1)
                x(i)=boundarypoints.P38.coord(i,2);
                y(i)=boundarypoints.P38.coord(i,1);
                z(i)=boundarypoints.P38.coord(i,3);
            end
            plot3(x,y,z,'k*'); hold on;
            clear sP38 i x y z;
        end
        % koniec wykresu punktow wielokrotnych P38

    end
    % koniec wykresu punktow 3D
    
    % wykres punktow 2D
    if P2D==1

        % wykres punktow brzegowych P23
        sP23=size(boundarypoints.P23.coord);
        x=zeros(sP23(1),1);
        y=zeros(sP23(1),1);
        z=zeros(sP23(1),1);
        for i=1:sP23(1)
            x(i)=boundarypoints.P23.coord(i,2);
            y(i)=boundarypoints.P23.coord(i,1);
            z(i)=boundarypoints.P23.coord(i,3);
        end
        plot3(x,y,z,'r.'); hold on;
        clear sP23 i x y z;
        % koniec wykresu punktow brzegowych P23
        
        % wykres wielokrotnych punktow brzegowych P24
        if isfield(boundarypoints,'P24')
            sP24=size(boundarypoints.P24.coord);
            x=zeros(sP24(1),1);
            y=zeros(sP24(1),1);
            z=zeros(sP24(1),1);
            for i=1:sP24(1)
                x(i)=boundarypoints.P24.coord(i,2);
                y(i)=boundarypoints.P24.coord(i,1);
                z(i)=boundarypoints.P24.coord(i,3);
            end
            plot3(x,y,z,'r*'); hold on;
            clear sP24 i x y z;
        end
        % koniec wykresu wielokrotnych punktow brzegowych P24
        
    end
    % koniec wykresu punktow 2D
    
    % wykres punktow 1D
    if P1D==1
        
        % wykres punktow krawedziowych P12
        sP12=size(boundarypoints.P12.coord);
        x=zeros(sP12(1),1);
        y=zeros(sP12(1),1);
        z=zeros(sP12(1),1);
        for i=1:sP12(1)
            x(i)=boundarypoints.P12.coord(i,2);
            y(i)=boundarypoints.P12.coord(i,1);
            z(i)=boundarypoints.P12.coord(i,3);
        end
        plot3(x,y,z,'m.'); hold on;
        clear sP12 i x y z;
        % koniec wykresu punktow krawedziowych P12

        % wykres punktow naroznych P10
        sP10=size(boundarypoints.P10.coord);
        x=zeros(sP10(1),1);
        y=zeros(sP10(1),1);
        z=zeros(sP10(1),1);
        for i=1:sP10(1)
            x(i)=boundarypoints.P10.coord(i,2);
            y(i)=boundarypoints.P10.coord(i,1);
            z(i)=boundarypoints.P10.coord(i,3);
        end
        plot3(x,y,z,'m*'); hold on;
        clear sP10 i x y z;
        % koniec wykresu punktow naroznych P10
        
    end
    % koniec wykresu punktow 1D
    
    % wykres punktow srednich 2D
    if A2D==1
        sA21=size(boundarypoints.A21.coord);
        x=zeros(sA21(1),1);
        y=zeros(sA21(1),1);
        z=zeros(sA21(1),1);
        for i=1:sA21(1)
            x(i)=boundarypoints.A21.coord(i,2);
            y(i)=boundarypoints.A21.coord(i,1);
            z(i)=boundarypoints.A21.coord(i,3);
        end
        plot3(x,y,z,'g.'); hold on;
        clear sA21 i x y z;        
    end
    % koniec wykresu punktow srednich 2D
end
clear punkty P3D P2D P1D A2D;
% koniec plotowania punktow

% plotowanie krawedzi
if linie>0
    
    % wykres krawedzi granic 3D
    if L3==1
        sBL=size(boundarylines.L3.grainno);
        for i=1:sBL(1)
            if boundarylines.L3.points(i,1)==34
                yxz1(1:3)=boundarypoints.P34.coord(boundarylines.L3.points(i,2),1:3);
            elseif boundarylines.L3.points(i,1)==38
                yxz1(1:3)=boundarypoints.P38.coord(boundarylines.L3.points(i,2),1:3);                
            elseif boundarylines.L3.points(i,1)==23
                yxz1(1:3)=boundarypoints.P23.coord(boundarylines.L3.points(i,2),1:3);
            elseif boundarylines.L3.points(i,1)==24
                yxz1(1:3)=boundarypoints.P24.coord(boundarylines.L3.points(i,2),1:3);
            elseif boundarylines.L3.points(i,1)==33
                yxz1(1:3)=boundarypoints.P33.coord(boundarylines.L3.points(i,2),1:3);
            elseif boundarylines.L3.points(i,1)==12
                yxz1(1:3)=boundarypoints.P12.coord(boundarylines.L3.points(i,2),1:3);
            else
                disp('dodaj typy punktow dla L3');
            end
            if boundarylines.L3.points(i,3)==34
                yxz2(1:3)=boundarypoints.P34.coord(boundarylines.L3.points(i,4),1:3);
            elseif boundarylines.L3.points(i,3)==38
                yxz2(1:3)=boundarypoints.P38.coord(boundarylines.L3.points(i,4),1:3);
            elseif boundarylines.L3.points(i,3)==23
                yxz2(1:3)=boundarypoints.P23.coord(boundarylines.L3.points(i,4),1:3);
            elseif boundarylines.L3.points(i,3)==24
                yxz2(1:3)=boundarypoints.P24.coord(boundarylines.L3.points(i,4),1:3);
            elseif boundarylines.L3.points(i,3)==33
                yxz2(1:3)=boundarypoints.P33.coord(boundarylines.L3.points(i,4),1:3);
            elseif boundarylines.L3.points(i,1)==12
                yxz2(1:3)=boundarypoints.P12.coord(boundarylines.L3.points(i,2),1:3);
            else
                disp('dodaj typy punktow dla L3');
            end
            x(1)=yxz1(2);
            x(2)=yxz2(2);
            y(1)=yxz1(1);
            y(2)=yxz2(1);
            z(1)=yxz1(3);
            z(2)=yxz2(3);
            plot3(x,y,z,'k-'); hold on;
        end
        clear sBL i yxz1 yxz2 x y z;
        
        sBL=size(boundarylines.L4.grainno);
        for i=1:sBL(1)
            if boundarylines.L4.points(i,1)==34
                yxz1(1:3)=boundarypoints.P34.coord(boundarylines.L4.points(i,2),1:3);
            elseif boundarylines.L4.points(i,1)==38
                yxz1(1:3)=boundarypoints.P38.coord(boundarylines.L4.points(i,2),1:3);
            elseif boundarylines.L4.points(i,1)==23
                yxz1(1:3)=boundarypoints.P23.coord(boundarylines.L4.points(i,2),1:3);
            elseif boundarylines.L4.points(i,1)==24
                yxz1(1:3)=boundarypoints.P24.coord(boundarylines.L4.points(i,2),1:3);
            elseif boundarylines.L4.points(i,1)==33
                yxz1(1:3)=boundarypoints.P33.coord(boundarylines.L4.points(i,2),1:3);
            elseif boundarylines.L4.points(i,1)==12
                yxz1(1:3)=boundarypoints.P12.coord(boundarylines.L4.points(i,2),1:3);
            else
                disp('dodaj typy punktow dla L4');
            end
            if boundarylines.L4.points(i,3)==34
                yxz2(1:3)=boundarypoints.P34.coord(boundarylines.L4.points(i,4),1:3);
            elseif boundarylines.L4.points(i,3)==38
                yxz2(1:3)=boundarypoints.P38.coord(boundarylines.L4.points(i,4),1:3);
            elseif boundarylines.L4.points(i,3)==23
                yxz2(1:3)=boundarypoints.P23.coord(boundarylines.L4.points(i,4),1:3);
            elseif boundarylines.L4.points(i,3)==24
                yxz2(1:3)=boundarypoints.P24.coord(boundarylines.L4.points(i,4),1:3);
            elseif boundarylines.L4.points(i,3)==33
                yxz2(1:3)=boundarypoints.P33.coord(boundarylines.L4.points(i,4),1:3);
            elseif boundarylines.L4.points(i,3)==12
                yxz2(1:3)=boundarypoints.P12.coord(boundarylines.L4.points(i,4),1:3);
            else
                disp('dodaj typy punktow dla L4');
            end
            x(1)=yxz1(2);
            x(2)=yxz2(2);
            y(1)=yxz1(1);
            y(2)=yxz2(1);
            z(1)=yxz1(3);
            z(2)=yxz2(3);
            plot3(x,y,z,'k-'); hold on;
        end
        clear sBL i yxz1 yxz2 x y z;
    end
    % koniec wykresu krawedzi granic w 3D
    
    % wykres krawedzi granic w 2D
    if L2==1
        ROInames=['ymin'; 'ymax'; 'xmin'; 'xmax'; 'zmin'; 'zmax'];
        for layer=1:6
            sL2=size(boundarylines.L2.(ROInames(layer,1:4)).points);
            for i=1:sL2(1)
                if boundarylines.L2.(ROInames(layer,1:4)).points(i,1)==23
                    yxz1(1:3)=boundarypoints.P23.coord(boundarylines.L2.(ROInames(layer,1:4)).points(i,2),1:3);
                elseif boundarylines.L2.(ROInames(layer,1:4)).points(i,1)==12
                    yxz1(1:3)=boundarypoints.P12.coord(boundarylines.L2.(ROInames(layer,1:4)).points(i,2),1:3);
                elseif boundarylines.L2.(ROInames(layer,1:4)).points(i,1)==24
                    yxz1(1:3)=boundarypoints.P24.coord(boundarylines.L2.(ROInames(layer,1:4)).points(i,2),1:3);
                elseif boundarylines.L2.(ROInames(layer,1:4)).points(i,1)==22
                    yxz1(1:3)=boundarypoints.P22.coord(boundarylines.L2.(ROInames(layer,1:4)).points(i,2),1:3);
                elseif boundarylines.L2.(ROInames(layer,1:4)).points(i,1)==10
                    yxz1(1:3)=boundarypoints.P10.coord(boundarylines.L2.(ROInames(layer,1:4)).points(i,2),1:3);
                else
                    disp('dodaj typy punktow dla L2');
                end
                if boundarylines.L2.(ROInames(layer,1:4)).points(i,3)==23
                    yxz2(1:3)=boundarypoints.P23.coord(boundarylines.L2.(ROInames(layer,1:4)).points(i,4),1:3);
                elseif boundarylines.L2.(ROInames(layer,1:4)).points(i,3)==12
                    yxz2(1:3)=boundarypoints.P12.coord(boundarylines.L2.(ROInames(layer,1:4)).points(i,4),1:3);
                elseif boundarylines.L2.(ROInames(layer,1:4)).points(i,3)==24
                    yxz2(1:3)=boundarypoints.P24.coord(boundarylines.L2.(ROInames(layer,1:4)).points(i,4),1:3);
                elseif boundarylines.L2.(ROInames(layer,1:4)).points(i,3)==22
                    yxz2(1:3)=boundarypoints.P22.coord(boundarylines.L2.(ROInames(layer,1:4)).points(i,4),1:3);
                elseif boundarylines.L2.(ROInames(layer,1:4)).points(i,3)==10
                    yxz2(1:3)=boundarypoints.P10.coord(boundarylines.L2.(ROInames(layer,1:4)).points(i,4),1:3);
                else
                    disp('dodaj typy punktow dla L2');
                end
                x(1)=yxz1(2);
                x(2)=yxz2(2);
                y(1)=yxz1(1);
                y(2)=yxz2(1);
                z(1)=yxz1(3);
                z(2)=yxz2(3);
                plot3(x,y,z,'r-'); hold on;
            end
        end
        clear ROInames layer sL2 yxz1 yxz2 i x y z;
    end
    % koniec wykresu krawedzi granic w 2D
    
    % wykres krawedzi granic w 1D
    if L1==1
        sL1=size(boundarylines.L1.points);
        for i=1:sL1(1)
            if boundarylines.L1.points(i,1)==12
                yxz1(1:3)=boundarypoints.P12.coord(boundarylines.L1.points(i,2),1:3);
            elseif boundarylines.L1.points(i,1)==10
                yxz1(1:3)=boundarypoints.P10.coord(boundarylines.L1.points(i,2),1:3);
            end
            if boundarylines.L1.points(i,3)==12
                yxz2(1:3)=boundarypoints.P12.coord(boundarylines.L1.points(i,4),1:3);
            elseif boundarylines.L1.points(i,3)==10
                yxz2(1:3)=boundarypoints.P10.coord(boundarylines.L1.points(i,4),1:3);
            end
            x(1)=yxz1(2);
            x(2)=yxz2(2);
            y(1)=yxz1(1);
            y(2)=yxz2(1);
            z(1)=yxz1(3);
            z(2)=yxz2(3);
            plot3(x,y,z,'r-'); hold on;
        end
        clear sL1 yxz1 yxz2 i x y z;
    end
    % koniec wykresu krawedzi granic w 1D
    
end
clear linie L3 L2 L1;
% koniec plotowania krawedzi

% plotowanie granic
if granice>0

    % wykres trojkatow 3D
    if T3==1

        % prepare color palette for plotting
        if kolorgranic==2 % grain IPF color
            if ~(exist('Colors','var') && isfield(Colors,'IPFgrains'))
                V05IPFcolorsGrains;
            end
        elseif kolorgranic==3 % grain random color
            if ~(exist('Colors','var') && isfield(Colors,'RandomGrains'))
                V06RandomColorsGrains;
            end
        elseif kolorgranic==4 % triangle normal IPF
            if ~(exist('Colors','var') && isfield(Colors,'IPFtriangles3D'))
                V07IPFcolorsTriangles;
            end
        elseif kolorgranic==5 % grain average misorientation
            if ~(exist('Colors','var') && isfield(Colors,'MisOrTriangles3D'))
                V08MisOrColor;
            end
        end
        % end prepare color palette for plotting

        % pobranie danych roboczych
        T3p=boundaryfaces.T3.points;
        sT3=size(T3p);
        % koniec pobierania danych roboczych

        % rysowanie trojkatow
        for i=1:sT3(1)

            % pobranie wspolrzednych wierzcholkow trojkatow
            x=[0 0 0];
            y=[0 0 0];
            z=[0 0 0];
            for j=1:3
                if T3p(i,2*j-1)==34
                    y(j)=boundarypoints.P34.coord(T3p(i,2*j),1);
                    x(j)=boundarypoints.P34.coord(T3p(i,2*j),2);
                    z(j)=boundarypoints.P34.coord(T3p(i,2*j),3);
                elseif T3p(i,2*j-1)==23
                    y(j)=boundarypoints.P23.coord(T3p(i,2*j),1);
                    x(j)=boundarypoints.P23.coord(T3p(i,2*j),2);
                    z(j)=boundarypoints.P23.coord(T3p(i,2*j),3);
                elseif T3p(i,2*j-1)==38
                    y(j)=boundarypoints.P38.coord(T3p(i,2*j),1);
                    x(j)=boundarypoints.P38.coord(T3p(i,2*j),2);
                    z(j)=boundarypoints.P38.coord(T3p(i,2*j),3);
                elseif T3p(i,2*j-1)==24
                    y(j)=boundarypoints.P24.coord(T3p(i,2*j),1);
                    x(j)=boundarypoints.P24.coord(T3p(i,2*j),2);
                    z(j)=boundarypoints.P24.coord(T3p(i,2*j),3);
                elseif T3p(i,2*j-1)==12
                    y(j)=boundarypoints.P12.coord(T3p(i,2*j),1);
                    x(j)=boundarypoints.P12.coord(T3p(i,2*j),2);
                    z(j)=boundarypoints.P12.coord(T3p(i,2*j),3);
                elseif T3p(i,2*j-1)==32
                    y(j)=boundarypoints.P32.coord(T3p(i,2*j),1);
                    x(j)=boundarypoints.P32.coord(T3p(i,2*j),2);
                    z(j)=boundarypoints.P32.coord(T3p(i,2*j),3);
                elseif T3p(i,2*j-1)==33
                    y(j)=boundarypoints.P33.coord(T3p(i,2*j),1);
                    x(j)=boundarypoints.P33.coord(T3p(i,2*j),2);
                    z(j)=boundarypoints.P33.coord(T3p(i,2*j),3);
                elseif T3p(i,2*j-1)==22
                    y(j)=boundarypoints.P22.coord(T3p(i,2*j),1);
                    x(j)=boundarypoints.P22.coord(T3p(i,2*j),2);
                    z(j)=boundarypoints.P22.coord(T3p(i,2*j),3);
                else
                    disp('brakuje typow punktow');
                end
            end
            clear j;
            % koniec pobierania wspolrzednych wierzcholkow

            % plotting method
            if kolorgranic==0 % green contour
                plot3(x,y,z,'g-'); hold on;
            elseif kolorgranic==1 % green triangles
                patch(x,y,z,'g'); hold on;
            elseif kolorgranic==2 % grain IPF color
                T3g=boundaryfaces.T3.grainno(i,1);
                patch(x,y,z,Colors.IPFgrains(T3g,1:3)); hold on;
            elseif kolorgranic==3 % grain random color
                T3g=boundaryfaces.T3.grainno(i,1);
                patch(x,y,z,Colors.RandomGrains(T3g,1:3)); hold on;
            elseif kolorgranic==4 % triangle normal IPF
                patch(x,y,z,Colors.IPFtriangles3D(i,1:3)); hold on;
            elseif kolorgranic==5 % grain average misorientation
                patch(x,y,z,Colors.MisOrTriangles3D(i,1:3)); hold on;
            end
            % end plotting method

        end
        clear i y x z T3p T3g sT3;
        % koniec rysowania trojkatow
    end
    % koniec wykresu trojkatow 3D

    % wykres trojkatow 2D
    if T2==1

        % prepare color palette for plotting
        if kolorgranic==2 % grain IPF color
            if ~(exist('Colors','var') && isfield(Colors,'IPFgrains'))
                V05IPFcolorsGrains;
            end
        elseif kolorgranic==3 % grain random color
            if ~(exist('Colors','var') && isfield(Colors,'RandomGrains'))
                V06RandomColorsGrains;
            end
        elseif kolorgranic==4 % triangle normal IPF
            if ~(exist('Colors','var') && isfield(Colors,'IPFtriangles2D'))
                V07IPFcolorsTriangles;
            end
        elseif kolorgranic==5 % grain average misorientation
            % outer triangles will be plotted gray
        end
        % end prepare color palette for plotting

        % pobranie danych roboczych
        T2p=boundaryfaces.T2.points;
        sT2p=size(T2p);
        % koniec pobierania danych roboczych

        % rysowanie trojkatow
        for i=1:sT2p(1)

            % pobranie wspolrzednych wierzcholkow trojkatow
            x=[0 0 0 0];
            y=[0 0 0 0];
            z=[0 0 0 0];
            for j=1:3
                if T2p(i,2*j-1)==23
                    y(j)=boundarypoints.P23.coord(T2p(i,2*j),1);
                    x(j)=boundarypoints.P23.coord(T2p(i,2*j),2);
                    z(j)=boundarypoints.P23.coord(T2p(i,2*j),3);
                elseif T2p(i,2*j-1)==22
                    y(j)=boundarypoints.P22.coord(T2p(i,2*j),1);
                    x(j)=boundarypoints.P22.coord(T2p(i,2*j),2);
                    z(j)=boundarypoints.P22.coord(T2p(i,2*j),3);
                elseif T2p(i,2*j-1)==24
                    y(j)=boundarypoints.P24.coord(T2p(i,2*j),1);
                    x(j)=boundarypoints.P24.coord(T2p(i,2*j),2);
                    z(j)=boundarypoints.P24.coord(T2p(i,2*j),3);
                elseif T2p(i,2*j-1)==12
                    y(j)=boundarypoints.P12.coord(T2p(i,2*j),1);
                    x(j)=boundarypoints.P12.coord(T2p(i,2*j),2);
                    z(j)=boundarypoints.P12.coord(T2p(i,2*j),3);
                elseif T2p(i,2*j-1)==21
                    y(j)=boundarypoints.A21.coord(T2p(i,2*j),1);
                    x(j)=boundarypoints.A21.coord(T2p(i,2*j),2);
                    z(j)=boundarypoints.A21.coord(T2p(i,2*j),3);
                elseif T2p(i,2*j-1)==10
                    y(j)=boundarypoints.P10.coord(T2p(i,2*j),1);
                    x(j)=boundarypoints.P10.coord(T2p(i,2*j),2);
                    z(j)=boundarypoints.P10.coord(T2p(i,2*j),3);
                else
                    disp('brakuje typow punktow w T2');
                end
            end
            x(4)=x(1);
            y(4)=y(1);
            z(4)=z(1);
            % koniec pobierania wspolrzednych wierzcholkow
            
            % plotting method
            if kolorgranic==0 % green contour
                plot3(x,y,z,'c-'); hold on;
            elseif kolorgranic==1 % green triangles
                patch(x,y,z,'c'); hold on;
            elseif kolorgranic==2 % grain IPF color
                T2g=boundaryfaces.T2.grainno(i);
                patch(x,y,z,Colors.IPFgrains(T2g,1:3),'EdgeColor','none'); hold on;
            elseif kolorgranic==3 % grain random color
                T2g=boundaryfaces.T2.grainno(i);
                patch(x,y,z,Colors.RandomGrains(T2g,1:3),'EdgeColor','none'); hold on;
            elseif kolorgranic==4 % triangle normal IPF
                patch(x,y,z,Colors.IPFtriangles2D(i,1:3),'EdgeColor','none'); hold on;
            elseif kolorgranic==5 % grain average misorientation
                patch(x,y,z,[0.5 0.5 0.5]); hold on;
            end
            % end plotting method

        end
        clear i j y x z T2p T2g sT2p;
        % koniec rysowania trojkatow
    end
    % koniec wykresu trojkatow 3D
end
clear granice kolorgranic T3 T2;
% koniec plotowania granic

grid on;
axis([0 wymiary(2) 0 wymiary(1) 0 wymiary(3)]);
view(-20,30);
clear wymiary;