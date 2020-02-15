% create list of neighboring grains

if exist('grainmap','var')

    if ~exist('grainnumber','var')
        grainnumber=max(max(max(grainmap)));
    end

    NM33=false(grainnumber); % initialization: neighbor matrix
    NLg=zeros(grainnumber,2,'uint16'); % initialization: neighbor list (grain numbers)

    % create neighbor matrix
    if (exist('boundarypoints','var') && isfield(boundarypoints,'P33'))

        % create neighbor matrix from triple-points (faster)
        disp('creating neighbor matrix from boundarypoints');
        P33g=boundarypoints.P33.grainno; % load data
        sP33g=size(P33g);
        for i=1:sP33g(1)
            NM33(P33g(i,1),P33g(i,2))=true;
            NM33(P33g(i,2),P33g(i,1))=true;
            NM33(P33g(i,1),P33g(i,3))=true;
            NM33(P33g(i,3),P33g(i,1))=true;
            NM33(P33g(i,2),P33g(i,3))=true;
            NM33(P33g(i,3),P33g(i,2))=true;
        end
        clear i P33g sP33g;
        % end create neighbor matrix from triple-points (faster)

    else

        % create neighbor matrix from grainmap (slower)
        disp('creating neighbor matrix from grainmap');
        wymiary=size(grainmap);
        for z=1:wymiary(3)
            for x=1:wymiary(2)
                for y=1:wymiary(1)
                    if y>1
                        NM33(grainmap(y,x,z),grainmap(y-1,x,z))=true;
                        NM33(grainmap(y-1,x,z),grainmap(y,x,z))=true;
                    end
                    if y<wymiary(1)
                        NM33(grainmap(y,x,z),grainmap(y+1,x,z))=true;
                        NM33(grainmap(y+1,x,z),grainmap(y,x,z))=true;
                    end
                    if x>1
                        NM33(grainmap(y,x,z),grainmap(y,x-1,z))=true;
                        NM33(grainmap(y,x-1,z),grainmap(y,x,z))=true;
                    end
                    if x<wymiary(2)
                        NM33(grainmap(y,x,z),grainmap(y,x+1,z))=true;
                        NM33(grainmap(y,x+1,z),grainmap(y,x,z))=true;
                    end
                    if z>1
                        NM33(grainmap(y,x,z),grainmap(y,x,z-1))=true;
                        NM33(grainmap(y,x,z-1),grainmap(y,x,z))=true;
                    end
                    if z<wymiary(3)
                        NM33(grainmap(y,x,z),grainmap(y,x,z+1))=true;
                        NM33(grainmap(y,x,z+1),grainmap(y,x,z))=true;
                    end
                end
            end
        end
        clear y x z wymiary;
        % end create neighbor matrix from grainmap (slower)
        
    end
    % end create neighbor matrix

    % create neighbor list from matrix
    nNLg=0; % neighbor list numerator
    for i=1:grainnumber-1
        for j=i+1:grainnumber
            if NM33(i,j)==true
                nNLg=nNLg+1;
                NLg(nNLg,1:2)=[i j];
            end
        end
    end
    clear i j NM33;
    % end create neighbor list from matrix
    
    Neighbors.Pairs=NLg;
    clear NLg nNLg;

else
    disp('variable grainmap is missing');
end