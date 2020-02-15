% pozial na ziarna metoda seed-growth
tic

% parametry zewnetrzne i zmienne globalne
misorangle=2;
wymiary=size(ormatrix);

% obliczanie macierzy dezorientacji
G1=zeros(3);
G2=zeros(3);

    % mapa dezorientacji w X
    disp('Obliczanie mapy dezorientacji w X');
    xmisor=zeros(wymiary(1),wymiary(2)-1);
    for y=1:wymiary(1)
        for x=1:wymiary(2)-1
            G2(1:3,1:3)=ormatrix(y,x+1,1:3,1:3);
            G1(1:3,1:3)=ormatrix(y,x,1:3,1:3);
            G12=G1*G2';
            xmisor(y,x)=real(180/pi*acos((G12(1,1)+G12(2,2)+G12(3,3)-1)/2));
            if xmisor(y,x)<misorangle
                xmisor(y,x)=0;
            end
        end
    end
    % koniec mapy dezorientacji w X

    % mapa dezorientacji w Y
    disp('Obliczanie mapy dezorientacji w Y');
    ymisor=zeros(wymiary(1)-1,wymiary(2));
    for x=1:wymiary(2)
        for y=1:wymiary(1)-1
            G2(1:3,1:3)=ormatrix(y+1,x,1:3,1:3);
            G1(1:3,1:3)=ormatrix(y,x,1:3,1:3);
            G12=G1*G2';
            ymisor(y,x)=real(180/pi*acos((G12(1,1)+G12(2,2)+G12(3,3)-1)/2));
            if ymisor(y,x)<misorangle
                ymisor(y,x)=0;
            end
        end
    end
    % koniec mapy dezorientacji w Y

clear G1 G2 G12 x y;       
% koniec obliczania macierzy dezorientacji

% podzial na ziarna

    % inicjalizacja zmiennych
    grainnumber=0; % inicjalizacja liczby ziaren
    grainmap=zeros(wymiary(1),wymiary(2)); % inicjalizacja mapy ziaren
    zera=wymiary(1)*wymiary(2); % liczba wolnych voxeli
    n=3000; % defaultowa dlugosc listy
    % koniec inicjalizacji zmiennych

    % petla glowna ziaren
    nlista=0;
    while zera>0

        % sadzenie nowego pixela
        if nlista==0

            % tworzenie nowego ziarna
            seedlist=find(grainmap==0,1);
            [yseed,xseed]=ind2sub(wymiary,seedlist); % pierwszy wolny voxel
            grainnumber=grainnumber+1;
            grainmap(yseed,xseed)=grainnumber;
            zera=zera-1;
            % koniec tworzenia nowego ziarna

            % kontrola dzialania
            if mod(grainnumber,1000)==0
                clc;
                fprintf('grainnumber: %6d\n',grainnumber);
                postep=round(100*(1-zera/(wymiary(1)*wymiary(2))));
                fprintf('postep: %2d\n',postep);
                clear postep;
            end
            % koniec kontroli dzialania

            % tworzenie listy pikseli do sprawdzenia
            lista=zeros(n,2); % struktura lista: y,x
            np=1; % poczatek listy
            nk=1; % koniec listy
            nlista=1; % liczba wpisow na liscie
            lista(1,1)=yseed;
            lista(1,2)=xseed;
            % koniec tworzenia listy pikseli do sprawdzenia

            clear seedlist yseed xseed;
        end
        % koniec sadzenia nowego piksela

        % rozrost seeda do wyczerpania listy
        while nlista>0

            y=lista(np,1); % pobranie piksela z listy
            x=lista(np,2); % pobranie piksela z listy
            np=np+1; % przesuniecie wskaznika na nastepna pozycje
            nlista=nlista-1; % liczba wpisow na liscie

            if y>1
                if grainmap(y-1,x)==0 && ymisor(y-1,x)<misorangle
                    grainmap(y-1,x)=grainnumber; % przydzial do ziarna
                    zera=zera-1;
                    nk=nk+1; % przesuniecie wskaznika na nastepna pozycje
                    lista(nk,1:2)=[y-1 x]; % dopisanie do listy
                    nlista=nlista+1; % liczba wpisow na liscie
                end
            end
            if y<wymiary(1)
                if grainmap(y+1,x)==0 && ymisor(y,x)<misorangle
                    grainmap(y+1,x)=grainnumber; % przydzial do ziarna
                    zera=zera-1;
                    nk=nk+1; % przesuniecie wskaznika na nastepna pozycje
                    lista(nk,1:2)=[y+1 x]; % dopisanie do listy
                    nlista=nlista+1;  % liczba wpisow na liscie
                end
            end
            if x>1
                if grainmap(y,x-1)==0 && xmisor(y,x-1)<misorangle
                    grainmap(y,x-1)=grainnumber; % przydzial do ziarna
                    zera=zera-1;
                    nk=nk+1; % przesuniecie wskaznika na nastepna pozycje
                    lista(nk,1:2)=[y x-1]; % dopisanie do listy
                    nlista=nlista+1;  % liczba wpisow na liscie
                end
            end
            if x<wymiary(2)
                if grainmap(y,x+1)==0 && xmisor(y,x)<misorangle
                    grainmap(y,x+1)=grainnumber; % przydzial do ziarna
                    zera=zera-1;
                    nk=nk+1; % przesuniecie wskaznika na nastepna pozycje
                    lista(nk,1:2)=[y x+1]; % dopisanie do listy
                    nlista=nlista+1;  % liczba wpisow na liscie
                end
            end

            % powiekszenie listy
            if nlista>n-5
                lista2=lista; % kopia robocza
                n=n+1000; % powiekszenie listy
                lista=zeros(n,2); % inicjalizacja
                lista(1:nlista,1:2)=lista2(1:nlista,1:2);
                clear lista2;
            end
            % koniec powiekszenia listy

        end
        % koniec rozrostu seeda do wyczerpania listy

    end
    clear lista np nk nlista y x n zera;
    % koniec petli glownej ziaren

% koniec podzialu na ziarna

% czyszczenie pamieci
clear misorangle wymiary ymisor xmisor;

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;