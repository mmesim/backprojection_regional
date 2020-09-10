function mkrotateobjects(handles,direction,angle);
% mkrotateobjects......rotation of graphic object
%
% call: mkrotateobject(handles,direction,angle);
%
%       handles: (numeric array) [handle]
%               handles to the graphic objects
%               This may be a vector or matrix of object
%               handles. All objects are rotated by the
%               same angle.
%
%      direction: (numeric array) [axis units]
%                 vector defining the orientation of the rotation axis.
%                 This is passed directly to rotate(), see there for
%                 description.
%
%       angle: (number) [deg]
%               rotation angle
%               This is passed directly to rotate
%
% result: none
%
% This routine rotates a number of objects by the given ANGLE.
% The rotation axis is defined by the vector through the origin
% and the point given in DIRECTION, as in MatLab's rotate().
%
% This routine modifies the XDATA and YDATA properties of drawn
% objects.
%
% Martin Knapmeyer, 09.12.2010


handles=handles(:);
objectcnt=length(handles);
for objectnr=1:objectcnt
    rotate(handles(objectnr),direction,angle);
end; % for objectnr
