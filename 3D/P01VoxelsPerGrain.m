% number of voxels in each grain

if exist('grainmap','var')
    if ~exist('grainnumber','var')
        grainnumber=max(max(max(grainmap)));
    end

    Statistics.VPG=zeros(grainnumber,1); % initialization: VoxelsPerGrain

    wymiary=size(grainmap);
    for z=1:wymiary(3)
        for y=1:wymiary(1)
            for x=1:wymiary(2)
                Statistics.VPG(grainmap(y,x,z))=Statistics.VPG(grainmap(y,x,z))+1;
            end
        end
    end
    clear y x z wymiary;

else
    disp('variable grainmap is missing');
end