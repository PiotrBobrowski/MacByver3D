% calculate random colors for each grain
tic

if exist('grainmap','var')

    if ~exist('grainnumber','var')
        grainnumber=max(max(max(grainmap)));
    end

    RandomGrains=rand(grainnumber,3); % generate random numbers

    % brightness normalization
    for i=1:grainnumber
        MX=max(RandomGrains(i,1:3));
        RandomGrains(i,1:3)=RandomGrains(i,1:3)/MX;
    end
    clear i MX;
    % end brightness normalizarion

    % save the data
    Colors.RandomGrains=RandomGrains;
    clear RandomGrains;
    % end save the data

else
    disp('variable grainmap is missing');
end

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;