function [grid]=make_grid(minlat, maxlat,inclat, minlon, maxlon,inclon, mindepth, maxdepth, incdepth)

%X1=Latitude (decimal degrees)
x1=minlat:inclat:maxlat;

%X2=Longitude (decimal degrees)
x2=minlon:inclon:maxlon;

%X3=Depth (Km)
x3=mindepth:incdepth:maxdepth;


%Get grid
[X1,X2,X3]=ndgrid(x1,x2,x3);
grid=[X1(:) X2(:) X3(:) ];


end 