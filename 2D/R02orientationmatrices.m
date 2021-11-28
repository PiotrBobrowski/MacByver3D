function data = R02orientationmatrices(data)
% ORIENTATIONMATRICES converts Euler angles into orientation matrices,
% reduces them to assymetric domain and converts back to Euler angles
%
% Inputs:
% data: structure containing data imported from .ang file
%
% Outputs:
% data: input structure with additional field 'orientationMatrices' 

arguments
    data (1,1) struct;
end

dims = data.dimensions;
eulerAngles = data.eulerAngles;

orientationMatrices = zeros(dims(1), dims(2), 3, 3);
eulerAnglesNew = zeros(size(eulerAngles));

for y = 1:dims(1)
    for x = 1:dims(2)
        E(1:3) = eulerAngles(y, x, (1:3));
        M = eul2rotm(E);
        Ma = assymetricdomain(M);
        orientationMatrices(y, x, 1:3, 1:3) = Ma;
        eulerAnglesNew(y, x, 1:3) = rotm2eul(Ma);
    end
end

data.eulerAngles = eulerAnglesNew;
data.orientationMatrices = orientationMatrices;

finishGood;

end
