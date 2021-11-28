function data = R01readang()
% READANG reads the specified .ang file 
% and puts its contents into a structure

[fileName, filePath] = uigetfile('*.ang', 'Select .ang file');
fileID = fopen([filePath fileName], 'r');
if fileID == 0
    error('Can not read the file');
end
    
fileContent = textscan(fileID, ...
    '%f %f %f %f %f %*[^\n]','CommentStyle','#');
fileID = fclose(fileID); %#ok<NASGU>
fileContent = cell2mat(fileContent);

stepX = fileContent(2,4); % x step [um]
stepY = stepX; % y step [um]
maxX = fileContent(end,4)/stepX + 1; % x size of the map
maxY = fileContent(end,5)/stepY + 1; % y size of the map
eulerAngles = zeros(maxY, maxX, 3); % eulerAngles: y,x,(phi1,PHI,phi2)
pointCoord = zeros(maxY, maxX, 2); % pointCoord: y,x,(x[um],y[um])

x = int16(fileContent(:,4)/stepX +1);
y = int16(fileContent(:,5)/stepY +1);

for i = 1:size(fileContent, 1)
    eulerAngles(y(i), x(i), 1:3) = fileContent(i, 1:3); % phi1 PHI phi2
    pointCoord(y(i), x(i), 1:2) = fileContent(i, 4:5); % x y
end

data.eulerAngles = eulerAngles;
data.pointCoord = pointCoord;
data.scanStep = [stepY, stepX];
data.dimensions = [maxY, maxX];

finishGood;

end
