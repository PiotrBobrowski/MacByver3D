% pozial na ziarna metoda seed-growth (wododzialowa)
tic

% parametry zewnetrzne i zmienne globalne
MisOrAngle=2; % kat graniczny
wymiary=size(ormatrix);

% obliczanie macierzy dezorientacji
G1=zeros(3,'single'); % inicjalizacja macierzy roboczej
G2=zeros(3,'single'); % inicjalizacja macierzy roboczej

    % mapa dezorientacji w X
    disp('obliczanie dezorientacji w X');
    xmisor=zeros(wymiary(1),wymiary(2)-1,wymiary(3),'single');
    for z=1:wymiary(3)
        for y=1:wymiary(1)
            for x=1:wymiary(2)-1
                G2(1:3,1:3)=ormatrix(y,x+1,z,1:3,1:3);
                G1(1:3,1:3)=ormatrix(y,x,z,1:3,1:3);
                G12=G1*G2';
                xmisor(y,x,z)=real(180/pi*acos((G12(1,1)+G12(2,2)+G12(3,3)-1)/2));
                if xmisor(y,x,z)<MisOrAngle %|| xmisor(y,x,z)>180-minmisor
                    xmisor(y,x,z)=0;
                end
            end
        end
    end
    % koniec mapy dezorientacji w X
    
    % mapa dezorientacji w Y
    disp('obliczanie dezorientacji w Y');
    ymisor=zeros(wymiary(1)-1,wymiary(2),wymiary(3),'single');
    for z=1:wymiary(3)
        for x=1:wymiary(2)
            for y=1:wymiary(1)-1
                G2(1:3,1:3)=ormatrix(y+1,x,z,1:3,1:3);
                G1(1:3,1:3)=ormatrix(y,x,z,1:3,1:3);
                G12=G1*G2';
                ymisor(y,x,z)=real(180/pi*acos((G12(1,1)+G12(2,2)+G12(3,3)-1)/2));
                if ymisor(y,x,z)<MisOrAngle %|| ymisor(y,x,z)>180-minmisor
                    ymisor(y,x,z)=0;
                end
            end
        end
    end
    % koniec mapy dezorientacji w Y

    % mapa dezorientacji w Z
    disp('obliczanie dezorientacji w Z');
    zmisor=zeros(wymiary(1),wymiary(2),wymiary(3)-1,'single');
    for y=1:wymiary(1)
        for x=1:wymiary(2)
            for z=1:wymiary(3)-1
                G2(1:3,1:3)=ormatrix(y,x,z+1,1:3,1:3);
                G1(1:3,1:3)=ormatrix(y,x,z,1:3,1:3);
                G12=G1*G2';
                zmisor(y,x,z)=real(180/pi*acos((G12(1,1)+G12(2,2)+G12(3,3)-1)/2));
                if zmisor(y,x,z)<MisOrAngle %|| zmisor(y,x,z)>180-minmisor
                    zmisor(y,x,z)=0;
                end
            end
        end
    end
    % koniec mapy dezorientacji w Z

clear G1 G2 G12 y x z;
% koniec obliczania macierzy dezorientacji

% podzial na ziarna

    % inicjalizacja zmiennych
    grainnumber=0; % inicjalizacja liczby ziaren
    grainmap=zeros(wymiary(1:3),'uint32'); % inicjalizacja mapy ziaren
    zera=wymiary(1)*wymiary(2)*wymiary(3); % liczba pustych voxeli
    % koniec inicjalizacji zmiennych
    
    % petla glowna podzialu na ziarna
    nlista=0; % pozycja kursora
    w=0; % monitorowanie przebiegu petli
    
    while zera>0
        
        % sadzenie nowego voxela
        if nlista==0
            SeedList=find(grainmap==0,1); % znajdz 1. wolny voxel
            [yseed,xseed,zseed]=ind2sub(wymiary,SeedList(1));
            grainnumber=grainnumber+1; % aktualny numer ziarna
            grainmap(yseed,xseed,zseed)=grainnumber; % posianie seeda
            zera=zera-1; % zmniejszenie licznika pustynch voxeli
            lista=zeros(5000,3,'uint32'); % inicjalizacja listy
            lista(1,1)=yseed;
            lista(1,2)=xseed;
            lista(1,3)=zseed;
            nlista=1;
            clear SeedList yseed xseed zseed;
        end
        % koniec sadzenia nowego voxela

        % rozrost seeda do wyczerpania listy
        while nlista>0
            y=lista(nlista,1); % pobranie ostatniego voxela z listy
            x=lista(nlista,2);
            z=lista(nlista,3);
            nlista=nlista-1;

            if y>1
                if grainmap(y-1,x,z)==0 && ymisor(y-1,x,z)<MisOrAngle
                        grainmap(y-1,x,z)=grainnumber;
                        zera=zera-1;
                        nlista=nlista+1;
                        lista(nlista,1:3)=[y-1 x z];
                end
            end
            if y<wymiary(1)
                if grainmap(y+1,x,z)==0 && ymisor(y,x,z)<MisOrAngle
                        grainmap(y+1,x,z)=grainnumber;
                        zera=zera-1;
                        nlista=nlista+1;
                        lista(nlista,1:3)=[y+1 x z];
                end
            end
            if x>1
                if grainmap(y,x-1,z)==0 && xmisor(y,x-1,z)<MisOrAngle
                        grainmap(y,x-1,z)=grainnumber;
                        zera=zera-1;
                        nlista=nlista+1;
                        lista(nlista,1:3)=[y x-1 z];
                end
            end
            if x<wymiary(2)
                if grainmap(y,x+1,z)==0 && xmisor(y,x,z)<MisOrAngle
                        grainmap(y,x+1,z)=grainnumber;
                        zera=zera-1;
                        nlista=nlista+1;
                        lista(nlista,1:3)=[y x+1 z];
                end
            end
            if z>1
                if grainmap(y,x,z-1)==0 && zmisor(y,x,z-1)<MisOrAngle
                        grainmap(y,x,z-1)=grainnumber;
                        zera=zera-1;
                        nlista=nlista+1;
                        lista(nlista,1:3)=[y x z-1];
                end
            end
            if z<wymiary(3)
                if grainmap(y,x,z+1)==0 && zmisor(y,x,z)<MisOrAngle
                        grainmap(y,x,z+1)=grainnumber;
                        zera=zera-1;
                        nlista=nlista+1;
                        lista(nlista,1:3)=[y x z+1];
                end
            end
            
            % kontrola dzialania
            w=w+1;
            if w==25000
                clc;
                sprawdzenie(1)=grainnumber;
                sprawdzenie(2)=zera;
                disp('grainnumber, liczba zer');
                disp(sprawdzenie(1:2));
                w=0;
            end
            % koniec kontroli dzialania
        end
        % koniec wzrostu seed do wyczerpania listy
    end
    
    clear zera y x z lista nlista;
    clear w sprawdzenie;
    clear ymisor xmisor zmisor;
    % koniec petli glownej podzialu na ziarna
% koniec podzialu na ziarna

% czyszczenie pamieci
clear MisOrAngle wymiary;

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;