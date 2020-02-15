% create border faces

% clear old data
if exist('boundaryfaces','var')
    clear boundaryfaces;
end
% end clear old data

% create list of neighboring grains
if ~(exist('Neighbors','var') && isfield(Neighbors,'Pairs'))
    P03Neighbors;
end
NLg=Neighbors.Pairs; % load data
sNLg=size(NLg);
% end create list of neighboring grains

% create uniform list of all edges

    % convert BL.L3 to BLL3
    L3g=boundarylines.L3.grainno; % load data
    L3p=boundarylines.L3.points; % load data
    sL3=size(L3g);
    BLL3=zeros(3*sL3(1),8,'uint32'); % structure: L(t,n),g1,g2,P1(t,n),P2(t,n)
    nBLL3=0;

    for i=1:sL3 % loop on L3 lines

        % 1. line
        nBLL3=nBLL3+1;
        BLL3(nBLL3,1:2)=[3 i]; % line: type and number
        BLL3(nBLL3,3:4)=L3g(i,1:2); % grain numbers
        BLL3(nBLL3,5:8)=L3p(i,1:4); % points: types and numbers

        % 2. line
        nBLL3=nBLL3+1;
        BLL3(nBLL3,1:2)=[3 i]; % line: type and number
        BLL3(nBLL3,3:4)=[L3g(i,1) L3g(i,3)]; % grain numbers
        BLL3(nBLL3,5:8)=L3p(i,1:4); % points: types and numbers

        % 3. line
        nBLL3=nBLL3+1;
        BLL3(nBLL3,1:2)=[3 i]; % line: type and number
        BLL3(nBLL3,3:4)=L3g(i,2:3); % grain numbers
        BLL3(nBLL3,5:8)=L3p(i,1:4); % points: types and numbers

    end % end loop on L3 lines
    clear i L3g L3p sL3 nBLL3;
    % end convert BL.L3 to BLL3

    % convert BL.L2 to BLL2
    ROInames=['ymin'; 'ymax'; 'xmin'; 'xmax'; 'zmin'; 'zmax'];
    BLL2=zeros(1000,8,'uint32'); % structure: L(t,n),g1,g2,P1(t,n),P2(t,n)
    nBLL2=0;
    for layer=1:6 % loop on ROI edges
        L2g=boundarylines.L2.(ROInames(layer,1:4)).grainno;
        L2p=boundarylines.L2.(ROInames(layer,1:4)).points;
        sL2=size(L2g);
        for i=1:sL2(1) % loop on L2 lines on one ROI edge
            nBLL2=nBLL2+1;
            BLL2(nBLL2,1:2)=[20+layer i]; % line: type and number
            BLL2(nBLL2,3:4)=L2g(i,1:2); % grain numbers
            BLL2(nBLL2,5:8)=L2p(i,1:4); % points: types and numbers
        end % end loop on L2 lines on one ROI edge
    end % end loop on ROI edges
    if nBLL2<1000
        BLL2(nBLL2+1:1000,:)=[];
    end
    clear layer i ROInames L2g L2p sL2 nBLL2;
    % end convert BL.L2 to BLL2

    % merge BLL3 and BLL2
    BLL3=[BLL3; BLL2];
    clear BLL2;
    % end merge BLL3 and BLL2

    % convert BL.L4 to BLL4
    % ----------
    % BL.L4.GN CAN BE CONVERTED INTO 6 PAIRS OF GRAINS,
    % BUT ONLY 4 OF THEM ARE REAL AND THE OTHER 2 ARE ARTIFICIAL
    % THUS BLL4 IS A SEPARATE LIST USED ONLY WHEN NEEDED
    % ----------
    if isfield(boundarylines,'L4')

        L4g=boundarylines.L4.grainno; % load data
        L4p=boundarylines.L4.points; % load data
        sL4g=size(L4g);
        BLL4=zeros(6*sL4g(1),8,'uint32'); % structure: L(t,n),g1,g2,P1(t,n),P2(t,n)
        nBLL4=0;
            
        for i=1:sL4g

            % 1. line
            nBLL4=nBLL4+1;
            BLL4(nBLL4,1:2)=[4 i]; % line: type and number
            BLL4(nBLL4,3:4)=L4g(i,1:2); % grain numbers
            BLL4(nBLL4,5:8)=L4p(i,1:4); % points: types and numbers

            % 2. line
            nBLL4=nBLL4+1;
            BLL4(nBLL4,1:2)=[4 i]; % line: type and number
            BLL4(nBLL4,3:4)=[L4g(i,1) L4g(i,3)]; % grain numbers
            BLL4(nBLL4,5:8)=L4p(i,1:4); % points: types and numbers

            % 3. line
            nBLL4=nBLL4+1;
            BLL4(nBLL4,1:2)=[4 i]; % line: type and number
            BLL4(nBLL4,3:4)=[L4g(i,1) L4g(i,4)]; % grain numbers
            BLL4(nBLL4,5:8)=L4p(i,1:4); % points: types and numbers

            % 4. line
            nBLL4=nBLL4+1;
            BLL4(nBLL4,1:2)=[4 i]; % line: type and number
            BLL4(nBLL4,3:4)=L4g(i,2:3); % grain numbers
            BLL4(nBLL4,5:8)=L4p(i,1:4); % points: types and numbers

            % 5. line
            nBLL4=nBLL4+1;
            BLL4(nBLL4,1:2)=[4 i]; % line: type and number
            BLL4(nBLL4,3:4)=[L4g(i,2) L4g(i,4)]; % grain numbers
            BLL4(nBLL4,5:8)=L4p(i,1:4); % points: types and numbers

            % 6. line
            nBLL4=nBLL4+1;
            BLL4(nBLL4,1:2)=[4 i]; % line: type and number
            BLL4(nBLL4,3:4)=L4g(i,3:4); % grain numbers
            BLL4(nBLL4,5:8)=L4p(i,1:4); % points: types and numbers

        end
        clear i L4g L4p sL4g nBLL4;
        
    else
        BLL4=[];
    end
    % end convert BL.L4 to BLL4
    
% end create uniform list of all edges

% create list of Closed Loops

    % initialization
    CLg=zeros(sNLg(1),3,'uint32'); % Closed Loops grain numbers: neigh numb,g1,g2
    CLl=zeros(sNLg(1),20,'uint32'); % Closed Loops lines: L(t,n),...
    nCLl=zeros(sNLg(1),1,'uint32'); % number of lines in CLl
    CLp=zeros(sNLg(1),10,'uint32'); % Closed Loops points: P(t,n),...
    nCLp=zeros(sNLg(1),1,'uint32'); % number of points in CLp
    nCL=0; % number of loops on the list
    Err3=[0 0 0]; % error list: i,g1,g2
    nErr3=0;
    % end initialization

for i=1:sNLg(1) % loop on all boundaries
    clc; disp(i); % running check

    fBLL3=find(BLL3(:,3)==NLg(i,1) & BLL3(:,4)==NLg(i,2)); % find L3 lines
    lfBLL3=length(fBLL3); % get how many L3 lines were found

    if lfBLL3>0 % some L3 lines were found
        
        % create list of L3 lines surrounding given boundary
        for j=1:lfBLL3 % loop on found lines
            fBLL3(j,1:8)=BLL3(fBLL3(j,1),1:8); % L(t,n),g1,g2,P1(t,n),P2(t,n)
        end % end loop on found lines
        clear j;
        % end create list of L3 lines surrounding given boundary

        % sort lines surrounding given boundary
        while ~isempty(fBLL3) % loop for sorting the lines around given boundary
            sfBLL3=size(fBLL3);
            fBLLsorted=zeros(sfBLL3(1),8,'uint32'); % L(t,n),g1,g2,P1(t,n),P2(t,n)
            fBLLpoints=zeros(sfBLL3(1),2,'uint32'); % P1 or P2 (t,n)
            nfBLLsorted=0;
            beginning(1:2)=fBLL3(1,5:6); % get point to begin the loop
            position(1:2)=fBLL3(1,5:6); % get current position
            
            wykonuj=true; % loop execution control
            while wykonuj % 2nd loop for sorting
                change=false; % mark succesful iteration

                % search fBLL3 for a step
                sfBLL3=size(fBLL3);
                for j=1:sfBLL3(1)
                    if (fBLL3(j,5)==position(1) && fBLL3(j,6)==position(2))
                        nfBLLsorted=nfBLLsorted+1;
                        fBLLsorted(nfBLLsorted,1:8)=fBLL3(j,1:8); % save the line
                        fBLLpoints(nfBLLsorted,1:2)=fBLL3(j,5:6); % save the point
                        position(1:2)=fBLL3(j,7:8); % make a step
                        fBLL3(j,1:8)=[0 0 0 0 0 0 0 0]; % zero the used line
                        change=true; % mark succesful iteration
                    elseif (fBLL3(j,7)==position(1) && fBLL3(j,8)==position(2))
                        nfBLLsorted=nfBLLsorted+1;
                        fBLLsorted(nfBLLsorted,1:8)=fBLL3(j,1:8); % save the line
                        fBLLpoints(nfBLLsorted,1:2)=fBLL3(j,7:8); % save the point
                        position(1:2)=fBLL3(j,5:6); % make a step
                        fBLL3(j,1:8)=[0 0 0 0 0 0 0 0]; % zero the used line
                        change=true; % mark succesful iteration
                    end
                end
                clear j;
                % end search fBLL3 for a step

                % search BLL4 for a missing step
                if change==false

                    fBLL4=find(BLL4(:,3)==NLg(i,1) & BLL4(:,4)==NLg(i,2)); % find L4 lines
                    lfBLL4=length(fBLL4); % get how many L4 lines were found

                    if lfBLL4>0 % some L4 lines were found

                        % create list of L4 lines surrounding given boundary
                        for j=1:lfBLL4 % loop on found lines
                            fBLL4(j,1:8)=BLL4(fBLL4(j,1),1:8); % L(t,n),g1,g2,P1(t,n),P2(t,n)
                        end % end loop on found lines
                        % end create list of L4 lines surrounding given boundary
                            
                        % search fBLL4 for a missing step
                        for j=1:lfBLL4
                            if (fBLL4(j,5)==position(1) && fBLL4(j,6)==position(2))
                                nfBLLsorted=nfBLLsorted+1;
                                fBLLsorted(nfBLLsorted,1:8)=fBLL4(j,1:8); % save the line
                                fBLLpoints(nfBLLsorted,1:2)=fBLL4(j,5:6); % save the point
                                position(1:2)=fBLL4(j,7:8); % make a step
                                fBLL4(j,1:8)=[0 0 0 0 0 0 0 0]; % zero the used line
                                change=true; % mark succesful iteration
                            elseif (fBLL4(j,7)==position(1) && fBLL4(j,8)==position(2))
                                nfBLLsorted=nfBLLsorted+1;
                                fBLLsorted(nfBLLsorted,1:8)=fBLL4(j,1:8); % save the line
                                fBLLpoints(nfBLLsorted,1:2)=fBLL4(j,7:8); % save the point
                                position(1:2)=fBLL4(j,5:6); % make a step
                                fBLL4(j,1:8)=[0 0 0 0 0 0 0 0]; % zero the used line
                                change=true; % mark succesful iteration
                            end
                        end
                        clear j fBLL4 lfBLL4;
                        % end search fBLL4 for a missing step

                    end
                end
                % end search BLL4 for a missing step

                % Closed Loop check
                if (position(1)==beginning(1) && position(2)==beginning(2)) % success
                    wykonuj=false; % end the loop

                    % save Closed Loop
                    nCL=nCL+1; % CL count
                    CLg(nCL,1:3)=[i NLg(i,1:2)]; % save CL grain numbers
                    nCLl(nCL)=nfBLLsorted; % save number of CL lines
                    nCLp(nCL)=nfBLLsorted; % save number of CL lines

                    for j=1:nfBLLsorted
                        CLl(nCL,2*j-1:2*j)=fBLLsorted(j,1:2); % save CL lines
                        CLp(nCL,2*j-1:2*j)=fBLLpoints(j,1:2); % save CL points
                    end
                    clear j;
                    % end save Closed Loop

                    % clear used lines
                    for j=sfBLL3(1):-1:1
                        if fBLL3(j,1)==0
                            fBLL3(j,:)=[];
                        end
                    end
                    clear j sfBLL3;
                    % end clear used lines

                elseif change==false
                    wykonuj=false; % end the loop                    
                    nErr3=nErr3+1;
                    Err3(nErr3,1:3)=[i NLg(i,1) NLg(i,2)];
                    
                    % clear used lines
                    for j=sfBLL3(1):-1:1
                        if fBLL3(j,1)==0
                            fBLL3(j,:)=[];
                        end
                    end
                    clear j sfBLL3;
                    % end clear used lines

                end
                % end Closed Loop check
                
            end % end 2nd loop for sorting
            clear wykonuj change;
        end  % end loop for sorting the lines around given boundary
        clear sfBLL3 fBLLsorted fBLLpoints nfBLLsorted beginning position;
        % end sort lines surrounding given boundary
        
    else % no L3 lines were found
        nErr3=nErr3+1;
        Err3(nErr3,1:3)=[i NLg(i,1) NLg(i,2)];
    end % end some L3 lines were found

end % end loop on all boundaries
clear i fBLL3 lfBLL3;
% create list of Closed Loops

% create list of P32 points on each boundary
P32g=boundarypoints.P32.grainno; % load data
P33g=boundarypoints.P33.grainno; % load data
NLP32=zeros(sNLg(1),1000,'uint32'); % initialization: list of P32 points on all boundaries
nNLP32=zeros(sNLg(1),1,'uint32'); % initialization: number of P32 points in each row of NLP32
NLP33=zeros(sNLg(1),10,'uint32'); % initialization: list of P33 points on some boundaries
nNLP33=zeros(sNLg(1),1,'uint32'); % initialization: number of P33 points in each row of NLP33

for i=1:sNLg(1) % loop on all boundaries

    fP32g=find(P32g(:,1)==NLg(i,1) & P32g(:,2)==NLg(i,2)); % find P32 points
    lfP32g=length(fP32g); % get how many points were found

    if lfP32g>0 % some P32 points were found

        nNLP32(i)=lfP32g; % save number of P32 points in the row
        NLP32(i,1:nNLP32(i))=fP32g(1:nNLP32(i)); % save the points

    else % no P32 points were found

        % find P33 points
        f12P33g=find(P33g(:,1)==NLg(i,1) & P33g(:,2)==NLg(i,2));
        f13P33g=find(P33g(:,1)==NLg(i,1) & P33g(:,3)==NLg(i,2));
        f23P33g=find(P33g(:,2)==NLg(i,1) & P33g(:,3)==NLg(i,2));
        fP33g=union(f23P33g,union(f12P33g,f13P33g));
        clear f12P33g f13P33g f23P33g;
        % end find P33 points

        lfP33g=length(fP33g);
        if lfP33g>0 % some P33 points were found
            nNLP33(i)=lfP33g; % save the number of P33 points in the row
            NLP33(i,1:nNLP33(i))=fP33g(1:nNLP33(i)); % save the points
        else
            disp('no P33 were found');
        end
        
    end

end % end loop on all boundaries
clear i P32g fP32g lfP32g P33g fP33g lfP33g;
% end create list of P32 points on each boundary

% initialize list of triangles
sBLL3=size(BLL3);
F32g=zeros(sBLL3(1),2,'uint32'); % surface lines grain numbers: g1,g2
F32p=zeros(sBLL3(1),4,'uint32'); % surface lines point types: P1(t1,n1),P2(t2,n2)
nF32=0;
T3g=zeros(sBLL3(1),2,'uint32'); % triangles grain numbers: g1,g2
T3l=zeros(sBLL3(1),6,'uint32'); % triangles lines: L1(t,n),L2(t,n),L3(t,n)
T3p=zeros(sBLL3(1),6,'uint32'); % triangles points: P1(t,n),P2(t,n),P3(t,n)
nT3=0;
clear sBLL3;
% end initialize list of triangles

% create list of mean points
wymiary=size(grainmap);
P32c=boundarypoints.P32.coord; % load data
P33c=boundarypoints.P33.coord; % load data
CLa=zeros(nCL,2,'uint32'); % average point for Closed Loops
for i=1:nCL % loop on Closed Loops
    if nCLp(i)>3 % Closed Loop requires finding mean point

        % get mean Loop points coordinates
        yxz=zeros(nCLp(i),3,'uint32'); % initialization
        for j=1:nCLp(i) % loop on lines in Closed Loop
            if CLp(i,2*j-1)==34
                yxz(j,1:3)=boundarypoints.P34.coord(CLp(i,2*j),1:3);
            elseif CLp(i,2*j-1)==23
                yxz(j,1:3)=boundarypoints.P23.coord(CLp(i,2*j),1:3);
            elseif CLp(i,2*j-1)==12
                yxz(j,1:3)=boundarypoints.P12.coord(CLp(i,2*j),1:3);
            elseif CLp(i,2*j-1)==38
                yxz(j,1:3)=boundarypoints.P38.coord(CLp(i,2*j),1:3);
            elseif CLp(i,2*j-1)==24
                yxz(j,1:3)=boundarypoints.P24.coord(CLp(i,2*j),1:3);
            end
        end % end loop on lines in Closed Loop
        meanyxz=uint32(round(mean(yxz)));
        clear j yxz;
        % end get mean Loop points coordinates
                
        % find nearest point
        if nNLP32(CLg(i,1))>0 % find P32 point

            % search for nearest P32 point
            radius=0; % search radius
            while radius<=5 % loop for search in radius

                % define search zone
                ymin=meanyxz(1)-radius;
                ymax=meanyxz(1)+radius;
                xmin=meanyxz(2)-radius;
                xmax=meanyxz(2)+radius;
                zmin=meanyxz(3)-radius;
                zmax=meanyxz(3)+radius;
                if ymin<0 % protection from exiting ROI
                    ymin=0;
                end
                if xmin<0
                    xmin=0;
                end
                if zmin<0
                    zmin=0;
                end
                if ymax>wymiary(1)
                    ymax=wymiary(1);
                end
                if xmax>wymiary(2)
                    xmax=wymiary(2);
                end
                if zmax>wymiary(3)
                    zmax=wymiary(3);
                end
                % end define search zone
                
                % search for the first good point
                for j=1:nNLP32(CLg(i,1)) % loop on NLP32 points
                    if (P32c(NLP32(CLg(i,1),j),1)>=ymin && P32c(NLP32(CLg(i,1),j),1)<=ymax)
                        if (P32c(NLP32(CLg(i,1),j),2)>=xmin && P32c(NLP32(CLg(i,1),j),2)<=xmax)
                            if (P32c(NLP32(CLg(i,1),j),3)>=zmin && P32c(NLP32(CLg(i,1),j),3)<=zmax)
                                CLa(i,1:2)=[32 NLP32(CLg(i,1),j)]; % save the average P32 point
                                radius=50; % set radius beyond limit to break the loop
                                break; % break the loop on P32 points
                            end
                        end
                    end
                end % end loop on NLP32 points
                clear j;
                % end search for the first good point

                radius=radius+1; % increase search radius
            end % end loop for search in radius
            % end search for nearest P32 point

        elseif nNLP33(i)>0 % find P33 point

            % search for nearest P33 point
            radius=0; % search radius
            while radius<=5 % loop for search in radius

                % define search zone
                ymin=meanyxz(1)-radius;
                ymax=meanyxz(1)+radius;
                xmin=meanyxz(2)-radius;
                xmax=meanyxz(2)+radius;
                zmin=meanyxz(3)-radius;
                zmax=meanyxz(3)+radius;
                if ymin<0 % protection from exiting ROI
                    ymin=0;
                end
                if xmin<0
                    xmin=0;
                end
                if zmin<0
                    zmin=0;
                end
                if ymax>wymiary(1)
                    ymax=wymiary(1);
                end
                if xmax>wymiary(2)
                    xmax=wymiary(2);
                end
                if zmax>wymiary(3)
                    zmax=wymiary(3);
                end
                % end define search zone
                
                % search for the first good point
                for j=1:nNLP33(CLg(i)) % loop on NLP33 points
                    if (P33c(NLP33(CLg(i),j),1)>=ymin && P33c(NLP33(CLg(i),j),1)<=ymax)
                        if (P33c(NLP33(CLg(i),j),2)>=xmin && P33c(NLP33(CLg(i),j),2)<=xmax)
                            if (P33c(NLP33(CLg(i),j),3)>=zmin && P33c(NLP33(CLg(i),j),3)<=zmax)
                                CLa(i,1:2)=[33 NLP33(CLg(i),j)]; % save the average P33 point
                                radius=50; % set radius beyond limit to break the loop
                                break; % break the loop on P33 points
                            end
                        end
                    end
                end % end loop on NLP33 points
                clear j;
                % end search for the first good point

                radius=radius+1; % increase search radius
            end % end loop for search in radius
            % end search for nearest P33 point

        else
            nErr3=nErr3+1;
            Err3(nErr3,1:3)=CLg(i,1:3);
        end
        clear radius ymin ymax xmin xmax zmin zmax;
        % end find nearest point

    elseif nCLl(i)==3 % create triangle immediately
        
        % create triangle
        nT3=nT3+1;
        T3g(nT3,1:2)=CLg(i,2:3); % save triangle grain numbers
        T3p(nT3,1:6)=CLp(i,1:6); % save triangle points
        T3l(nT3,1:6)=CLl(i,1:6); % save triangle lines
        % end create triangle
        
    else
        nErr3=nErr3+1;
        Err3(nErr3,1:3)=[i CLg(i,2) CLg(i,3)];
    end
end % end loop on Closed Loops
clear i j P32c P33c meanyxz; % end loop on Closed Loops
% end create list of mean points

% create F32 lines and T3 triangles for points on Closed Loops
for i=1:nCL % loop on Closed Loops

    if CLa(i,1)~=0 % check if mean point was found
        F32l=zeros(nCLp(i),1,'uint32'); % array to store F32 line numbers

        % ----------
        % there are 2 loops on nCLp because prior to triangle creation
        % both F32 lines (j and j+1) have to exist
        % ----------

        % create F32 lines
        for j=1:nCLp(i) % loop on points in Closed Loop
            nF32=nF32+1;
            F32g(nF32,1:2)=CLg(i,2:3); % save F32 line grain numbers
            F32p(nF32,1:4)=[CLp(i,2*j-1:2*j) CLa(i,1:2)]; % save F32 line points
            F32l(j)=nF32;
        end % end loop on points in Closed Loop
        % end create F32 lines

        % create T3 triangles
        for j=1:nCLp(i)-1 % loop on points in Closed Loop
            nT3=nT3+1;
            k=2*j;
            T3g(nT3,1:2)=CLg(i,2:3); % save T3 triangle grain numbers
            T3p(nT3,1:6)=[CLp(i,k-1:k) CLp(i,k+1:k+2) CLa(i,1:2)]; % save points
            T3l(nT3,1:6)=[CLl(i,k-1:k) 32 F32l(j) 32 F32l(j+1)]; % save lines
        end  % loop on points in Closed Loop
        
            % save the last triangle of the Closed Loop
            k=2*(j+1);
            nT3=nT3+1;
            T3g(nT3,1:2)=CLg(i,2:3); % save T3 triangle grain numbers
            T3p(nT3,1:6)=[CLp(i,k-1:k) CLp(i,1:2) CLa(i,1:2)]; % save points
            T3l(nT3,1:6)=[CLl(i,k-1:k) 32 F32l(1) 32 F32l(j+1)]; % save lines
            % end save the last triangle of the Closed Loop

        % end create T3 triangles

    end % end check if mean point was found

end % end loop on Closed Loops
clear i j k;

    % clear excess zeros
    sF32=size(F32g);
    if nF32<sF32(1)
        F32g(nF32+1:sF32(1),:)=[];
        F32p(nF32+1:sF32(1),:)=[];
    end

    sT3=size(T3g);
    if nT3<sT3(1)
        T3g(nT3+1:sT3(1),:)=[];
        T3p(nT3+1:sT3(1),:)=[];
        T3l(nT3+1:sT3(1),:)=[];
    end
    clear sF32 sT3;
    % end clear excess zeros

% end create F32 lines and T3 triangles for points on Closed Loops

% save the data
boundaryfaces.T3.grainno=T3g;
boundaryfaces.T3.points=T3p;
boundaryfaces.T3.lines=T3l;
if nErr3>0
    boundaryfaces.Err3=Err3;
end
clear T3g T3p T3l nT3 Err3 nErr3;
boundarylines.F32.grainno=F32g;
boundarylines.F32.points=F32p;
clear F32g F32p F32l nF32;
% end save the data

clear BLL3 BLL4 wymiary;
clear CLg CLp CLl CLa nCL nCLp nCLl;
clear NLg NLP32 NLP33 sNLg nNLP32 nNLP33;
% end create F32 lines and T3 triangles for points on Closed Loops

% create uniform BLL1 list of L1 lines
sL1=size(boundarylines.L1.grainno);
BLL1=zeros(sL1(1),13,'uint32'); % initialization: L(t,n),gn,P1(t,n),P2(t,n),P1(y,x,z),P2(y,x,z)
for i=1:sL1(1)
    BLL1(i,1:3)=[1 i boundarylines.L1.grainno(i)]; % get L(t,n) and gn
    BLL1(i,4:7)=boundarylines.L1.points(i,1:4); % get P1(t,n),P2(t,n)
    if BLL1(i,4)==12
        BLL1(i,8:10)=boundarypoints.P12.coord(BLL1(i,5),1:3);
    elseif BLL1(i,4)==10
        BLL1(i,8:10)=boundarypoints.P10.coord(BLL1(i,5),1:3);
    end
    if BLL1(i,6)==12
        BLL1(i,11:13)=boundarypoints.P12.coord(BLL1(i,7),1:3);
    elseif BLL1(i,6)==10
        BLL1(i,11:13)=boundarypoints.P10.coord(BLL1(i,7),1:3);
    end
end
clear i sL1;
% end create uniform BLL1 list of L1 lines

% create list of Closed Loops
wymiary=size(grainmap);

        % initialization
        CLg=zeros(1000,2,'uint32'); % Closed Loops grain numbers: loop numb,gn
        CLl=zeros(1000,20,'uint32'); % Closed Loops lines: L(t,n),...
        nCLl=zeros(1000,1,'uint32'); % number of lines in CLl
        CLp=zeros(1000,20,'uint32'); % Closed Loops points: P(t,n),...
        nCLp=zeros(1000,1,'uint32'); % number of points in CLp
        nCL=0; % number of loops on the list
        Err2=[0 0 0]; % error list: layer,i,g1
        nErr2=0; % number of errors
        % end initialization

for layer=1:6 % loop on ROI borders
    
    % load data
    if layer==1
        uGM=unique(grainmap(1,1:wymiary(2),1:wymiary(3))); % get grain numbers on ROI
        L2g=boundarylines.L2.ymin.grainno; % get L2 grain numbers
        L2p=boundarylines.L2.ymin.points; % get L2 points
        fBLL1=find(BLL1(:,8)==0 & BLL1(:,11)==0); % get L1 lines
    elseif layer==2
        uGM=unique(grainmap(wymiary(1),1:wymiary(2),1:wymiary(3))); % get grain numbers on ROI
        L2g=boundarylines.L2.ymax.grainno; % get L2 grain numbers
        L2p=boundarylines.L2.ymax.points; % get L2 points
        fBLL1=find(BLL1(:,8)==wymiary(1) & BLL1(:,11)==wymiary(1)); % get L1 lines
    elseif layer==3
        uGM=unique(grainmap(1:wymiary(1),1,1:wymiary(3))); % get grain numbers on ROI
        L2g=boundarylines.L2.xmin.grainno; % get L2 grain numbers
        L2p=boundarylines.L2.xmin.points; % get L2 points
        fBLL1=find(BLL1(:,9)==0 & BLL1(:,12)==0); % get L1 lines
    elseif layer==4
        uGM=unique(grainmap(1:wymiary(1),wymiary(2),1:wymiary(3))); % get grain numbers on ROI
        L2g=boundarylines.L2.xmax.grainno; % get L2 grain numbers
        L2p=boundarylines.L2.xmax.points; % get L2 points
        fBLL1=find(BLL1(:,9)==wymiary(2) & BLL1(:,12)==wymiary(2)); % get L1 lines
    elseif layer==5
        uGM=unique(grainmap(1:wymiary(1),1:wymiary(2),1)); % get grain numbers on ROI
        L2g=boundarylines.L2.zmin.grainno; % get L2 grain numbers
        L2p=boundarylines.L2.zmin.points; % get L2 points
        fBLL1=find(BLL1(:,10)==0 & BLL1(:,13)==0); % get L1 lines
    else
        uGM=unique(grainmap(1:wymiary(1),1:wymiary(2),wymiary(3))); % get grain numbers on ROI
        L2g=boundarylines.L2.zmax.grainno; % get L2 grain numbers
        L2p=boundarylines.L2.zmax.points; % get L2 points
        fBLL1=find(BLL1(:,10)==wymiary(3) & BLL1(:,13)==wymiary(3)); % get L1 lines
    end
    % end load data

    % create uniform list of all edges on a ROI border

        % convert L2 to BLL2
        sL2=size(L2g);
        BLL2=zeros(2*sL2(1),7,'uint32');
        nBLL2=0;
        for i=1:sL2(1) % loop on lines on a ROI border

            % 1 line
            nBLL2=nBLL2+1;
            BLL2(nBLL2,1:3)=[2 i L2g(i,1)]; % get L(t,n) and gn
            BLL2(nBLL2,4:7)=L2p(i,1:4); % get P1(t,n),P2(t,n)

            % 2 line
            nBLL2=nBLL2+1;
            BLL2(nBLL2,1:3)=[2 i L2g(i,2)]; % get L(t,n) and gn
            BLL2(nBLL2,4:7)=L2p(i,1:4); % get P1(t,n),P2(t,n)

        end % end loop on lines on a ROI border
        clear i L2g L2p sL2;
        % end convert L2 to BLL2

        % add L1 to BLL2
        lfBLL1=length(fBLL1);
        for i=1:lfBLL1
            nBLL2=nBLL2+1;
            BLL2(nBLL2,1:7)=BLL1(fBLL1(i),1:7);
        end
        clear i lfBLL1 fBLL1 nBLL2;
        % end add L1 to BLL2

    % end create uniform list of all edges on a ROI border

    % create list of Closed Loops


    luGM=length(uGM); % number of grains on the ROI border
    for i=1:luGM

        fBLL2=find(BLL2(:,3)==uGM(i)); % find L2 lines
        lfBLL2=length(fBLL2); % get how many L2 lines were found

        if lfBLL2>0 % some L2 lines were found

            % create list of L2 lines surrounding given boundary
            for j=1:lfBLL2 % loop on found lines
                fBLL2(j,1:7)=BLL2(fBLL2(j,1),1:7); % L(t,n),gn,P1(t,n),P2(t,n)
            end % end loop on found lines
            clear j;
            % end create list of L2 lines surrounding given boundary

            % sort lines surrounding given boundary
            while ~isempty(fBLL2) % loop for sorting the lines around given boundary
                sfBLL2=size(fBLL2);
                fBLLsorted=zeros(sfBLL2(1),7,'uint32'); % L(t,n),gn,P1(t,n),P2(t,n)
                fBLLpoints=zeros(sfBLL2(1),2,'uint32'); % P1 or P2 (t,n)
                nfBLLsorted=0;
                beginning(1:2)=fBLL2(1,4:5); % get point to begin the loop
                position(1:2)=fBLL2(1,4:5); % get current position

                wykonuj=true; % loop execution control
                while wykonuj % inner loop for sorting the lines
                    change=false; % mark succesful iteration

                    % search fBLL2 for a step
                    sfBLL2=size(fBLL2);
                    for j=1:sfBLL2(1)
                        if (fBLL2(j,4)==position(1) && fBLL2(j,5)==position(2))
                            nfBLLsorted=nfBLLsorted+1;
                            fBLLsorted(nfBLLsorted,1:7)=fBLL2(j,1:7); % save the line
                            fBLLpoints(nfBLLsorted,1:2)=fBLL2(j,4:5); % save the point
                            position(1:2)=fBLL2(j,6:7); % make a step
                            fBLL2(j,1:7)=[0 0 0 0 0 0 0]; % zero the used line
                            change=true; % mark succesful iteration
                        elseif (fBLL2(j,6)==position(1) && fBLL2(j,7)==position(2))
                            nfBLLsorted=nfBLLsorted+1;
                            fBLLsorted(nfBLLsorted,1:7)=fBLL2(j,1:7); % save the line
                            fBLLpoints(nfBLLsorted,1:2)=fBLL2(j,6:7); % save the point
                            position(1:2)=fBLL2(j,4:5); % make a step
                            fBLL2(j,1:7)=[0 0 0 0 0 0 0]; % zero the used line
                            change=true; % mark succesful iteration
                        end
                    end
                    clear j;
                    % end search fBLL2 for a step
                    
                    % Closed Loop check
                    if (position(1)==beginning(1) && position(2)==beginning(2)) % success
                        wykonuj=false; % end the loop

                        % save Closed Loop
                        nCL=nCL+1; % CL count
                        CLg(nCL,1:2)=[i uGM(i)]; % save CL grain number
                        nCLl(nCL)=nfBLLsorted; % save number of CL lines
                        nCLp(nCL)=nfBLLsorted; % save number of CL lines

                        for j=1:nfBLLsorted
                            CLl(nCL,2*j-1:2*j)=fBLLsorted(j,1:2); % save CL lines
                            CLp(nCL,2*j-1:2*j)=fBLLpoints(j,1:2); % save CL points
                        end
                        clear j;
                        % end save Closed Loop

                        % clear used lines
                        for j=sfBLL2(1):-1:1
                            if fBLL2(j,1)==0
                                fBLL2(j,:)=[];
                            end
                        end
                        clear j sfBLL2;
                        % end clear used lines

                    elseif change==false
                        wykonuj=false; % end the loop                    
                        nErr2=nErr2+1;
                        Err2(nErr2,1:3)=[layer i uGM(i)];

                        % clear used lines
                        for j=sfBLL2(1):-1:1
                            if fBLL2(j,1)==0
                                fBLL2(j,:)=[];
                            end
                        end
                        clear j sfBLL2;
                        % end clear used lines

                    end
                    % end Closed Loop check

                end % end inner loop for sorting lines
                clear wykonuj change;
            end  % end loop for sorting the lines around given boundary
            clear sfBLL2 fBLLsorted fBLLpoints nfBLLsorted beginning position;
            % end sort lines surrounding given boundary

        else % no L2 lines were found
            nErr2=nErr2+1;
            Err2(nErr2,1:3)=[layer i uGM(i)];
        end % end some L2 lines were found            
    end
    clear i fBLL2 lfBLL2 uGM luGM;
    % end create list of Closed Loops  

end % end loop on ROI borders
clear layer;

    % remove excess zeros
    if nCL<1000
        CLg(nCL+1:1000,:)=[];
        CLl(nCL+1:1000,:)=[];
        CLp(nCL+1:1000,:)=[];
        nCLl(nCL+1:1000)=[];
        nCLp(nCL+1:1000)=[];
    end
    % end remove excess zeros

% end create list of Closed Loops

% initialize list of triangles
A21g=zeros(nCL,1,'uint32'); % average points: gn
A21c=zeros(nCL,3,'uint32'); % average points: y,x,z
nA21=0;
F20g=zeros(1000,1,'uint32'); % surface lines grain number: gn
F20p=zeros(1000,4,'uint32'); % surface lines point types: P1(t1,n1),P2(t2,n2)
nF20=0;
T2g=zeros(1000,1,'uint32'); % triangles grain numbers: gn
T2l=zeros(1000,6,'uint32'); % triangles lines: L1(t,n),L2(t,n),L3(t,n)
T2p=zeros(1000,6,'uint32'); % triangles points: P1(t,n),P2(t,n),P3(t,n)
nT2=0;
% end initialize list of triangles

% create A21 points, F20 lines and T2 triangles for Closed Loops
for i=1:nCL % loop on Closed Loops
    if nCLp(i)>3 % Closed Loop requires finding mean point
        
        % get mean Loop points coordinates
        yxz=zeros(nCLp(i),3,'uint32'); % initialization
        for j=1:nCLp(i) % loop on lines in Closed Loop
            if CLp(i,2*j-1)==23
                yxz(j,1:3)=boundarypoints.P23.coord(CLp(i,2*j),1:3);
            elseif CLp(i,2*j-1)==12
                yxz(j,1:3)=boundarypoints.P12.coord(CLp(i,2*j),1:3);
            elseif CLp(i,2*j-1)==10
                yxz(j,1:3)=boundarypoints.P10.coord(CLp(i,2*j),1:3);
            elseif CLp(i,2*j-1)==24
                yxz(j,1:3)=boundarypoints.P24.coord(CLp(i,2*j),1:3);
            end
        end % end loop on lines in Closed Loop
        meanyxz=uint32(round(mean(yxz)));
        clear j yxz;
        % end get mean Loop points coordinates
        
        % create A21 point
        nA21=nA21+1;
        A21g(nA21)=CLg(i,2);
        A21c(nA21,1:3)=meanyxz(1:3);
        clear meanyxz;
        % end create A21 points

        % create F20 lines
        F20l=zeros(nCLp(i),1,'uint32'); % array to store F20 line numbers
        for j=1:nCLp(i) % loop on points in Closed Loop
            nF20=nF20+1;
            F20g(nF20)=CLg(i,2); % save F20 line grain number
            F20p(nF20,1:4)=[CLp(i,2*j-1:2*j) 21 nA21]; % save points
            F20l(j)=nF20;
        end % end loop on points in Closed Loop 
        % end create F20 lines

        % create T2 triangles
        for j=1:nCLp(i)-1 % loop on points in Closed Loop
            nT2=nT2+1;
            k=2*j;
            T2g(nT2)=CLg(i,2); % save T2 triangle grain number
            T2p(nT2,1:6)=[CLp(i,k-1:k) CLp(i,k+1:k+2) 21 nA21]; % save points
            T2l(nT2,1:6)=[CLl(i,k-1:k) 20 F20l(j) 20 F20l(j+1)]; % save lines
        end  % loop on points in Closed Loop

            % save the last triangle of the Closed Loop
            k=2*(j+1);
            nT2=nT2+1;
            T2g(nT2)=CLg(i,2); % save T2 triangle grain number
            T2p(nT2,1:6)=[CLp(i,k-1:k) CLp(i,1:2) 21 nA21]; % save points
            T2l(nT2,1:6)=[CLl(i,k-1:k) 20 F20l(1) 20 F20l(j+1)]; % save lines
            % end save the last triangle of the Closed Loop

        % end create T2 triangles

    elseif nCLl(i)==3 % create triangle immediately

        % create triangle
        nT2=nT2+1;
        T2g(nT2)=CLg(i,2); % save T2 triangle grain number
        T2p(nT2,1:6)=CLp(i,1:6); % save points
        T2l(nT2,1:6)=CLl(i,1:6); % save lines
        % end create triangle

    else
        nErr2=nErr2+1;
        Err2(nErr2,1:3)=[0 i CLg(i,2)];
    end
end % end loop on Closed Loops
clear i j k;

    % clear excess zeros
    if nA21<nCL
        A21g(nA21+1:nCL)=[];
        A21c(nA21+1:nCL,:)=[];
    end
    if nF20<1000
        F20g(nF20+1:1000,:)=[];
        F20p(nF20+1:1000,:)=[];
    end
    if nT2<1000
        T2g(nT2+1:1000,:)=[];
        T2p(nT2+1:1000,:)=[];
        T2l(nT2+1:1000,:)=[];
    end
    % end clear excess zeros

% end create A21 points, F20 lines and T2 triangles for Closed Loops

% save the data
boundarypoints.A21.grainno=A21g;
boundarypoints.A21.coord=A21c;
clear A21g A21c nA21;
boundarylines.F20.grainno=F20g;
boundarylines.F20.points=F20p;
clear F20g F20p F20l nF20;
boundaryfaces.T2.grainno=T2g;
boundaryfaces.T2.points=T2p;
boundaryfaces.T2.lines=T2l;
if nErr2>0
    boundaryfaces.Err2=Err2;
end
clear T2g T2p T2l nT2 Err2 nErr2;
% end save the data

clear BLL1 BLL2 wymiary;
clear CLg CLp CLl nCL nCLp nCLl;