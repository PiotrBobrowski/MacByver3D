function orMat = assymetricdomain(orientationMatrix)
% ASSYMETRICDOMAIN converts orientation matrix to assymetric domain
%
% Input:
% orientationMatrix: a 3x3 orientation matrix
%
% Output:
% orMat: a 3x3 orientation matrix in assymetric domain

    arguments
        orientationMatrix (3,3) double;
    end

    orMat = zeros(3);

    % find X vector
    T = [orientationMatrix; -orientationMatrix];
    [~, Ti] = max(T(:,1)); % max of the x coord (1st T column)
    orMat(1, 1:3) = T(Ti, 1:3);

    if Ti==1 || Ti==4
        T(4,:) = [];
        T(1,:) = [];
    elseif Ti==2 || Ti==5
        T(5,:) = [];
        T(2,:) = [];
    else
        T(6,:) = [];
        T(3,:) = [];
    end

    % find Z vector
    [~, Ti] = max(T(:,3)); % max of the z coord (3rd T column)
    orMat(3, 1:3) = T(Ti, 1:3);

    % calculate Y vector
    orMat(2,1) = orMat(3,2)*orMat(1,3) - orMat(3,3)*orMat(1,2);
    orMat(2,2) = orMat(3,3)*orMat(1,1) - orMat(3,1)*orMat(1,3);
    orMat(2,3) = orMat(3,1)*orMat(1,2) - orMat(3,2)*orMat(1,1);

end
