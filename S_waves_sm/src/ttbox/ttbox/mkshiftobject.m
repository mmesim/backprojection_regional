function mkshiftobject(handles,dx,dy);
% mkshiftobject.......linear shift of graphic object
%
% call: mkshiftobject(handles,dx,dy);
%
%       handles: (numeric array) [handle]
%               handles to the graphic objects
%               This may be a vector or matrix of object
%               handles. All objects are shifted by the
%               same amount.
%
%       dx: (number) [axis units]
%           amount of shift in X axis direction
%
%       dy: (number) [axis units]
%           amount of shift in Y axis direction
%
% result: none
%
% This routine shifts an object that is already drawn
% within the corrdinate frame of its axes.
% The routine simply adds DX and DY to the XDATA and YDATA
% properties of the object structure.
%
% Martin Knapmeyer, 09.12.2010

handles=handles(:);
objectcnt=length(handles);
for objectnr=1:objectcnt
   currentobject=handles(objectnr);
   type=get(currentobject,'type');
   switch type
      case {'text'}
         position=get(currentobject,'Position');
         position(1)=position(1)+dx;
         position(2)=position(2)+dy;
         set(currentobject,'Position',position);
      otherwise
         thisx=get(currentobject,'XDATA');
         thisy=get(currentobject,'YDATA');
         thisx=thisx+dx;
         thisy=thisy+dy;
         set(currentobject,'XDATA',thisx);
         set(currentobject,'YDATA',thisy);
   end; % switch type
end; % for objectcnt