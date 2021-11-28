function orientationMatrix = eul2rotm(eulerAngles)
% EUL2ROTM converts a triple of euler angles in Bunge convention (ZXZ)
% into rotation matrix
%
% Input:
% eulerAngles: a triple of Euler angles phi1, PHI, phi2
%
% Output:
% orientationMatrix: a 3x3 orientation matrix

    arguments
        eulerAngles (1,3) double;
    end

    % pre-calculate trigonometric functions
    sf1 = sin(eulerAngles(1));
    cf1 = cos(eulerAngles(1));
    sf2 = sin(eulerAngles(3));
    cf2 = cos(eulerAngles(3));
    sF = sin(eulerAngles(2));
    cF = cos(eulerAngles(2));

    % calculate orientation matrix
    orientationMatrix = zeros(3);
    orientationMatrix(1,1) = cf1*cf2 - sf1*sf2*cF;
    orientationMatrix(1,2) = sf1*cf2 + cf1*sf2*cF;
    orientationMatrix(1,3) = sf2*sF;
    orientationMatrix(2,1) = -cf1*sf2 - sf1*cf2*cF;
    orientationMatrix(2,2) = -sf1*sf2 + cf1*cf2*cF;
    orientationMatrix(2,3) = cf2*sF;
    orientationMatrix(3,1) = sf1*sF;
    orientationMatrix(3,2) = -cf1*sF;
    orientationMatrix(3,3) = cF;

end
