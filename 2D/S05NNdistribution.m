% boliczanie liczby sasiadow i ich rozkladu
tic

% parametry zewnetrzne i zmienne globlane
wymiary=size(grainmap);
PlotType=2; % 1-simple, 2-spline

% macierz sasiadow
P22g=boundarypoints.P22.grainno;
sP22g=size(P22g);
neighbormatrix22=zeros(grainnumber,grainnumber); % inicjalizacja
for i=1:sP22g(1)
    neighbormatrix22(P22g(i,1),P22g(i,2))=1;
    neighbormatrix22(P22g(i,2),P22g(i,1))=1;
end
clear i P22g sP22g;
% koniec macierzy sasiadow

% lista sasiadow
neighborlist22=zeros(grainnumber,2); % struktura: NN,0,GN1,GN2,...
for i=1:grainnumber
    k=2; % numerator kolumn
    for j=1:grainnumber
        if neighbormatrix22(i,j)==1
            k=k+1;
            neighborlist22(i,k)=j; % zanotowanie numeru ziarna
        end
    end
    neighborlist22(i,1)=k-2; % zanotowanie liczby sasiadow
end
clear i j k neighbormatrix22;
% koniec listy sasiadow

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
        neighborlist22(uedgegrains(i),:)=[];
    end
    clear i uedgegrains;
    % koniec odrzucania brzegowych ziaren
    
% koniec odrzucania brzegowych ziaren

% histogram liczby sasiadow
NNmax=max(neighborlist22(:,1)); % inicjalizacja
NNhist=zeros(NNmax,2); % maximum histogramu

    % wartosci histogramu
    for i=1:length(neighborlist22)
        NNhist(neighborlist22(i,1),2)=NNhist(neighborlist22(i,1),2)+1;
    end
    clear i;
    NNhist=NNhist/length(neighborlist22); % normalizacja number fraction
    clear neighborlist22;
    % koniec wartosci histogramu

    % kategorie histogramu
    for i=1:NNmax
        NNhist(i,1)=i;
    end
    clear i;
    % koniec kategorii histogramu
    
clear NNmax;
% koniec histogramu liczby sasiadow

% wykres histogramu
if PlotType==1 % prosty
    plot(NNhist(:,1),NNhist(:,2),'k.-');
elseif PlotType==2 % spline
    x=NNhist(1,1):0.1:length(NNhist); % zakres x do resamplingu
    y=spline(NNhist(:,1),NNhist(:,2));
    plot(NNhist(:,1),NNhist(:,2),'k.',x,ppval(y,x),'k-');
    clear x y;
end
ymax=1.1*max(NNhist(:,2)); % okreslenie pionowej skali wykresu
axis([0 length(NNhist) 0 ymax]); % okreslenie skali wykresu  
clear ymax;
% koniec wykresu histogramu

% czyszczenie pamieci
clear wymiary PlotType;

toc