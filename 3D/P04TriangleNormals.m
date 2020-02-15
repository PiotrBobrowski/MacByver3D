% calculate triangle normals

if exist('boundaryfaces','var')

    % 3D triangle normals
    if isfield(boundaryfaces,'T3')

        % load data
        T3p=boundaryfaces.T3.points;
        sT3=size(T3p);
        SS=ScanStep.xstep^2;
        % end load data

       % initialization
        Normal=zeros(sT3(1),3);
        Area=zeros(sT3(1),1);
        % end initialization

        % main loop
        for i=1:sT3(1) % loop on triangles
            Pc=[0 0 0];

            % load points coordinates
            for j=1:3 % loop on points of triangle
                if T3p(i,2*j-1)==32
                    Pc(j,1:3)=boundarypoints.P32.coord(T3p(i,2*j),1:3);
                elseif T3p(i,2*j-1)==33
                    Pc(j,1:3)=boundarypoints.P33.coord(T3p(i,2*j),1:3);
                elseif T3p(i,2*j-1)==34
                    Pc(j,1:3)=boundarypoints.P34.coord(T3p(i,2*j),1:3);
                elseif T3p(i,2*j-1)==22
                    Pc(j,1:3)=boundarypoints.P22.coord(T3p(i,2*j),1:3);
                elseif T3p(i,2*j-1)==23
                    Pc(j,1:3)=boundarypoints.P23.coord(T3p(i,2*j),1:3);
                elseif T3p(i,2*j-1)==12
                    Pc(j,1:3)=boundarypoints.P12.coord(T3p(i,2*j),1:3);
                else
                    disp('some types of points are missing');
                end
            end % end loop on points of triangle
            clear j;
            % end load points coordinates

            % calculate vectors
            W1=Pc(1,1:3)-Pc(2,1:3);
            W2=Pc(1,1:3)-Pc(3,1:3);
            if W1(3)<0
                W1=-W1;
            end
            if W2(3)<0
                W2=-W2;
            end
            % end calculate vectors

            % calculate vector product
            y=W1(2)*W2(3)-W1(3)*W2(2);
            x=W1(3)*W2(1)-W1(1)*W2(3);
            z=W1(1)*W2(2)-W1(2)*W2(1);
            l=(y^2+x^2+z^2)^0.5;
            % end calculate vector product

            % normalize vector length
            y=y/l;
            x=x/l;
            z=z/l;
            % end normalize vector length

            % convert to positive hemisphere
            if z<0
                y=-y; x=-x; z=-z;
            elseif z==0
                if x<0
                    y=-y; x=-x;
                elseif x==0
                    if y<0
                        y=-y;
                    end
                end
            end
            % end convert to positive hemisphere

            % save the result
            Normal(i,1:3)=[y x z];
            Area(i)=l/2*SS;
            % end save the result

        end % end loop on triangles
        clear i Pc W1 W2 y x z l T3p sT3 SS;
        % end main loop

        % save the data
        boundaryfaces.T3.area=Area;
        boundaryfaces.T3.normal=Normal;
        clear Area Normal;
        % end save the data

    else
        disp('field T3 in boundaryfaces is missing');
    end
    % end 3D triangle normals
    
    % 2D triangle normals
    if isfield(boundaryfaces,'T2')

        % load data
        T2p=boundaryfaces.T2.points;
        sT2=size(T2p);
        SS=ScanStep.xstep^2;
        % end load data

       % initialization
        Normal=zeros(sT2(1),3);
        Area=zeros(sT2(1),1);
        % end initialization

        % main loop
        for i=1:sT2(1) % loop on triangles
            Pc=[0 0 0];

            % load points coordinates
            for j=1:3 % loop on points of triangle
                if T2p(i,2*j-1)==21
                    Pc(j,1:3)=boundarypoints.A21.coord(T2p(i,2*j),1:3);
                elseif T2p(i,2*j-1)==23
                    Pc(j,1:3)=boundarypoints.P23.coord(T2p(i,2*j),1:3);
                elseif T2p(i,2*j-1)==12
                    Pc(j,1:3)=boundarypoints.P12.coord(T2p(i,2*j),1:3);
                elseif T2p(i,2*j-1)==10
                    Pc(j,1:3)=boundarypoints.P10.coord(T2p(i,2*j),1:3);
                else
                    disp('some types of points are missing');
                end
            end % end loop on points of triangle
            clear j;
            % end load points coordinates

            % calculate vectors
            W1=Pc(1,1:3)-Pc(2,1:3);
            W2=Pc(1,1:3)-Pc(3,1:3);
            if W1(3)<0
                W1=-W1;
            end
            if W2(3)<0
                W2=-W2;
            end
            % end calculate vectors

            % calculate vector product
            y=W1(2)*W2(3)-W1(3)*W2(2);
            x=W1(3)*W2(1)-W1(1)*W2(3);
            z=W1(1)*W2(2)-W1(2)*W2(1);
            l=(y^2+x^2+z^2)^0.5;
            % end calculate vector product

            % normalize vector length
            y=y/l;
            x=x/l;
            z=z/l;
            % end normalize vector length

            % convert to positive hemisphere
            if z<0
                y=-y; x=-x; z=-z;
            elseif z==0
                if x<0
                    y=-y; x=-x;
                elseif x==0
                    if y<0
                        y=-y;
                    end
                end
            end
            % end convert to positive hemisphere

            % save the result
            Normal(i,1:3)=[y x z];
            Area(i)=l/2*SS;
            % end save the result

        end % end loop on triangles
        clear i Pc W1 W2 y x z l T2p sT2 SS;
        % end main loop

        % save the data
        boundaryfaces.T2.area=Area;
        boundaryfaces.T2.normal=Normal;
        clear Area Normal;
        % end save the data

    else
        disp('field T2 in boundaryfaces is missing');
    end
    % end 2D triangle normals

else
    disp('variable boundaryfaces is missing');
end