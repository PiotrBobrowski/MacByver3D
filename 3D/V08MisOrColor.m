% calculate misorientation colors for triangles
tic

if exist('boundaryfaces','var')

    if ~(exist('Neighbors','var') && isfield(Neighbors,'Pairs'))
        P03Neighbors;
    end

    if ~(exist('Neighbors','var') && isfield(Neighbors,'Angles'))
        S02NeighborMisorientations;
    end

    % create color palette
    MisOrPalette=zeros(65,3); % initialization: color palette
    MisOrPalette(1,3)=1; % B(1)

    for i=2:15 % loop on angles 0-15deg
        MisOrPalette(i,3)=1-i/15; % B(2:15)
        MisOrPalette(i,2)=i/15; % G(2:15)
    end
    clear i;

    for i=1:50 % loop on angles 15-65deg
        MisOrPalette(i+15,2)=1-i/50; % B(16:65)
        MisOrPalette(i+15,1)=i/50; % R(16:65)
    end
    clear i;

        % brightness normalization
        for i=1:65
            mx=max(MisOrPalette(i,1:3));
            MisOrPalette(i,1:3)=MisOrPalette(i,1:3)/mx;
        end
        clear i mx;
        % end brightness normalization

    % end create color palette
    
    % 3D triangles colors
    sT3=size(boundaryfaces.T3.grainno);
    MisOrColor=zeros(sT3(1),3); % initialization: triangles colors
    for i=1:sT3(1) % loop on triangles
        gn1=boundaryfaces.T3.grainno(i,1); % get grain number 1
        gn2=boundaryfaces.T3.grainno(i,2); % get grain number 2
        pair=find(Neighbors.Pairs(:,1)==gn1 & Neighbors.Pairs(:,2)==gn2,1); % get pair number
        alfa=ceil(Neighbors.Angles(pair)); % get rounded misor angle for the pair
        if alfa>65
            alfa=65;
        end
        MisOrColor(i,1:3)=MisOrPalette(alfa,1:3); % save the color
    end % end loop on triangles
    clear i gn1 gn2 pair alfa sT3;
    % end 3D triangles colors

    % save the data
    Colors.MisOrTriangles3D=MisOrColor;
    clear MisOrColor MisOrPalette;
    % end save the data

else
    disp('variable boundaryfaces is missing');
end

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;