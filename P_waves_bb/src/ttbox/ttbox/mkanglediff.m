function delta=mkcsianglediff(alpha,beta);
% mkcsianglediff......angular difference between two directions
%
% call: delta=mkcsianglediff(alpha,beta);
%
%       alpha: (number) [deg]
%
%             one direction, defined as angle against some reference
%
%       beta: (number) [deg]
%
%             another direction, defined as angle against te same reference
%
% result: delta: (number) [deg]
%
%                the angular difference between the two input directions
%
%
% The angular difference cannot be computed as difference between two
% angles, because of the 360deg periodicity: a 352 degree difference is the
% same as an 8 deg difference, only in the other direction.
%
% Instead, the inner product of two vectors pointing in the two directions
% has to be evaluated.
%
% Martin Knapmeyer, 28.05.2010, 21.12.2010


%%% a useful constant
radian=pi/180;


%%% transform angles into radians
alpha=alpha*radian;
beta=beta*radian;


%%% construct two unit vectors from the input directions
valpha=[cos(alpha); sin(alpha)];
vbeta=[cos(beta); sin(beta)];


%%% inner product of the two vectors
dotprod=sum(valpha.*vbeta);

%%% by construction, dotprod can not exceed 1
%%% but it sometimes does because of numerical inaccuracies.
dotprod=min(dotprod,1);


%%% resulting angle
%%% since vectors are unit vectors, the division by their lengths can be
%%% omitted!
delta=acos(dotprod)/radian;