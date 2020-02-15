% grain borders smoothing: Grain-by-Grain
% wybor kierunku poprzez najbardziej zaprzyjaznionego sasiada
% w razie remisu wybierz wieksze ziarno
% bez blokowania ziaren
tic

% create list of grain sizes
if ~(exist('Statistics','var') && isfield(Statistics,'VPG'))
    P01VoxelsPerGrain;
end
% end create list of grain sizes

wymiary=size(grainmap);
for l=1:2 % loop on grains in both directions
    
    % loop direction control
    if l==1
        begining=1;
        ending=grainnumber;
        loopstep=1;
    else
        begining=grainnumber;
        ending=1;
        loopstep=-1;
    end
    % end loop direction control

    % create array of BorderVoxels
    BorderVoxels=zeros(wymiary,'uint32');
    for y=1:wymiary(1)-1
        for x=1:wymiary(2)
            for z=1:wymiary(3)
                if grainmap(y,x,z)~=grainmap(y+1,x,z)
                    BorderVoxels(y,x,z)=grainmap(y,x,z);
                    BorderVoxels(y+1,x,z)=grainmap(y+1,x,z);
                end
            end
        end
    end
    for y=1:wymiary(1)
        for x=1:wymiary(2)-1
            for z=1:wymiary(3)
                if grainmap(y,x,z)~=grainmap(y,x+1,z)
                    BorderVoxels(y,x,z)=grainmap(y,x,z);
                    BorderVoxels(y,x+1,z)=grainmap(y,x+1,z);
                end
            end
        end
    end
    for y=1:wymiary(1)
        for x=1:wymiary(2)
            for z=1:wymiary(3)-1
                if grainmap(y,x,z)~=grainmap(y,x,z+1)
                    BorderVoxels(y,x,z)=grainmap(y,x,z);
                    BorderVoxels(y,x,z+1)=grainmap(y,x,z+1);
                end
            end
        end
    end
    clear y x z;
    % end create array of BorderVoxels

    % main loop
%     BlockedVoxels=false(wymiary); % lock smoothed grains

    for gn=begining:loopstep:ending % loop on grains
        clc; fprintf('smoothed grain: %3d/%3d\n',gn,grainnumber);
        ChangedVoxelsTotalOld=-2; % voxels changed in previous iteration
        ChangedVoxelsTotal=0; % voxele changed in current iteration

        while ChangedVoxelsTotalOld-ChangedVoxelsTotal~=0 % do while something changes
            ChangedVoxelsTotalOld=ChangedVoxelsTotal;
            fprintf('Number of changed voxels: %3d\n',ChangedVoxelsTotal);

            [Vy,Vx,Vz]=ind2sub(wymiary,find(BorderVoxels==gn)); % find voxels for current grain
            lVy=length(Vy); % get number of found voxels
            vtc=zeros(lVy,4,'uint32'); % initialization: y,x,z,overwrite direction
            nvtc=0; % numerator vtc

            % determine voxels to change in current grain
            for j=1:lVy % loop on voxels in current grain

                % current voxel coordinates
                y=Vy(j);
                x=Vx(j);
                z=Vz(j);
                % end current voxel coordinates        

                % count voxel neighbors
                nearvoxels=[0 0 0 0 0 0]; % voxels grainnumbers: z-1,z+1,y-1,x+1,y+1,x-1
                nFriends=0;
                if z>1
                    if grainmap(y,x,z)==grainmap(y,x,z-1)
                        nFriends=nFriends+1;
                    else %if BlockedVoxels(y,x,z-1)==false
                        nearvoxels(1)=grainmap(y,x,z-1);
                    end
                end
                if z<wymiary(3)
                    if grainmap(y,x,z)==grainmap(y,x,z+1)
                        nFriends=nFriends+1;
                    else %if BlockedVoxels(y,x,z+1)==false
                        nearvoxels(2)=grainmap(y,x,z+1);
                    end
                end
                if y>1
                    if grainmap(y,x,z)==grainmap(y-1,x,z)
                        nFriends=nFriends+1;
                    else %if BlockedVoxels(y-1,x,z)==false
                        nearvoxels(3)=grainmap(y-1,x,z);
                    end
                end
                if x<wymiary(2)
                    if grainmap(y,x,z)==grainmap(y,x+1,z)
                        nFriends=nFriends+1;
                    else %if BlockedVoxels(y,x+1,z)==false
                        nearvoxels(4)=grainmap(y,x+1,z);
                    end
                end
                if y<wymiary(1)
                    if grainmap(y,x,z)==grainmap(y+1,x,z)
                        nFriends=nFriends+1;
                    else %if BlockedVoxels(y+1,x,z)==false
                        nearvoxels(5)=grainmap(y+1,x,z);
                    end
                end
                if x>1
                    if grainmap(y,x,z)==grainmap(y,x-1,z)
                        nFriends=nFriends+1;
                    else %if BlockedVoxels(y,x-1,z)==false
                        nearvoxels(6)=grainmap(y,x-1,z);
                    end
                end
                % end count voxel neighbors

                % save the exposed voxel to change
                if nFriends<=2
                    
                    % count neighbors' friends
                    nFriends2=[0 0 0 0 0 0]; % z-1,z+1,y-1,x+1,y+1,x-1
                    if nearvoxels(1)~=0 % z-1
                        if (z-1>1 && grainmap(y,x,z-1)==grainmap(y,x,z-2)) % z-2
                            nFriends2(1)=nFriends2(1)+1;
                        end
                        if (y>1 && grainmap(y,x,z-1)==grainmap(y-1,x,z-1)) % y-1,z-1
                            nFriends2(1)=nFriends2(1)+1;
                        end
                        if (y<wymiary(1) && grainmap(y,x,z-1)==grainmap(y+1,x,z-1)) % y+1,z-1
                            nFriends2(1)=nFriends2(1)+1;
                        end
                        if (x>1 && grainmap(y,x,z-1)==grainmap(y,x-1,z-1)) % x-1,z-1
                            nFriends2(1)=nFriends2(1)+1;
                        end
                        if (x<wymiary(2) && grainmap(y,x,z-1)==grainmap(y,x+1,z-1))% x+1,z-1
                            nFriends2(1)=nFriends2(1)+1;
                        end
                    end
                    if nearvoxels(2)~=0 % z+1
                        if (z+1<wymiary(3) && grainmap(y,x,z+1)==grainmap(y,x,z+2)) % z+2
                            nFriends2(2)=nFriends2(2)+1;
                        end
                        if (y>1 && grainmap(y,x,z+1)==grainmap(y-1,x,z+1))% y-1,z+1
                            nFriends2(2)=nFriends2(2)+1;
                        end
                        if (y<wymiary(1) && grainmap(y,x,z+1)==grainmap(y+1,x,z+1))% y+1,z+1
                            nFriends2(2)=nFriends2(2)+1;
                        end
                        if (x>1 && grainmap(y,x,z+1)==grainmap(y,x-1,z+1)) % x-1,z+1
                            nFriends2(2)=nFriends2(2)+1;
                        end
                        if (x<wymiary(2) && grainmap(y,x,z+1)==grainmap(y,x+1,z+1))% x+1,z+1
                            nFriends2(2)=nFriends2(2)+1;
                        end
                    end
                    if nearvoxels(3)~=0 % y-1
                        if (z>1 && grainmap(y-1,x,z)==grainmap(y-1,x,z-1)) % y-1,z-1
                            nFriends2(3)=nFriends2(3)+1;
                        end
                        if (z<wymiary(3) && grainmap(y-1,x,z)==grainmap(y-1,x,z+1)) % y-1,z+1
                            nFriends2(3)=nFriends2(3)+1;
                        end
                        if (y-1>1 && grainmap(y-1,x,z)==grainmap(y-2,x,z)) % y-2
                            nFriends2(3)=nFriends2(3)+1;
                        end
                        if (x>1 && grainmap(y-1,x,z)==grainmap(y-1,x-1,z)) % y-1,x-1
                            nFriends2(3)=nFriends2(3)+1;
                        end
                        if (x<wymiary(2) && grainmap(y-1,x,z)==grainmap(y-1,x+1,z)) % y-1,x+1
                            nFriends2(3)=nFriends2(3)+1;
                        end
                    end
                    if nearvoxels(4)~=0 % x+1
                        if (z>1 && grainmap(y,x+1,z)==grainmap(y,x+1,z-1)) % x+1,z-1
                            nFriends2(4)=nFriends2(4)+1;
                        end
                        if (z<wymiary(3) && grainmap(y,x+1,z)==grainmap(y,x+1,z+1)) % x+1,z+1
                            nFriends2(4)=nFriends2(4)+1;
                        end
                        if (y>1 && grainmap(y,x+1,z)==grainmap(y-1,x+1,z)) % y-1,x+1
                            nFriends2(4)=nFriends2(4)+1;
                        end
                        if (y<wymiary(1) && grainmap(y,x+1,z)==grainmap(y+1,x+1,z)) % y+1,x+1
                            nFriends2(4)=nFriends2(4)+1;
                        end
                        if (x+1<wymiary(2) && grainmap(y,x+1,z)==grainmap(y,x+2,z)) % x+2
                            nFriends2(4)=nFriends2(4)+1;
                        end
                    end
                    if nearvoxels(5)~=0 % y+1
                        if (z>1 && grainmap(y+1,x,z)==grainmap(y+1,x,z-1)) % y+1,z-1
                            nFriends2(5)=nFriends2(5)+1;
                        end
                        if (z<wymiary(3) && grainmap(y+1,x,z)==grainmap(y+1,x,z+1)) % y+1,z+1
                            nFriends2(5)=nFriends2(5)+1;
                        end
                        if (y+1<wymiary(1) && grainmap(y+1,x,z)==grainmap(y+2,x,z)) % y+2
                            nFriends2(5)=nFriends2(5)+1;
                        end
                        if (x>1 && grainmap(y+1,x,z)==grainmap(y+1,x-1,z)) % y+1,x-1
                            nFriends2(5)=nFriends2(5)+1;
                        end
                        if (x<wymiary(2) && grainmap(y+1,x,z)==grainmap(y+1,x+1,z)) % y+1,x+1
                            nFriends2(5)=nFriends2(5)+1;
                        end
                    end
                    if nearvoxels(6)~=0 % x-1
                        if (z>1 && grainmap(y,x-1,z)==grainmap(y,x-1,z-1)) % x-1,z-1
                            nFriends2(6)=nFriends2(6)+1;
                        end
                        if (z<wymiary(3) && grainmap(y,x-1,z)==grainmap(y,x-1,z+1)) % x-1,z+1
                            nFriends2(6)=nFriends2(6)+1;
                        end
                        if (y>1 && grainmap(y,x-1,z)==grainmap(y-1,x-1,z)) % y-1,x-1
                            nFriends2(6)=nFriends2(6)+1;
                        end
                        if (y<wymiary(1) && grainmap(y,x-1,z)==grainmap(y+1,x-1,z)) % y+1,x-1
                            nFriends2(6)=nFriends2(6)+1;
                        end
                        if (x-1>1 && grainmap(y,x-1,z)==grainmap(y,x-2,z)) % x-2
                            nFriends2(6)=nFriends2(6)+1;
                        end
                    end
                    % end count neighbors' friends

                    % find most friendly neighbor and get overwrite direction
                    if ~isempty(nonzeros(nFriends2)) % protection from locked grains
                        iFriends2=find(nFriends2==max(nonzeros(nFriends2))); % get indices of most friendly neighbors

                        if length(iFriends2)==1 % only one most friendly neighbor
                            nvtc=nvtc+1;
                            vtc(nvtc,1:4)=[y x z iFriends2]; % save the exposed voxel to change
                        elseif length(iFriends2)>1 % there are more most friendly neighbors
                            GSnearvoxels=[0 0 0 0 0 0]; % initialization: GS 1-6

                            for i=1:length(iFriends2) % loop on most firendly neighbors
                                    % get grain sizes of most friendly neighbors
                                GSnearvoxels(iFriends2(i))=Statistics.VPG(nearvoxels(iFriends2(i)));
                            end % end loop on most firendly neighbors
                            clear i;

                            [mGS,iGS]=max(GSnearvoxels); % find largest firendly grain
                            nvtc=nvtc+1;
                            vtc(nvtc,1:4)=[y x z iGS]; % save the exposed voxel to change
                        end

                    end % protection from locked grains
                    % end find most friendly neighbor and get overwrite direction

                end
                % end save the exposed voxel to change
                
            end % end loop on voxels in current grain
            clear j Vy Vx Vz lVy mGS iGS GSnearvoxels;
            clear nearvoxels nFriends nFriends2 mFriends2 iFriends2;
            % end determine voxels to change in current grain

            % change the saved voxels
            for j=1:nvtc % z-1,z+1,y-1,x+1,y+1,x-1
                ChangedVoxelsTotal=ChangedVoxelsTotal+1;
                y=vtc(j,1);
                x=vtc(j,2);
                z=vtc(j,3);
                
                % overvrite the voxel
                if vtc(j,4)==1 % z-1
                    BorderVoxels(y,x,z)=BorderVoxels(y,x,z-1);
                    grainmap(y,x,z)=grainmap(y,x,z-1);
                    ormatrix(y,x,z,1:3,1:3)=ormatrix(y,x,z-1,1:3,1:3);
                    EulerAngles(y,x,z,3:5)=EulerAngles(y,x,z-1,3:5);
                elseif vtc(j,4)==2 % z+1
                    BorderVoxels(y,x,z)=BorderVoxels(y,x,z+1);
                    grainmap(y,x,z)=grainmap(y,x,z+1);
                    ormatrix(y,x,z,1:3,1:3)=ormatrix(y,x,z+1,1:3,1:3);
                    EulerAngles(y,x,z,3:5)=EulerAngles(y,x,z+1,3:5);
                elseif vtc(j,4)==3 % y-1
                    BorderVoxels(y,x,z)=BorderVoxels(y-1,x,z);
                    grainmap(y,x,z)=grainmap(y-1,x,z);
                    ormatrix(y,x,z,1:3,1:3)=ormatrix(y-1,x,z,1:3,1:3);
                    EulerAngles(y,x,z,3:5)=EulerAngles(y-1,x,z,3:5);
                elseif vtc(j,4)==4 % x+1
                    BorderVoxels(y,x,z)=BorderVoxels(y,x+1,z);
                    grainmap(y,x,z)=grainmap(y,x+1,z);
                    ormatrix(y,x,z,1:3,1:3)=ormatrix(y,x+1,z,1:3,1:3);
                    EulerAngles(y,x,z,3:5)=EulerAngles(y,x+1,z,3:5);
                elseif vtc(j,4)==5 % y+1
                    BorderVoxels(y,x,z)=BorderVoxels(y+1,x,z);
                    grainmap(y,x,z)=grainmap(y+1,x,z);
                    ormatrix(y,x,z,1:3,1:3)=ormatrix(y+1,x,z,1:3,1:3);
                    EulerAngles(y,x,z,3:5)=EulerAngles(y+1,x,z,3:5);            
                elseif vtc(j,4)==6 % x-1
                    BorderVoxels(y,x,z)=BorderVoxels(y,x-1,z);
                    grainmap(y,x,z)=grainmap(y,x-1,z);
                    ormatrix(y,x,z,1:3,1:3)=ormatrix(y,x-1,z,1:3,1:3);
                    EulerAngles(y,x,z,3:5)=EulerAngles(y,x-1,z,3:5);            
                end
                % end overvrite the voxel
                
                % broaden the border zone
                if (z>1 && BorderVoxels(y,x,z-1)~=0)
                    BorderVoxels(y,x,z-1)=grainmap(y,x,z-1);
                end
                if (z<wymiary(3) && BorderVoxels(y,x,z+1)~=0)
                    BorderVoxels(y,x,z+1)=grainmap(y,x,z+1);
                end
                if (y>1 && BorderVoxels(y-1,x,z)~=0)
                    BorderVoxels(y-1,x,z)=grainmap(y-1,x,z);
                end
                if (y<wymiary(1) && BorderVoxels(y+1,x,z)~=0)
                    BorderVoxels(y+1,x,z)=grainmap(y+1,x,z);
                end
                if (x>1 && BorderVoxels(y,x-1,z)~=0)
                    BorderVoxels(y,x-1,z)=grainmap(y,x-1,z);
                end
                if (x<wymiary(2) && BorderVoxels(y,x+1,z)~=0)
                    BorderVoxels(y,x+1,z)=grainmap(y,x+1,z);
                end
                % end broaden the border zone

            end
            clear j y x z;
            % end change the saved voxels

        end % end do while something changes
        clear vtc nvtc;

%         % lock the smoothed grain
%         [Vy,Vx,Vz]=ind2sub(wymiary,find(grainmap==gn)); % voxels of current grain
%         for j=1:length(Vy)
%             BlockedVoxels(Vy(j),Vx(j),Vz(j))=true;
%         end
%         clear j Vy Vx Vz;
%         % end lock the smoothed grain

    end % end loop on grains
    clear gn ChangedVoxelsTotal ChangedVoxelsTotalOld BlockedVoxels;

end % end loop on grains in both directions
clear begining ending loopstep l BorderVoxels wymiary;   

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;