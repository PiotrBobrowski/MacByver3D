% wygladzanie granic ziaren: linia po linii
tic

% parametry zewnetrzne i zmienne globalne
wymiary=size(grainmap);
ChangedPixels=0;

% petla glowna
for y=1:wymiary(1)
    for x=1:wymiary(2)
        
        % lista sasiadow piksela
        nearpixels=[0 0 0 0];
        nfriends=0;
        
        if y>1
            if grainmap(y,x)==grainmap(y-1,x)
                nfriends=nfriends+1;
            else
                nearpixels(1)=grainmap(y-1,x);
            end
        end
        if x<wymiary(2)
            if grainmap(y,x)==grainmap(y,x+1)
                nfriends=nfriends+1;
            else
                nearpixels(2)=grainmap(y,x+1);
            end
        end
        if y<wymiary(1)
            if grainmap(y,x)==grainmap(y+1,x)
                nfriends=nfriends+1;
            else
                nearpixels(3)=grainmap(y+1,x);
            end
        end
        if x>1
            if grainmap(y,x)==grainmap(y,x-1)
                nfriends=nfriends+1;
            else
                nearpixels(4)=grainmap(y,x-1);
            end
        end
        % koniec listy sasiadow piksela
        
        % poprawienie wysunietego piksela
        if nfriends<=1
            ChangedPixels=ChangedPixels+1;
            unearpixels=unique(nonzeros(nearpixels)); % unikatowe numery sasiadow
            lunearpixels=length(unearpixels); % liczba unikatowych sasiadow
            if lunearpixels==1
                grainmap(y,x)=unearpixels; % numer ziarna do nadpisania
            else
                unearpixels(lunearpixels,2)=0; % poszerzenie tablicy/inicjalizacja
                
                % histogram liczby sasiadow
                for i=1:lunearpixels
                    for j=1:4
                        if nearpixels(j)==unearpixels(i,1)
                            unearpixels(i,2)=unearpixels(i,2)+1;
                        end
                    end
                end
                clear i j;
                % koniec histogramu liczby sasiadow
                
                [munearpixels iunearpixels]=max(unearpixels(:,2)); % maksimum histogramu
                grainmap(y,x)=unearpixels(iunearpixels,1); % numer ziarna do nadpisania
                clear munearpixels iunearpixels;
            end
            clear unearpixels lunearpixels;
            
            % przepisanie macierzy orientacji
            fnearpixels=find(nearpixels==grainmap(y,x),1); 
            if fnearpixels==1
                ormatrix(y,x,1:3,1:3)=ormatrix(y-1,x,1:3,1:3);
                EulerAngles(y,x,3:5)=EulerAngles(y-1,x,3:5);
            elseif fnearpixels==2
                ormatrix(y,x,1:3,1:3)=ormatrix(y,x+1,1:3,1:3);
                EulerAngles(y,x,3:5)=EulerAngles(y,x+1,3:5);
            elseif fnearpixels==3
                ormatrix(y,x,1:3,1:3)=ormatrix(y+1,x,1:3,1:3);
                EulerAngles(y,x,3:5)=EulerAngles(y+1,x,3:5);
            else
                ormatrix(y,x,1:3,1:3)=ormatrix(y,x-1,1:3,1:3);
                EulerAngles(y,x,3:5)=EulerAngles(y,x-1,3:5);
            end
            clear fnearpixels;
            % koniec przepisania macierzy orientacji 
        end
    end
end
clear nearpixels nfriends;
clear wymiary y x;
% koniec petli glownej

toc
S=load('C:\\Program Files\\MATLAB\\toolbox\\matlab\\audiovideo\\splat.mat');
sound(S.y,S.Fs);
clear S;