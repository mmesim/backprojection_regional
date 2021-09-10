function newdelta=mkreduceto180(delta);
% mkreduceto180.........reduce epicentral distances to 0...180 deg interval
%
% call: newdelta=mkreduceto180(delta);
%
%       delta: [deg]
%              Epicentral distance in the interval -inf...inf
%              This might be a list of values.
%
% result: newdelta: [deg]
%                   the same distance, but reduced to the interval 0...180
%                   as common in seismology
%
% Martin Knapmeyer, 12.09.2007, 19.06.2008, 23.06.2008


%%% zeroth step: do not process empty input MK19062008
if isempty(delta)
   newdelta=[];
   return;
end; % if isempty(delta)

%%% first step: reduce -inf...inf to 0...inf
indies=find(delta<0);
delta(indies)=-delta(indies);


%%% second step: identify all non-NaN elements of input 
validinput=find(~isnan(delta));


%%% second step: reduce 0...inf to 0...180
if delta(validinput)>=0
   
    %%% init a result array
    newdelta=delta;
    
    
    %%% in which multiple of the 180deg interval are we?
    intervalnr=ceil(delta./180);

    %%% the reduction equation
    newdelta(validinput)=(delta(validinput)...
                         -fix(intervalnr(validinput)./2)*360)...
                         ./((-1).^(intervalnr(validinput)-1));
    
else
    %%% negative values of delta should be impossible here...
    error('MKREDUCETO180: input must be positive!');
end; % if delta>0