% macierze orientacji sprowadzone do domeny asymetrycznej
tic

% ----------
% Metoda sprowadzania orientacji do domeny asymetrycznej poprzez
% uporzadkowanie kolejnosci wierszy w macierzy orientacji razem
% z ich minusowaniem i przeliczenie poprawionej macierzy na
% katy Eulera
% Najlepsze efekty daje metoda tangensa razem z zamiana katow
% ujemnych na dodatnie (inwersja)
% ----------

% parametry zewnetrzne i zmienne globalne
    % metoda przeliczania M na E:
    % 1 - sinus
    % 2 - tangens
    % 3 - jedynka trygonometryczna
    metoda=2;
    
    % inwersja katow ujemnych:
    % 0 - nie
    % 1 - tak
    inwersja=1;

wymiary=size(EulerAngles);
ormatrix=zeros(wymiary(1),wymiary(2),wymiary(3),3,3,'single'); % inicjalizacja
% koniec parametrow zewnetrznych i zmiennych globalnych

% obliczanie macierzy orientacji i asymetryzacja
M=zeros(3); % inicjalizacja macierzy roboczej
T001=zeros(6,3); % inicjalizacja macierzy wekt. 001 z M

for z=1:wymiary(3)
    clc;
    fprintf('obliczanie macierzy orientacji, z=%3d\n',z);
    for y=1:wymiary(1)
        for x=1:wymiary(2)
            
            % obliczanie macierzy orientacji
            sf1=sin(EulerAngles(y,x,z,3));
            cf1=cos(EulerAngles(y,x,z,3));
            sf2=sin(EulerAngles(y,x,z,5));
            cf2=cos(EulerAngles(y,x,z,5));
            sF=sin(EulerAngles(y,x,z,4));
            cF=cos(EulerAngles(y,x,z,4));
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
            [~,T001i]=max(T001); % znalezienie max wektora x
            M(1,1:3)=T001(T001i(1),1:3); % przepisanie wektora na poz.x
            
                % kasowanie wykorzystanego wektora i jego rownoleglego brata
                if T001i(1)==1 || T001i(1)==4
                    T001(4,1:3)=[0 0 0];
                    T001(1,1:3)=[0 0 0];
                elseif T001i(1)==2 || T001i(1)==5
                    T001(5,1:3)=[0 0 0];
                    T001(2,1:3)=[0 0 0];
                else
                    T001(6,1:3)=[0 0 0];
                    T001(3,1:3)=[0 0 0];
                end
                % koniec kasowania wykorzystanych wektorow

            [~,T001i]=max(T001); % znalezienie max wektora z
            M(3,1:3)=T001(T001i(3),1:3); % przepisanie wektora na poz.z
            M(2,1)=M(3,2)*M(1,3)-M(3,3)*M(1,2); % wyznaczenie wektora y
            M(2,2)=M(3,3)*M(1,1)-M(3,1)*M(1,3); % wyznaczenie wektora y
            M(2,3)=M(3,1)*M(1,2)-M(3,2)*M(1,1); % wyznaczenie wektora y
            ormatrix(y,x,z,1:3,1:3)=M(1:3,1:3);
            % koniec sprowadzania macierzy o domeny asymetrycznej
        end
    end
end
clear sf1 cf1 sf2 cf2 sF cF;
clear T001 T001m T001i;
clear x y z M;
% koniec obliczania macierzy orientacji i asymetryzacji

% konwersja macierzy do katow Eulera
disp('przeliczenie macierzy na katy Eulera');
Eulery=zeros(wymiary(1),wymiary(2),wymiary(3),5,'single');
if metoda==1 % metoda arcus sinus
    for z=1:wymiary(3)
        clc;
        fprintf('aktualizacja katow Eulera, z=%3d\n',z);
        for y=1:wymiary(1)
            for x=1:wymiary(2)
                Eulery(y,x,z,4)=acos(ormatrix(y,x,z,3,3));
                s=sin(Eulery(y,x,z,4));
                Eulery(y,x,z,3)=asin(ormatrix(y,x,z,3,1)/s);
                Eulery(y,x,z,5)=asin(ormatrix(y,x,z,1,3)/s);
                Eulery(y,x,z,1)=y;
                Eulery(y,x,z,2)=x;
            end
        end
    end
elseif metoda==2 % metoda arcus tangens
    for z=1:wymiary(3)
        clc;
        fprintf('aktualizacja katow Eulera, z=%3d\n',z);
        for y=1:wymiary(1)
            for x=1:wymiary(2)
                Eulery(y,x,z,4)=acos(ormatrix(y,x,z,3,3));
                Eulery(y,x,z,3)=atan(-ormatrix(y,x,z,3,1)/ormatrix(y,x,z,3,2));
                Eulery(y,x,z,5)=atan(ormatrix(y,x,z,1,3)/ormatrix(y,x,z,2,3));
                if inwersja==1
                    if Eulery(y,x,z,3)<0
                        Eulery(y,x,z,3)=-Eulery(y,x,z,3);
                    end
                    if Eulery(y,x,z,5)<0
                        Eulery(y,x,z,5)=-Eulery(y,x,z,5);
                    end
                end
                Eulery(y,x,z,1)=y;
                Eulery(y,x,z,2)=x;
            end
        end
    end
elseif metoda==3 % metoda jedynki trygonometrycznej
    for z=1:wymiary(3)
        clc;
        fprintf('aktualizacja katow Eulera, z=%3d\n',z);
        for y=1:wymiary(1)
            for x=1:wymiary(2)
                Eulery(y,x,z,4)=acos(ormatrix(y,x,z,3,3));
                s=(1-(ormatrix(y,x,z,3,3)^2)^0.5);
                Eulery(y,x,z,3)=asin(ormatrix(y,x,z,3,1)/s);
                Eulery(y,x,z,5)=asin(ormatrix(y,x,z,1,3)/s);
                Eulery(y,x,z,1)=y;
                Eulery(y,x,z,2)=x;
            end
        end
    end
else
    disp('musisz wybrac metode');
end
EulerAngles=Eulery;
clear Eulery;
clear metoda inwersja y x z;
% koniec konwersji M2E

% czyszczenie pamieci
clear wymiary;

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;