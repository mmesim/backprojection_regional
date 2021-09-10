function direction=mkangledir(alpha,beta);
% mkangledir.......direction of angular difference
%
% call: direction=mkangledir(alpha,beta);
%
%       alpha: (number) [deg]
%               first direction
%
%       beta: (number) [deg]
%               second direction
%
%
% result: direction: (number)
%
%                    sign of angular increment necessary to change from
%                    direction ALPHA into direction BETA
%                    This is the sign of the shortest arc in terms of the
%                    angle count direction
%
%                    +1: increase alpha to obtain beta
%                    -1: decrease alpha to obtain beta
%                     0: alpha and beta denote identical directions
%                        or differ by 180 degrees - in any case, the
%                        direction of increment does not matter
%
% Martin Knapmeyer, 17.11.2010


%%% difference in directions
anglediff=mkanglediff(alpha,beta);


%%% reduce input angles to interval 0...360
alpha=mkreduceto360(alpha);

beta=mkreduceto360(beta);

%%% direction sign
direction=sign(mkanglediff(mkreduceto360(alpha-anglediff),beta)-...
               mkanglediff(mkreduceto360(alpha+anglediff),beta));
               