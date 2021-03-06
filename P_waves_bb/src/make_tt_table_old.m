function  [tt,grid]=make_tt_table(pha,model,minlat, maxlat,inclat, minlon, maxlon,inclon, mindepth, maxdepth, incdepth, minorigin, maxorigin, incorigin,header)

%Loop through stations and grid point to get travel times
% TTBox : A MatLab Toolbox for the computation of 1D Teleseismic Travel
% Times
%https://doi.org/10.1785/gssrl.75.6.726


%1. Make Grid
grid=make_grid(minlat, maxlat,inclat, minlon, maxlon,inclon, mindepth, maxdepth, incdepth, minorigin, maxorigin, incorigin);

fprintf('Number of grid points: %d\n',length(grid))

%2. calculate distance of each station from each grid point
dis_sta=my_distance(grid,header);

%3. call ttbox to calculate travel times
%Preallocate memory
tt=zeros(length(grid),length(dis_sta(1,:)));

%Station
for  i=1:length(dis_sta(1,:))
fprintf('Travel times - Station:  %03d \n',i)   
    %grid point
    parfor  k=1:length(grid)
       tt1=mkttime(pha,dis_sta(k,i),grid(k,3),model); 
            if length(tt1)>=2
            tt(k,i)=tt1(2,1);
            elseif length(tt1)==1
            tt(k,i)=tt1(1,1);
            end
    end %grid point
    
end %station
end