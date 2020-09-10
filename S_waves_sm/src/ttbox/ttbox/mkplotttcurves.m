function handles=mkplotttcurves(ttcurves,linespec,orientation,dolabel);
% mkplotttcurves.........plot travel time curves fro structure
%
% call: handles=mkplottraveltimecurves(ttcurves,linespec);
%       handles=mkplottraveltimecurves(ttcurves,linespec,orientation);
%       handles=mkplottraveltimecurves(ttcurves,linespec,orientation,dolabel);
%
%       ttcurves: structure describing travel time curves. Such structures
%                 are produced by MKTTCURVES and consist of the following fields:
%                   .name    : model.name as given by the user
%                   .dangle  : the DANGLE goiven by the user
%                   .h       : focal depth as given by the user
%                   .anz     : number opf phases contained in structure (==length of TTC)
%                   .ttc     : sub-structure of arrays containing the data itself
%                              ttc is an array. each element of ttc describes the travel time curve
%                              of a single phase.
%                   .ttc(i).p: name of the i-th phase
%                   .ttc(i).d: epicentral distances for the i-th travel time curve
%                   .ttc(i).t: travel time for the i-th phase
%       linespec: a LINSPEC string, specifying the plot style.
%    orientation: controls which coordinate axis is used as time axis.
%                 This is a string which might contain one of the following
%                 key words:
%                 'xaxis': the x axis is used as time axis
%                 'yaxis': the y axis is used as time axis
%
%                 DEFAULT_ 'yaxis'
%
%        dolabel: controls whether or not phase name labels are attached to
%                 the travel time curves.
%                 This is a string which might contain one of the keywords
%                 'dolabel': attach name labels
%                 'nolabel': do not attach name labels
%
%                  DEFAULT: 'dolabel'
%
% result: handles: handles to the generated line objects
%
% plots the travel time curves defined by TTCURVES into the current axis.
% SWITCHES HOLD ON AND OFF TO DO SO.
% Distances will be reduced to the interval 0...180deg.
%
% Text labels can be identified by their UserData field, which contains the
% string "mktttcurves".
%
% Martin Knapmeyer, 30.07.2002, 19.01.2011

%% prepare output
handles=zeros(ttcurves.anz,1);


%% understand input
default.orientation='yaxis';
default.dolabel='dolabel';
nin=nargin;
switch nin
    case {2}
         orientation=default.orientation;
         dolabel=default.dolabel;
    case {3}
         dolabel=default.dolabel;
    case {4}
         %%% everything given by caller, do nothing
    otherwise
         error('MKPLOTTTCURVES: illegal number of input parameters!');
end; % switch nin
orientation=lower(orientation);
dolabel=lower(dolabel);



%% plot stuff
for indy=1:ttcurves.anz;
   %%% do not attempt if no curve data present!
   if ~isempty(ttcurves.ttc(indy).d)
      %disp(ttcurves.ttc(indy).p);
      %%% reduce distances to 0...180
      ttcurves.ttc(indy).d=mod(ttcurves.ttc(indy).d,360);
      indies=find(ttcurves.ttc(indy).d>180);
      ttcurves.ttc(indy).d(indies)=360-ttcurves.ttc(indy).d(indies);
      %%% and now: plot!
      switch orientation
          case {'yaxis'}
              %%% use y axis as time axis
              hold on;
              handles(indy)=plot(ttcurves.ttc(indy).d,ttcurves.ttc(indy).t,linespec);
              set(handles(indy),'Tag',ttcurves.ttc(indy).p);
              if strcmp(dolabel,'dolabel')
                  %%% write phase name label
                  firstindy=find((~isnan(ttcurves.ttc(indy).d))&(~isnan(ttcurves.ttc(indy).t)));
                  if ~isempty(firstindy)
                     firstindy=firstindy(1);
                     th=text(ttcurves.ttc(indy).d(firstindy),ttcurves.ttc(indy).t(firstindy),...
                             ttcurves.ttc(indy).p,...
                             'Color',get(handles(indy),'Color'),...
                             'VerticalAlignment','bottom',...
                             'Clipping','on');
                     textent=get(th,'Extent');
                     tpos=get(th,'Position');
                     if tpos(1)<90
                        tpos(1)=max(tpos(1),0); % positions text at 0deg bundary inside plot
                     else
                        tpos(1)=min(tpos(1),180-textent(3)); %% positions text at 180 boundary inside plot
                     end; % if tpos
                     set(th,'position',tpos);
                     set(th,'UserData','mkplotttcurves');
                  end; % if ~isempty
              end; % if strcmp(dolabel,'dolabel')
              hold off;
      
          case {'xaxis'}
              %%% use x-axis as time axis to be compatible with MKPLOTSECTION
              hold on;
              handles(indy)=plot(ttcurves.ttc(indy).t,ttcurves.ttc(indy).d,linespec);
              set(handles(indy),'Tag',ttcurves.ttc(indy).p);
              firstindy=find((~isnan(ttcurves.ttc(indy).d))&(~isnan(ttcurves.ttc(indy).t)));
              if strcmp(dolabel,'dolabel')
                  %%% write phase name label
                  if ~isempty(firstindy)
                     firstindy=firstindy(1);
                     th=text(ttcurves.ttc(indy).t(firstindy),ttcurves.ttc(indy).d(firstindy),...
                             ttcurves.ttc(indy).p,...
                             'Color',get(handles(indy),'Color'),...
                             'VerticalAlignment','bottom',...
                             'Clipping','on');
                     textent=get(th,'Extent');
                     tpos=get(th,'Position');
                     if tpos(2)<90
                        tpos(2)=max(tpos(2),0); % positions text at 0deg bundary inside plot
                     else
                        tpos(2)=min(tpos(2),180-textent(4)); %% positions text at 180 boundary inside plot
                     end; % if tpos
                     set(th,'position',tpos);
                     set(th,'UserData','mkplotttcurves');
                  end; % if ~isempty
              end; % if strcmp(dolabel,'dolabel')
              hold off;
              
          otherwise
              error(['MKPLOTTCURVES: unknown orientation ' upper(orientation)]);
      end; % switch orientation
   else
      disp(['MKPLOTTTCURVES: no data for curve #' int2str(indy) ' (Phase: ' ttcurves.ttc(indy).p ')']);
   end; % if ~isempty(ttcurves.ttc(indy).d) else
end; % for indy


%%% return output
% output is already in the output variable.