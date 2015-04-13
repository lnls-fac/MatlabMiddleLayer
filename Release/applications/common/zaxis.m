function varargout = zaxis(a, FigList)
%ZAXISS - Sets the z-axis
%  zaxis(a)
%  zaxis(a, FigureList)
%  zaxis(a, AxesList)
%
% INPUTS
%  1. a - [Zmin Zmax]
%  2. FigList - Vector of figure or axes handles
%               if not specified, changes just the z-axis on the current plot
%
%  See also zaxiss, xaxis, yaxis, axis

%  Written by Greg Portmann


if nargin == 1
    set(gca, 'ZLim', a);
elseif nargin >= 2
    for i = 1:length(FigList)
        if rem(FigList,1) == 0
            haxes = gca;
            figure(FigList(i));
            set(gca, 'ZLim', a);
            axes(haxes);
        else
            % FigList is really a axes list
            set(FigList(i), 'ZLim', a);
        end
    end
end

if nargout >= 1 || nargin == 0
    a = axis;
    varargout{1} = a(5:6);
end

