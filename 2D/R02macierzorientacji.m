% macierze orientacji sprowadzone do domeny asymetrycznej
tic

% ----------
% Metoda sprowadzenia danych eksperymentalnych do domeny
% asymetrycznej poprzez uporzadkowanie kolejnosci wierszy 
% w macierzy orientacji razem z ich minusowaniem i zamiana
% poprawionej macierzy na katy Eulera
% Najlepsze efekty daje metoda tangensa razem z zamiana katow ujemnych
% na dodatnie (inwersja)
% ----------

% parametry zewnetrzne i zmienne globalne
metoda=2; %MtoE: 1-sinus, 2-tangens, 3-jedynka
inwersja=1; %MtoE: 0-nie, 1-tak

wymiary=size(EulerAngles);
ormatrix=zeros(wymiary(1),wymiary(2),3,3);

% obliczanie macierzy orientacji i asymetryzacja
M=zeros(3); % inicjalizacja macierzy roboczej
T001=zeros(6,3); % inicjalizacja macierzy wekt. 001 z M
for y=1:wymiary(1)
    for x=1:wymiary(2)
        
        % obliczanie macierzy orientacji
        sf1=sin(EulerAngles(y,x,3));
        cf1=cos(EulerAngles(y,x,3));
        sf2=sin(EulerAngles(y,x,5));
        cf2=cos(EulerAngles(y,x,5));
        sF=sin(EulerAngles(y,x,4));
        cF=cos(EulerAngles(y,x,4));
        M(1,1)=cf1*cf2-sf1*sf2*cF;
        M(1,2)=sf1*cf2+cf1*sf2*cF;
        M(1,3)=sf2*sF;
        M(2,1)=-cf1*sf2-sf1*cf2*cF;
        M(2,2)=-sf1*sf2+cf1*cf2*cF;
        M(2,3)=cf2*sF;
        M(3,1)=sf1*sF;
        M(3,2)=-cf1*sF;
        M(3,3)=cF;
        % koniec obliczania macierzy orientacji

        % sprowadzanie macierzy do domeny asymetrycznej
        T001(1:3,1:3)=M; % zapis w T kierunkow 100,010,001
        T001(4:6,1:3)=-M; % zapis w T kierunkow -100,-010,-001
        [T001m,T001i]=max(T001); % znalezienie max wektora x
        M(1,1:3)=T001(T001i(1),1:3); % przepisanie wektora na poz.x

            % kasowanie wykorzystanego wektora i jego rownoleglego brata
            if T001i(1)==1 || T001i(1)==4
                T001(4,:)=[];
                T001(1,:)=[];
            elseif T001i(1)==2 || T001i(1)==5
                T001(5,:)=[];
                T001(2,:)=[];
            else
                T001(6,:)=[];
                T001(3,:)=[];
            end
            % koniec kasowania wykorzystanych wektorow

        [T001m,T001i]=max(T001); % znalezienie max wektora z
        M(3,1:3)=T001(T001i(3),1:3); % przepisanie wektora na poz.z
        M(2,1)=M(3,2)*M(1,3)-M(3,3)*M(1,2); % wyznaczenie wektora y
        M(2,2)=M(3,3)*M(1,1)-M(3,1)*M(1,3); % wyznaczenie wektora y
        M(2,3)=M(3,1)*M(1,2)-M(3,2)*M(1,1); % wyznaczenie wektora y
        ormatrix(y,x,1:3,1:3)=M(1:3,1:3);
        % koniec sprowadzania macierzy doo domeny asymetrycznej
    end
end
clear sf1 cf1 sf2 cf2 sF cF;
clear T001 T001m T001i;
clear y x M;
% koniec obliczania macierzy orientacji i asymetryzacji

% konwersja macierzy do katow Eulera
Eulery=zeros(wymiary(1),wymiary(2),5);
if metoda==1 % metoda arcus sinus
    for y=1:wymiary(1)
        for x=1:wymiary(2)
            Eulery(y,x,4)=acos(ormatrix(y,x,3,3));
            s=sin(Eulery(y,x,4));
            Eulery(y,x,3)=asin(ormatrix(y,x,3,1)/s);
            Eulery(y,x,5)=asin(ormatrix(y,x,1,3)/s);
            Eulery(y,x,1)=y;
            Eulery(y,x,2)=x;
        end
    end
elseif metoda==2 % metoda arcus tangens
    for y=1:wymiary(1)
        for x=1:wymiary(2)
            Eulery(y,x,4)=acos(ormatrix(y,x,3,3));
            Eulery(y,x,3)=atan(-ormatrix(y,x,3,1)/ormatrix(y,x,3,2));
            Eulery(y,x,5)=atan(ormatrix(y,x,1,3)/ormatrix(y,x,2,3));
            if inwersja==1
                if Eulery(y,x,3)<0
                    Eulery(y,x,3)=-Eulery(y,x,3);
                end        
                if Eulery(y,x,5)<0
                    Eulery(y,x,5)=-Eulery(y,x,5);
                end
            end
            Eulery(y,x,1)=y;
            Eulery(y,x,2)=x;
        end
    end
elseif metoda==3 % metoda jedynki trygonometrycznej
    for y=1:wymiary(1)
        for x=1:wymiary(2)
            Eulery(y,x,4)=acos(ormatrix(y,x,3,3));
            s=(1-(ormatrix(y,x,3,3)^2)^0.5);
            Eulery(y,x,3)=asin(ormatrix(y,x,3,1)/s);
            Eulery(y,x,5)=asin(ormatrix(y,x,1,3)/s);
            Eulery(y,x,1)=y;
            Eulery(y,x,2)=x;
        end
    end
else
    disp('musisz wybrac metode');
end
EulerAngles=Eulery;
clear Eulery metoda inwersja y x s status;
% koniec konwersji MtoE

% czyszczenie pamieci
clear wymiary;

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;