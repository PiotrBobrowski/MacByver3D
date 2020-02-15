% calculate IPF colors for every voxel
tic

% IPF reference direction
IPF=3; % 1-RD, 2-TD, 3=ND

if exist('ormatrix','var')
    wymiary=size(ormatrix);

    % define main directions in C reference
    % V1=[001], V2=[101], V3=[111]
    V1=[0 0 1;0 1 0;1 0 0];
    V2=[1 0 1;1 1 0;0 1 1;-1 0 1;-1 1 0;0 -1 1];
    V3=[1 1 1;1 1 -1;1 -1 1;-1 1 1];
    % end define main directions in C reference

    % calculate angles to S main axes
    alfa=zeros(wymiary(1),wymiary(2),wymiary(3),3); % min angles to C directions
    for z=1:wymiary(3)
        for x=1:wymiary(2)
            for y=1:wymiary(1)
                M(1:3,1:3)=ormatrix(y,x,z,1:3,1:3); % load data

                % calculate angles to [001]
                alfa1=[0 0 0]; % store all symmetric solutions
                NcxV1=[0 0 0]; % cross product M(IPF) x V001
                for v1=1:3
                    NcxV1(1)=M(2,IPF)*V1(v1,3)-M(3,IPF)*V1(v1,2);
                    NcxV1(2)=M(3,IPF)*V1(v1,1)-M(1,IPF)*V1(v1,3);
                    NcxV1(3)=M(1,IPF)*V1(v1,2)-M(2,IPF)*V1(v1,1);
                    alfa1(v1)=180/pi*asin(sqrt(NcxV1(1)^2+NcxV1(2)^2+NcxV1(3)^2));
                end
                clear v1;
                alfa(y,x,z,1)=min(alfa1);
                % end calculate angles to [001]

                % calculate angles to [101]
                alfa2=[0 0 0 0 0 0]; % store all symmetric solutions
                NcxV2=[0 0 0]; % cross product M(IPF) x V101
                for v2=1:6
                    NcxV2(1)=M(2,IPF)*V2(v2,3)-M(3,IPF)*V2(v2,2);
                    NcxV2(2)=M(3,IPF)*V2(v2,1)-M(1,IPF)*V2(v2,3);
                    NcxV2(3)=M(1,IPF)*V2(v2,2)-M(2,IPF)*V2(v2,1);
                    alfa2(v2)=180/pi*asin(sqrt((NcxV2(1)^2+NcxV2(2)^2+NcxV2(3)^2)/2));
                end
                clear v2;
                alfa(y,x,z,2)=min(alfa2);
                % end calculate angles to [101]
                
                % calculate angles to [111]
                alfa3=[0 0 0 0]; % store all symmetric solutions
                NcxV3=[0 0 0]; % cross product M(IPF) x V111
                for v3=1:4
                    NcxV3(1)=M(2,IPF)*V3(v3,3)-M(3,IPF)*V3(v3,2);
                    NcxV3(2)=M(3,IPF)*V3(v3,1)-M(1,IPF)*V3(v3,3);
                    NcxV3(3)=M(1,IPF)*V3(v3,2)-M(2,IPF)*V3(v3,1);
                    alfa3(v3)=180/pi*asin(sqrt((NcxV3(1)^2+NcxV3(2)^2+NcxV3(3)^2)/3));
                end
                clear v3;
                alfa(y,x,z,3)=min(alfa3);
                % end calculate angles to [111]

            end
        end
        clc;
        fprintf('calculating IPF angles, z=%3d\n',z);
    end
    clear y x z M alfa1 alfa2 alfa3 NcxV1 NcxV2 NcxV3;
    clear V1 V2 V3;
    % end calculate angles to S main axes

    % construct IPF palette
    IPFcolors=zeros(wymiary(1),wymiary(2),wymiary(3),3);
    for z=1:wymiary(3)
        for x=1:wymiary(2)
            for y=1:wymiary(1)
                IPFcolors(y,x,z,1)=1-(alfa(y,x,z,1)/54.74); % R
                IPFcolors(y,x,z,2)=1-(alfa(y,x,z,2)/45.00); % G
                IPFcolors(y,x,z,3)=1-(alfa(y,x,z,3)/54.74); % B
            end
        end
        clc;
        fprintf('calculating IPF colors, z=%3d\n',z);
    end
    clear y x z alfa;
    % end construsc IPF palette

    % brightness mormalization
    for z=1:wymiary(3)
        for x=1:wymiary(2)
            for y=1:wymiary(1)
                maxIPF=max(IPFcolors(y,x,z,1:3));
                IPFcolors(y,x,z,1)=IPFcolors(y,x,z,1)/maxIPF;
                IPFcolors(y,x,z,2)=IPFcolors(y,x,z,2)/maxIPF;
                IPFcolors(y,x,z,3)=IPFcolors(y,x,z,3)/maxIPF;
            end
        end
    end
    clear y x z maxIPF;
    % end brightness normalization

    % save the data
    Colors.IPFvoxels=IPFcolors;
    clear IPFcolors IPF wymiary;
    % end save the data

else
    disp('variable ormatrix is missing');
end

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;