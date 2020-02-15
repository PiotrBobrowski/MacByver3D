% neighbor misorientations
tic

if ~(exist('Statistics','var') && isfield(Statistics,'AverageOrientations'))
    P02AverageOrientation;
end

if ~(exist('Neighbors','var') && isfield(Neighbors,'Pairs'))
    P03Neighbors;
end

% calculate orientation differences among neighbors
NLg=Neighbors.Pairs; % load data
AvM=Statistics.AverageOrientations; % load data
nNL=size(Neighbors.Pairs);
NeighMisorM=zeros(3,3,nNL(1)); % initialization: misorientation matrices
NeighMisorAxis=zeros(nNL(1),3); % initialization: misorientation axes
NeighMisorAngle=zeros(nNL(1),1); % initialization: misorientation angles

for i=1:nNL(1) % loop on neighboring pairs

    % calculate misorientation matrix
    M1(1:3,1:3)=AvM(1:3,1:3,NLg(i,1));
    M2(1:3,1:3)=AvM(1:3,1:3,NLg(i,2));
    M12=M1*M2';
    
        % assymetric domain
        T001(1:6,1:3)=[M12; -M12]; % vect. 100,010,001,-100,-010,-001
        [T001m,T001i]=max(T001); % find max of x
        M12(1,1:3)=T001(T001i(1),1:3); % write vector on pos. x

            % delete used vector and its parallel brother
            if T001i(1)==1 || T001i(1)==4
                T001(4,:)=[];
                T001(1,:)=[];
            elseif T001i(1)==2 || T001i(1)==5
                T001(5,:)=[];
                T001(2,:)=[];
            else
                T001(6,:)=[];
                T001(3,:)=[];
            end
            % end delete used vector and its parallel brother

        [T001m,T001i]=max(T001); % find max of z
        M12(3,1:3)=T001(T001i(3),1:3); % write vector on pos. z
        M12(2,1)=M12(3,2)*M12(1,3)-M12(3,3)*M12(1,2); % calculate y
        M12(2,2)=M12(3,3)*M12(1,1)-M12(3,1)*M12(1,3); % calculate y
        M12(2,3)=M12(3,1)*M12(1,2)-M12(3,2)*M12(1,1); % calculate y
        clear T001 T001m T001i;
        % end assymetric domain

    NeighMisorM(1:3,1:3,i)=M12(1:3,1:3);
    % end calculate misorientation matrix

    % calculate misorientation axis/angle
    NeighMisorAxis(i,1:3)=[M12(2,3)-M12(3,2) M12(1,3)-M12(3,1) M12(2,1)-M12(1,2)];
    NeighMisorAngle(i)=180/pi*acos((M12(1,1)+M12(2,2)+M12(3,3)-1)/2);
    if NeighMisorAxis(i,3)<0
        NeighMisorAxis(i,1:3)=-NeighMisorAxis(i,1:3);
    end
    % end calculate misorientation axis/angle

end % end loop on neighboring pairs
clear i nNL NLg AvM M1 M2 M12;
% end calculate orientation differences among neighbors

% save the data
Neighbors.Matrices=NeighMisorM;
Neighbors.Axes=NeighMisorAxis;
Neighbors.Angles=NeighMisorAngle;
clear NeighMisorM NeighMisorAxis NeighMisorAngle;
% end save the data

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;