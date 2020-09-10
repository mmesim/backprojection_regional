function [baz,dist]=mklsbaz(elat,elon,slat,slon);
% mkbaz.................calculate Back azimuth from coordinates
%
% call: delta=mklsbaz(elat,elon,slat,slon);
%
%             elat: list or matrix of epicenter latitudes
%             elon: list or matrix ofepicenter longitude
%             slat: single station latitude
%             slot: single station longitude
%
% all coordinates in degrees, positive to the north and east, respectively.
%
% result: baz: back azimuth, in degrees
%              NaN in cases in which the BAZ is undefined
%
%  after formula 4.4.3 in Lay/Wallace's book "Modern Global Seismology"
%  but completed and improved by MK
%
% Martin Knapmeyer, 10.09.1996, 15.08.2002, 21.08.2002, 02.06.2003, 03.06.2003
%                   11.12.2007

%%% integrated into locsmith MK11122007

%%% a useful constant
radian=pi/180;


%%% allocate arrays for results
res=elat*0;
dist=elat*0;


b=(90-elat)*radian; % event colatitude
c=(90-slat)*radian; % station colatitude
dist=mklsepidist(elon,elat,slon,slat);
a=dist*radian;

%%% new vectorized version MK 21.08.2002
undefd=find((dist==0)|(dist==180));
if ~isempty(undefd)
   res(undefd)=res(undefd)+NaN;
end; % if ~isempty
if (c==0)|(c==pi)
   %%% if station is at a pole, the BAZ is the event longitude
   %%% except at those places where dist==0 or dist==180
   res=elon;
   %%% ELON might be negative, but BAZe should be positive and in 0...360
   negativ=find(res<0);
   if ~isempty(negativ)
      res(negativ)=360+res(negativ);
   end; % if ~isempty(negativ)
   %%% set BAZ for undefined values to NaN MK02062003
   if ~isempty(undefd)
      res(undefd)=res(undefd)+NaN;
   end; % if ~isempty
else
   indies=find((dist~=0)&(dist~=180)); %%% do not compute BAZ where dist==0 or dist==180!
   if ~isempty(indies)
      res(indies)=acos((cos(b(indies))-cos(a(indies)).*cos(c))./(sin(a(indies)).*sin(c)))/radian;
   end; % if ~isempty(indies)
   %%% don't do the follwoing for pole-stations MK02062003
   indies=find(slon>elon);
   if ~isempty(indies)
      res(indies)=360-res(indies);
   end; % if ~isepmty
   %%% is the event west or east of station? MK15082002
   indies=find(abs(slon-elon)>180);
   if ~isempty(indies)
      res(indies)=360-res(indies);
   end; % if ~isempty
end; % if c==0



%%% old version with imperfect vectorization
% if (dist==0)|(dist==180)
%    %%% if the epicentral distance is zero or 180deg, the BAZ is undefined
%    res=NaN;
% else
%    if (c==0)|(c==180)
%       %%% if station is at a pole, the BAZ is the event longitude
%       res=elon;
%    else
%       res=acos((cos(b)-cos(a).*cos(c))./(sin(a).*sin(c)))/radian;
%    end; % if c==0
% end; % if a==0
%
% if slon>elon
%    res=360-res;
% end; % if res
%
%% if ~isreal(res)
%%    disp([num2str(elon) ' ' num2str(res)]);
%% end;
%
%%%% is the event west or east of station? MK15082002
%if abs(slon-elon)>180 %elon<slon-180
%   res=360-res;
%end; %if


% %%% reshape RES and DIST into format of ELAT and ELON
% res=reshape(res,size(elat));
% dist=reshape(dist,size(elat));

%%% return results
baz=real(res);
dist=dist;


