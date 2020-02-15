% grain Border smoothing: Grain by Grain
tic

% global variables
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
    % end create array of border voxels
    
    % main loop
    BlockedVoxels=false(wymiary); % lock smoothed grains
    for gn=begining:loopstep:ending % loop on grains
        clc;
        fprintf('smoothed grain: %3d/%3d\n',gn,grainnumber);
        ChangedVoxelsTotalOld=-2; % voxels changed in previous iteration
        ChangedVoxelsTotal=0; % voxele changed in current iteration
        
        while ChangedVoxelsTotalOld-ChangedVoxelsTotal~=0 % do while something changes
            ChangedVoxelsTotalOld=ChangedVoxelsTotal;
            fprintf('Number of changed voxels: %3d\n',ChangedVoxelsTotal);

            [Vy,Vx,Vz]=ind2sub(wymiary,find(BorderVoxels==gn)); % find voxels for current grain
            lVy=length(Vy); % number of found voxels
            vtc=zeros(lVy,4,'uint32'); % initialization: y,x,z,overwrite direction
            nvtc=0; % numerator vtc

            % determine voxels to change in current grain
            for j=1:lVy % loop on voxels in current grain

                % current voxel coordinates
                y=Vy(j);
                x=Vx(j);
                z=Vz(j);
                % end current voxel coordinates

                % list of voxel neighbors
                nearvoxels=[0 0 0 0 0 0]; %z-1,z+1,y-1,x+1,y+1,x-1
                nfriends=0;
                if z>1
                    if grainmap(y,x,z)==grainmap(y,x,z-1)
                        nfriends=nfriends+1;
                    elseif BlockedVoxels(y,x,z-1)==false
                        nearvoxels(1)=grainmap(y,x,z-1);
                    end
                end
                if z<wymiary(3)
                    if grainmap(y,x,z)==grainmap(y,x,z+1)
                        nfriends=nfriends+1;
                    elseif BlockedVoxels(y,x,z+1)==false
                        nearvoxels(2)=grainmap(y,x,z+1);
                    end
                end
                if y>1
                    if grainmap(y,x,z)==grainmap(y-1,x,z)
                        nfriends=nfriends+1;
                    elseif BlockedVoxels(y-1,x,z)==false
                        nearvoxels(3)=grainmap(y-1,x,z);
                    end
                end
                if x<wymiary(2)
                    if grainmap(y,x,z)==grainmap(y,x+1,z)
                        nfriends=nfriends+1;
                    elseif BlockedVoxels(y,x+1,z)==false
                        nearvoxels(4)=grainmap(y,x+1,z);
                    end
                end
                if y<wymiary(1)
                    if grainmap(y,x,z)==grainmap(y+1,x,z)
                        nfriends=nfriends+1;
                    elseif BlockedVoxels(y+1,x,z)==false
                        nearvoxels(5)=grainmap(y+1,x,z);
                    end
                end
                if x>1
                    if grainmap(y,x,z)==grainmap(y,x-1,z)
                        nfriends=nfriends+1;
                    elseif BlockedVoxels(y,x-1,z)==false
                        nearvoxels(6)=grainmap(y,x-1,z);
                    end
                end
                % end list of voxel neighbors

                % save the exposed voxel to change
                if nfriends<=2
                    unearvoxels=unique(nonzeros(nearvoxels)); % unique grain numbers of neighbors
                    if ~isempty(unearvoxels)
                        lunearvoxels=length(unearvoxels); % number of unique neighbors

                        % determine overwrite direction
                        if lunearvoxels>1 % if more than one neighbor
                            unearvoxels(lunearvoxels,2)=0; % broaden the array

                            % neighbor number histogram
                            for k1=1:lunearvoxels
                                for k2=1:6
                                    if nearvoxels(k2)==unearvoxels(k1,1)
                                        unearvoxels(k1,2)=unearvoxels(k1,2)+1;
                                    end
                                end
                            end
                            clear k1 k2;
                            % end neighbor number hostogram

                            [munearvoxels,iunearvoxels]=max(unearvoxels(:,2)); % max. hist.
                            fnearvoxels=find(nearvoxels==unearvoxels(iunearvoxels,1),1); % overwrite direction
                            clear munearvoxels iunearvoxels;
                        else
                            fnearvoxels=find(nearvoxels==unearvoxels,1); % only one neighbor
                        end
                        nvtc=nvtc+1;
                        vtc(nvtc,1:4)=[y x z fnearvoxels]; % save the exposed voxel to change
                        clear fnearvoxels;
                        % end determine overwrite direction
                        
                    end
                    clear unearvoxels lunearvoxels;
                end
                clear y x z nearvoxels nfriends;
                % end save the exposed voxel to change

            end % end loop on voxels in current grain
            clear j Vy Vx Vz lVy;
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

        % lock the smoothed grain
        [Vy,Vx,Vz]=ind2sub(wymiary,find(grainmap==gn)); % voxels of current grain
        for j=1:length(Vy)
            BlockedVoxels(Vy(j),Vx(j),Vz(j))=true;
        end
        clear j Vy Vx Vz;
        % end lock the smoothed grain

    end % end loop on grains
    clear gn ChangedVoxelsTotal ChangedVoxelsTotalOld BlockedVoxels;
end % end loop on grains in both directions
clear begining ending loopstep l BorderVoxels wymiary;

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;