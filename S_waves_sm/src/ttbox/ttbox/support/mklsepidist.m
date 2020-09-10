function delta=mklsepidist(elon,elat,slon,slat);
% mkepidist.............calculate epicentral distance from coordinates
%
% call: delta=mklsepidist(elon,elat,slon,slat);
%
%             elon: (numeric) [deg]
%                   epicenter longitude
%             elat: (nmeric) [deg]
%                   epicenter latitude
%             slon: (numeric) [deg]
%                   station longitude
%             slat: (numeric) [deg]
%                   station latitude
%
%             All input must be scalar. This version is not vectorized!
%             If you have matrix input, use MKLSEPIDISTV.
%             (unvectorized code is faster in case of non-vector input!)
%
% All coordinates in degrees, positive to the north and east, respectively.
% Valid for spherical planets.
%
% result: delta: epicentral distance, in degrees
%
% after formula 4.4.1 in Lay/Wallace's book "Modern Global Seismology"
%
% Martin Knapmeyer, 10.9.1996, unvectorized 06.12.2004

radian=pi/180;



%%% non-vectorized code for scalar input: is faster!

b=(90-elat)*radian; % event colatitude
c=(90-slat)*radian; % station colatitude
ga=elon-slon;
%indies=find(ga>180);
%if ~isempty(indies)
%   ga(indies)=360-ga(indies);
%end; % i f~isempty
if ga>180
   ga=360-ga;
end; % if ga>180
ga=ga.*radian;

res=acos(cos(b).*cos(c)+sin(b).*sin(c).*cos(ga));

% if ~isreal(res)
%    disp([num2str(elon) ' ' num2str(res)]);
% end;

delta=real(res)/radian;


