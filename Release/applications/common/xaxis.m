function varargout = xaxis(a, FigList)
%XAXIS - Sets the horizontal axis
%  xaxis(a)
%  xaxis(a, FigList)
%  xaxis(a, AxesList)
%
% INPUTS
%  1. a - [Xmin Xmax]
%  2. FigList - Vector of figure or axes handles
%               if not specified, changes just the x-axis on the current plot
%
%  See also xaxiss, yaxis, zaxis, axis

%  Written by Greg Portmann


if nargin == 1
    set(gca, 'XLim', a);
elseif nargin >= 2
    for i = 1:length(FigList)
        if rem(FigList,1) == 0
            haxes = gca;
            figure(FigList(i));
            set(gca, 'XLim', a);
            axes(haxes);
        else
            % FigList is really a axes list
            set(FigList(i), 'XLim', a);
        end
    end
end

if nargout >= 1 || nargin == 0
    a = axis;
    varargout{1} = a(1:2);
end
