function data = R03grains(data, misorangle)
% GRAINS divides the map into grains using the seed-growth approach
%
% Inputs:
% data: structure containing orientation matrices
%
% Outputs:
% data: input structure with additional field 'grains'

arguments
    data (1,1) struct;
    misorangle (1,1) double = 2;
end

orMat = data.orientationMatrices;

%% calculate misorientation arrays
G1=zeros(3);
G2=zeros(3);

% X misorientation array
disp('Calculating X misorientation array');
misorX = zeros(data.dimensions(1), data.dimensions(2)-1);
for y = 1:data.dimensions(1)
    for x = 1:data.dimensions(2)-1
        G1(1:3, 1:3) = orMat(y, x, 1:3, 1:3);
        G2(1:3, 1:3) = orMat(y, x+1, 1:3, 1:3);
        G12 = G1 * G2';
        misorX(y, x) = ...
            real(180/pi * acos((G12(1,1)+G12(2,2)+G12(3,3)-1)/2));
        if misorX(y, x) < misorangle
            misorX(y, x) = 0;
        end
    end
end

% Y misorientation array
disp('Calculating Y misorientation array');
misorY = zeros(data.dimensions(1)-1, data.dimensions(2));
for y = 1:data.dimensions(1)-1
    for x = 1:data.dimensions(2)
        G2(1:3, 1:3) = orMat(y+1, x, 1:3, 1:3);
        G1(1:3, 1:3) = orMat(y, x, 1:3, 1:3);
        G12 = G1 * G2';
        misorY(y, x) = ...
            real(180/pi * acos((G12(1,1)+G12(2,2)+G12(3,3)-1)/2));
        if misorY(y, x) < misorangle
            misorY(y, x) = 0;
        end
    end
end

%% grain division

% initialization
grainNumber = 0; % initialize grain number
grainMap = zeros(data.dimensions(1), data.dimensions(2));
empties = data.dimensions(1) * data.dimensions(2);
n = 3000; % starting size of pixel list

% main loop
nList = 0;
while empties > 0 % do while there are unassigned pixels

    if nList == 0 % plant new seed

        % create a new grain
        seedList = find(grainMap == 0, 1);
        [seedY, seedX] = ind2sub(data.dimensions, seedList);
        grainNumber = grainNumber + 1;
        grainMap(seedY, seedX) = grainNumber;
        empties = empties - 1;

        % running check
        if mod(grainNumber, 1000) == 0
            progress = round(100*(1 - empties/(data.dimensions(1)*data.dimensions(2))));
            fprintf('progress: %2d, grainNumber: %6d\n', progress, grainNumber);
        end

        % create a list of pixels to check
        pixelList = zeros(n, 2); % structure: y,x
        pB = 1; % begin pointer
        pE = 1; % end pointer
        nList = 1; % number of pixels on the list
        pixelList(1, 1:2) = [seedY, seedX];
    end

    while nList > 0 % grow the seed until the List is depleted
        y = pixelList(pB, 1); % pick a pixel from the list
        x = pixelList(pB, 2); % pick a pixel from the list
        pB = pB + 1; % move the pointer to the next position
        nList = nList - 1; % number of pixels on the list

        if y > 1
            if grainMap(y-1, x) == 0 && misorY(y-1, x) < misorangle
                grainMap(y-1, x) = grainNumber; % assign to grain
                empties = empties - 1;
                pE = pE + 1; % move the pointer to the next position
                pixelList(pE, 1:2) = [y-1, x]; % add to the list
                nList = nList + 1; % number of pixels on the list
            end
        end
        if y < data.dimensions(1)
            if grainMap(y+1, x) == 0 && misorY(y, x) < misorangle
                grainMap(y+1, x) = grainNumber; % assign to grain
                empties = empties - 1;
                pE = pE + 1; % move the pointer to the next position
                pixelList(pE, 1:2) = [y+1, x]; % add to the list
                nList = nList + 1;  % number of pixels on the list
            end
        end
        if x > 1
            if grainMap(y, x-1) == 0 && misorX(y, x-1) < misorangle
                grainMap(y, x-1) = grainNumber; % assign to grain
                empties = empties - 1;
                pE = pE + 1; % move the pointer to the next position
                pixelList(pE, 1:2) = [y, x-1]; % add to the list
                nList = nList + 1; % number of pixels on the list
            end
        end
        if x < data.dimensions(2)
            if grainMap(y, x+1) == 0 && misorX(y,x) < misorangle
                grainMap(y, x+1) = grainNumber; % assign to grain
                empties = empties - 1;
                pE = pE + 1; % move the pointer to the next position
                pixelList(pE, 1:2) = [y, x+1]; % add to the list
                nList = nList + 1; % number of pixels on the list
            end
        end

        % extend the pixel list on case of oveflow
        if nList > n - 4
            List2 = pixelList; % temporary copy
            n = n + 1000; % expand the list by 1000
            pixelList = zeros(n, 2); % reinitialize
            pixelList(1:nList, 1:2) = List2(1:nList, 1:2);
            clear List2;
        end

    end

end

data.grainMap = grainMap;
data.grainNumber = grainNumber;

finishGood;
