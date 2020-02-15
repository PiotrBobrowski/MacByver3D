% laczenie punktow granicznych w pary krawedziowe
% ----------
% metoda lini wychodzacych z klastera
% zakladam brak sortowania 24
% ----------
tic

% parametry zewnetrzne i zmienne globalne
wymiary=size(grainmap);

% czyszczenie starych danych
if exist('boundarylines','var')
    clear boundarylines;
end
% koniec czyszczenia starych danych

% wyszukiwanie par w P34 (i P24 oraz P38)
    % przygotowanie zbioru danych
        % zamiana P34 na P3 i P4
            % pobranie danych i inicjalizacja tablic P3 i P4
            P34c=boundarypoints.P34.coord; % pobranie danych P34
            sP34c=size(P34c);
            P3=zeros(4*sP34c(1),5,'uint32'); % inicjalizacja: t,n,g1,g2,g3
            P4=zeros(sP34c(1),6,'uint32'); % inicjalizacja: t,n,g1,g2,g3,g4
            nP3=0; % numerator P3
            nP4=0; % numerator P4
            % koniec inicjalizacji tablic P3 i P4

        for i=1:sP34c(1) % petla po P34

            % okreslenie wspolrzednych punktu
            y=P34c(i,1);
            x=P34c(i,2);
            z=P34c(i,3);

            % kierunek z-1
            z1=unique([grainmap(y,x,z) grainmap(y,x+1,z) grainmap(y+1,x+1,z) grainmap(y+1,x,z)]);
            if length(z1)==3 % linia potrojna
                nP3=nP3+1;
                P3(nP3,1:2)=[34 i];
                P3(nP3,3:5)=z1(1:3);
            elseif length(z1)==4 % linia poczworna
                nP4=nP4+1;
                P4(nP4,1:2)=[34 i];
                P4(nP4,3:6)=z1(1:4);
            end

            % kierunek z+1
            z2=unique([grainmap(y,x,z+1) grainmap(y,x+1,z+1) grainmap(y+1,x+1,z+1) grainmap(y+1,x,z+1)]);
            if length(z2)==3 % linia potrojna
                nP3=nP3+1;
                P3(nP3,1:2)=[34 i];
                P3(nP3,3:5)=z2(1:3);
            elseif length(z2)==4 % linia poczworna
                nP4=nP4+1;
                P4(nP4,1:2)=[34 i];
                P4(nP4,3:6)=z2(1:4);
            end

            % kierunek y-1
            y1=unique([grainmap(y,x,z) grainmap(y,x+1,z) grainmap(y,x+1,z+1) grainmap(y,x,z+1)]);
            if length(y1)==3 % linia potrojna
                nP3=nP3+1;
                P3(nP3,1:2)=[34 i];
                P3(nP3,3:5)=y1(1:3);
            elseif length(y1)==4 % linia poczworna
                nP4=nP4+1;
                P4(nP4,1:2)=[34 i];
                P4(nP4,3:6)=y1(1:4);
            end

            % kierunek y+1
            y2=unique([grainmap(y+1,x,z) grainmap(y+1,x+1,z) grainmap(y+1,x+1,z+1) grainmap(y+1,x,z+1)]);
            if length(y2)==3 % linia potrojna
                nP3=nP3+1;
                P3(nP3,1:2)=[34 i];
                P3(nP3,3:5)=y2(1:3);
            elseif length(y2)==4 % linia poczworna
                nP4=nP4+1;
                P4(nP4,1:2)=[34 i];
                P4(nP4,3:6)=y2(1:4);
            end

            % kierunek x-1
            x1=unique([grainmap(y,x,z) grainmap(y+1,x,z) grainmap(y+1,x,z+1) grainmap(y,x,z+1)]);
            if length(x1)==3 % linia potrojna
                nP3=nP3+1;
                P3(nP3,1:2)=[34 i];
                P3(nP3,3:5)=x1(1:3);
            elseif length(x1)==4 % linia poczworna
                nP4=nP4+1;
                P4(nP4,1:2)=[34 i];
                P4(nP4,3:6)=x1(1:4);
            end

            % kierunek x+1
            x2=unique([grainmap(y,x+1,z) grainmap(y+1,x+1,z) grainmap(y+1,x+1,z+1) grainmap(y,x+1,z+1)]);
            if length(x2)==3 % linia potrojna
                nP3=nP3+1;
                P3(nP3,1:2)=[34 i];
                P3(nP3,3:5)=x2(1:3);
            elseif length(x2)==4 % linia poczworna
                nP4=nP4+1;
                P4(nP4,1:2)=[34 i];
                P4(nP4,3:6)=x2(1:4);
            end
        end % koniec petli po P34
        clear i y x z y1 y2 x1 x2 z1 z2 P34c;
        % koniec zamiany P34 na P3

        % polaczenie P23 z P3
        if isfield(boundarypoints,'P23')
            sP23g=size(boundarypoints.P23.grainno);
            for i=1:sP23g(1)
                nP3=nP3+1;
                P3(nP3,1:2)=[23 i];
                P3(nP3,3:5)=boundarypoints.P23.grainno(i,1:3);
            end
            clear i sP23g;
        end
        % koniec laczenia P23 z P3

        % polaczenie P24 z P4
        if isfield(boundarypoints,'P24')
            sP24g=size(boundarypoints.P24.grainno);
            for i=1:sP24g(1)
                nP4=nP4+1;
                P4(nP4,1:2)=[24 i];
                P4(nP4,3:6)=boundarypoints.P24.grainno(i,1:4);
            end
            clear i sP24g;
        end
        % koniec laczenia P24 z P4

        % polaczenie P38 z P3 i P4
        if isfield(boundarypoints,'P38') % sprawdzenie czy sa P38
            P38c=boundarypoints.P38.coord;
            sP38c=size(P38c);
            for i=1:sP38c(1) % petla po P38

                % okreslenie wspolrzednych punktu
                y=P38c(i,1);
                x=P38c(i,2);
                z=P38c(i,3);

                % kierunek z-1
                z1=unique([grainmap(y,x,z) grainmap(y,x+1,z) grainmap(y+1,x+1,z) grainmap(y+1,x,z)]);
                if length(z1)==3 % linia potrojna
                    nP3=nP3+1;
                    P3(nP3,1:2)=[34 i];
                    P3(nP3,3:5)=z1(1:3);
                elseif length(z1)==4 % linia poczworna
                    nP4=nP4+1;
                    P4(nP4,1:2)=[34 i];
                    P4(nP4,3:6)=z1(1:4);
                end

                % kierunek z+1
                z2=unique([grainmap(y,x,z+1) grainmap(y,x+1,z+1) grainmap(y+1,x+1,z+1) grainmap(y+1,x,z+1)]);
                if length(z2)==3 % linia potrojna
                    nP3=nP3+1;
                    P3(nP3,1:2)=[34 i];
                    P3(nP3,3:5)=z2(1:3);
                elseif length(z2)==4 % linia poczworna
                    nP4=nP4+1;
                    P4(nP4,1:2)=[34 i];
                    P4(nP4,3:6)=z2(1:4);
                end

                % kierunek y-1
                y1=unique([grainmap(y,x,z) grainmap(y,x+1,z) grainmap(y,x+1,z+1) grainmap(y,x,z+1)]);
                if length(y1)==3 % linia potrojna
                    nP3=nP3+1;
                    P3(nP3,1:2)=[34 i];
                    P3(nP3,3:5)=y1(1:3);
                elseif length(y1)==4 % linia poczworna
                    nP4=nP4+1;
                    P4(nP4,1:2)=[34 i];
                    P4(nP4,3:6)=y1(1:4);
                end

                % kierunek y+1
                y2=unique([grainmap(y+1,x,z) grainmap(y+1,x+1,z) grainmap(y+1,x+1,z+1) grainmap(y+1,x,z+1)]);
                if length(y2)==3 % linia potrojna
                    nP3=nP3+1;
                    P3(nP3,1:2)=[34 i];
                    P3(nP3,3:5)=y2(1:3);
                elseif length(y2)==4 % linia poczworna
                    nP4=nP4+1;
                    P4(nP4,1:2)=[34 i];
                    P4(nP4,3:6)=y2(1:4);
                end

                % kierunek x-1
                x1=unique([grainmap(y,x,z) grainmap(y+1,x,z) grainmap(y+1,x,z+1) grainmap(y,x,z+1)]);
                if length(x1)==3 % linia potrojna
                    nP3=nP3+1;
                    P3(nP3,1:2)=[34 i];
                    P3(nP3,3:5)=x1(1:3);
                elseif length(x1)==4 % linia poczworna
                    nP4=nP4+1;
                    P4(nP4,1:2)=[34 i];
                    P4(nP4,3:6)=x1(1:4);
                end

                % kierunek x+1
                x2=unique([grainmap(y,x+1,z) grainmap(y+1,x+1,z) grainmap(y+1,x+1,z+1) grainmap(y,x+1,z+1)]);
                if length(x2)==3 % linia potrojna
                    nP3=nP3+1;
                    P3(nP3,1:2)=[34 i];
                    P3(nP3,3:5)=x2(1:3);
                elseif length(x2)==4 % linia poczworna
                    nP4=nP4+1;
                    P4(nP4,1:2)=[34 i];
                    P4(nP4,3:6)=x2(1:4);
                end

            end % koniec petli po P38
            clear i y x z y1 y2 x1 x2 z1 z2 P38c sP38c;
        end % koniec sprawdzenia czy sa P38
        % koniec laczenia P38 z P3 i P4

        % usuniecie nadmiarowych zer po inicjalizacji P3 i P4
        if nP3<4*sP34c(1)
            P3(nP3+1:length(P3),:)=[];
        end
        clear sP34c;
        if nP4==0 % zmiana 31.10.2019, stary warunek: max(P4)==0
            clear P4 nP4; % usun tablice jesli pusta
        elseif nP4<length(P4) % skroc tablice jesli za dluga
            P4(nP4+1:length(P4),:)=[];
        end
        % koniec usuwania nadmiarowych zer po inicjalizacji        
    % koniec przygotowania zbioru danych

    % petla glowna parowania punktow P3
        % struktura BL3points: t1,n1,t2,n2
        % struktura BL3grainno: g1,g2,g3
    BL3points=zeros(nP3,4,'uint32'); % inicjalizacja
    BL3grainno=zeros(nP3,3,'uint32'); % inicjalizacja
    Single3points=zeros(100,2,'uint32'); % inicjalizacja
    Single3grainno=zeros(100,3,'uint32'); % inicjalizacja
    Multiple3points=zeros(100,4,'uint32'); % inicjalizacja
    Multiple3grainno=zeros(100,3,'uint32'); % inicjalizacja
    nBL3=0; % numerator BE-boundarylines
    nSingle3=0; % numerator singli
    nMultiple3=0; % numerator multipli    

    while ~isempty(P3) % rob dopoki sa P3
        fP3=find(P3(:,3)==P3(1,3) & P3(:,4)==P3(1,4) & P3(:,5)==P3(1,5));
        lfP3=length(fP3); % liczba znalezionych punktow

        % poprawne pary punktow
        if lfP3==2
            nBL3=nBL3+1;
            BL3points(nBL3,1:2)=P3(fP3(1),1:2); % typ i numer 1. punktu
            BL3points(nBL3,3:4)=P3(fP3(2),1:2); % typ i numer 2. punktu
            BL3grainno(nBL3,1:3)=P3(fP3(1),3:5); % nr 1.2.3. ziarna
            P3(fP3(2),:)=[]; % usuniecie wykorzystanego punktu z listy
            P3(fP3(1),:)=[]; % usuniecie wykorzystanego punktu z listy

        % zanotowanie singli
        elseif lfP3==1
            nSingle3=nSingle3+1;
            Single3points(nSingle3,1:2)=P3(fP3(1),1:2); % typ i numer
            Single3grainno(nSingle3,1:3)=P3(fP3(1),3:5); % numery ziaren
            P3(fP3(1),:)=[]; % usuniecie wykorzystanego punktu z listy

        % zanotowanie multipli
        else
            nMultiple3=nMultiple3+1;
            Multiple3grainno(nMultiple3,1:3)=P3(fP3(1),3:5); % numery ziaren
            Multiple3points(nMultiple3,1)=lfP3; % liczba punktow
            for i=1:lfP3
                Multiple3points(nMultiple3,2*i+1)=P3(fP3(i),1); % typ punktu
                Multiple3points(nMultiple3,2*i+2)=P3(fP3(i),2); % numer punktu
            end
            for i=lfP3:-1:1 % usuniecie wykorzystanych punktow z listy
                P3(fP3(i),:)=[];
            end
            clear i;
        end
    end % koniec robienia dopoki sa P3
    clear P3 fP3 lfP3;
    % koniec petli glownej parowania punktow P3

    % petla glowna parowania punktow P4
    if exist('P4','var') % sprawdzenie czy istnieja P4
        % struktura BL4points: t1,n1,t2,n2
        % struktura BL4grainno: g1,g2,g3,g4
        BL4points=zeros(nP4,4,'uint32'); % inicjalizacja
        BL4grainno=zeros(nP4,4,'uint32'); % inicjalizacja
        Single4points=zeros(10,2,'uint32'); % inicjalizacja
        Single4grainno=zeros(10,3,'uint32'); % inicjalizacja
        Multiple4points=zeros(10,4,'uint32'); % inicjalizacja
        Multiple4grainno=zeros(10,3,'uint32'); % inicjalizacja
        nBL4=0; % numerator BE-boundarylines
        nSingle4=0; % numerator singli
        nMultiple4=0; % numerator multipli    

        while ~isempty(P4) % rob dopoki sa P4
            fP4=find(P4(:,3)==P4(1,3) & P4(:,4)==P4(1,4) & P4(:,5)==P4(1,5) & P4(:,6)==P4(1,6));
            lfP4=length(fP4); % liczba znalezionych punktow

            % poprawne pary punktow
            if lfP4==2
                nBL4=nBL4+1;
                BL4points(nBL4,1:2)=P4(fP4(1),1:2); % typ i numer 1. punktu
                BL4points(nBL4,3:4)=P4(fP4(2),1:2); % typ i numer 2. punktu
                BL4grainno(nBL4,1:4)=P4(fP4(1),3:6); % nr 1.2.3.4. ziarna
                P4(fP4(2),:)=[]; % usuniecie wykorzystanego punktu z listy
                P4(fP4(1),:)=[]; % usuniecie wykorzystanego punktu z listy

            % zanotowanie singli
            elseif lfP4==1
                nSingle4=nSingle4+1;
                Single4points(nSingle4,1:2)=P4(fP4(1),1:2); % typ i numer
                Single4grainno(nSingle4,1:4)=P4(fP4(1),3:6); % numery ziaren
                P4(fP4(1),:)=[]; % usuniecie wykorzystanego punktu z listy

            % zanotowanie multipli
            else
                nMultiple4=nMultiple4+1;
                Multiple4grainno(nMultiple4,1:4)=P4(fP4(1),3:6); % numery ziaren
                Multiple4points(nMultiple4,1)=lfP4; % liczba punktow
                for i=1:lfP4
                    Multiple4points(nMultiple4,2*i+1)=P4(fP4(i),1); % typ punktu
                    Multiple4points(nMultiple4,2*i+2)=P4(fP4(i),2); % numer punktu
                end
                for i=lfP4:-1:1 % usuniecie wykorzystanych punktow z listy
                    P4(fP4(i),:)=[];
                end
                clear i;
            end
        end % koniec robienia dopoki sa P4
        clear P4 fP4 lfP4;
    end % koniec sprawdzenia czy P4 istnieja
    % koniec petli glownej parowania punktow P4

    % kasowanie nadmiarowych 0 po alokacji
        % czyszczenie BL3
        if nBL3<nP3
            BL3grainno(nBL3+1:nP3,:)=[];
            BL3points(nBL3+1:nP3,:)=[];
        end
        if nSingle3<100
            Single3points(nSingle3+1:100,:)=[];
            Single3grainno(nSingle3+1:100,:)=[];
        end
        if nMultiple3<100
            Multiple3points(nMultiple3+1:100,:)=[];
            Multiple3grainno(nMultiple3+1:100,:)=[];
        end
        clear nP3;
        % koniec czyszczenia BL3

        % czyszczenie BL4
        if nBL4<nP4
            BL4grainno(nBL4+1:nP4,:)=[];
            BL4points(nBL4+1:nP4,:)=[];
        end
        if nSingle4<10
            Single4points(nSingle4+1:10,:)=[];
            Single4grainno(nSingle4+1:10,:)=[];
        end
        if nMultiple4<10
            Multiple4points(nMultiple4+1:10,:)=[];
            Multiple4grainno(nMultiple4+1:10,:)=[];
        end
        clear nP4;
        % koniec czyszczenia BL4
    % koniec kasowania nadmiarowych 0 po alokacji    
% koniec wyszukiwania par w P34 (i P24 oraz P38)

% wyszukiwanie par w P23 (i P24)
Single2points=zeros(10,2,'uint32'); % inicjalizacja
Single2grainno=zeros(10,2,'uint32'); % inicjalizacja
nSingle2=0; % numerator singli
Multiple2points=zeros(10,4,'uint32'); % inicjalizacja
Multiple2grainno=zeros(10,2,'uint32'); % inicjalizacja
nMultiple2=0; % numerator multipli
layers=['ymin';'ymax';'xmin';'xmax';'zmin';'zmax'];
layer=0; %1:y=0, 2:y=max, 3:x=0, 4:x=max, 5:z=0, 6:z=max

for yxz=1:3 % petla zmieniajaca sie po wymiarach: y,x,z
    for minmax=0:wymiary(yxz):wymiary(yxz) % petla dla min i max

        % przygotowanie zbioru danych
            % zamiana P23 na P2
            fP23=find(boundarypoints.P23.coord(:,yxz)==minmax); %P23 na wybranym brzegu
            sfP23=size(fP23); % liczba punktow
            P2=zeros(3*sfP23(1),5,'uint32'); % inicjalizacja P2
            for i=1:sfP23(1)
                % pierwszy dublet
                P2(3*i-2,1:2)=[23 fP23(i)]; % typ i numer punktu
                P2(3*i-2,3:4)=boundarypoints.P23.grainno(fP23(i),1:2); % 1.2. ziarna
                % drugi dublet
                P2(3*i-1,1:2)=[23 fP23(i)];
                P2(3*i-1,3)=boundarypoints.P23.grainno(fP23(i),1);
                P2(3*i-1,4)=boundarypoints.P23.grainno(fP23(i),3);
                % trzeci dublet
                P2(3*i,1:2)=[23 fP23(i)];
                P2(3*i,3:4)=boundarypoints.P23.grainno(fP23(i),2:3);
            end
            clear i fP23 sfP23;
            % koniec zamiany P23 na P2

            % dodanie P12 do P2
            if isfield(boundarypoints,'P12') % sprawdzenie czy sa P12
                sP2=size(P2);
                sP12=size(boundarypoints.P12.coord);
                for i=1:sP12(1)
                    if boundarypoints.P12.coord(i,yxz)==minmax
                        sP2(1)=sP2(1)+1;
                        P2(sP2(1),1:2)=[12 i];
                        P2(sP2(1),3:4)=boundarypoints.P12.grainno(i,1:2);
                    end
                end
            end
            clear sP2 sP12 i;
            % koniec dodawania P12 do P2

            % dodanie P24 do P2 (zakladam brak sortowania 24)
            if isfield(boundarypoints,'P24') % sprawdznie czy sa P24
                P24g=boundarypoints.P24.grainno; % pobranie danych
                fP24c=find(boundarypoints.P24.coord(:,yxz)==minmax); %P24 na wybranym brzegu
                sP24c=size(fP24c); % liczba punktow
                if sP24c(1)>0 % sprawdzenie czy znaleziono punkty
                    sP2=size(P2);
                    for i=1:sP24c(1)
                        % pierwszy dublet
                        sP2(1)=sP2(1)+1;
                        P2(sP2(1),1:2)=[24 fP24c(i)];
                        P2(sP2(1),3:4)=sort([P24g(fP24c(i),1) P24g(fP24c(i),2)]);
                        % drugi dublet
                        sP2(1)=sP2(1)+1;
                        P2(sP2(1),1:2)=[24 fP24c(i)];
                        P2(sP2(1),3:4)=sort([P24g(fP24c(i),2) P24g(fP24c(i),3)]);
                        % trzeci dublet
                        sP2(1)=sP2(1)+1;
                        P2(sP2(1),1:2)=[24 fP24c(i)];
                        P2(sP2(1),3:4)=sort([P24g(fP24c(i),3) P24g(fP24c(i),4)]);
                        % czwarty dublet
                        sP2(1)=sP2(1)+1;
                        P2(sP2(1),1:2)=[24 fP24c(i)];
                        P2(sP2(1),3:4)=sort([P24g(fP24c(i),1) P24g(fP24c(i),4)]);
                    end
                    clear i;
                end % koniec sprawdzenia czy znaleziono punkty
                clear P24g fP24 sP24c sP2;
            end % koniec sprawdzenia czy sa P24
            % koniec dodawania P24 do P2 (zakladam brak sortowania 24)
        % koniec przygotowania zbioru danych

        % laczenie punktow w pary
            % struktura BL2points: t1,n1,t2,n2
            % struktura BL2grainno: g1,g2
        sP2=size(P2);
        BL2points=zeros(sP2(1),4,'uint32'); % inicjalizacja
        BL2grainno=zeros(sP2(1),2,'uint32'); % inicjalizacja
        nBL2=0; % numerator BL2

        % petla glowna parowania punktow
        while ~isempty(P2)
            fP2=find(P2(:,3)==P2(1,3) & P2(:,4)==P2(1,4)); % indeksy pary
            lfP2=length(fP2); % liczba znalezionych punktow

            % poprawne pary punktow
            if lfP2==2
                nBL2=nBL2+1;
                BL2points(nBL2,1:2)=P2(fP2(1),1:2); % typ i numer 1. punktu
                BL2points(nBL2,3:4)=P2(fP2(2),1:2); % typ i numer 2. punktu
                BL2grainno(nBL2,1:2)=P2(fP2(1),3:4); % numery ziaren
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
        if nBL2<sP2(1)
            BL2grainno(nBL2+1:sP2(1),:)=[];
            BL2points(nBL2+1:sP2(1),:)=[];
        end
        clear sP2;
        % koniec kasowania nadmiarowych 0 po alokacji

        % zapis wyniku
        layer=layer+1;
        boundarylines.L2.(layers(layer,1:4)).points=BL2points(1:nBL2,1:4);
        boundarylines.L2.(layers(layer,1:4)).grainno=BL2grainno(1:nBL2,1:2);
        clear nBL2 BL2points BL2grainno;
        % koniec zapisu wyniku
    end % koniec petli min i max
end % koniec petli po wymiarach y,x,z

    % kasowanie nadmiarowych 0 po alokacji
    if nSingle2<10
        Single2points(nSingle2+1:10,:)=[];
        Single2grainno(nSingle2+1:10,:)=[];
    end
    if nMultiple2<10
        Multiple2points(nMultiple2+1:10,:)=[];
        Multiple2grainno(nMultiple2+1:10,:)=[];
    end
    % koniec kasowania nadmiarowych 0 po alokacji

clear yxz minmax layer layers;
% koniec wyszukiwania par w P23 (i P24)

% wyszukiwanie par w P12 i P10
    % pobranie danych roboczych
    P10c=boundarypoints.P10.coord;
    P10g=boundarypoints.P10.grainno;
    P12c=boundarypoints.P12.coord;
    P12g=boundarypoints.P12.grainno;
    % koniec pobierania danych roboczzych

    % inicjalizacja
    BL1points=zeros(100,4,'uint32'); % inicjalizacja
    BL1grainno=zeros(100,1,'uint32'); % inicjalizacja
    Single1points=zeros(100,2,'uint32'); % inicjalizacja
    Single1grainno=zeros(100,1,'uint32'); % inicjalizacja
    Multiple1points=zeros(100,4,'uint32'); % inicjalizacja
    Multiple1grainno=zeros(100,1,'uint32'); % inicjalizacja
    nBL1=0; % numerator BE-boundarylines
    nSingle1=0; % numerator singli
    nMultiple1=0; % numerator multipli
    % koniec inicjalizacji

    % petla glowna po krawedziach
    for krawedzie=1:12 % petla po krawedziach

        % szukanie odpowiednich punktow
        switch krawedzie
        case 1 % 0,x,0
            fP10c=find(P10c(:,1)==0 & P10c(:,3)==0);
            fP12c=find(P12c(:,1)==0 & P12c(:,3)==0);
        case 2 % max,x,0
            fP10c=find(P10c(:,1)==wymiary(1) & P10c(:,3)==0);
            fP12c=find(P12c(:,1)==wymiary(1) & P12c(:,3)==0);            
        case 3 % 0,x,max
            fP10c=find(P10c(:,1)==0 & P10c(:,3)==wymiary(3));
            fP12c=find(P12c(:,1)==0 & P12c(:,3)==wymiary(3));                        
        case 4 % max,x,max
            fP10c=find(P10c(:,1)==wymiary(1) & P10c(:,3)==wymiary(3));
            fP12c=find(P12c(:,1)==wymiary(1) & P12c(:,3)==wymiary(3));                                
        case 5 % y,0,0
            fP10c=find(P10c(:,2)==0 & P10c(:,3)==0);
            fP12c=find(P12c(:,2)==0 & P12c(:,3)==0);            
        case 6 % y,max,0
            fP10c=find(P10c(:,2)==wymiary(2) & P10c(:,3)==0);
            fP12c=find(P12c(:,2)==wymiary(2) & P12c(:,3)==0);                        
        case 7 % y,0,max
            fP10c=find(P10c(:,2)==0 & P10c(:,3)==wymiary(3));
            fP12c=find(P12c(:,2)==0 & P12c(:,3)==wymiary(3));                                    
        case 8 % y,max,max
            fP10c=find(P10c(:,2)==wymiary(2) & P10c(:,3)==wymiary(3));
            fP12c=find(P12c(:,2)==wymiary(2) & P12c(:,3)==wymiary(3));                                            
        case 9 % 0,0,z
            fP10c=find(P10c(:,1)==0 & P10c(:,2)==0);
            fP12c=find(P12c(:,1)==0 & P12c(:,2)==0);            
        case 10 % max,0,z
            fP10c=find(P10c(:,1)==wymiary(1) & P10c(:,2)==0);
            fP12c=find(P12c(:,1)==wymiary(1) & P12c(:,2)==0);                        
        case 11 % 0,max,z
            fP10c=find(P10c(:,1)==0 & P10c(:,2)==wymiary(2));
            fP12c=find(P12c(:,1)==0 & P12c(:,2)==wymiary(2));                                    
        case 12 % max,max,z
            fP10c=find(P10c(:,1)==wymiary(1) & P10c(:,2)==wymiary(2));
            fP12c=find(P12c(:,1)==wymiary(1) & P12c(:,2)==wymiary(2));                                                        
        end
        % koniec szukania odpowiednich punktow

        % utworzenie listy punktow do sparowania
        lfP10c=length(fP10c); % liczba znalezionych P10
        lfP12c=length(fP12c); % liczba znalezionych P12
        P1=zeros(lfP10c+2*lfP12c,3,'uint32'); % inicjalizacja: t1,n1,g1
        nP1=0;
        for i=1:lfP10c
            nP1=nP1+1;
            P1(nP1,1:2)=[10 fP10c(i)];
            P1(nP1,3)=P10g(fP10c(i));
        end
        for i=1:lfP12c
            nP1=nP1+1;
            P1(nP1,1:2)=[12 fP12c(i)];
            P1(nP1,3)=P12g(fP12c(i),1);
            nP1=nP1+1;
            P1(nP1,1:2)=[12 fP12c(i)];
            P1(nP1,3)=P12g(fP12c(i),2);
        end
        clear i fP10c fP12c lfP10c lfP12c nP1;
        % koniec tworzenia listy punktow do sparowania

        % petla glowna parowania punktow P1
        while ~isempty(P1) % rob dopoki sa P1
            fP1=find(P1(:,3)==P1(1,3));
            lfP1=length(fP1); % liczba znalezionych punktow

            % poprawne pary punktow
            if lfP1==2
                nBL1=nBL1+1;
                BL1points(nBL1,1:2)=P1(fP1(1),1:2); % typ i numer 1. punktu
                BL1points(nBL1,3:4)=P1(fP1(2),1:2); % typ i numer 2. punktu
                BL1grainno(nBL1,1)=P1(fP1(1),3); % nr ziarna
                P1(fP1(2),:)=[]; % usuniecie wykorzystanego punktu z listy
                P1(fP1(1),:)=[]; % usuniecie wykorzystanego punktu z listy

            % zanotowanie singli
            elseif lfP1==1
                nSingle1=nSingle1+1;
                Single1points(nSingle1,1:2)=P1(fP1(1),1:2); % typ i numer
                Single1grainno(nSingle1,1)=P1(fP1(1),3); % numery ziaren
                P1(fP1(1),:)=[]; % usuniecie wykorzystanego punktu z listy

            % zanotowanie multipli
            else
                nMultiple1=nMultiple1+1;
                Multiple1grainno(nMultiple1,1)=P1(fP1(1),3); % numery ziaren
                Multiple1points(nMultiple1,1)=lfP1; % liczba punktow
                for i=1:lfP1
                    Multiple1points(nMultiple1,2*i+1)=P1(fP1(i),1); % typ punktu
                    Multiple1points(nMultiple1,2*i+2)=P1(fP1(i),2); % numer punktu
                end
                for i=lfP1:-1:1 % usuniecie wykorzystanych punktow z listy
                    P1(fP1(i),:)=[];
                end
                clear i;
            end
        end % koniec robienia dopoki sa P1
        clear P1 nP1 fP1 lfP1;
        % koniec petli glownej parowania punktow P1
    end % koniec petli po krawedziach
    clear krawedzie P10c P10g P12c P12g;
    % koniec petli glownej po krawedziach

    % kasowanie nadmiarowych 0 po alokacji
    if nBL1<100
        BL1points(nBL1+1:100,:)=[];
        BL1grainno(nBL1+1:100,:)=[];
    end
    if nSingle1<100
        Single1points(nSingle1+1:100,:)=[];
        Single1grainno(nSingle1+1:100,:)=[];
    end
    if nMultiple1<100
        Multiple1points(nMultiple1+1:100,:)=[];
        Multiple1grainno(nMultiple1+1:100,:)=[];
    end
    % koniec kasowania nadmiarowych 0 po alokacji            
% koniec wyszukiwania par w P12 i P10

% parowanie Multiple3 metoda krokow po granicy
if nMultiple3>0 % sprawdzenie czy sa Multiple3
    clc; disp('parowanie Multiple3');
    for i=1:nMultiple3 % petla po Multiple3
        disp(i);

        % pobranie jednego Multiple3
        MultipleGN(1:3)=Multiple3grainno(i,1:3);
        MultipleP=Multiple3points(i,:);

        % konwersja multipla
        MultipleYXZ=zeros(MultipleP(1),5,'uint32'); % struktura: typ,numer,y,x,z
        for j=1:MultipleP(1)
            MultipleYXZ(j,1:2)=MultipleP(2*j+1:2*j+2); % kopiowanie typu i numeru
            if MultipleYXZ(j,1)==34
                MultipleYXZ(j,3:5)=boundarypoints.P34.coord(MultipleYXZ(j,2),1:3);
            elseif MultipleYXZ(j,1)==38
                MultipleYXZ(j,3:5)=boundarypoints.P38.coord(MultipleYXZ(j,2),1:3);
            elseif MultipleYXZ(j,1)==23
                MultipleYXZ(j,3:5)=boundarypoints.P23.coord(MultipleYXZ(j,2),1:3);
            elseif MultipleYXZ(j,1)==24
                MultipleYXZ(j,3:5)=boundarypoints.P24.coord(MultipleYXZ(j,2),1:3);
            end
        end
        clear j;
        MultipleP(2:length(MultipleP))=[]; % pozostawiam tylko liczbe punktow
        % koniec konwersji multipla

        % petla glowna parowania Multipli
        for j=1:MultipleP % petla po wszystkich punktach w Multiplu
            if (MultipleYXZ(j,1)~=0 && MultipleYXZ(j,2)~=0) % ktore jeszcze nie zostaly wyzerowane

                % wspolrzedne punktu
                y=MultipleYXZ(j,3);
                x=MultipleYXZ(j,4);
                z=MultipleYXZ(j,5);
                % koniec wspolrzednych punktu

                % petla glowna kroczenia po granicy
                para=0;
                KierunekPrzejscia=-1;
                while para==0 % rob do znalezienia pary

                    % okreslenie kierunku przejscia
                    for k=1:7 % petla po kierunkach: z-,z+,y-,y+,x-,x+

                        klaster=[0 0 0];
                        if (k==1 && KierunekPrzejscia~=2) % krok z-1, zakaz cofania
                            if (y>0 && y<wymiary(1) && x>0 && x<wymiary(2) && z>0)
                                klaster=[grainmap(y,x,z) grainmap(y,x+1,z) grainmap(y+1,x+1,z) grainmap(y+1,x,z)];
                            end
                        elseif (k==2 && KierunekPrzejscia~=1) % krok z+1, zakaz cofania
                            if (y>0 && y<wymiary(1) && x>0 && x<wymiary(2) && z<wymiary(3))
                                klaster=[grainmap(y,x,z+1) grainmap(y,x+1,z+1) grainmap(y+1,x+1,z+1) grainmap(y+1,x,z+1)];
                            end
                        elseif (k==3 && KierunekPrzejscia~=4) % krok y-1, zakaz cofania
                            if (y>0 && x>0 && x<wymiary(2) && z>0 && z<wymiary(3))
                                klaster=[grainmap(y,x,z) grainmap(y,x+1,z) grainmap(y,x+1,z+1) grainmap(y,x,z+1)];
                            end
                        elseif (k==4 && KierunekPrzejscia~=3) % krok y+1, zakaz cofania
                            if (y<wymiary(1) && x>0 && x<wymiary(2) && z>0 && z<wymiary(3))
                                klaster=[grainmap(y+1,x,z) grainmap(y+1,x+1,z) grainmap(y+1,x+1,z+1) grainmap(y+1,x,z+1)];
                            end
                        elseif (k==5 && KierunekPrzejscia~=6) % krok x-1, zakaz cofania
                            if (y>0 && y<wymiary(1) && x>0 && z>0 && z<wymiary(3))
                                klaster=[grainmap(y,x,z) grainmap(y+1,x,z) grainmap(y+1,x,z+1) grainmap(y,x,z+1)];
                            end
                        elseif (k==6 && KierunekPrzejscia~=5) % krok x+1, zakaz cofania
                            if (y>0 && y<wymiary(1) && x<wymiary(2) && z>0 && z<wymiary(3))
                                klaster=[grainmap(y,x+1,z) grainmap(y+1,x+1,z) grainmap(y+1,x+1,z+1) grainmap(y,x+1,z+1)];
                            end
                        elseif k==7
                            KierunekPrzejscia=-1; % z jakiegos powodu nie okreslono kierunku przejscia
                        else
                            klaster=[0 0 0];
                        end

                        Jump=unique(klaster);
                        if length(Jump)==3 % sprawdzenie czy jest poprawna linia potrojna
                            if Jump(1)==MultipleGN(1)
                                if Jump(2)==MultipleGN(2)
                                    if Jump(3)==MultipleGN(3)
                                        KierunekPrzejscia=k;
                                        break;
                                    end
                                end
                            end
                        end % koniec sprawdzenia czy jest poprawna linia potrojna
                    end % koniec petli po mozliwych kierunkach
                    clear k klaster Jump;
                    % okreslenie kierunku przejscia

                    % wykonanie przejscia
                    if KierunekPrzejscia==1 % z-1
                        z=z-1;
                    elseif KierunekPrzejscia==2 % z+1
                        z=z+1;
                    elseif KierunekPrzejscia==3 % y-1
                        y=y-1;
                    elseif KierunekPrzejscia==4 % y+1
                        y=y+1;
                    elseif KierunekPrzejscia==5 % x-1
                        x=x-1;
                    elseif KierunekPrzejscia==6 % x+1
                        x=x+1;
                    else % nie okreslono kierunku przejscia
                        break; % koniec kroczenia
                    end
                    % koniec wykonywania przejscia

                    % sprawdzenie zakonczenia odcinka
                    for k=1:MultipleP % petla po punktach w Multiplu
                        if (y==MultipleYXZ(k,3) && x==MultipleYXZ(k,4) && z==MultipleYXZ(k,5))
                            para=k;
                            break;
                        end
                    end % koniec petli po punktach w Muliplu
                    clear k;
                    % koniec sprawdzania zakonczenia odcinka

                end % koniec robienia do znalezienia pary
                clear y x z KierunekPrzejscia;
                % koniec petli glownej kroczenia po granicy

                % zapisanie znalezionej pary
                if para>0
                    nBL3=nBL3+1;
                    BL3grainno(nBL3,1:3)=MultipleGN(1:3);
                    BL3points(nBL3,1:2)=MultipleYXZ(j,1:2);
                    BL3points(nBL3,3:4)=MultipleYXZ(para,1:2);
                    MultipleYXZ(j,1:5)=[0 0 0 0 0];
                    MultipleYXZ(para,1:5)=[0 0 0 0 0];
                end
                clear para;
                % koniec zapisu znalezionej pary

            end % ktore jeszcze nie zostaly wyzerowane
        end % koniec petli po wszystkich punktach w Multiplu
        clear j;
        % koniec petli glownej parowania Multipli

        % zapisanie niesparowanych punktow w Single3
        for j=1:MultipleP
            if (MultipleYXZ(j,1)~=0 && MultipleYXZ(j,2)~=0)
                nSingle3=nSingle3+1;
                Single3points(nSingle3,1:2)=MultipleYXZ(j,1:2); % typ i numer singla
                Single3grainno(nSingle3,1:3)=MultipleGN(1:3); % numery ziaren singla
            end
        end
        clear j MultipleP MultipleYXZ MultipleGN;
        % koniec zapisu niesparowanych punktow w Single3

        % zerowanie sprawdzonego Multipla z Multiple3
        Multiple3points(i,1)=0;
        Multiple3grainno(i,1:3)=[0 0 0];
        % koniec zerowania sprawdzonego Multipla z Multiple3

    end % koniec petli po Multiple3
    clear i;

    % usuwanie poprawionych Multipli3
    for i=nMultiple3:-1:1
        if Multiple3points(i,1)==0
            Multiple3points(i,:)=[];
            Multiple3grainno(i,:)=[];
            nMultiple3=nMultiple3-1;
        end
    end
    clear i;
    % koniec usuwania poprawionych Multipli3

end % koniec sprawdzenia czy sa Multiple3
% koniec parowania Multiple3 metoda krokow po granicy

% parowanie Multiple4 metoda krokow po granicy
if nMultiple4>0 % sprawdzenie czy sa Multiple4
    disp('parowanie Multiple4');
    for i=1:nMultiple4 % petla po Multiple4
        disp(i);

        % pobranie jednego Multiple4
        MultipleGN(1:4)=Multiple4grainno(i,1:4);
        MultipleP=Multiple4points(i,:);

        % konwersja multipla
        MultipleYXZ=zeros(MultipleP(1),5,'uint32'); % struktura: typ,numer,y,x,z
        for j=1:MultipleP(1)
            MultipleYXZ(j,1:2)=MultipleP(2*j+1:2*j+2); % kopiowanie typu i numeru
            if MultipleYXZ(j,1)==34
                MultipleYXZ(j,3:5)=boundarypoints.P34.coord(MultipleYXZ(j,2),1:3);
            elseif MultipleYXZ(j,1)==38
                MultipleYXZ(j,3:5)=boundarypoints.P38.coord(MultipleYXZ(j,2),1:3);
            elseif MultipleYXZ(j,1)==23
                MultipleYXZ(j,3:5)=boundarypoints.P23.coord(MultipleYXZ(j,2),1:3);
            elseif MultipleYXZ(j,1)==24
                MultipleYXZ(j,3:5)=boundarypoints.P24.coord(MultipleYXZ(j,2),1:3);
            end
        end
        clear j;
        MultipleP(2:length(MultipleP))=[]; % pozostawiam tylko liczbe punktow
        % koniec konwersji multipla

        % petla glowna parowania Multipli
        for j=1:MultipleP % petla po wszystkich punktach w Multiplu
            if (MultipleYXZ(j,1)~=0 && MultipleYXZ(j,2)~=0) % ktore jeszcze nie zostaly wyzerowane

                % wspolrzedne punktu
                y=MultipleYXZ(j,3);
                x=MultipleYXZ(j,4);
                z=MultipleYXZ(j,5);
                % koniec wspolrzednych punktu

                % petla glowna kroczenia po granicy
                para=0;
                KierunekPrzejscia=-1;
                while para==0 % rob do znalezienia pary

                    % okreslenie kierunku przejscia
                    for k=1:7 % petla po kierunkach: z-,z+,y-,y+,x-,x+

                        klaster=[0 0 0 0];
                        if (k==1 && KierunekPrzejscia~=2) % krok z-1, zakaz cofania
                            if (y>0 && y<wymiary(1) && x>0 && x<wymiary(2) && z>0)
                                klaster=[grainmap(y,x,z) grainmap(y,x+1,z) grainmap(y+1,x+1,z) grainmap(y+1,x,z)];
                            end
                        elseif (k==2 && KierunekPrzejscia~=1) % krok z+1, zakaz cofania
                            if (y>0 && y<wymiary(1) && x>0 && x<wymiary(2) && z<wymiary(3))
                                klaster=[grainmap(y,x,z+1) grainmap(y,x+1,z+1) grainmap(y+1,x+1,z+1) grainmap(y+1,x,z+1)];
                            end
                        elseif (k==3 && KierunekPrzejscia~=4) % krok y-1, zakaz cofania
                            if (y>0 && x>0 && x<wymiary(2) && z>0 && z<wymiary(3))
                                klaster=[grainmap(y,x,z) grainmap(y,x+1,z) grainmap(y,x+1,z+1) grainmap(y,x,z+1)];
                            end
                        elseif (k==4 && KierunekPrzejscia~=3) % krok y+1, zakaz cofania
                            if (y<wymiary(1) && x>0 && x<wymiary(2) && z>0 && z<wymiary(3))
                                klaster=[grainmap(y+1,x,z) grainmap(y+1,x+1,z) grainmap(y+1,x+1,z+1) grainmap(y+1,x,z+1)];
                            end
                        elseif (k==5 && KierunekPrzejscia~=6) % krok x-1, zakaz cofania
                            if (y>0 && y<wymiary(1) && x>0 && z>0 && z<wymiary(3))
                                klaster=[grainmap(y,x,z) grainmap(y+1,x,z) grainmap(y+1,x,z+1) grainmap(y,x,z+1)];
                            end
                        elseif (k==6 && KierunekPrzejscia~=5) % krok x+1, zakaz cofania
                            if (y>0 && y<wymiary(1) && x<wymiary(2) && z>0 && z<wymiary(3))
                                klaster=[grainmap(y,x+1,z) grainmap(y+1,x+1,z) grainmap(y+1,x+1,z+1) grainmap(y,x+1,z+1)];
                            end
                        elseif k==7
                            KierunekPrzejscia=-1; % z jakiegos powodu nie okreslono kierunku przejscia
                        else
                            klaster=[0 0 0 0];
                        end

                        Jump=unique(klaster);
                        if length(Jump)==4 % sprawdzenie czy jest poprawna linia poczworna
                            if Jump(1)==MultipleGN(1)
                                if Jump(2)==MultipleGN(2)
                                    if Jump(3)==MultipleGN(3)
                                        if Jump(4)==MultipleGN(4)
                                            KierunekPrzejscia=k;
                                            break;
                                        end
                                    end
                                end
                            end
                        end % koniec sprawdzenia czy jest poprawna linia potrojna
                    end % koniec petli po mozliwych kierunkach
                    clear k klaster Jump;
                    % koniec okreslenia kierunku przejscia

                    % wykonanie przejscia
                    if KierunekPrzejscia==1 % z-1
                        z=z-1;
                    elseif KierunekPrzejscia==2 % z+1
                        z=z+1;
                    elseif KierunekPrzejscia==3 % y-1
                        y=y-1;
                    elseif KierunekPrzejscia==4 % y+1
                        y=y+1;
                    elseif KierunekPrzejscia==5 % x-1
                        x=x-1;
                    elseif KierunekPrzejscia==6 % x+1
                        x=x+1;
                    else % nie okreslono kierunku przejscia
                        break; % koniec kroczenia
                    end
                    % koniec wykonywania przejscia

                    % sprawdzenie zakonczenia odcinka
                    for k=1:MultipleP % petla po punktach w Multiplu
                        if (y==MultipleYXZ(k,3) && x==MultipleYXZ(k,4) && z==MultipleYXZ(k,5))
                            para=k;
                            break;
                        end
                    end % koniec petli po punktach w Muliplu
                    clear k;
                    % koniec sprawdzania zakonczenia odcinka

                end % koniec robienia do znalezienia pary
                clear y x z KierunekPrzejscia;
                % koniec petli glownej kroczenia po granicy

                % zapisanie znalezionej pary
                if para>0
                    nBL4=nBL4+1;
                    BL4grainno(nBL4,1:4)=MultipleGN(1:4);
                    BL4points(nBL4,1:2)=MultipleYXZ(j,1:2);
                    BL4points(nBL4,3:4)=MultipleYXZ(para,1:2);
                    MultipleYXZ(j,1:5)=[0 0 0 0 0];
                    MultipleYXZ(para,1:5)=[0 0 0 0 0];                    
                end
                clear para;
                % koniec zapisu znalezionej pary

            end % ktore jeszcze nie zostaly wyzerowane
        end % koniec petli po wszystkich punktach w Multiplu
        clear j;
        % koniec petli glownej parowania Multipli

        % zapisanie niesparowanych punktow w Single4
        for j=1:MultipleP
            if (MultipleYXZ(j,1)~=0 && MultipleYXZ(j,2)~=0)
                nSingle4=nSingle4+1;
                Single4points(nSingle4,1:2)=MultipleYXZ(j,1:2); % typ i numer singla
                Single4grainno(nSingle4,1:4)=MultipleGN(1:4); % numery ziaren singla
            end
        end
        clear j MultipleP MultipleYXZ MultipleGN;
        % koniec zapisu niesparowanych punktow w Single4

        % zerowanie sprawdzonego Multipla z Multiple4
        Multiple4points(i,1)=0;
        Multiple4grainno(i,1:4)=[0 0 0 0];
        % koniec zerowania sprawdzonego Multipla z Multiple4

    end % koniec petli po Multiple4
    clear i;

    % usuwanie poprawionych Multipli4
    for i=nMultiple4:-1:1
        if Multiple4points(i,1)==0
            Multiple4points(i,:)=[];
            Multiple4grainno(i,:)=[];
            nMultiple4=nMultiple4-1;
        end
    end
    clear i;
    % koniec usuwania poprawionych Multipli4

end % koniec sprawdzenia czy sa Multiple4
% koniec parowania Multiple4 metoda krokow po granicy

% parowanie Multiple2 metoda krokow po granicy
layers=['ymin';'ymax';'xmin';'xmax';'zmin';'zmax'];
if nMultiple2>0 % sprawdzenie czy sa Multiple2
    disp('parowanie Multiple2')
    for i=1:nMultiple2 % petla po Multiple2
        disp(i);

        % pobranie jednego Multiple2
        MultipleGN(1:2)=Multiple2grainno(i,1:2);
        MultipleP=Multiple2points(i,:);

        % konwersja multipla
        MultipleYXZ=zeros(MultipleP(1),5,'uint32'); % struktura: typ,numer,y,x,z
        for j=1:MultipleP(1)
            MultipleYXZ(j,1:2)=MultipleP(2*j+1:2*j+2); % kopiowanie typu i numeru
            if MultipleYXZ(j,1)==23
                MultipleYXZ(j,3:5)=boundarypoints.P23.coord(MultipleYXZ(j,2),1:3);
            elseif MultipleYXZ(j,1)==24
                MultipleYXZ(j,3:5)=boundarypoints.P24.coord(MultipleYXZ(j,2),1:3);
            elseif MultipleYXZ(j,1)==12
                MultipleYXZ(j,3:5)=boundarypoints.P12.coord(MultipleYXZ(j,2),1:3);
            end
        end
        clear j;
        MultipleP(2:length(MultipleP))=[]; % pozostawiam tylko liczbe punktow
        % koniec konwersji multipla

        % petla glowna parowania Multipli
        for j=1:MultipleP % petla po wszystkich punktach w Multiplu
            if (MultipleYXZ(j,1)~=0 && MultipleYXZ(j,2)~=0) % ktore jeszcze nie zostaly wyzerowane

                % wspolrzedne punktu
                y=MultipleYXZ(j,3);
                x=MultipleYXZ(j,4);
                z=MultipleYXZ(j,5);
                % koniec wspolrzednych punktu

                % petla glowna kroczenia po granicy
                para=0;
                KierunekPrzejscia=-1;
                while para==0 % rob do znalezienia pary

                    % okreslenie kierunku przejscia
                    for k=1:7 % petla po kierunkach: z-,z+,y-,y+,x-,x+
                        klaster=[0 0];

                        % okreslenie na ktorym brzegu ROI lezy punkt
                        if z==wymiary(3) % brzeg z=max    
                            if (k==3 && KierunekPrzejscia~=4) % krok y-1, zakaz cofania
                                if (y>0 && x>0 && x<wymiary(2))
                                    klaster=[grainmap(y,x,z) grainmap(y,x+1,z)];
                                end
                            elseif (k==4 && KierunekPrzejscia~=3) % krok y+1, zakaz cofania
                                if (y<wymiary(1) && x>0 && x<wymiary(2))
                                    klaster=[grainmap(y+1,x,z) grainmap(y+1,x+1,z)];
                                end
                            elseif (k==5 && KierunekPrzejscia~=6) % krok x-1, zakaz cofania
                                if (y>0 && y<wymiary(1) && x>0)
                                    klaster=[grainmap(y,x,z) grainmap(y+1,x,z)];
                                end
                            elseif (k==6 && KierunekPrzejscia~=5) % krok x+1, zakaz cofania
                                if (y>0 && y<wymiary(1) && x<wymiary(2))
                                    klaster=[grainmap(y,x+1,z) grainmap(y+1,x+1,z)];
                                end
                            elseif k==7
                                KierunekPrzejscia=-1; % z jakiegos powodu nie okreslono kierunku przejscia
                            end   
                        elseif z==0 % brzeg z=min
                            if (k==3 && KierunekPrzejscia~=4) % krok y-1, zakaz cofania
                                if (y>0 && x>0 && x<wymiary(2))
                                    klaster=[grainmap(y,x,z+1) grainmap(y,x+1,z+1)];
                                end
                            elseif (k==4 && KierunekPrzejscia~=3) % krok y+1, zakaz cofania
                                if (y<wymiary(1) && x>0 && x<wymiary(2))
                                    klaster=[grainmap(y+1,x,z+1) grainmap(y+1,x+1,z+1)];
                                end
                            elseif (k==5 && KierunekPrzejscia~=6) % krok x-1, zakaz cofania
                                if (y>0 && y<wymiary(1) && x>0)
                                    klaster=[grainmap(y,x,z+1) grainmap(y+1,x,z+1)];
                                end
                            elseif (k==6 && KierunekPrzejscia~=5) % krok x+1, zakaz cofania
                                if (y>0 && y<wymiary(1) && x<wymiary(2))
                                    klaster=[grainmap(y,x+1,z+1) grainmap(y+1,x+1,z+1)];
                                end
                            elseif k==7
                                KierunekPrzejscia=-1; % z jakiegos powodu nie okreslono kierunku przejscia
                            end   
                        elseif y==wymiary(1) % brzeg y=max
                            if (k==1 && KierunekPrzejscia~=2) % krok z-1, zakaz cofania
                                if (x>0 && x<wymiary(2) && z>0)
                                    klaster=[grainmap(y,x,z) grainmap(y,x+1,z)];
                                end
                            elseif (k==2 && KierunekPrzejscia~=1) % krok z+1, zakaz cofania
                                if (x>0 && x<wymiary(2) && z<wymiary(3))
                                    klaster=[grainmap(y,x,z+1) grainmap(y,x+1,z+1)];
                                end
                            elseif (k==5 && KierunekPrzejscia~=6) % krok x-1, zakaz cofania
                                if (x>0 && z>0 && z<wymiary(3))
                                    klaster=[grainmap(y,x,z) grainmap(y,x,z+1)];
                                end
                            elseif (k==6 && KierunekPrzejscia~=5) % krok x+1, zakaz cofania
                                if (x<wymiary(2) && z>0 && z<wymiary(3))
                                    klaster=[grainmap(y,x+1,z) grainmap(y,x+1,z+1)];
                                end
                            elseif k==7
                                KierunekPrzejscia=-1; % z jakiegos powodu nie okreslono kierunku przejscia
                            end
                        elseif y==0 % brzeg y=min
                            if (k==1 && KierunekPrzejscia~=2) % krok z-1, zakaz cofania
                                if (x>0 && x<wymiary(2) && z>0)
                                    klaster=[grainmap(y+1,x,z) grainmap(y+1,x+1,z)];
                                end
                            elseif (k==2 && KierunekPrzejscia~=1) % krok z+1, zakaz cofania
                                if (x>0 && x<wymiary(2) && z<wymiary(3))
                                    klaster=[grainmap(y+1,x,z+1) grainmap(y+1,x+1,z+1)];
                                end
                            elseif (k==5 && KierunekPrzejscia~=6) % krok x-1, zakaz cofania
                                if (x>0 && z>0 && z<wymiary(3))
                                    klaster=[grainmap(y+1,x,z) grainmap(y+1,x,z+1)];
                                end
                            elseif (k==6 && KierunekPrzejscia~=5) % krok x+1, zakaz cofania
                                if (x<wymiary(2) && z>0 && z<wymiary(3))
                                    klaster=[grainmap(y+1,x+1,z) grainmap(y+1,x+1,z+1)];
                                end
                            elseif k==7
                                KierunekPrzejscia=-1; % z jakiegos powodu nie okreslono kierunku przejscia
                            end
                        elseif x==wymiary(2)
                            if (k==1 && KierunekPrzejscia~=2) % krok z-1, zakaz cofania
                                if (y>0 && y<wymiary(1) && z>0)
                                    klaster=[grainmap(y,x,z) grainmap(y+1,x,z)];
                                end
                            elseif (k==2 && KierunekPrzejscia~=1) % krok z+1, zakaz cofania
                                if (y>0 && y<wymiary(1) && z<wymiary(3))
                                    klaster=[grainmap(y,x,z+1) grainmap(y+1,x,z+1)];
                                end
                            elseif (k==3 && KierunekPrzejscia~=4) % krok y-1, zakaz cofania
                                if (y>0 && z>0 && z<wymiary(3))
                                    klaster=[grainmap(y,x,z) grainmap(y,x,z+1)];
                                end
                            elseif (k==4 && KierunekPrzejscia~=3) % krok y+1, zakaz cofania
                                if (y<wymiary(1) && z>0 && z<wymiary(3))
                                    klaster=[grainmap(y+1,x,z) grainmap(y+1,x,z+1)];
                                end
                            elseif k==7
                                KierunekPrzejscia=-1; % z jakiegos powodu nie okreslono kierunku przejscia
                            end
                        else % brzeg x=0
                            if (k==1 && KierunekPrzejscia~=2) % krok z-1, zakaz cofania
                                if (y>0 && y<wymiary(1) && z>0)
                                    klaster=[grainmap(y,x+1,z) grainmap(y+1,x+1,z)];
                                end
                            elseif (k==2 && KierunekPrzejscia~=1) % krok z+1, zakaz cofania
                                if (y>0 && y<wymiary(1) && z<wymiary(3))
                                    klaster=[grainmap(y,x+1,z+1) grainmap(y+1,x+1,z+1)];
                                end
                            elseif (k==3 && KierunekPrzejscia~=4) % krok y-1, zakaz cofania
                                if (y>0 && z>0 && z<wymiary(3))
                                    klaster=[grainmap(y,x+1,z) grainmap(y,x+1,z+1)];
                                end
                            elseif (k==4 && KierunekPrzejscia~=3) % krok y+1, zakaz cofania
                                if (y<wymiary(1) && z>0 && z<wymiary(3))
                                    klaster=[grainmap(y+1,x+1,z) grainmap(y+1,x+1,z+1)];
                                end
                            elseif k==7
                                KierunekPrzejscia=-1; % z jakiegos powodu nie okreslono kierunku przejscia
                            end                        
                        end
                        % koniec okreslania na ktorym brzegu ROI lezy punkt

                        Jump=unique(klaster);
                        if length(Jump)==2 % sprawdzenie czy jest poprawna linia podwojna
                            if Jump(1)==MultipleGN(1)
                                if Jump(2)==MultipleGN(2)
                                    KierunekPrzejscia=k;
                                    break;
                                end
                            end
                        end % koniec sprawdzenia czy jest poprawna linia potrojna
                    end % koniec petli po mozliwych kierunkach
                    clear k klaster Jump;
                    % koniec okreslania kierunku przejscia

                    % wykonanie przejscia
                    if KierunekPrzejscia==1 % z-1
                        z=z-1;
                    elseif KierunekPrzejscia==2 % z+1
                        z=z+1;
                    elseif KierunekPrzejscia==3 % y-1
                        y=y-1;
                    elseif KierunekPrzejscia==4 % y+1
                        y=y+1;
                    elseif KierunekPrzejscia==5 % x-1
                        x=x-1;
                    elseif KierunekPrzejscia==6 % x+1
                        x=x+1;
                    else % nie okreslono kierunku przejscia
                        break; % koniec kroczenia
                    end
                    % koniec wykonywania przejscia

                    % sprawdzenie zakonczenia odcinka
                    for k=1:MultipleP % petla po punktach w Multiplu
                        if (y==MultipleYXZ(k,3) && x==MultipleYXZ(k,4) && z==MultipleYXZ(k,5))
                            para=k;
                            break;
                        end
                    end % koniec petli po punktach w Muliplu
                    clear k;
                    % koniec sprawdzania zakonczenia odcinka

                end % koniec robienia do znalezienia pary
                clear KierunekPrzejscia;
                % koniec petli glownej kroczenia po granicy

                % zapisanie znalezionej pary
                if para>0

                    % okreslenie na ktorym brzegu mapy jest punkt
                    if y==0 % singiel na brzegu y=0
                        layer=1;
                    elseif y==wymiary(1) % singiel na brzegu y=max
                        layer=2;
                    elseif x==0 % singiel na brzegu x=0
                        layer=3;
                    elseif x==wymiary(2) % singiel na brzegu x=max
                        layer=4;
                    elseif z==0 % singiel na brzegu z=0
                        layer=5;
                    elseif z==wymiary(3) % singiel na brzegu z=max
                        layer=6;
                    end
                        % kiedys tu byl: clear y x z;
                    % koniec okreslania na ktorym brzegu mapy jest punkt
                    
                    % zapis sparowanych punktow
                    sBL2g=size(boundarylines.L2.(layers(layer,1:4)).grainno);
                    sBL2g(1)=sBL2g(1)+1;
                    boundarylines.L2.(layers(layer,1:4)).grainno(sBL2g(1),1:2)=MultipleGN(1:2); % przepisanie numerow ziaren
                    boundarylines.L2.(layers(layer,1:4)).points(sBL2g(1),1:2)=MultipleYXZ(j,1:2); % przepisanie 1. punktu
                    boundarylines.L2.(layers(layer,1:4)).points(sBL2g(1),3:4)=MultipleYXZ(para,1:2); % przepisanie 2. punktu
                    MultipleYXZ(j,1:5)=[0 0 0 0 0]; % zerowanie sparowanych
                    MultipleYXZ(para,1:5)=[0 0 0 0 0]; % zerowanie sparowanych
                    clear layer sBL2g;
                    % koniec zapisu sparowanych punktow

                end
                clear para y x z;
                % koniec zapisu znalezionej pary

            end % ktore jeszcze nie zostaly wyzerowane
        end % koniec petli po wszystkich punktach w Multiplu
        clear j;
        % koniec petli glownej parowania Multipli

        % zapisanie niesparowanych punktow w Single2
        for j=1:MultipleP
            if (MultipleYXZ(j,1)~=0 && MultipleYXZ(j,2)~=0)
                nSingle2=nSingle2+1;
                Single2points(nSingle2,1:2)=MultipleYXZ(j,1:2); % typ i numer singla
                Single2grainno(nSingle2,1:2)=MultipleGN(1:2); % numery ziaren singla
            end
        end
        clear j MultipleP MultipleYXZ MultipleGN;
        % koniec zapisu niesparowanych punktow w Single2

        % zerowanie sprawdzonego Multipla z Multiple2
        Multiple2points(i,1)=0;
        Multiple2grainno(i,1:2)=[0 0];
        % koniec zerowania sprawdzonego Multipla z Multiple2

    end % koniec petli po Multiple2
    clear i;

    % usuwanie poprawionych Multipli2
    for i=nMultiple2:-1:1
        if Multiple2points(i,1)==0
            Multiple2points(i,:)=[];
            Multiple2grainno(i,:)=[];
            nMultiple2=nMultiple2-1;
        end
    end
    clear i;
    % koniec usuwania poprawionych Multipli2

end % koniec sprawdzenia czy sa Multiple2
% koniec parowania Multiple2 metoda krokow po granicy

% parowanie Multiple1 metoda chamskiego sortowania
if nMultiple1>0 % sprawdzenie czy sa Multiple1
    disp('parowanie Multiple1');
    for i=1:nMultiple1 % petla po Multiple1
        disp(i);
        
        % pobranie jednego Multiple1
        MultipleGN=Multiple1grainno(i);
        MultipleP=Multiple1points(i,:);
        
        % zabezpieczenie
        if mod(MultipleP(1),2)~=0
            disp('parowanie Multiple1: nieparzysta liczba punktow!');
            disp('beda wychodzily glupoty');
            disp('numer Multipla:');
            disp(i);
        end
        % koniec zabezpieczenia

        % konwersja multipla
        MultipleYXZ=zeros(MultipleP(1),5,'uint32'); % struktura: typ,numer,y,x,z
        for j=1:MultipleP(1)
            MultipleYXZ(j,1:2)=MultipleP(2*j+1:2*j+2); % kopiowanie typu i numeru
            if MultipleYXZ(j,1)==12
                MultipleYXZ(j,3:5)=boundarypoints.P12.coord(MultipleYXZ(j,2),1:3);
            elseif MultipleYXZ(j,1)==10
                MultipleYXZ(j,3:5)=boundarypoints.P10.coord(MultipleYXZ(j,2),1:3);
            end
        end
        clear j;
        MultipleP(2:length(MultipleP))=[]; % pozostawiam tylko liczbe punktow
        % koniec konwersji multipla

        % petla glowna parowania Multipli
        MultipleYXZ=sort(MultipleYXZ);
        for j=2:2:MultipleP
            nBL1=nBL1+1;
            BL1grainno(nBL1,1)=MultipleGN;
            BL1points(nBL1,1:2)=MultipleYXZ(j-1,1:2);
            BL1points(nBL1,3:4)=MultipleYXZ(j,1:2);
        end
        clear j MultipleGN MultipleP MultipleYXZ;
        % koniec petli glownej parowania Multipli

        % zerowanie sprawdzonego Multipla z Multiple1
        Multiple1points(i,1)=0;
        Multiple1grainno(i)=0;
        % koniec zerowania sprawdzonego Multipla z Multiple1

    end % koniec petli po Multiple1
    clear i;

    % usuwanie poprawionych Multipli1
    for i=nMultiple1:-1:1
        if Multiple1points(i,1)==0
            Multiple1points(i,:)=[];
            Multiple1grainno(i,:)=[];
            nMultiple1=nMultiple1-1;
        end
    end
    clear i;
    % koniec usuwania poprawionych Multipli3

end % koniec sprawdzenia czy sa Multiple1
% koniec parowania Multiple1 metoda chamskiego sortowania

% zapis danych wynikowych
    % zapis wynikow 3D
        % linie potrojne
        boundarylines.L3.grainno=BL3grainno;
        boundarylines.L3.points=BL3points;
        if nSingle3>0
            boundarylines.Single3.grainno=Single3grainno;
            boundarylines.Single3.points=Single3points;
        end
        if nMultiple3>0
            boundarylines.Multiple3.grainno=Multiple3grainno;
            boundarylines.Multiple3.points=Multiple3points;
        end
        clear BL3grainno BL3points nBL3;
        clear Single3grainno Single3points nSingle3;
        clear Multiple3grainno Multiple3points nMultiple3;
        % koniec linii potrojnych

        % linie poczworne
        boundarylines.L4.grainno=BL4grainno;
        boundarylines.L4.points=BL4points;
        if nSingle4>0
            boundarylines.Single4.grainno=Single4grainno;
            boundarylines.Single4.points=Single4points;
        end
        if nMultiple4>0
            boundarylines.Multiple4.grainno=Multiple4grainno;
            boundarylines.Multiple4.points=Multiple4points;
        end
        clear BL4grainno BL4points nBL4;
        clear Single4grainno Single4points nSingle4;
        clear Multiple4grainno Multiple4points nMultiple4;
        % koniec linii poczwornych        
    % koniec zapisu wynikow 3D

    % zapis wynikow 2D
        % konwersja danych do struktury
        if nSingle2>0
            boundarylines.Single2.grainno=Single2grainno;
            boundarylines.Single2.points=Single2points;
        end
        if nMultiple2>0
            boundarylines.Multiple2.grainno=Multiple2grainno;
            boundarylines.Multiple2.points=Multiple2points;
        end
        % koniec konwersji danych do struktury

        clear BNgrainno BNpoints nBL2;
        clear Single2grainno Single2points nSingle2;
        clear Multiple2grainno Multiple2points nMultiple2;
    % koniec zapisu wynikow 2D

    % zapis wynikow 1D
    boundarylines.L1.grainno=BL1grainno;
    boundarylines.L1.points=BL1points;
    if nSingle1>0
        boundarylines.Single1.grainno=Single1grainno;
        boundarylines.Single1.points=Single1points;
    end
    if nMultiple1>0
        boundarylines.Multiple1.grainno=Multiple1grainno;
        boundarylines.Multiple1.points=Multiple1points;
    end
    clear BL1grainno BL1points nBL1;
    clear Single1grainno Single1points nSingle1;
    clear Multiple1grainno Multiple1points nMultiple1;
    % koniec zapisu wynikow 1D
% koniec zapisu danych wynikowych

% sortowanie wynikow
    % sortowanie L3
    sL3=size(boundarylines.L3.points);
    for i=1:sL3(1)
        k=[0 0]; % pomocniczy kontener do sortowania
        if boundarylines.L3.points(i,1)<boundarylines.L3.points(i,3) % sortowanie typow
            k(1:2)=boundarylines.L3.points(i,1:2);
            boundarylines.L3.points(i,1:2)=boundarylines.L3.points(i,3:4);
            boundarylines.L3.points(i,3:4)=k(1:2);
        end
        if boundarylines.L3.points(i,1)==boundarylines.L3.points(i,3) % sortowanie numerow
            if boundarylines.L3.points(i,2)>boundarylines.L3.points(i,4)
                k(2)=boundarylines.L3.points(i,2);
                boundarylines.L3.points(i,2)=boundarylines.L3.points(i,4);
                boundarylines.L3.points(i,4)=k(2);
            end
        end
    end
    clear i k sL3;
    % koniec sortowania L3

    % sortowanie L4
    sL4=size(boundarylines.L4.points);
    for i=1:sL4(1)
        k=[0 0]; % pomocniczy kontener do sortowania
        if boundarylines.L4.points(i,1)<boundarylines.L4.points(i,3) % sortowanie typow
            k(1:2)=boundarylines.L4.points(i,1:2);
            boundarylines.L4.points(i,1:2)=boundarylines.L4.points(i,3:4);
            boundarylines.L4.points(i,3:4)=k(1:2);
        end
        if boundarylines.L4.points(i,1)==boundarylines.L4.points(i,3) % sortowanie numerow
            if boundarylines.L4.points(i,2)>boundarylines.L4.points(i,4)
                k(2)=boundarylines.L4.points(i,2);
                boundarylines.L4.points(i,2)=boundarylines.L4.points(i,4);
                boundarylines.L4.points(i,4)=k(2);
            end
        end
    end
    clear i k sL4;
    % koniec sortowania L4

    % sortowanie L2
    layers=['ymin';'ymax';'xmin';'xmax';'zmin';'zmax'];
    for j=1:6 % petla po brzegach
        sL2=size(boundarylines.L2.(layers(j,1:4)).points);
        for i=1:sL2(1)
            k=[0 0]; % pomocniczy kontener do sortowania
            if boundarylines.L2.(layers(j,1:4)).points(i,1)<boundarylines.L2.(layers(j,1:4)).points(i,3) % sortowanie typow
                k(1:2)=boundarylines.L2.(layers(j,1:4)).points(i,1:2);
                boundarylines.L2.(layers(j,1:4)).points(i,1:2)=boundarylines.L2.(layers(j,1:4)).points(i,3:4);
                boundarylines.L2.(layers(j,1:4)).points(i,3:4)=k(1:2);                
            end
            if boundarylines.L2.(layers(j,1:4)).points(i,1)==boundarylines.L2.(layers(j,1:4)).points(i,3) % sortowanie numerow
                if boundarylines.L2.(layers(j,1:4)).points(i,2)>boundarylines.L2.(layers(j,1:4)).points(i,4)
                    k(2)=boundarylines.L2.(layers(j,1:4)).points(i,2);
                    boundarylines.L2.(layers(j,1:4)).points(i,2)=boundarylines.L2.(layers(j,1:4)).points(i,4);
                    boundarylines.L2.(layers(j,1:4)).points(i,4)=k(2);
                end
            end
        end
    end % koniec petli po brzegach
    clear i j k sL2 layers;
    % koniec sortowania L2

    % sortowanie L1
    sL1=size(boundarylines.L1.points);
    k=[0 0];
    for i=1:sL1(1)
        if boundarylines.L1.points(i,1)<boundarylines.L1.points(i,3) % sortowanie typow
            k(1:2)=boundarylines.L1.points(i,1:2);
            boundarylines.L1.points(i,1:2)=boundarylines.L1.points(i,3:4);
            boundarylines.L1.points(i,3:4)=k(1:2);
        end
        if boundarylines.L1.points(i,1)==boundarylines.L1.points(i,3) % sortowanie numerow
            if boundarylines.L1.points(i,2)>boundarylines.L1.points(i,4)
                k(2)=boundarylines.L1.points(i,2);
                boundarylines.L1.points(i,2)=boundarylines.L1.points(i,4);
                boundarylines.L1.points(i,4)=k(2);
            end
        end
    end
    clear i k sL1;    
    % koniec sortowania L1
% koniec sortowania wynikow

% czyszczenie pamieci
clear wymiary;

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;