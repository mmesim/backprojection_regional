function garbageout=mklinearscale(garbagein);
% mklinearscale.......draw baroque linear scales for coordinate systems
%
% call: handles=mklinearscale;
%       handles=mklinearscale(scaleinfo);
%       scaleinfo=mklinearscale('defaults');
%
%
%       scaleinfo: (struct)
%                  structure describing the appearence of the scale
%                  This structure contains the following fields:
%
%                  .orientation: (number or string) [deg]
%                                Orientation angle: the scale will be
%                                rotated by this angle around the position
%                                defined in the .position field
%
%                                To simplify life, this may also bei either
%                                of the two strings "x" and "y" if you wish
%                                to draw an X or Y axis.
%
%                  .tickdirection: (string)
%                                This string indicates whether the ticks
%                                start at the lower (right) or at the upper
%                                (left) end of an x (y) axis.
%                                The following values are accepted:
%                                "up"
%                                "down"
%                                "middle"
%
%                  .position: (numeric array) [axes units]
%                             two element vector defining the position of
%                             the lower left corner of the scale
%                             The first element is the x coorindate, the
%                             second is the y coordinate.
%
%                  .extent: (number) [axes units]
%                           length of the scale in units of the underlying
%                           axes objects
%
%                  .range: (numeric array) [scale units]
%                          two element vector defining the value range
%                          shown on the scale
%                          min(range) is the lower end, max(range) is the
%                          upper end.
%
%                  .framewidth: (number) [axes units]
%                               width of the scale frame in units of the
%                               underlying axes object
%
%                  .steps: (numeric array) [scale units]
%                          increments of the tickmarks on the scale, in
%                          units of its RANGE
%                          tick families with different increments can be
%                          defined and separated optically by their tick
%                          lengths. An arbitrary number of tick families
%                          can be defined.
%
%                  .ticklen: (numeric array) [framewidth units]
%                            numeric array defining the tick lengths
%                            ticks generated with increment .STEPS(i) have
%                            length .TICKLEN(i)
%                            The tick length is given in units of the frame
%                            width, i.e. 1 means the tick covers the entire
%                            frame width, and 0.5 only half of it.
%
%                  .dolabel: (numeric array) [flag]
%                            list of flags defining wether or not a text
%                            label is written on ticks.
%                            ticks generated with increment .STEPS(i) are
%                            labelled if .DOLABEL(i) is 1.
%
%                  .labelpos: (numeric array) [flag]
%                            List of flags defining the location of labels
%                            relative to the scale. labelpos(i) corresponds
%                            to the i-th family of ticks.
%                            possible values are:
%                            0: label is drawn at that side of the scale
%                               where the ticks originate
%                            1: label is drawn at that side of the scale
%                               where the ticks end.
%                            These labels are effective only if dolabel(i)
%                            is set to 1.
%
%                  .bgcolor: (colspec)
%                            a color specifier that can be passed to
%                            patch()
%                            This defines the background color of the
%                            scale.
%
%                  .fgcolor: (colspec)
%                            a color specifier that can be passed to
%                            plot()
%                            This defines the color of the ticks.
%
%
%         if MKLINEARSCALE is called with argument "defaults", a scaleinfo
%         structure containing the default settings is returned. This is an
%         easy way to obtain a complete scaleinfo structure.
%
%         When no input parameter is given, the default scale will be
%         drawn.
%
% results: handles: (struct)
%                   handles to all created plot objects
%
%                   This structure contains the following fields:
%
%                   .frame: (number)
%                           handle to the frame box around the scale (which
%                           is a patch object)
%                   .ticks: (number)
%                           handle to the tick lines (line objects)
%                  .labels: (numeric array)
%                           handles to the label text objects
%
%
%          scaleinfo: (struct)
%                     default scale info structure
%
% Martin Knapmeyer, 03.12.2010, 06.12.2010, 09.12.2010


%% construct default scaleinfo
default=struct('orientation','x',...
               'tickdirection','down',...
               'position',[3 2],...
               'extent',1,...
               'range',[-8 17],...
               'framewidth',0.5,...
               'steps',[0.5 1 5],...
               'ticklen',[0.4 0.6 0.8],...
               'dolabel',[0 1 1],...
               'labelpos',[0 0 1],...
               'bgcolor','y',...
               'fgcolor','r');
            
%% prepare output
handles=struct('frame',[],...
               'ticks',[],...
               'labels',[]);
            


%% understand input
nin=nargin;
switch nin
   case {0}
      calltype='plotscale';
      scaleinfo=default;
      garbageout=[];
   case {1}
      if isstruct(garbagein)
         %%% input is a scale info structure
         calltype='plotscale';
         scaleinfo=garbagein;
         garbageout=[];
      else
         %%% input is not a scale info, but probably "default"
         calltype='getdefault';
      end; % if isstruct
   otherwise
end; % switch nin;



            
%% perform according to call type
switch calltype
   case {'plotscale'}
        
        %% define extent of the background patch
        l=scaleinfo.extent;
        w=scaleinfo.framewidth;
        patchx=[l 0 0 l];
        patchy=[0 0 w w];
        
        
        %% create tick and label positions
        %%% first create tick positions in world coordinates, i.e. in
        %%% terms of .RANGE, then transform to the .EXTENT.
        %%% allscales are generated in horizotal direction first.
        familycnt=length(scaleinfo.steps); % number of tick families to be created
        tickx=[];
        ticky=[];
        labelx=[];
        labely=[];
        labelvalue=[];
        labelhalign='';
        labelvalign='';
        minrange=min(scaleinfo.range);
        maxrange=max(scaleinfo.range);
        
        for family=1:familycnt
            tickstart=minrange-rem(minrange,scaleinfo.steps(family));
            for xtickpos=tickstart:scaleinfo.steps(family):maxrange
                if xtickpos>=minrange
                   
                   
                   %%% tick positions
                   tickx=[tickx NaN xtickpos xtickpos];
                   switch lower(scaleinfo.tickdirection)
                      case {'up'}
                         ticky=[ticky NaN,...
                                0,...
                                scaleinfo.ticklen(family)*scaleinfo.framewidth];
                      case {'down'}
                         ticky=[ticky NaN,...
                                scaleinfo.framewidth,...
                                scaleinfo.framewidth*(1-scaleinfo.ticklen(family))];
                      case {'middle'}
                         ticky=[ticky NaN,...
                                scaleinfo.framewidth*(1/2-scaleinfo.ticklen(family)/2),...
                                scaleinfo.framewidth*(1/2+scaleinfo.ticklen(family)/2)];
                      otherwise
                         error(['MKLINEARSCALE: unknown tick direction upper(scaleinfo.tickdirection)']);
                   end; % switch lower(scaleinfo.tickdirection)
                   
                   
                   %%% label positions, orientation, and alignment
                   if scaleinfo.dolabel(family)==1
                      labelx=[labelx xtickpos];
                      labely=[labely scaleinfo.labelpos(family)*scaleinfo.framewidth];
                      labelvalue=[labelvalue xtickpos];
                      if isstr(scaleinfo.orientation)
                         switch lower(scaleinfo.orientation)
                            case {'x'}
                                 labelhalign=strvcat(labelhalign,'center');
                                 switch scaleinfo.labelpos(family)
                                    case {0}
                                        labelvalign=strvcat(labelvalign,'top');
                                    case {1}
                                        labelvalign=strvcat(labelvalign,'bottom');
                                 end; % switch scaleinfo.labelpos(family)
                            case {'y'}
                                 labelvalign=strvcat(labelvalign,'middle');
                                 switch scaleinfo.labelpos(family)
                                    case {0}
                                        labelhalign=strvcat(labelhalign,'left');
                                    case {1}
                                        labelhalign=strvcat(labelhalign,'right');
                                 end; % switch scaleinfo.labelpos(family)
                         end; % switch lower(scaleinfo.orientation)
                      end; % if isstr(scaleinfo.orientation)
                   end; % if dolabel(family)==1
                   
                   
                end; %  if xtickpos>=minrange
            end; % for xtickpos
        end; % for family
        
        %%% apply scale factor
        lengthscale=scaleinfo.extent/abs(diff(scaleinfo.range));
        tickx=(tickx-minrange)*lengthscale;
        ticky=ticky;
        labelx=(labelx-minrange)*lengthscale;
        
        
        
        

              
        
        %% do the plotting
        %%% frame
        handles.frame=patch(patchx,patchy,'k');
        set(handles.frame,'FaceColor',scaleinfo.bgcolor);
        set(handles.frame,'EdgeColor',scaleinfo.fgcolor);
        
        %%% ticks
        hold on
        handles.ticks=plot(tickx,ticky,scaleinfo.fgcolor);
        hold off
           
        
        %% labels
        labelcnt=length(labelx);
        for labelnr=1:labelcnt
            newlabel=text(labelx(labelnr),labely(labelnr),...
                          num2str(labelvalue(labelnr)),...
                          'VerticalAlignment',deblank(labelvalign(labelnr,:)),...
                          'HorizontalAlignment',deblank(labelhalign(labelnr,:)),...
                          'BackgroundColor',scaleinfo.bgcolor,...
                          'EdgeColor',scaleinfo.fgcolor,...
                          'Color',scaleinfo.fgcolor,...
                          'Clipping','on');
            handles.labels=[handles.labels; newlabel];
        end; % for labelnr   
           
           
        %% apply rotation
        if isstr(scaleinfo.orientation)
           switch lower(scaleinfo.orientation)
              case {'x'}
                   %%% the scles are constructed along x axis.
                  
              case {'y'}
                   %%% Apply some simple rotation scheme as long as the
                   %%% continuous rotation does not work
                   mkconvertx2y(handles.ticks);
                   mkconvertx2y(handles.frame);
                   mkconvertx2y(handles.labels);
                   labelcnt=length(handles.labels);
%                    for labelnr=1:labelcnt
%                        set(handles.labels(labelnr),'HorizontalAlignment','right');
%                        set(handles.labels(labelnr),'VerticalAlignment','middle');
%                    end; % for labelcnt;
              otherwise
                 error(['MKLINEARSCALE: unknown orientation ' upper(scaleinfo.orientation)]);
           end; % switch lower(scaleinfo.orientation)
        else
           %%% rotate according to numerical angle
           mkrotateobjects(handles.ticks,...
                           [0 0 1],...
                           scaleinfo.orientation);
           mkrotateobjects(handles.frame,...
                           [0 0 1],...
                           scaleinfo.orientation);
        end; % if isstr(scaleinfo.orientation)
                     
        
        
        
        
        %% apply shift to requested starting point
        mkshiftobject(handles.ticks,...
                      scaleinfo.position(1),...
                      scaleinfo.position(2));
        mkshiftobject(handles.frame,...
                      scaleinfo.position(1),...
                      scaleinfo.position(2));
        mkshiftobject(handles.labels,...
                      scaleinfo.position(1),...
                      scaleinfo.position(2));
        
        
        
        
        %% prepare output
        garbageout=handles;
        
        
   case {'getdefault'}
        garbageout=default;
end; % switch


%% return
return;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                       HELPER ROUTINES                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function mkconvertx2y(handles);
% mkconvertx2y......convert x axes scales into y axes scales


handles=handles(:);
objectcnt=length(handles);
for objectnr=1:objectcnt
   currentobject=handles(objectnr);
   type=get(currentobject,'type');
   switch type
      case {'text'}
         position=get(currentobject,'Position');
         swap=position(1);
         position(1)=-position(2);
         position(2)=swap;
         set(currentobject,'Position',position);
      otherwise
         thisx=get(currentobject,'XDATA');
         thisy=get(currentobject,'YDATA');
         swap=thisx;
         thisx=-thisy;
         thisy=swap;
         set(currentobject,'XDATA',thisx);
         set(currentobject,'YDATA',thisy);
   end; % switch type
end; % for objectcnt

return;
