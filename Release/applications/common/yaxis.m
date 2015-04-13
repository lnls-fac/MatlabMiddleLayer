function varargout = yaxis(a, FigList)
%YAXIS - Sets the vertical axis
%  yaxis(a)
%  yaxis(a, FigList)
%  yaxis(a, AxesList)
%
%  INPUTS
%  1. a - [Ymin Ymax]
%  2. FigList - Vector of figure or axes handles
%               if not specified, changes just the y-axis on the current plot
%
%  See also yaxiss, xaxis, zaxis, axis

%  Written by Greg Portmann

if nargin == 1
    set(gca, 'YLim', a);
elseif nargin >= 2
    for i = 1:length(FigList)
        if rem(FigList,1) == 0
            haxes = gca;
            figure(FigList(i));
            set(gca, 'YLim', a);
            axes(haxes);
        else
            % FigList is really a axes list
            set(FigList(i), 'YLim', a);
        end
    end
end

if nargout >= 1 || nargin == 0
    a = axis;
    varargout{1} = a(3:4);
end

