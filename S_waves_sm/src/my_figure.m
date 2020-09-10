function []=my_figure(all,minlat, maxlat,inclat, minlon, maxlon,inclon, mindepth, maxdepth, incdepth,minorigin, maxorigin, incorigin)

origin=minorigin:incorigin:maxorigin+incorigin;
depth=mindepth:incdepth:maxdepth+incdepth;

!mkdir -p OUTPUT   

%Group to depth time
for i=1:length(depth)-1

fprintf('Figure #%03d out of %03d \n',i,length(depth)-1)  
 
f=figure('visible','off');
axis tight manual
filename=sprintf('depth.%3.1f.gif',depth(1,i));

a=all(all(:,3)>=depth(1,i) & all(:,3)<depth(1,i+1),:);      

%group to origin time
for k=1:length(origin)-1
        
b=a(a(:,4)>=origin(1,k)-0.05 & a(:,4)<origin(1,k+1),:);      
        
%create a meshgrid
x=b(:,2); y=b(:,1); z=b(:,5);
[xx,yy]=meshgrid(minlon:inclon:maxlon, minlat:inclat:maxlat);
zz=griddata(x,y,z,xx,yy,'v4');

%Plot
surf(xx,yy,zz,'LineStyle','none')
title(sprintf('Depth:%3.1f Time:%3.1f',depth(1,i),origin(1,k)))
xlabel('Longitude')
ylabel('Latitude')
xlim([minlon maxlon])
ylim([minlat maxlat])
view([0 90])
colormap(jet) 
drawnow
%Gif file
F=getframe(f);
im=frame2im(F);
[imind,cm]=rgb2ind(im,256);

if k == 1 
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
end 

end
close all
movefile(filename,'OUTPUT/');
end


end