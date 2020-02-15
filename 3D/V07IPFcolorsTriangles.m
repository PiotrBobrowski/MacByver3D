% calculate IPF color for each triangle
tic

if exist('boundaryfaces','var')

    % define main directions in C reference
    % V1=[001], V2=[101], V3=[111]
    V1=[0 0 1;0 1 0;1 0 0];
    V2=[1 0 1;1 1 0;0 1 1;-1 0 1;-1 1 0;0 -1 1];
    V3=[1 1 1;1 1 -1;1 -1 1;-1 1 1];
    % end define main directions in C reference

    % 3D triangles colors
    if ~isfield(boundaryfaces.T3,'normal')
        P04TriangleNormals;
    end

    if ~(exist('Statistics','var') && isfield(Statistics,'AverageOrientations'))
        P02AverageOrientation;
    end

        % main loop
        sT3=size(boundaryfaces.T3.grainno);
        alfa=zeros(sT3(1),6); % initialization: angles to C directions
        T3c=zeros(sT3(1),6); % initialization: IPF color table for triangles

        for i=1:sT3(1) % loop on triangles
            for j=1:2 % loop on 2 sides of triangle
            
                % load data
                Ns(1:3)=boundaryfaces.T3.normal(i,1:3); % Normal in S reference
                M(1:3,1:3)=Statistics.AverageOrientations(...
                    1:3,1:3,boundaryfaces.T3.grainno(i,j)); % orientation matrix
                % end load data
                
                if ~isnan(Ns(1))
                    Nc=M*Ns'; % Normal in C reference
                end
                
                % calculate angles to [001]
                alfa1=[0 0 0]; % store all symmetric solutions
                NcxV1=[0 0 0]; % cross product Nc x V001
                for v1=1:3
                    NcxV1(1)=Nc(2)*V1(v1,3)-Nc(3)*V1(v1,2);
                    NcxV1(2)=Nc(3)*V1(v1,1)-Nc(1)*V1(v1,3);
                    NcxV1(3)=Nc(1)*V1(v1,2)-Nc(2)*V1(v1,1);
                    alfa1(v1)=180/pi*asin(sqrt(NcxV1(1)^2+NcxV1(2)^2+NcxV1(3)^2));
                end
                alfa(i,3*(j-1)+1)=min(alfa1);
                clear v1;
                % end calculate angles to [001]

                % calculate angles to [101]
                alfa2=[0 0 0 0 0 0]; % store all symmetric solutions
                NcxV2=[0 0 0]; % cross product Nc x V101
                for v2=1:6
                    NcxV2(1)=Nc(2)*V2(v2,3)-Nc(3)*V2(v2,2);
                    NcxV2(2)=Nc(3)*V2(v2,1)-Nc(1)*V2(v2,3);
                    NcxV2(3)=Nc(1)*V2(v2,2)-Nc(2)*V2(v2,1);
                    alfa2(v2)=180/pi*asin(sqrt((NcxV2(1)^2+NcxV2(2)^2+NcxV2(3)^2)/2));
                end
                alfa(i,3*(j-1)+2)=min(alfa2);
                clear v2;
                % end calculate angles to [101]

                % calculate angles to [111]
                alfa3=[0 0 0 0]; % store all symmetric solutions
                NcxV3=[0 0 0]; % cross product Nc x V111
                for v3=1:4
                    NcxV3(1)=Nc(2)*V3(v3,3)-Nc(3)*V3(v3,2);
                    NcxV3(2)=Nc(3)*V3(v3,1)-Nc(1)*V3(v3,3);
                    NcxV3(3)=Nc(1)*V3(v3,2)-Nc(2)*V3(v3,1);
                    alfa3(v3)=180/pi*asin(sqrt((NcxV3(1)^2+NcxV3(2)^2+NcxV3(3)^2)/3));
                end
                alfa(i,3*(j-1)+3)=min(alfa3);
                clear v3;
                % end calculate angles to [111]
                
                % construct IPF palette
                T3c(i,3*(j-1)+1)=1-(alfa(i,3*(j-1)+1)/54.74); % R
                T3c(i,3*(j-1)+2)=1-(alfa(i,3*(j-1)+2)/45.00); % G
                T3c(i,3*(j-1)+3)=1-(alfa(i,3*(j-1)+3)/54.74); % B
                clear alfa;
                % end construct IPF palette

            end % end loop on 2 sides of triangle
        end % end loop on triangles
        clear i j Ns Nc M;
        clear alfa1 alfa2 alfa3 NcxV1 NcxV2 NcxV3;
        % end main loop

        % brightness normalization
        for i=1:sT3(1)
            for j=1:2
                maxIPF=max(T3c(i,3*(j-1)+1:3*(j-1)+3));
                T3c(i,3*(j-1)+1)=T3c(i,3*(j-1)+1)/maxIPF;
                T3c(i,3*(j-1)+2)=T3c(i,3*(j-1)+2)/maxIPF;
                T3c(i,3*(j-1)+3)=T3c(i,3*(j-1)+3)/maxIPF;
            end
        end
        clear i j maxIPF;
        % end brightness normalization
        
        % save the data
        Colors.IPFtriangles3D=T3c;
        clear T3c sT3;
        % end save the data
    
    % end 3D triangles colors
    
    % 2D triangles colors
    if ~isfield(boundaryfaces.T2,'normal')
        P04TriangleNormals;
    end
    
    if ~(exist('Statistics','var') && isfield(Statistics,'AverageOrientations'))
        P02AverageOrientation;
    end
    
        % main loop
        sT2=size(boundaryfaces.T2.grainno);
        alfa=zeros(sT2(1),3); % initialization: angles to C directions
        T2c=zeros(sT2(1),3); % initialization: IPF color table for triangles

        for i=1:sT2(1) % loop on triangles
            
            % load data
            Ns(1:3)=boundaryfaces.T2.normal(i,1:3); % Normal in S reference
            M(1:3,1:3)=Statistics.AverageOrientations(...
                1:3,1:3,boundaryfaces.T2.grainno(i)); % orientation matrix
            % end load data

            Nc=M*Ns'; % Normal in C reference
                
            % calculate angles to [001]
            alfa1=[0 0 0]; % store all symmetric solutions
            NcxV1=[0 0 0]; % cross product Nc x V001
            for v1=1:3
                NcxV1(1)=Nc(2)*V1(v1,3)-Nc(3)*V1(v1,2);
                NcxV1(2)=Nc(3)*V1(v1,1)-Nc(1)*V1(v1,3);
                NcxV1(3)=Nc(1)*V1(v1,2)-Nc(2)*V1(v1,1);
                alfa1(v1)=180/pi*asin(sqrt(NcxV1(1)^2+NcxV1(2)^2+NcxV1(3)^2));
            end
            alfa(i,1)=min(alfa1);
            clear v1;
            % end calculate angles to [001]

            % calculate angles to [101]
            alfa2=[0 0 0 0 0 0]; % store all symmetric solutions
            NcxV2=[0 0 0]; % cross product Nc x V101
            for v2=1:6
                NcxV2(1)=Nc(2)*V2(v2,3)-Nc(3)*V2(v2,2);
                NcxV2(2)=Nc(3)*V2(v2,1)-Nc(1)*V2(v2,3);
                NcxV2(3)=Nc(1)*V2(v2,2)-Nc(2)*V2(v2,1);
                alfa2(v2)=180/pi*asin(sqrt((NcxV2(1)^2+NcxV2(2)^2+NcxV2(3)^2)/2));
            end
            alfa(i,2)=min(alfa2);
            clear v2;
            % end calculate angles to [101]

            % calculate angles to [111]
            alfa3=[0 0 0 0]; % store all symmetric solutions
            NcxV3=[0 0 0]; % cross product Nc x V111
            for v3=1:4
                NcxV3(1)=Nc(2)*V3(v3,3)-Nc(3)*V3(v3,2);
                NcxV3(2)=Nc(3)*V3(v3,1)-Nc(1)*V3(v3,3);
                NcxV3(3)=Nc(1)*V3(v3,2)-Nc(2)*V3(v3,1);
                alfa3(v3)=180/pi*asin(sqrt((NcxV3(1)^2+NcxV3(2)^2+NcxV3(3)^2)/3));
            end
            alfa(i,3)=min(alfa3);
            clear v3;
            % end calculate angles to [111]
                
            % construct IPF palette
            T2c(i,1)=1-(alfa(i,1)/54.74); % R
            T2c(i,2)=1-(alfa(i,2)/45.00); % G
            T2c(i,3)=1-(alfa(i,3)/54.74); % B
            clear i alfa;
            % end construct IPF palette

        end % end loop on triangles
        clear i Ns Nc M;
        clear alfa1 alfa2 alfa3 NcxV1 NcxV2 NcxV3;
        % end main loop

        % brightness normalization
        for i=1:sT2(1)
            maxIPF=max(T2c(i,1:3));
            T2c(i,1)=T2c(i,1)/maxIPF;
            T2c(i,2)=T2c(i,2)/maxIPF;
            T2c(i,3)=T2c(i,3)/maxIPF;
        end
        clear i maxIPF;
        % end brightness normalization
        
        % save the data
        Colors.IPFtriangles2D=T2c;
        clear T2c sT2;
        % end save the data

    % end 2D triangles colors
    
    clear V1 V2 V3;
else
    disp('variable boundaryfaces is missing');
end

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;