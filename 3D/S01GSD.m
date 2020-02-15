% calculate grain size distributions
tic

% external parameters
BinNumber=25;
DistType=1; % 1-GVD[um3], 2-ESD[um]
% end external parameters

if exist('grainmap','var')

    if ~(exist('Statistics','var') && isfield(Statistics,'VPG'))
        P01VoxelsPerGrain;
    end

    % calculate distribution
    if DistType==1 % Grain Volume Distribution

        % calculate grain volumes
        VoxVol=ScanStep.xstep^3; % single voxel volume
        GrainVol=zeros(grainnumber,1); % initialization
        for i=1:grainnumber
            GrainVol(i)=Statistics.VPG(i)*VoxVol;
        end
        clear i VoxVol;
        % end calculate grain volumes

        % calculate histogram
        [HistY,HistX]=hist(GrainVol,BinNumber);
        HistY=HistY';
        HistX=HistX';
        HistY=HistY/sum(HistY); % normalization
        % end calculate histogram

%     % fitowanie rozkladu
%     MeanSigma=lognfit(GrainVol);
%     FitY=lognpdf(HistX,MeanSigma(1),MeanSigma(2));
%     FitY=FitY/sum(FitY); % normalizacja
%     % koniec fitowania rozkladu

        % fit distribution
        Mean=expfit(GrainVol);
        FitY=exppdf(HistX,Mean);
        FitY=FitY/sum(FitY); % normalization
        % end fit distribution

        % plot distribution
        plot(HistX,HistY,'.k'); hold on;
        plot(HistX,FitY,'-k'); hold on;
        % end plot distribution

        % save the distribution
        Statistics.GVD.Volumes=GrainVol;
        Statistics.GVD.HistX=HistX;
        Statistics.GVD.HistY=HistY;
        Statistics.GVD.FitY=FitY;
        Statistics.GVD.Mean=Mean;
        clear GrainVol HistX HistY FitY Mean;
        % end save the distribution

    elseif DistType==2 % Equivalent Sphere Diameter

        % calculate sphere diameters
        ESD=zeros(grainnumber,1); % initialization
        for i=1:grainnumber
            ESD(i)=(6/pi*Statistics.VPG(i))^(1/3)*ScanStep.xstep;
        end
        clear i;
        % end calculate sphere diameters

        % calculate histogram
        [HistY,HistX]=hist(ESD,BinNumber);
        HistY=HistY';
        HistX=HistX';
        HistY=HistY/sum(HistY); % normalization
        % end calculate histogram

        % fit distribution
        MeanSigma=lognfit(ESD);
        FitY=lognpdf(HistX,MeanSigma(1),MeanSigma(2));
        FitY=FitY/sum(FitY); % normalization
        % end fit distribution

        % plot distribution
        plot(HistX,HistY,'.k'); hold on;
        plot(HistX,FitY,'-k'); hold on;
        % end plot distribution

        % save the distribution
        Statistics.ESD.Diameters=ESD;
        Statistics.ESD.HistX=HistX;
        Statistics.ESD.HistY=HistY;
        Statistics.ESD.FitY=FitY;
        Statistics.ESD.MeanSigma=MeanSigma;
        clear ESD HistX HistY FitY MeanSigma;
        % end save the distribution

    else
        disp('inappropriate distribution type');
    end

else
    disp('variable grainmap is missing');
end
    
clear BinNumber DistType;
toc