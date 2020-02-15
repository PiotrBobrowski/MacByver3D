% obliczenie rozkladu wielkosci ziarna
tic

% parametry zewnetrzne i zmienne globalne
wymiary=size(grainmap);
NumberOfBins=30;
SizeType=2; % 1-Grain Area, 2-ECD
HistType=2; % 0-nic, 1-number fraction, 2-area fraction
PlotType=2; % 1-simple, 2-spline

% obliczanie wielkosci ziaren w pix
grainsizevxl=zeros(grainnumber,1); % tablica rozmiarow ziaren
for y=1:wymiary(1)
    for x=1:wymiary(2)
        pixel=grainmap(y,x);
        grainsizevxl(pixel)=grainsizevxl(pixel)+1;
    end
end
clear y x pixel;
% koniec obliczania wielkosci ziaren w pix

% wielkosc ziaren w [um] lub [um2]
PixelSize=ScanStep.xstep*ScanStep.ystep;
if SizeType==1 % grain area
    grainsize=grainsizevxl*PixelSize;
elseif SizeType==2 % ECD
    grainsize=grainsizevxl*PixelSize;
    for i=1:length(grainsize)
        grainsize(i)=(grainsize(i)*4/pi)^0.5; % obliczenie ECD
    end
    clear i;
end
clear MapStepSize;
% koniec wielkosci ziaren w [um] lub [um2]

% odrzucenie brzegowych ziaren

    % lista brzegowych ziaren
    edgegrains(1:wymiary(2))=grainmap(1,:); % N
    edgegrains(wymiary(2)+1:2*wymiary(2))=grainmap(wymiary(1),:); % S
    edgegrains(2*wymiary(2)+1:2*wymiary(2)+wymiary(1))=grainmap(:,1); % W
    edgegrains(2*wymiary(2)+wymiary(1)+1:2*wymiary(2)+2*wymiary(1))=grainmap(:,wymiary(2)); % E
    uedgegrains=unique(edgegrains);
    clear edgegrains;
    % koniec listy brzegowych ziaren
    
    % odrzucenie brzegowych ziaren
    for i=length(uedgegrains):-1:1
        grainsize(uedgegrains(i))=[];
        grainsizevxl(uedgegrains(i))=[];
    end
    clear i uedgegrains;
    % koniec odrzucania brzegowych ziaren
    
% koniec odrzucania brzegowych ziaren

% histogram wielkosci ziaren
GSDmax=ceil(max(grainsize)); % najwieksze ziarno
binwidth=GSDmax/NumberOfBins; % szerokosc przedzialow
    
    % granice przedzialow
    GShist=zeros(NumberOfBins+1,2); % inicjalizacja
    for i=2:NumberOfBins+1
        GShist(i)=GShist(i-1)+binwidth;
    end
    clear i;
    % koniec kranic przedzialow
    
    % wyznaczenie histogramu
    if HistType==1 % histogram liczbowy
        GShist(:,2)=hist(grainsize,GShist(:,1)); % wyznaczenie histogramu
        GShist(:,2)=GShist(:,2)/length(grainsize); % normalizacja number fraction
    elseif HistType==2 % histogram powierzchniowy        
        for i=1:length(grainsize) % petla po wszystkich ziarnach
            for j=1:NumberOfBins % petla po binach
                if (grainsize(i)>GShist(j,1) && grainsize(i)<GShist(j+1,1))
                    GShist(j,2)=GShist(j,2)+grainsizevxl(i)*PixelSize;
                    break;
                end
            end
        end
        clear i j;
        MapArea=(wymiary(1)-1)*(wymiary(2)-1)*PixelSize; % normalizacja area fraction
        GShist(:,2)=GShist(:,2)/MapArea; % normalizacja area fraction
        clear MapArea VoxelSize;       
    end
    % koniec wyznaczania histogramu

clear binwidth;
% koniec histogramu wielkosci ziaren

% wykres histogramu
if PlotType==1 % prosty
    plot(GShist(:,1),GShist(:,2),'k-');
elseif PlotType==2 % spline
    x=GShist(1,1):0.1*GShist(2,1):GShist(length(GShist),1); % zakres x do resamplingu
    y=spline(GShist(:,1),GShist(:,2));
    plot(GShist(:,1),GShist(:,2),'k.',x,ppval(y,x),'k-');
    clear x y;
end
ymax=1.1*max(GShist(:,2)); % okreslenie pionowej skali wykresu
axis([0 GSDmax 0 ymax]); % okreslenie skali wykresu
clear ymax GSDmax;
% koniec wykresu histogramu

% czyszczenie pamieci
clear wymiary NumberOfBins SizeType HistType PlotType;

toc