% ploter 3D for single grain

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
        T2=1; % trojkaty 2D: 0-nic, 1-tak

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
        IPF=Colors.IPFgrains; % load data
        wymiary=size(grainmap);
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
        wymiary=size(grainmap);
        for z=1:wymiary(3)
            for y=1:wymiary(1)
                for x=1:wymiary(2)
                    if grainmap(y,x,z)==Grain
                        cube=[ver(:,1)+x-1,ver(:,2)+y-1,ver(:,3)+z-1];

                        if y>1
                            if grainmap(y,x,z)~=grainmap(y-1,x,z)
                                patch('Faces',facymin,'Vertices',cube,...
                                    'FaceColor',facecolors(y,x,z,1:3),...
                                    'FaceAlpha',1); hold on;
                            end
                        else
                            patch('Faces',facymin,'Vertices',cube,...
                                'FaceColor',facecolors(y,x,z,1:3),...
                                'FaceAlpha',1); hold on;
                        end

                        if y<wymiary(1)
                            if grainmap(y,x,z)~=grainmap(y+1,x,z)
                                patch('Faces',facymax,'Vertices',cube,...
                                    'FaceColor',facecolors(y,x,z,1:3),...
                                    'FaceAlpha',1); hold on;
                            end
                        else
                            patch('Faces',facymax,'Vertices',cube,...
                                'FaceColor',facecolors(y,x,z,1:3),...
                                'FaceAlpha',1); hold on;
                        end

                        if x>1
                            if grainmap(y,x,z)~=grainmap(y,x-1,z)
                                patch('Faces',facxmin,'Vertices',cube,...
                                    'FaceColor',facecolors(y,x,z,1:3),...
                                    'FaceAlpha',1); hold on;
                            end
                        else
                            patch('Faces',facxmin,'Vertices',cube,...
                                'FaceColor',facecolors(y,x,z,1:3),...
                                'FaceAlpha',1); hold on;
                        end

                        if x<wymiary(2)
                            if grainmap(y,x,z)~=grainmap(y,x+1,z)
                                patch('Faces',facxmax,'Vertices',cube,...
                                    'FaceColor',facecolors(y,x,z,1:3),...
                                    'FaceAlpha',1); hold on;
                            end
                        else
                            patch('Faces',facxmax,'Vertices',cube,...
                                'FaceColor',facecolors(y,x,z,1:3),...
                                'FaceAlpha',1); hold on;
                        end

                        if z>1
                            if grainmap(y,x,z)~=grainmap(y,x,z-1)
                                patch('Faces',faczmin,'Vertices',cube,...
                                    'FaceColor',facecolors(y,x,z,1:3),...
                                    'FaceAlpha',1); hold on;
                            end
                        else
                            patch('Faces',faczmin,'Vertices',cube,...
                            'FaceColor',facecolors(y,x,z,1:3),...
                            'FaceAlpha',1); hold on;
                        end

                        if z<wymiary(3)
                            if grainmap(y,x,z)~=grainmap(y,x,z+1)
                                patch('Faces',faczmax,'Vertices',cube,...
                                    'FaceColor',facecolors(y,x,z,1:3),...
                                    'FaceAlpha',1); hold on;
                            end
                        else
                            patch('Faces',faczmax,'Vertices',cube,...
                                'FaceColor',facecolors(y,x,z,1:3),...
                                'FaceAlpha',1); hold on;
                        end
                    end
                end
            end
        end
        clear y x z;
        clear facxmin facxmax facymin facymax faczmin faczmax;
        clear ver cube lgrain facecolors;
        % end main loop
    % end plotting cubes
end
clear cubes;
% end plot cubes

% plotowanie punktow
if punkty>0

    % wykres punktow w 3D
    if P3D==1

        % wykres P34
        if isfield(boundarypoints,'P34')
            sP34=size(boundarypoints.P34.grainno);
            for i=1:sP34(1)
                if (boundarypoints.P34.grainno(i,1)==Grain ...
                        || boundarypoints.P34.grainno(i,2)==Grain ...
                        || boundarypoints.P34.grainno(i,3)==Grain ...
                        || boundarypoints.P34.grainno(i,4)==Grain)
                    plot3(boundarypoints.P34.coord(i,2),...
                        boundarypoints.P34.coord(i,1),...
                        boundarypoints.P34.coord(i,3),'k.'); hold on;
                end
            end
            clear i sP34;
        else
            disp('brakuje tablicy boundarypoints.P34');
        end
        % koniec wykresu P34
        
        % wykres P38
        if isfield(boundarypoints,'P38')
            sP38=size(boundarypoints.P38.grainno);
            for i=1:sP38(1)
                for j=1:sP38(2)
                    if boundarypoints.P38.grainno(i,j)==Grain
                        plot3(boundarypoints.P38.coord(i,2),...
                            boundarypoints.P38.coord(i,1),...
                            boundarypoints.P38.coord(i,3),'k*'); hold on;
                    end
                end
            end
            clear i j sP38;
        end
        % koniec wykresu P38

    end
    % koniec wykresu punktow 3D
    
    % wykres punktow 2D
    if P2D==1
        
        % wykres P23
        if isfield(boundarypoints,'P23')
            sP23=size(boundarypoints.P23.grainno);
            for i=1:sP23(1)
                if (boundarypoints.P23.grainno(i,1)==Grain ...
                        || boundarypoints.P23.grainno(i,2)==Grain ...
                        || boundarypoints.P23.grainno(i,3)==Grain)
                    plot3(boundarypoints.P23.coord(i,2),...
                        boundarypoints.P23.coord(i,1),...
                        boundarypoints.P23.coord(i,3),'r.'); hold on;
                end
            end
            clear i sP23;
        else
            disp('brakuje tablicy boundarypoints.P23');
        end
        % koniec wykersu P23
        
        % wykres P24
        if isfield(boundarypoints,'P24')
            sP24=size(boundarypoints.P24.grainno);
            for i=1:sP24(1)
                if (boundarypoints.P24.grainno(i,1)==Grain ...
                        || boundarypoints.P24.grainno(i,2)==Grain ...
                        || boundarypoints.P24.grainno(i,3)==Grain ...
                        || boundarypoints.P24.grainno(i,4)==Grain)
                    plot3(boundarypoints.P24.coord(i,2),...
                        boundarypoints.P24.coord(i,1),...
                        boundarypoints.P24.coord(i,3),'r*'); hold on;
                end
            end
            clear i sP24;
        end
        % koniec wykresu wielokrotnych punktow brzegowych P24
        
    end
    % koniec wykresu punktow 2D

    % wykres punktow 1D
    if P1D==1
        
        % wykres P12
        if isfield(boundarypoints,'P12')
            sP12=size(boundarypoints.P12.grainno);
            for i=1:sP12(1)
                if (boundarypoints.P12.grainno(i,1)==Grain ...
                        || boundarypoints.P12.grainno(i,2)==Grain)
                    plot3(boundarypoints.P12.coord(i,2),...
                        boundarypoints.P12.coord(i,1),...
                        boundarypoints.P12.coord(i,3),'m.'); hold on;
                end
            end
            clear i sP12;
        else
            disp('brakuje tablicy boundarypoints.P12');
        end
        % koniec P12

        % wykres P10
        if isfield(boundarypoints,'P10')
            sP10=size(boundarypoints.P10.grainno);
            for i=1:sP10(1)
                if boundarypoints.P10.grainno(i)==Grain
                    plot3(boundarypoints.P12.coord(i,2),...
                        boundarypoints.P10.coord(i,1),...
                        boundarypoints.P10.coord(i,3),'m*'); hold on;
                end
            end
            clear i sP10;
        end
        % koniec P10

    end
    % koniec wykresu punktow 1D

    % wykres punktow srednich 2D
    if A2D==1
        if isfield(boundarypoints,'A21')
            sA21=size(boundarypoints.A21.grainno);
            for i=1:sA21(1)
                if (boundarypoints.A21.grainno(i,1)==Grain ...
                        || boundarypoints.A21.grainno(i,2)==Grain)
                    plot3(boundarypoints.A21.coord(i,2),...
                        boundarypoints.A21.coord(i,1),...
                        boundarypoints.A21.coord(i,3),'g.'); hold on;
                end
            end
            clear i sA21;
        end
    end
    % koniec wykresu punktow srednich 2D

end
clear punkty P3D P2D P1D A2D;
% koniec plotowania punktow

% plotowanie krawedzi
if linie>0

    % wykres krawedzi 3D
    if L3==1

        % wykres L3
        if isfield(boundarylines,'L3')
            sBL=size(boundarylines.L3.grainno);
            for i=1:sBL(1)
                for j=1:sBL(2)
                    if boundarylines.L3.grainno(i,j)==Grain
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
                end
            end
            clear i j sBL yxz1 yxz2 x y z;
        else
            disp('brakuje tablicy boundarylines.L3');
        end
        % koniec wykresu L3

        % wykres L4
        if isfield(boundarylines,'L4')
            sBL=size(boundarylines.L4.grainno);
            for i=1:sBL(1)
                for j=1:sBL(2)
                    if boundarylines.L4.grainno(i,j)==Grain
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
                end
            end
            clear i j sBL yxz1 yxz2 x y z;
        end
        % koniec wykresu L4

    end
    % koniec wykresu krawedzi 3D

    % wykres krawedzi 2D
    if L2==1
        if isfield(boundarylines,'L2')
            ROInames=['ymin'; 'ymax'; 'xmin'; 'xmax'; 'zmin'; 'zmax'];
            for layer=1:6
                sL2=size(boundarylines.L2.(ROInames(layer,1:4)).grainno);
                for i=1:sL2(1)
                    for j=1:sL2(2)
                        if boundarylines.L2.(ROInames(layer,1:4)).grainno(i,j)==Grain
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
                end
            end
            clear layer i j ROInames sL2 yxz1 yxz2 y x z;
        else
            disp('brakuje tablicy boundarylines.L2');
        end
    end
    % koniec wykresu krawedzi 2D
    
    % wykres krawedzi 1D
    if L1==1
        if isfield(boundarylines,'L1')
            sL1=size(boundarylines.L1.grainno);
            for i=1:sL1(1)
                if boundarylines.L1.grainno(i)==Grain
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
            end
            clear sL1 yxz1 yxz2 i x y z;
        end
    end
    % koniec wykresu krawedzi 1D
    
end
clear linie L3 L2 L1;
% koniec plotowania krawedzi

% plotowanie granic
if granice>0

    % wykres trojkatow 3D
    if T3==1
        if isfield(boundaryfaces,'T3')

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
                if ~(exist('Colors','var') && isfield(Colors,'MisOrTriangles3D'))
                    V08MisOrColor;
                end
            end
            % end prepare color palette for plotting

            T3p=boundaryfaces.T3.points;
            sT3=size(boundaryfaces.T3.grainno);
            for i=1:sT3(1)
                if (boundaryfaces.T3.grainno(i,1)==Grain ...
                        || boundaryfaces.T3.grainno(i,2)==Grain)
                    
                    % pobieranie wspolrzednych wierzcholkow
                    yxz=[0 0 0;0 0 0;0 0 0];
                    for j=1:3
                        if T3p(i,2*j-1)==34
                            yxz(j,1:3)=boundarypoints.P34.coord(T3p(i,2*j),1:3);
                        elseif T3p(i,2*j-1)==23
                            yxz(j,1:3)=boundarypoints.P23.coord(T3p(i,2*j),1:3);
                        elseif T3p(i,2*j-1)==38
                            yxz(j,1:3)=boundarypoints.P38.coord(T3p(i,2*j),1:3);
                        elseif T3p(i,2*j-1)==24
                            yxz(j,1:3)=boundarypoints.P24.coord(T3p(i,2*j),1:3);
                        elseif T3p(i,2*j-1)==12
                            yxz(j,1:3)=boundarypoints.P12.coord(T3p(i,2*j),1:3);
                        elseif T3p(i,2*j-1)==32
                            yxz(j,1:3)=boundarypoints.P32.coord(T3p(i,2*j),1:3);
                        elseif T3p(i,2*j-1)==33
                            yxz(j,1:3)=boundarypoints.P33.coord(T3p(i,2*j),1:3);
                        elseif T3p(i,2*j-1)==22
                            yxz(j,1:3)=boundarypoints.P22.coord(T3p(i,2*j),1:3);
                        else
                            disp('brakuje typow punktow');
                        end
                    end
                    clear j;
                    % koniec pobierania wspolrzednych wierzcholkow

                    % plotting method
                    if kolorgranic==0 % green contour
                        plot3(yxz(1:3,2),yxz(1:3,1),yxz(1:3,3),'g-'); hold on;
                    elseif kolorgranic==1 % green triangles
                        patch(yxz(1:3,2),yxz(1:3,1),yxz(1:3,3),'g'); hold on;
                    elseif kolorgranic==2 % grain IPF color
                        patch(yxz(1:3,2),yxz(1:3,1),yxz(1:3,3),Colors.IPFgrains(Grain,1:3)); hold on;
                    elseif kolorgranic==3 % grain random color
                        patch(yxz(1:3,2),yxz(1:3,1),yxz(1:3,3),Colors.RandomGrains(Grain,1:3)); hold on;
                    elseif kolorgranic==4 % triangle normal IPF
                        patch(yxz(1:3,2),yxz(1:3,1),yxz(1:3,3),Colors.IPFtriangles3D(i,1:3)); hold on;
                    elseif kolorgranic==5 % grain average misorientation
                        patch(yxz(1:3,2),yxz(1:3,1),yxz(1:3,3),Colors.MisOrTriangles3D(i,1:3)); hold on;
                    end
                    % end plotting method

                end
            end
            clear i yxz T3p T3c T3g sT3;
        else
            disp('table boundaryfaces.T3 is missing');
        end
    end
    % koniec wykresu trojkatow 3D

    % wykres trojkatow 2D
    if T2==1
        if isfield(boundaryfaces,'T2')

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
            
            T2p=boundaryfaces.T2.points;
            sT2=size(boundaryfaces.T2.grainno);
            for i=1:sT2(1)
                if boundaryfaces.T2.grainno(i)==Grain
                    
                    % pobieranie wspolrzednych wierzcholkow
                    yxz=[0 0 0;0 0 0;0 0 0];
                    for j=1:3
                        if T2p(i,2*j-1)==23
                            yxz(j,1:3)=boundarypoints.P23.coord(T2p(i,2*j),1:3);
                        elseif T2p(i,2*j-1)==22
                            yxz(j,1:3)=boundarypoints.P22.coord(T2p(i,2*j),1:3);
                        elseif T2p(i,2*j-1)==24
                            yxz(j,1:3)=boundarypoints.P24.coord(T2p(i,2*j),1:3);
                        elseif T2p(i,2*j-1)==12
                            yxz(j,1:3)=boundarypoints.P12.coord(T2p(i,2*j),1:3);
                        elseif T2p(i,2*j-1)==21
                            yxz(j,1:3)=boundarypoints.A21.coord(T2p(i,2*j),1:3);
                        elseif T2p(i,2*j-1)==10
                            yxz(j,1:3)=boundarypoints.P10.coord(T2p(i,2*j),1:3);
                        else
                            disp('brakuje typow punktow w T2');
                        end
                    end
                    % koniec pobierania wspolrzednych wierzcholkow
                    
                    % plottong method
                    if kolorgranic==0 % cyan contour
                        plot3(yxz(1:3,2),yxz(1:3,1),yxz(1:3,3),'c-'); hold on;
                    elseif kolorgranic==1 % cyan triangles
                        patch(yxz(1:3,2),yxz(1:3,1),yxz(1:3,3),'c'); hold on;
                    elseif kolorgranic==2 % grain IPF color
                        patch(yxz(1:3,2),yxz(1:3,1),yxz(1:3,3),Colors.IPFgrains(Grain,1:3)); hold on;
                    elseif kolorgranic==3 % grain random color
                        patch(yxz(1:3,2),yxz(1:3,1),yxz(1:3,3),Colors.RandomGrains(Grain,1:3)); hold on;
                    elseif kolorgranic==4 % triangle normal IPF
                        patch(yxz(1:3,2),yxz(1:3,1),yxz(1:3,3),Colors.IPFtriangles2D(i,1:3)); hold on;
                    elseif kolorgranic==5 % grain average misorientation
                        patch(yxz(1:3,2),yxz(1:3,1),yxz(1:3,3),[0.5 0.5 0.5]); hold on;
                    end
                    % end plotting method

                end
            end
            clear i j yxz T2p sT2;
        end   
    end
    % koniec wykresu trojkatow 3D
end
clear granice kolorgranic T3 T2;
% koniec plotowania granic

grid on;
axis equal;
% axis([0 wymiary(2) 0 wymiary(1) 0 wymiary(3)]);
view(-20,30);
clear wymiary;