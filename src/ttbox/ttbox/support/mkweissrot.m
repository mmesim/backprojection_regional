function rnew=mkweissrot(r,n,phi);
% mkweissrot.......eric weisstein's general alias rotation formula
%
% call: rnew=mkweissrot(r,n,phi);
%
%       r: (numeric array) [arbitrary]
%          three component vector in the original coordinate frame
%          due to the use of dot() and cross() for the vector operations,
%          this cannot be an n-by-3 matrix but has to be 1-by-3 or 3-by-1.
%
%       n: (numeric array) [arbitrary]
%          unit vector defining the rotation axis
%          (will be normalized internally)
%
%       phi: (number) [deg]
%            rotation angle, counterclockwise
%
% result:  rnew: (numeric array) [as R]
%                three component vector components in new coordinate frame,
%                as column vector.
%
% The routine keeps vector R fixed in the three dimensional space and computes
% its components in a new coordinate frame which is rotated by angle PHI around
% the axis defined by N. This is a so-called alias transformation.
%
% Source: Weisstein, Eric W., "Rotation Formula" From MathWorld-- A Wolfram
% Resource. http://mathworld.wolfram.com/RotationFormula.com
%
% Martin Knampeyer, 04.11.2009


%%% this is the same as MKCSIWEISSROT in the CSI toolbox. I hat ecode duplication
%%% like this, but CSI is intended to be as self-contained as possible. be
%%% careful when changing the code!

%%% guarantee that n is a unit vector
n=n./norm(n);

%%% make input column vectors
n=n(:);
r=r(:);


%%% a useful constant
radian=pi/180;


%%% transform angle into radians
phi=phi*radian;

%%% apply Weissteins formula
rnew=r.*cos(phi)+n.*dot(n,r)*(1-cos(phi))+cross(r,n)*sin(phi);


%%% that's it.