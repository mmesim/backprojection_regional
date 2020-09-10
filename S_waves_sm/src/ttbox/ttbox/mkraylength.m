function raylength=mkraylength(segx,segz,rp);
% mkraylength....computes ray path length from MKX4P output
%
% call: raylength=mkraylength(segx,segz,rp);
%
%         segx:  (numeric array) [deg]
%
%                horizontal distance segments traveled in each layer [deg] IN SPHERICAL EARTH
%                together with SEGZ, this gives the ray geometry
%
%         segz:  (numeric array [km]
%
%                vertical distance segments traveled in each layer [km] IN SPHERICAL EARTH
%                these are more or less the layer interface depths. (not for the deepest element of
%                segz, which gives the ray vertex)
%                Note: _depths_ not _radii_ !
%
%         This is the ray segment output of MKX4P.
%
%         rp: (number) [km]
%
%             planet radius as given in the model structure. This is needed
%             to convert the arcs given in SEGX into kilometers.
%
%
% results:
%
%         raylength: (number) [km]
%
%                    The length of the ray path of the ray described by
%                    SEGX and SEGZ.
%
% This routine computes the length of a single ray path from the ray
% description delivered by MKX4P.
% 
% LIMITATION: like MKRAYFAN, the routine assumes that the ray consists of
% straight line pieces althought the real rays are very likely to be
% curved. Curvature is only approximated by the refraction of the linear
% pieces at the interfaces. To obtain accurate results, it is thus
% recommended to use a fine depth sampling in order to make the individual
% pieces short.
%
% Martin Knapmeyer, 11.05.2011


%% a useful constant
radian=pi/180;

%% from deg to rad
segx=segx*radian;

%% number of segments
%%% a line element consists of the start end endpoint, i.e. 
%%% the number of linear segments is one less than the number of samples in
%%% SEGX and SEGZ
segcnt=length(segx)-1;

%% loop over ray segments
raylength=0;
for segnr=1:segcnt
    
    %% length of current segment
    [startx,startz]=pol2cart(segx(segnr),rp-segz(segnr));
    [endx,endz]=pol2cart(segx(segnr+1),rp-segz(segnr+1));
    seglength=sqrt((endx-startx)^2+(endz-startz)^2);
    
    %% add to overall length
    raylength=raylength+seglength;
    
end; % for segnr


