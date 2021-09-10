function mkchkmodelintegrity(model);
% mkchkmodelintegrity.......detect bugs in model structure
%
% call: mkchkmodelintegrity(model)
%
%       model: a MODEL structure as returned by MKREADND
%
% results: none
%
% This routine checks the model structure for some bugs that make it
% impossible to use it for travel time computations.
%
% Such features are:
%
% - missing .z, .vp, or .vs field
% - redundant depth samples, i.e. more than two samples having the same
%   depth
% - use of proper units (km/s for velocity, g/ccm for density)
%
%
% The detection of a model bug results in a run time error with a diagnostic
% message. Therefore it is not necessary to return any informations. 
%
% Martin Knapmeyer, 28.08.2007, 04.06.2008



%%%%%% test for missing .z field
if ~isfield(model,'z')
    error(['MKCHKMODELINTEGRITY: depth list (z field) missing in model.']);
end; % if ~isfield(model,'z')

%%%%%% test for missing vp field
if ~isfield(model,'vp')
    error(['MKCHKMODELINTEGRITY: P velocity (vp field) missing in model.']);
end; % if ~isfield(model,'vp')

%%%%%% test for missing vs field
if ~isfield(model,'vs')
    error(['MKCHKMODELINTEGRITY: S velocity (vs field) missing in model.']);
end; % if ~isfield(model,'vs')




%%%%%% test for redundant depth samples
model.z=sort(model.z); % make sure they are sorted - this can also catch missing digits
%%% label adjacent identical samples, including discontinuities
%%% ADJACENT will be 1 at the first of two adjacent samples with identical values
adjacent=(diff(model.z)==0);
%%% adding adjacent labels results in 2 if there are more than two adjacent
%%% samples with identical depths.
adjsum=adjacent(1:end-1)+adjacent(2:end);
%%% if ADJSUM concains any 2, there are redundant samples, and their
%%% depth can be extracted now.
redundant=find(adjsum==2);
if ~isempty(redundant)
   disp(' ');
   disp('************************');
   redundantcnt=length(redundant);
   for indy=1:redundantcnt
       disp(['MKCHKMODELINTEGRITY: redundant samples for depth ',...
             num2str(model.z(redundant(indy))),...
             'km.']);
   end; % for indy
   disp('************************');
   disp(' ');
   error(['MKCHKMODELINTEGRITY: ' int2str(redundantcnt) ' redundant depths found!']);
end; % if ~isempty



%%%%%% test for wrong units in vp
%%%%%% velocities must be in km/s, therefore values larger than 1e3 point
%%%%%% to use of m/s instead. To be able to read exotic models, however, we
%%%%%% only give a warning here. MK04062008
if min(model.vp)>1000
   warning('MKCHKMODELINTEGRITY: Vp probably uses wrong units! (must be km/s)');
end; % if min(model.vp)>1000


%%%%%% test for wrong units in vs
%%%%%% velocities must be in km/s, therefore values larger than 1e3 point
%%%%%% to use of m/s instead. To be able to read exotic models, however, we
%%%%%% only give a warning here. MK04062008
if min(model.vs)>1000
   warning('MKCHKMODELINTEGRITY: Vs probably uses wrong units! (must be km/s)');
end; % if min(model.vs)>1000


%%%%%% test for wrong units in rho
%%%%%% densities must be in g/ccm, therefore values larger than 1e3 point
%%%%%% to use of kg/m3 instead. To be able to read exotic models, however, we
%%%%%% only give a warning here. MK04062008
if min(model.rho)>1000
   warning('MKCHKMODELINTEGRITY: Rho probably uses wrong units! (must be g/ccm)');
end; % if min(model.rho)>1000



