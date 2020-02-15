% wygladzanie granic ziaren
% ----------
% Metoda wygladzania:
% friends<=1, iterations=do konca
% uzytecznosc: wysoka, szybka
% ----------
tic
% parametry zewnetrzne i zmienne globalne
wymiary=size(grainmap);
iterations=0;

% petla glowna
ChangedVoxelsTotalOld=-1; % voxele zmienione w poprzedniej iteracji
ChangedVoxelsTotal=0; % voxele zmienione w obecnej iteracji
ChangedVoxels=zeros(wymiary); % wszystkie zmienione voxele
while ChangedVoxelsTotalOld-ChangedVoxelsTotal~=0 % rob dopoki cos sie zmienia
    iterations=iterations+1
    ChangedVoxelsTotalOld=ChangedVoxelsTotal;
    for z=1:wymiary(3)
        for y=1:wymiary(1)
            for x=1:wymiary(2)
                if ChangedVoxels(y,x,z)==0

                    % lista sasiadow voxela
                    nearvoxels=[0 0 0 0 0 0]; %z-1,z+1,y-1,x+1,y+1,x-1
                    nfriends=0;

                    if z>1
                        if grainmap(y,x,z)==grainmap(y,x,z-1)
                            nfriends=nfriends+1;
                        else
                            nearvoxels(1)=grainmap(y,x,z-1);
                        end
                    end
                    if z<wymiary(3)
                        if grainmap(y,x,z)==grainmap(y,x,z+1)
                            nfriends=nfriends+1;
                        else
                            nearvoxels(2)=grainmap(y,x,z+1);
                        end
                    end
                    if y>1
                        if grainmap(y,x,z)==grainmap(y-1,x,z)
                            nfriends=nfriends+1;
                        else
                            nearvoxels(3)=grainmap(y-1,x,z);
                        end
                    end
                    if x<wymiary(2)
                        if grainmap(y,x,z)==grainmap(y,x+1,z)
                            nfriends=nfriends+1;
                        else
                            nearvoxels(4)=grainmap(y,x+1,z);
                        end
                    end
                    if y<wymiary(1)
                        if grainmap(y,x,z)==grainmap(y+1,x,z)
                            nfriends=nfriends+1;
                        else
                            nearvoxels(5)=grainmap(y+1,x,z);
                        end
                    end
                    if x>1
                        if grainmap(y,x,z)==grainmap(y,x-1,z)
                            nfriends=nfriends+1;
                        else
                            nearvoxels(6)=grainmap(y,x-1,z);
                        end
                    end
                    % koniec listy sasiadow voxela

                    % poprawienie wysunietego voxela
                    if nfriends<=2 % k=2 powoduje glupoty
                        ChangedVoxels(y,x,z)=1;
                        unearvoxels=unique(nonzeros(nearvoxels)); % unikatowe numery sasiadow
                        lunearvoxels=length(unearvoxels); % liczba unikatowych sasiadow

                        % wybor ziarna do wzbogacenia
                        if lunearvoxels>1 % jezeli wiecej niz jeden unikatowy sasiad
                            unearvoxels(lunearvoxels,2)=0; % poszerzenie tablicy/inicjalizacja

                            % histogram liczby sasiadow
                            for i=1:lunearvoxels % petla po unikatach
                                for j=1:6 % petla po sasiadach
                                    if unearvoxels(i,1)==nearvoxels(j)
                                        unearvoxels(i,2)=unearvoxels(i,2)+1;
                                    end % koniec petli po sasiadach
                                end % petla po unikatach
                            end
                            clear i j;
                            % koniec histogramu liczby sasiadow

                            [munearvoxels iunearvoxels]=max(unearvoxels(:,2)); % maksimum histogramu
                            grainmap(y,x,z)=unearvoxels(iunearvoxels,1); % numer ziarna do nadpisania
                            clear munearvoxels iunearvoxels;
                        else
                            grainmap(y,x,z)=unearvoxels; % numer ziarna do nadpisania
                        end
                        clear unearvoxels lunearvoxels;
                        % koniec wyboru ziarna do wzbogacenia

                        % przepisanie macierzy orientacji
                        fnearvoxels=find(nearvoxels==grainmap(y,x,z),1);
                        if fnearvoxels==1
                            ormatrix(y,x,z,1:3,1:3)=ormatrix(y,x,z-1,1:3,1:3);
                            EulerAngles(y,x,z,3:5)=EulerAngles(y,x,z-1,3:5);
                        elseif fnearvoxels==2
                            ormatrix(y,x,z,1:3,1:3)=ormatrix(y,x,z+1,1:3,1:3);
                            EulerAngles(y,x,z,3:5)=EulerAngles(y,x,z+1,3:5);
                        elseif fnearvoxels==3
                            ormatrix(y,x,z,1:3,1:3)=ormatrix(y-1,x,z,1:3,1:3);
                            EulerAngles(y,x,z,3:5)=EulerAngles(y-1,x,z,3:5);
                        elseif fnearvoxels==4
                            ormatrix(y,x,z,1:3,1:3)=ormatrix(y,x+1,z,1:3,1:3);
                            EulerAngles(y,x,z,3:5)=EulerAngles(y,x+1,z,3:5);
                        elseif fnearvoxels==5
                            ormatrix(y,x,z,1:3,1:3)=ormatrix(y+1,x,z,1:3,1:3);
                            EulerAngles(y,x,z,3:5)=EulerAngles(y+1,x,z,3:5);
                        elseif fnearvoxels==6
                            ormatrix(y,x,z,1:3,1:3)=ormatrix(y,x-1,z,1:3,1:3);
                            EulerAngles(y,x,z,3:5)=EulerAngles(y,x-1,z,3:5);
                        end
                        clear fnearvoxels;
                        % koniec przepisania macierzy orientacji 
                    end
                    % koniec poprawiania wysunietego voxela
                end
            end
        end
    end
    ChangedVoxelsTotal=nnz(ChangedVoxels);
    clear l y x z;
    clear nearvoxels nfriends;
end
% koniec petli glownej

% kasowanie zmiennych
clear wymiary; % iterations;

toc
S=load([matlabroot '\\toolbox\\matlab\\audiovideo\\splat.mat']);
sound(S.y,S.Fs);
clear S;