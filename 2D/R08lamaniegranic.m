% lamanie odcinkow granicznych w 2D
tic
% zmienne globalne i parametry zewnetrzne
breaktreshold=1.75; % kryterium lamania granicy, optimum=2
wymiary=size(grainmap);

% pobranie danych o punktach krawedziowych
P22g=boundarypoints.P22.grainno;
P22c=boundarypoints.P22.coord;

% tablice robocze z liniami D2
D2g=boundaryedges.D2.grainno;
D2p=boundaryedges.D2.points;

% tablice wynikowe
sD2=size(D2g);
BEg=zeros(sD2(1),2); % polamane krawedzie: ziarna
BEp=zeros(sD2(1),4); % polamane krawedzie: punkty
lamanie=zeros(sD2(1),1); % zaznaczanie odcinkow zlamanych
nBE=0; % numerator tablicy wynikowej

% petla glowna
while ~isempty(D2g)

    % wspolrzedne koncow odcinka krawedziowego
        % pobranie wspolrzednych pierwszego konca P1
        if D2p(1,1)==23
            P1c(1:2)=boundarypoints.P23.coord(D2p(1,2),1:2);
        elseif D2p(1,1)==12
            P1c(1:2)=boundarypoints.P12.coord(D2p(1,2),1:2);
        elseif D2p(1,1)==24
            P1c(1:2)=boundarypoints.P24.coord(D2p(1,2),1:2);
        elseif D2p(1,1)==22
            P1c(1:2)=boundarypoints.P22.coord(D2p(1,2),1:2);
        end

        % pobranie wspolrzednych drugiego konca P2
        if D2p(1,3)==23
            P2c(1:2)=boundarypoints.P23.coord(D2p(1,4),1:2);
        elseif D2p(1,3)==12
            P2c(1:2)=boundarypoints.P12.coord(D2p(1,4),1:2);
        elseif D2p(1,3)==24
            P2c(1:2)=boundarypoints.P24.coord(D2p(1,4),1:2);
        elseif D2p(1,3)==22
            P2c(1:2)=boundarypoints.P22.coord(D2p(1,4),1:2);
        end
    % koniec wspolrzednych odcinka krawedziowego
    
    % zabezpieczenie przed granica o dlugosci 1 pix
    BoundaryLength=((P1c(1)-P2c(1))^2+(P1c(2)-P2c(2))^2)^0.5;
    
    if BoundaryLength<1.5 % zabezpieczenie przed granica o dlugosci 1 pix
        nBE=nBE+1;
        BEg(nBE,1:2)=D2g(1,1:2);
        BEp(nBE,1:4)=D2p(1,1:4);
    else % granica wymaga sprawdzenia
        
        % okreslenie punktow nalezacych do danego odcinka metoda skokow
            % kroczenie po granicy
            EndOfLine=false;
            WrongDirection=false;
            while ~EndOfLine % kroczenie po granicy
                
                % wspolrzedne 1. punktu
                y=P1c(1);
                x=P1c(2);
                % koniec wspolrzednych 1. punktu

                % tworzenie tablicy przejsc
                Jump=zeros(4,2); % inicjalizacja: GN1, GN2
                if y>0
                    if x<wymiary(2)
                        if x>0
                            Jump(1,1:2)=sort([grainmap(y,x) grainmap(y,x+1)]); % N
                        end
                        if y<wymiary(1)
                            Jump(2,1:2)=sort([grainmap(y,x+1) grainmap(y+1,x+1)]); % E
                        end
                    end
                    if (y<wymiary(1) && x>0)
                        Jump(4,1:2)=sort([grainmap(y,x) grainmap(y+1,x)]); % W
                    end     
                end
                if (y<wymiary(1) && x>0 && x<wymiary(2))
                    Jump(3,1:2)=sort([grainmap(y+1,x) grainmap(y+1,x+1)]); % S
                end
                    
                    
                
%                 if (y>0 && x>0 && x<wymiary(2))
%                     Jump(1,1:2)=sort([grainmap(y,x) grainmap(y,x+1)]); % N
%                 end
%                 if (y>0 && y<wymiary(1) && x<wymiary(2))
%                     Jump(2,1:2)=sort([grainmap(y,x+1) grainmap(y+1,x+1)]); % E
%                 end
%                 if (y<wymiary(1) && x>0 && x<wymiary(2))
%                     Jump(3,1:2)=sort([grainmap(y+1,x) grainmap(y+1,x+1)]); % S
%                 end
%                 if (y>0 && y<wymiary(1) && x>0)
%                     Jump(4,1:2)=sort([grainmap(y,x) grainmap(y+1,x)]); % W
%                 end
                
%                 if x<wymiary(2)
%                     Jump(1,1:2)=sort([grainmap(y,x) grainmap(y,x+1)]); % N
%                     if y<wymiary(1)
%                         Jump(2,1:2)=sort([grainmap(y,x+1) grainmap(y+1,x+1)]); % E
%                         Jump(3,1:2)=sort([grainmap(y+1,x) grainmap(y+1,x+1)]); % S
%                     end
%                 end
%                 if y<wymiary(1)
%                     Jump(4,1:2)=sort([grainmap(y,x) grainmap(y+1,x)]); % W
%                 end
                % koniec tworzenia tablicy przejsc

                % wybor kierunku 1. przejscia
                JumpDirection=0;
                if WrongDirection==false
                    for j=1:4
                        if (Jump(j,1)==D2g(1,1) && Jump(j,2)==D2g(1,2))
                            JumpDirection=j;
                            break;
                        end
                    end
                    clear j;
                else
                    for j=4:-1:1
                        if (Jump(j,1)==D2g(1,1) && Jump(j,2)==D2g(1,2))
                            JumpDirection=j;
                            break;
                        end
                    end
                    clear j;
                end
                % koniec wybierania kierunku 1. przejscia

                % wykonanie 1. kroku
                if JumpDirection==1 % N
                    y=y-1;
                elseif JumpDirection==2 % E
                    x=x+1;
                elseif JumpDirection==3 % S
                    y=y+1;
                elseif JumpDirection==4 % W
                    x=x-1;
                end
                % koniec wykonywania 1. kroku

                % wykonanie kolejnych krokow
                P=zeros(100,2); % inicjalizacja: typ,numer,y,x
                nP=0; % numerator P

                while ~EndOfLine % wykonanie kolejnych krokow

                    % sprawdzenie zakonczenia odcinka
                    if (y==P2c(1) && x==P2c(2)) % sprawdzenie zakonczenia odcinka
                        EndOfLine=true;
                        
                    else
                        % zapisanie punktu na liscie
                        if ~EndOfLine 
                            nP=nP+1;
                            P(nP,1:2)=[y x];
                        end
                        % koniec zapisywania punktu na liscie

                        % tworzenie tablicy przejsc
                        Jump=zeros(4,2);
                        if y>0
                            if x<wymiary(2)
                                if x>0
                                    Jump(1,1:2)=sort([grainmap(y,x) grainmap(y,x+1)]); % N
                                end
                                if y<wymiary(1)
                                    Jump(2,1:2)=sort([grainmap(y,x+1) grainmap(y+1,x+1)]); % E
                                end
                            end
                            if (y<wymiary(1) && x>0)
                                Jump(4,1:2)=sort([grainmap(y,x) grainmap(y+1,x)]); % W
                            end     
                        end
                        if (y<wymiary(1) && x>0 && x<wymiary(2))
                            Jump(3,1:2)=sort([grainmap(y+1,x) grainmap(y+1,x+1)]); % S
                        end
%                         if x<wymiary(2)
%                             Jump(1,1:2)=sort([grainmap(y,x) grainmap(y,x+1)]); % N
%                             if y<wymiary(1)
%                                 Jump(2,1:2)=sort([grainmap(y,x+1) grainmap(y+1,x+1)]); % E
%                                 Jump(3,1:2)=sort([grainmap(y+1,x) grainmap(y+1,x+1)]); % S
%                             end
%                         end
%                         if y<wymiary(1)
%                             Jump(4,1:2)=sort([grainmap(y,x) grainmap(y+1,x)]); % W
%                         end
                        % koniec tworzenia tablicy przejsc

                        % zerowanie kierunku nadejscia
                        if JumpDirection==1
                            Jump(3,1:2)=[0 0];
                        elseif JumpDirection==2
                            Jump(4,1:2)=[0 0];
                        elseif JumpDirection==3
                            Jump(1,1:2)=[0 0];
                        else
                            Jump(2,1:2)=[0 0];
                        end
                        % koniec zerowania kierunku nadejscia

                        % wybor kierunku przejscia
                        JumpDirection=0;
                        for j=1:4
                            if (Jump(j,1)==D2g(1,1) && Jump(j,2)==D2g(1,2))
                                JumpDirection=j;
                                break;
                            end
                        end
                        clear j;
                        % koniec wybierania kierunku przejscia

                        % wykonanie kroku
                        if JumpDirection==1 % N
                            y=y-1;
                        elseif JumpDirection==2 % E
                            x=x+1;
                        elseif JumpDirection==3 % S
                            y=y+1;
                        elseif JumpDirection==4 % W
                            x=x-1;
                        else % nie okreslono kierunku przejscia
                            WrongDirection=true;
                            break;
                        end
                        % koniec wykonywania kroku

                    end
                    % koniec sprawdzania zakonczenia odcinka

                end
                % koniec wykonywania kolejnych krokow

            end
            clear EndOfLine WrongDirection Jump JumpDirection;
            % koniec kroczenia po granicy
        % koniec okreslania punktow nalezacych do odcinka metoda skokow
        
        % obliczenie odleglosci punktow od prostej
            % wektor PQ(x,y) wzdloz prostej, rosnace y
            PQ(1)=P1c(2)-P2c(2); % PQ(x)
            PQ(2)=P1c(1)-P2c(1); % PQ(y)
            if PQ(2)<0
                PQ=-PQ;
            end
            LPQ=(PQ(1)^2+PQ(2)^2)^0.5; % dlugosc wektora PQ
            % koniec wektora PQ
            
            L=zeros(nP,1); % odleglosci punktow od prostej
            
            % obliczenie odleglosci dla kazdego punktu
            for i=1:nP
                % wektor PR(x,y) do badanego punktu, rosnace y
                PR(1)=P1c(2)-P((i),2); % PR(x)
                PR(2)=P1c(1)-P((i),1); % PR(y)
                if PR(2)<0
                    PR=-PR;
                end
                % koniec wektora PR

                % iloczyn wektorowy PQxPR
                PQPR=PQ(1)*PR(2)-PQ(2)*PR(1);
                LPQPR=abs(PQPR);
                % koniec iloczynu wektorowego

                % odleglosc punktu od prostej
                L(i)=LPQPR/LPQ;
                % koniec odleglosci
            end
            clear sEP i PQ LPQ PR PQPR LPQPR;
            % koniec obliczania odleglosci dla kazdego punktu
        % koniec obliczania odleglosci punktow od prostej

        % sprawdzenie kryterium odleglosci i lamanie odcinkow
        [Lmaxvalue,Lmaxindex]=max(L);
        if Lmaxvalue<=breaktreshold % bez lamania: zapis do tablicy wynikowej
            nBE=nBE+1;
            BEg(nBE,1:2)=D2g(1,1:2); % przepisanie z1,z2
            BEp(nBE,1:4)=D2p(1,1:4); % przepisanie t1,n1,t2,n2
        else % lamanie odcinka: zapis na koniec tablicy roboczej
            
            % okreslenie typu i numeru punktu P22
            EP=find(P22c(:,1)==P(Lmaxindex,1) & P22c(:,2)==P(Lmaxindex,2));
            
            % sD2=size(D2g); % aktualna dlugosc tablicy roboczej
        
            % dopisanie danych 1. zlamanego odcinka na koniec tablicy roboczej
            sD2(1)=sD2(1)+1;
            D2g(sD2(1),1:2)=D2g(1,1:2); % przepisanie z1,z2
            D2p(sD2(1),1:2)=D2p(1,1:2); % przepisanie typu i numeru P1
            D2p(sD2(1),3:4)=[22 EP]; % dodanie typu i numeru P2
            lamanie(sD2(1))=1; % oznaczenie zlamanego odcinka
                    
            % dopisanie danych 2. zlamanego odcinka na koniec tablicy roboczej
            sD2(1)=sD2(1)+1;
            D2g(sD2(1),1:2)=D2g(1,1:2); % przepisanie z1,z2
            D2p(sD2(1),1:2)=[22 EP]; % dodanie typu i numeru P1
            D2p(sD2(1),3:4)=D2p(1,3:4); % przepisanie typu i numeru P2
            lamanie(sD2(1))=1; % oznaczenie zlamanego odcinka
        end % koniec lamania odcinka
        % koniec sprawdzania kryterium odleglosci i lamanie odcinkow
      
    end
    clear y x;
    clear P nP L Lmaxvalue Lmaxindex BoundaryLength;
    % koniec zabezpieczenia przed granica o dlugosci 1 pix
    clear EP;
    D2p(1,:)=[];
    D2g(1,:)=[];
    lamanie(1)=[];
    sD2(1)=sD2(1)-1;
end
clear P1c P2c;
% koniec petli glownej

% zapis wynikow
boundaryedges.D2.grainno=BEg;
boundaryedges.D2.points=BEp;

% czyszczenie pamieci
clear D2g D2p sD2;
clear nBE BEg BEp P22g P22c 
clear lamanie breaktreshold wymiary;

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;