% laczenie punktow granicznych w pary krawedziowe
tic

% zmienne globalne i parametry zewnetrzne
wymiary=size(grainmap);

% przygotowanie zbioru danych

    % zamiana BP.P23 na liste PP23
    P23g=boundarypoints.P23.grainno; % zmienna dziala szybciej niz struktura
    sP23=size(P23g);
    PP23=zeros(3*sP23(1),4); % inicjalizacja, PP23: typ,numer,GN1,GN2
    for i=1:sP23(1)
        % pierwszy dublet
        PP23(3*i-2,1:2)=[23 i]; % typ i numer punktu
        PP23(3*i-2,3:4)=P23g(i,1:2); % numery ziaren
        % drugi dublet
        PP23(3*i-1,1:2)=[23 i];
        PP23(3*i-1,3)=P23g(i,1);
        PP23(3*i-1,4)=P23g(i,3);
        % trzeci dublet
        PP23(3*i,1:2)=[23 i];
        PP23(3*i,3:4)=P23g(i,2:3);
    end
    clear P23g sP23 i;
    % koniec zamiany BP.P23 na liste PP23

    % ----------
    % POMIJAM ZAMANE P24
    % ----------

    % zamiana BP.P12 na PP12
    P12g=boundarypoints.P12.grainno; % zmienna dziala szybciej niz struktura
    sP12=size(P12g);
    PP12=zeros(sP12(1),4); % inicjalizajca, PP12: typ,numer,GN1,GN2
    for i=1:sP12(1)
        PP12(i,1:2)=[12 i]; % typ i numer punktu
        PP12(i,3:4)=P12g(i,1:2); % numery ziaren
    end
    clear P12g sP12 i;
    % koniec zamiany BP.P12 na PP12

    % scalenie list par granicznych
    sPP23=size(PP23);
    sPP12=size(PP12);
    P2=zeros(sPP23(1)+sPP12(1),4);
    P2(1:sPP23(1),1:4)=PP23(1:sPP23(1),1:4);
    P2(sPP23(1)+1:sPP23(1)+sPP12(1),1:4)=PP12(1:sPP12(1),1:4);
    clear PP23 PP12 sPP23 sPP12;
    % koniec scalania list par granicznych

% koniec przygotowania zbioru danych

% wyszukiwanie par w P2
        % struktura boundaryedges.D2.points: t1,n1,t2,n2
        % struktura boundaryedges.D2.grainno: g1,g2
    nBE=0; % numerator BE-boundaryedges
    BEpoints=zeros(ceil(length(P2)/2),4); % inicjalizacja
    BEgrainno=zeros(ceil(length(P2)/2),2); % inicjalizacja
    nSingle2=0; % numerator singli
    Single2points=zeros(100,2); % inicjalizacja
    Single2grainno=zeros(100,2); % inicjalizacja
    nMultiple2=0; % numerator multipli
    Multiple2points=zeros(100,4); % inicjalizacja
    Multiple2grainno=zeros(100,2); % inicjalizacja

    % petla glowna parowania punktow
    while ~isempty(P2)
        fP2=find(P2(:,3)==P2(1,3) & P2(:,4)==P2(1,4)); % indeksy pary
        lfP2=length(fP2); % liczba znalezionych punktow

        % poprawne pary punktow
        if lfP2==2
            nBE=nBE+1;
            BEpoints(nBE,1:2)=P2(fP2(1),1:2); % typ i numer 1. punktu
            BEpoints(nBE,3:4)=P2(fP2(2),1:2); % typ i numer 2. punktu
            BEgrainno(nBE,1:2)=P2(fP2(1),3:4); % numery ziaren
            P2(fP2(2),:)=[]; % usuniecie wykorzystanego punktu z listy
            P2(fP2(1),:)=[]; % usuniecie wykorzystanego punktu z listy

        % zanotowanie singli
        elseif lfP2==1
            nSingle2=nSingle2+1;
            Single2points(nSingle2,1:2)=P2(fP2(1),1:2); % typ i numer singla
            Single2grainno(nSingle2,1:2)=P2(fP2(1),3:4); % numery ziaren singla
            P2(fP2(1),:)=[]; % usuniecie wykorzystanego punktu z listy

        % zanotowanie multipli
        else
            nMultiple2=nMultiple2+1;
            Multiple2grainno(nMultiple2,1:2)=P2(fP2(1),3:4); % numery ziaren
            Multiple2points(nMultiple2,1)=lfP2; % liczba problematycznych punktow
            for i=1:lfP2
                Multiple2points(nMultiple2,2*i+1)=P2(fP2(i),1); % typ punktu
                Multiple2points(nMultiple2,2*i+2)=P2(fP2(i),2); % numer punktu
            end
            for i=lfP2:-1:1 % usuniecie wykorzystanych punktow z listy
                P2(fP2(i),:)=[];
            end
            clear i;
        end

    end
    clear P2 fP2 lfP2;
    % koniec petli glownej parowania punktow

    % kasowanie nadmiarowych 0 po alokacji
    for i=length(BEgrainno):-1:1
        if BEgrainno(i,1)==0
            BEgrainno(i,:)=[];
            BEpoints(i,:)=[];
        end
    end
    clear i;
    if nSingle2<100
        Single2points(nSingle2+1:100,:)=[];
        Single2grainno(nSingle2+1:100,:)=[];
    end
    if nMultiple2<100
        Multiple2points(nMultiple2+1:100,:)=[];
        Multiple2grainno(nMultiple2+1:100,:)=[];
    end
    % koniec kasowania nadmiarowych 0 po alokacji

% koniec wyszukiwania par w P2

% uzupelnienie singli (i multipli) z P24
if isfield(boundarypoints,'P24') % sprawdzenie czy P24 istnieja

    % zamiana P24 na P2
        % -----NUMERY ZIAREN P24 SA POSORTOWANE-----
        % -----I NIE TRZYMAJA KOLEJNOSCI KLASTERA-----
    P24g=boundarypoints.P24.grainno; % zmienna dziala szybciej niz struktura
    P24c=boundarypoints.P24.coord; % zmienna dziala szybciej niz struktura
    sP24g=size(P24g); % sprawdzenie rozmiaru P24
    P2=zeros(4*sP24g(1),4); % ponowna inicjalizacja P2:typ,numer,GN1,GN2
    for i=1:sP24g(1)

        % wspolrzedne punktu
        y=P24c(i,1);
        x=P24c(i,2);

        % pierwszy dublet
        P2(4*i-3,1:2)=[24 i]; % typ i numer punktu
        P2(4*i-3,3)=grainmap(y,x); % numer ziarna (y,x)
        P2(4*i-3,4)=grainmap(y,x+1); % numer ziarna (y,x+1)
        % drugi dublet
        P2(4*i-2,1:2)=[24 i];
        P2(4*i-2,3)=grainmap(y,x+1); % numer ziarna (y,x+1)
        P2(4*i-2,4)=grainmap(y+1,x+1); % numer ziarna (y+1,x+1)
        % trzeci dublet
        P2(4*i-1,1:2)=[24 i];
        P2(4*i-1,3)=grainmap(y+1,x+1); % numer ziarna (y+1,x+1)
        P2(4*i-1,4)=grainmap(y+1,x); % numer ziarna (y+1,x)
        % czwarty dublet
        P2(4*i,1:2)=[24 i];
        P2(4*i,3)=grainmap(y+1,x); % numer ziarna (y+1,x)
        P2(4*i,4)=grainmap(y,x); % numer ziarna (y,x)
    end
    nP2=4*sP24g(1);

        % sortowanie numerow ziaren
        for i=1:nP2
            if P2(i,3)>P2(i,4)
                k=P2(i,4);
                P2(i,4)=P2(i,3);
                P2(i,3)=k;
            end
        end
        clear k;
        % koniec sortowania numerow ziaren

    clear P24g P24c sP24g i y x;
    % koniec zamiany P24 na P2

    % uzupelnienie singli z P24
    if nSingle2>0 % sprawdzenie czy istnieja single
        for i=1:nSingle2 % petla po singlach
            for j=1:nP2 % petla po P2
                if Single2grainno(i,1)==P2(j,3) 
                    if Single2grainno(i,2)==P2(j,4)
                        nBE=nBE+1;
                        BEgrainno(nBE,1:2)=Single2grainno(i,1:2); % przepisanie numerow ziaren
                        BEpoints(nBE,1:2)=Single2points(i,1:2); % przepisanie 1. punktu
                        BEpoints(nBE,3:4)=P2(j,1:2); % przepisanie 2. punktu
                        Single2grainno(i,1:2)=[0 0]; % zerowanie uzupelnionych singli
                        Single2points(i,1:2)=[0 0]; % zerowanie uzupelnionych singli
                        P2(j,1:4)=[-1 -1 -1 -1]; % zerowanie wykorzystanych P24
                        break;
                    end
                end
            end
        end
        clear i j;

        % usuwanie uzupelnionych singli z listy
        for i=nSingle2:-1:1
            if Single2points(i,1)==0
                Single2points(i,:)=[];
                Single2grainno(i,:)=[];
                nSingle2=nSingle2-1;
            end
        end
        clear i;
        % koniec usuwania uzupelnionych singli z listy

        % usuwanie wykorzystanych P24
        for i=nP2:-1:1
            if P2(i,1)==-1
                P2(i,:)=[];
                nP2=nP2-1;
            end
        end
        clear i;
        % koniec usuwania wykorzystanych P24

    end
    % koniec uzupelniania singli z P24

    % uzupelnienie multipli z P24
    if (nMultiple2>0 && nP2>0) % sprawdzenie czy istnieja multiple
        for i=1:nMultiple2 % petla po multiplach
            for j=1:nP2 % petla po P2
                if Multiple2grainno(i,1)==P2(j,3)
                    if Multiple2grainno(i,2)==P2(j,4)
                        Multiple2points(i,1)=Multiple2points(i,1)+1;
                        Multiple2points(i,2*Multiple2points(i,1)+1)=P2(j,1);
                        Multiple2points(i,2*Multiple2points(i,1)+2)=P2(j,2);
                        P2(j,1:4)=[-1 -1 -1 -1]; % zerowanie wykorzystanych P24
                    end
                end
            end
        end
        clear i j;

        % usuwanie wykorzystanych P24
        for i=nP2:-1:1
            if P2(i,1)==-1
                P2(i,:)=[];
                nP2=nP2-1;
            end
        end
        clear i;
        % koniec usuwania wykorzystanych P24

    end
    % koniec uzupelniania multipli z P24

    % polaczenie P24 w pary
    if ~isempty(P2)
        while ~isempty(P2)
            fP2=find(P2(:,3)==P2(1,3) & P2(:,4)==P2(1,4)); % indeksy pary
            lfP2=length(fP2); % liczba znalezionych punktow

            % poprawne pary punktow
            if lfP2==2
                nBE=nBE+1;
                BEpoints(nBE,1:2)=P2(fP2(1),1:2); % typ i numer 1. punktu
                BEpoints(nBE,3:4)=P2(fP2(2),1:2); % typ i numer 2. punktu
                BEgrainno(nBE,1:2)=P2(fP2(1),3:4); % numery ziaren
                P2(fP2(2),:)=[]; % usuniecie wykorzystanego punktu z listy
                P2(fP2(1),:)=[]; % usuniecie wykorzystanego punktu z listy
            else
                disp('nie sparowano wszystkich P24');
            end
            % koniec poprawnych par punktow
        end
%         clear fP2 lfP2 P2 nP2;
    end
    clear fP2 lfP2 P2 nP2;
    % koniec laczenia P24 w pary
    
end
% koniec uzupelniania singli (i multipli) z P24

% parowanie multipli metoda skokow po granicy
sMultiple2=size(Multiple2points);
for i=1:sMultiple2(1) % petla po wszystkich multiplach

    % pobranie jednego multipla
    MultipleGN(1:2)=Multiple2grainno(i,1:2);
    MultipleP=Multiple2points(i,:);

    % konwersja multipla
    MultipleYX=zeros(MultipleP(1),4); % struktura: typ,numer,y,x
    for j=1:MultipleP(1)
        MultipleYX(j,1:2)=MultipleP(2*j+1:2*j+2); % kopiowanie typu i numeru
        if MultipleYX(j,1)==23
            MultipleYX(j,3:4)=boundarypoints.P23.coord(MultipleYX(j,2),1:2);
        elseif MultipleYX(j,1)==24
            MultipleYX(j,3:4)=boundarypoints.P24.coord(MultipleYX(j,2),1:2);
        elseif MultipleYX(j,1)==12
            MultipleYX(j,3:4)=boundarypoints.P12.coord(MultipleYX(j,2),1:2);
        end
    end
    clear j;
    MultipleP(2:length(MultipleP))=[]; % pozostawiam tylko liczbe punktow
    % koniec konwersji multipla

    % parowanie punktow w multiplu
    for j=1:MultipleP % petla po wszystkich punktach w multiplu,
        if MultipleYX(j,1)~=0 % ktore nie jeszcze zostaly wyzerowane

            % wspolrzedne punktu
            y=MultipleYX(j,3);
            x=MultipleYX(j,4);

            % tablica przejsc
            Jump=zeros(4,2); % inicjalizacja: GN1,GN2
            if x<wymiary(2)
                Jump(1,1:2)=sort([grainmap(y,x) grainmap(y,x+1)]); % N
                if y<wymiary(1)
                    Jump(2,1:2)=sort([grainmap(y,x+1) grainmap(y+1,x+1)]); % E
                    Jump(3,1:2)=sort([grainmap(y+1,x) grainmap(y+1,x+1)]); % S
                end
            end
            if y<wymiary(1)
                Jump(4,1:2)=sort([grainmap(y,x) grainmap(y+1,x)]); % W
            end

            % wybor kierunku 1. przejscia
            KierunekPrzejscia=0;
            for k=1:4
                if (Jump(k,1)==MultipleGN(1) && Jump(k,2)==MultipleGN(2))
                    KierunekPrzejscia=k;
                    break;
                end
            end
            clear k;

            % wykonanie kroku
            if KierunekPrzejscia==1 % N
                y=y-1;
            elseif KierunekPrzejscia==2 % E
                x=x+1;
            elseif KierunekPrzejscia==3 % S
                y=y+1;
            elseif KierunekPrzejscia==4 % W
                x=x-1;
            end

            % petla glowna
            if KierunekPrzejscia>0 % okreslono kierunek przejscia
                
                para=0;
                while para==0

                    % sprawdzenie zakonczenia odcinka
                    for k=1:MultipleP
                        if (y==MultipleYX(k,3) && x==MultipleYX(k,4))
                            para=k;
                            break;
                        end
                    end
                    clear k;

                    if para~=0 % znaleziono drugi punkt

                        nBE=nBE+1;
                        BEgrainno(nBE,1:2)=MultipleGN(1:2);
                        BEpoints(nBE,1:2)=MultipleYX(j,1:2);
                        BEpoints(nBE,3:4)=MultipleYX(para,1:2);
                        MultipleYX(j,1:4)=[0 0 0 0];
                        MultipleYX(para,1:4)=[0 0 0 0];

                    else % nie znaleziono drugiego punktu

                        % tablica przejsc
                        if x<wymiary(2)
                            Jump(1,1:2)=sort([grainmap(y,x) grainmap(y,x+1)]); % N
                            if y<wymiary(1)
                                Jump(2,1:2)=sort([grainmap(y,x+1) grainmap(y+1,x+1)]); % E
                                Jump(3,1:2)=sort([grainmap(y+1,x) grainmap(y+1,x+1)]); % S
                            end
                        end
                        if y<wymiary(1)
                            Jump(4,1:2)=sort([grainmap(y,x) grainmap(y+1,x)]); % W
                        end

                        % zerowanie kierunku nadejscia
                        if KierunekPrzejscia==1
                            Jump(3,1:2)=[0 0];
                        elseif KierunekPrzejscia==2
                            Jump(4,1:2)=[0 0];
                        elseif KierunekPrzejscia==3
                            Jump(1,1:2)=[0 0];
                        else
                            Jump(2,1:2)=[0 0];
                        end

                        % wybor kierunku przejscia
                        KierunekPrzejscia=0;
                        for k=1:4
                            if (Jump(k,1)==MultipleGN(1) && Jump(k,2)==MultipleGN(2))
                                KierunekPrzejscia=k;
                                break;
                            end
                        end
                        clear k;

                        % wykonanie kroku
                        if KierunekPrzejscia==1 % N
                            y=y-1;
                        elseif KierunekPrzejscia==2 % E
                            x=x+1;
                        elseif KierunekPrzejscia==3 % S
                            y=y+1;
                        elseif KierunekPrzejscia==4 % W
                            x=x-1;
                        else % nie okreslono kierunku przejscia
                            nSingle2=nSingle2+1;
                            Single2points(nSingle2,1:2)=MultipleYX(j,1:2); % typ i numer singla
                            Single2grainno(nSingle2,1:2)=MultipleGN(1:2); % numery ziaren singla
                            MultipleYX(j,1:4)=[0 0 0 0]; % usuniecie wykorzystanego punktu z listy
                            break;
                        end
                    end
                end
                clear para;
                
            else % nie okreslono kierunku przejscia
                nSingle2=nSingle2+1;
                Single2points(nSingle2,1:2)=MultipleYX(j,1:2); % typ i numer singla
                Single2grainno(nSingle2,1:2)=MultipleGN(1:2); % numery ziaren singla
                MultipleYX(j,1:4)=[0 0 0 0]; % usuniecie wykorzystanego punktu z listy
            end
        end
        clear Jump y x KierunekPrzejscia;
    end
    clear j;
    % koniec parowania punktow w multiplu

    % usuniecie wykorzystanych punktow z multipla
    for j=MultipleP:-1:1
        if MultipleYX(j,1)==0
            MultipleYX(j,:)=[];
        end
    end
    clear j;
    % koniec usuwania wykorzystanych punktow z multipla

    % aktualizacja BE.Multiple2
    if isempty(MultipleYX) % wszystkie punkty sparowane
        Multiple2points(i,1:sMultiple2(2))=0;
        Multiple2grainno(i,1:2)=[0 0];
    else % niesparowane punkty
        sMultipleYX=size(MultipleYX); % liczba niesparowanych punktow
        Multiple2points(i,1)=sMultipleYX(1); % zapis liczby niesparowanych
        for j=1:sMultipleYX(1) % zapis typu i numeru niesparowanych
            Multiple2points(i,2*j+1)=MultipleYX(j,1);
            Multiple2points(i,2*j+2)=MultipleYX(j,2);
        end
        Multiple2points(2*j+3:sMultiple2(2))=0; % zerowanie reszty
        clear j;
    end
    clear MultipleYX sMultipleYX;
    % koniec aktualizacji BE.Multiple2
end

    % usuwanie poprawionych multipli
    for i=sMultiple2(1):-1:1
        if Multiple2points(i,1)==0
            Multiple2points(i,:)=[];
            Multiple2grainno(i,:)=[];
        end
    end
    clear i;
    % koniec usuwania poprawionych multipli

    clear MultipleGN MultipleP sMultiple2 sBE wymiary;

% koniec parowania multipli metoda skokow po granicy

% tworzenie zbioru wynikowego
boundaryedges.D2.grainno=BEgrainno;
boundaryedges.D2.points=BEpoints;
clear BEgrainno BEpoints nBE;

if exist('Single2points','var')
    if ~isempty(Single2points)
        boundaryedges.Single2.points=Single2points;
        boundaryedges.Single2.grainno=Single2grainno;
    end
    clear Single2points Single2grainno nSingle2;
end
if exist('Multiple2points','var')
    if ~isempty(Multiple2points)
        boundaryedges.Multiple2.points=Multiple2points;
        boundaryedges.Multiple2.grainno=Multiple2grainno;
    end
    clear Multiple2points Multiple2grainno nMultiple2;
end
% koniec tworzenia zbioru wynikowego

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;