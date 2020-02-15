% calculate IPF colors for each grain
tic

% IPF reference direction
IPF=3; % 1-RD, 2-TD, 3=ND

if (exist('ormatrix','var') && exist('grainmap','var'))

    if ~(exist('Statistics','var') && isfield(Statistics,'AverageOrientations'))
        P02AverageOrientation;
    end

    if ~exist('grainnumber','var')
        grainnumber=max(max(max(grainmap)));
    end

    AvM=Statistics.AverageOrientations; % load data

    % define main directions in C reference
    % V1=[001], V2=[101], V3=[111]
    V1=[0 0 1;0 1 0;1 0 0];
    V2=[1 0 1;1 1 0;0 1 1;-1 0 1;-1 1 0;0 -1 1];
    V3=[1 1 1;1 1 -1;1 -1 1;-1 1 1];
    % end define main directions in C reference

    % calculate angles to S main axes
    alfa=zeros(grainnumber,3); % min angles to C directions
    for i=1:grainnumber

        % calculate angles to [001]
        alfa1=[0 0 0]; % store all symmetric solutions
        NcxV1=[0 0 0]; % cross product M(IPF) x V001
        for v1=1:3
            NcxV1(1)=AvM(2,IPF,i)*V1(v1,3)-AvM(3,IPF,i)*V1(v1,2);
            NcxV1(2)=AvM(3,IPF,i)*V1(v1,1)-AvM(1,IPF,i)*V1(v1,3);
            NcxV1(3)=AvM(1,IPF,i)*V1(v1,2)-AvM(2,IPF,i)*V1(v1,1);
            alfa1(v1)=180/pi*asin(sqrt(NcxV1(1)^2+NcxV1(2)^2+NcxV1(3)^2));
        end
        alfa(i,1)=min(alfa1);
        clear v1;
        % end calculate angles to [001]

        % calculate angles to [101]
        alfa2=[0 0 0 0 0 0]; % store all symmetric solutions
        NcxV2=[0 0 0]; % cross product M(IPF) x V101
        for v2=1:6
            NcxV2(1)=AvM(2,IPF,i)*V2(v2,3)-AvM(3,IPF,i)*V2(v2,2);
            NcxV2(2)=AvM(3,IPF,i)*V2(v2,1)-AvM(1,IPF,i)*V2(v2,3);
            NcxV2(3)=AvM(1,IPF,i)*V2(v2,2)-AvM(2,IPF,i)*V2(v2,1);
            alfa2(v2)=180/pi*asin(sqrt((NcxV2(1)^2+NcxV2(2)^2+NcxV2(3)^2)/2));
        end
        alfa(i,2)=min(alfa2);
        clear v2;
        % end calculate angles to [101]

        % calculate angles to [111]
        alfa3=[0 0 0 0]; % store all symmetric solutions
        NcxV3=[0 0 0]; % cross product M(IPF) x V111
        for v3=1:4
            NcxV3(1)=AvM(2,IPF,i)*V3(v3,3)-AvM(3,IPF,i)*V3(v3,2);
            NcxV3(2)=AvM(3,IPF,i)*V3(v3,1)-AvM(1,IPF,i)*V3(v3,3);
            NcxV3(3)=AvM(1,IPF,i)*V3(v3,2)-AvM(2,IPF,i)*V3(v3,1);
            alfa3(v3)=180/pi*asin(sqrt((NcxV3(1)^2+NcxV3(2)^2+NcxV3(3)^2)/3));
        end
        alfa(i,3)=min(alfa3);
        clear v3;
        % end calculate angles to [111]

    end
    clear i AvM alfa1 alfa2 alfa3 NcxV1 NcxV2 NcxV3;
    clear V1 V2 V3;
    % calculate angles to S main axes

    % construct IPF palette
    IPFcolors=zeros(grainnumber,3);
    for i=1:grainnumber
        IPFcolors(i,1)=1-(alfa(i,1)/54.74); % R
        IPFcolors(i,2)=1-(alfa(i,2)/45.00); % G
        IPFcolors(i,3)=1-(alfa(i,3)/54.74); % B
    end
    clear i alfa;
    % end construct IPF palette

    % brightness mormalization
    for i=1:grainnumber
        maxIPF=max(IPFcolors(i,1:3));
        IPFcolors(i,1)=IPFcolors(i,1)/maxIPF;
        IPFcolors(i,2)=IPFcolors(i,2)/maxIPF;
        IPFcolors(i,3)=IPFcolors(i,3)/maxIPF;
    end
    clear i maxIPF;
    % end brightness mormalization

    % save the data
    Colors.IPFgrains=IPFcolors;
    clear IPFcolors IPF;
    % end save the data

else
    disp('variable grainmap or ormatrix is missing');
end

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;