function dis_sta=my_distance(grid,header)

%Calculate distance between each station and grid point
%Distance is in degrees
%Matlab mapping toolbox: distance

%Preallocate memory
dis_sta=zeros(length(grid),length(header));

%Get stations' coordinates
parfor i=1:length(header)

stlo=header(i).STLO;
stla=header(i).STLA;

dis_sta(:,i)=distance(stla,stlo,grid(:,1),grid(:,2));

end


end