% average orientation of each grain

if (exist('grainmap','var') && exist('ormatrix','var'))

    if ~exist('grainnumber','var')
        grainnumber=max(max(max(grainmap)));
    end

    if (~exist('Statistics','var') || ~isfield(Statistics,'VPG'))
        P01VoxelsPerGrain;
    end

    AvM=zeros(3,3,grainnumber); % initialization: average matrices

    % sum all appropriate matrices
    wymiary=size(grainmap);
    for z=1:wymiary(3)
        for x=1:wymiary(2)
            for y=1:wymiary(1)
                AvM(1,1,grainmap(y,x,z))=AvM(1,1,grainmap(y,x,z))+ormatrix(y,x,z,1,1);
                AvM(1,2,grainmap(y,x,z))=AvM(1,2,grainmap(y,x,z))+ormatrix(y,x,z,1,2);
                AvM(1,3,grainmap(y,x,z))=AvM(1,3,grainmap(y,x,z))+ormatrix(y,x,z,1,3);
                AvM(2,1,grainmap(y,x,z))=AvM(2,1,grainmap(y,x,z))+ormatrix(y,x,z,2,1);
                AvM(2,2,grainmap(y,x,z))=AvM(2,2,grainmap(y,x,z))+ormatrix(y,x,z,2,2);
                AvM(2,3,grainmap(y,x,z))=AvM(2,3,grainmap(y,x,z))+ormatrix(y,x,z,2,3);
                AvM(3,1,grainmap(y,x,z))=AvM(3,1,grainmap(y,x,z))+ormatrix(y,x,z,3,1);
                AvM(3,2,grainmap(y,x,z))=AvM(3,2,grainmap(y,x,z))+ormatrix(y,x,z,3,2);
                AvM(3,3,grainmap(y,x,z))=AvM(3,3,grainmap(y,x,z))+ormatrix(y,x,z,3,3);
            end
        end
        clc; disp('z='); disp(z);
    end
    clear y x z wymiary;
    % end sum all appropriate matrices

    % divide by number of voxels
    for i=1:grainnumber
        AvM(1,1,i)=AvM(1,1,i)/Statistics.VPG(i);
        AvM(1,2,i)=AvM(1,2,i)/Statistics.VPG(i);
        AvM(1,3,i)=AvM(1,3,i)/Statistics.VPG(i);
        AvM(2,1,i)=AvM(2,1,i)/Statistics.VPG(i);
        AvM(2,2,i)=AvM(2,2,i)/Statistics.VPG(i);
        AvM(2,3,i)=AvM(2,3,i)/Statistics.VPG(i);
        AvM(3,1,i)=AvM(3,1,i)/Statistics.VPG(i);
        AvM(3,2,i)=AvM(3,2,i)/Statistics.VPG(i);
        AvM(3,3,i)=AvM(3,3,i)/Statistics.VPG(i);
    end
    clear i;
    % end divide by number of voxels
    
    Statistics.AverageOrientations=AvM;
    clear AvM;

else
    disp('variable grainmap or ormatrix is missing');
end