function  eulerAngles = rotm2eul(orientationMatrix)
% ROTM2EUL converts a rotation matrix into a triple of euler angles
% in Bunge convention (ZXZ)
%
% Input:
% orientationMatrix: a 3x3 orientation matrix
%
% Output:
% eulerAngles: a triple of Euler angles phi1, PHI, phi2

    arguments
        orientationMatrix (3,3) double;
    end

    eulerAngles = zeros(1,3);

    eulerAngles(1) = atan(-orientationMatrix(3,1)/orientationMatrix(3,2));
    eulerAngles(2) = acos(orientationMatrix(3,3));
    eulerAngles(3) = atan(orientationMatrix(1,3)/orientationMatrix(2,3));

    if eulerAngles(1) < 0
        eulerAngles(1) = eulerAngles(1) + 2*pi;
    end
    if eulerAngles(3) < 0
        eulerAngles(3) = eulerAngles(3) + 2*pi;
    end

end
