% wygladzanie granic ziaren: ziarno po ziarnie
% algorytm iteruje po numerach ziaren w obie strony
tic

% parametry zewnetrzne i zmienne globalne
wymiary=size(grainmap);

for l=1:2 % petla w obie strony

    % wybor kierunku iterowania
    if l==1
        poczatek=1;
        koniec=grainnumber;
        krok=1;
    else
        poczatek=grainnumber;
        koniec=1;
        krok=-1;
    end
    % koniec wyboru kierunku iterowania

    % petla glowna
    BlockedVoxels=zeros(wymiary); % blokada zeby nie zmieniac wygladzonych ziaren
    for gn=poczatek:krok:koniec % petla po ziarnach
        clc;
        disp('gn=');
        disp(gn);
        ChangedVoxelsTotalOld=-1; % voxele zmienione w poprzedniej iteracji
        ChangedVoxelsTotal=0; % voxele zmienione w obecnej iteracji
        while ChangedVoxelsTotalOld-ChangedVoxelsTotal~=0 % rob dopoki cos sie zmienia
            ChangedVoxelsTotalOld=ChangedVoxelsTotal;
            
            [Vy,Vx]=ind2sub(wymiary,find(grainmap==gn)); % voxele z danego ziarna
            lVy=length(Vy); % liczba znalezionych voxeli
            vtc=zeros(lVy,3); % vtc: y,x,kier.nadpisu
            nvtc=0; % numerator vtc

            % okreslenie voxeli do poprawienia
            for j=1:lVy % petla po voxelach w danym ziarnie

                % wspolrzedne voxela
                y=Vy(j);
                x=Vx(j);
                % koniec wspolrzednych voxela

                % lista sasiadow voxela
                nearvoxels=[0 0 0 0]; %y-1,x+1,y+1,x-1
                nfriends=0;
                if y>1
                    if grainmap(y,x)==grainmap(y-1,x)
                        nfriends=nfriends+1;
                    elseif BlockedVoxels(y-1,x)==0
                        nearvoxels(1)=grainmap(y-1,x);
                    end
                end
                if x<wymiary(2)
                    if grainmap(y,x)==grainmap(y,x+1)
                        nfriends=nfriends+1;
                    elseif BlockedVoxels(y,x+1)==0
                        nearvoxels(2)=grainmap(y,x+1);
                    end
                end
                if y<wymiary(1)
                    if grainmap(y,x)==grainmap(y+1,x)
                        nfriends=nfriends+1;
                    elseif BlockedVoxels(y+1,x)==0
                        nearvoxels(3)=grainmap(y+1,x);
                    end
                end
                if x>1
                    if grainmap(y,x)==grainmap(y,x-1)
                        nfriends=nfriends+1;
                    elseif BlockedVoxels(y,x-1)==0
                        nearvoxels(4)=grainmap(y,x-1);
                    end
                end
                % koniec listy sasiadow voxela

                % zanotowanie wysunietego voxela
                if nfriends<=1
                    unearvoxels=unique(nonzeros(nearvoxels)); % unikatowe numery sasiadow
                    if ~isempty(unearvoxels)
                        lunearvoxels=length(unearvoxels); % liczba unikatowych sasiadow
                        
                        % wybor kierunku przepisania
                        if lunearvoxels>1 % jezeli wiecej niz jeden unikatowy sasiad
                            unearvoxels(lunearvoxels,2)=0; % poszerzenie tablicy/inicjalizacja
                            
                            % histogram liczby sasiadow
                            for k1=1:lunearvoxels
                                for k2=1:4
                                    if nearvoxels(k2)==unearvoxels(k1,1)
                                        unearvoxels(k1,2)=unearvoxels(k1,2)+1;
                                    end
                                end
                            end
                            clear k1 k2;
                            % koniec histogramu liczby sasiadow

                            [munearvoxels, iunearvoxels]=max(unearvoxels(:,2)); % maksimum histogramu
                            fnearvoxels=find(nearvoxels==unearvoxels(iunearvoxels,1),1); % kierunek nadpisania
                            clear munearvoxels iunearvoxels;
                        else
                            fnearvoxels=find(nearvoxels==unearvoxels,1); % kierunek nadpisania
                        end
                        % koniec wyboru kierunku przepisania
                        
                        nvtc=nvtc+1;
                        vtc(nvtc,1:3)=[y x fnearvoxels]; % zanotowanie wysunietego voxela
                        clear lunearvoxels fnearvoxels;    
                    end
                    clear unearvoxels;
                end
                clear y x nearvoxels nfriends;
                % koniec notowania wysunietego voxela
                
            end % koniec petli po voxelach w danym ziarnie
            clear j Vy Vx lVy;
            % koniec okreslania voxeli do poprawienia

            % poprawienie zanotowanych voxeli
            for j=1:nvtc % y-1,x+1,y+1,x-1
                ChangedVoxelsTotal=ChangedVoxelsTotal+1;
                y=vtc(j,1);
                x=vtc(j,2);
                if vtc(j,3)==1
                    grainmap(y,x)=grainmap(y-1,x);
                    ormatrix(y,x,1:3,1:3)=ormatrix(y-1,x,1:3,1:3);
                    EulerAngles(y,x,3:5)=EulerAngles(y-1,x,3:5);
                elseif vtc(j,3)==2
                    grainmap(y,x)=grainmap(y,x+1);
                    ormatrix(y,x,1:3,1:3)=ormatrix(y,x+1,1:3,1:3);
                    EulerAngles(y,x,3:5)=EulerAngles(y,x+1,3:5);
                elseif vtc(j,3)==3
                    grainmap(y,x)=grainmap(y+1,x);
                    ormatrix(y,x,1:3,1:3)=ormatrix(y+1,x,1:3,1:3);
                    EulerAngles(y,x,3:5)=EulerAngles(y+1,x,3:5);            
                elseif vtc(j,3)==4
                    grainmap(y,x)=grainmap(y,x-1);
                    ormatrix(y,x,1:3,1:3)=ormatrix(y,x-1,1:3,1:3);
                    EulerAngles(y,x,3:5)=EulerAngles(y,x-1,3:5);            
                end  
            end
            clear j y x;
            % koniec poprawiania zanotowanych voxeli

        end % koniec robienia dopoki cos sie zmienia
        clear vtc nvtc;

        % zablokowanie wygladzonego ziarna
        [Vy,Vx]=ind2sub(wymiary,find(grainmap==gn)); % voxele z danego ziarna
        for j=1:length(Vy)
            BlockedVoxels(Vy(j),Vx(j))=1;
        end
        clear j Vy Vx;
        % koniec blokowania wygladzonego ziarna

    end % koniec petli po ziarnach
    clear gn ChangedVoxelsTotal ChangedVoxelsTotalOld BlockedVoxels;
    % koniec petli glownej

end % koniec petli w obie strony
clear poczatek koniec krok;

% czyszczenie pamieci
clear wymiary l;

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;