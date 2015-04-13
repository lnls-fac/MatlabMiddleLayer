function plot_reson(a,b,c,fen)
% function plot_reson(a,b,c,fen)
% plot resonance whose equation is: a*fx+ b*fz = c 
% in a windows whose dimensions are in fen=[xmin xmax zmin zmax]
% eg:
% plot_reson(3,1,65,[18 19 10 11])
%
% Laurent S. Nadolski, Synchrotron SOLEIL, 02/04

%% Check input argument
if nargin < 3
    help reson
    return
end

%% build straight line equation
x=[fen(1) fen(2)];

if (b ~=0)
    y = (c-a*x)/b;
elseif (a ==0 & b ==0)
    % ne fait rien
    return
else
    x = c/a*ones(2,1);
    y = [fen(3) fen(4)];
end

%% define resonance order
order = abs(a)+abs(b);

%% appearance options depending on order
width = 0.5;
style = '-';

switch order
    case 1
        color = 'k';
        width = 3;
    case 2
        color = 'c';
    case 3
        color = 'm';
        style = '--';
    case 4
        color = 'r';
    case 5
        color = 'b';
    case 6
        color = 'y';
    case 7
        color = 'g';
    case 8
        color = 'c';
        style = '-.';
    case 9
        color = 'm';
        style = '-.';
    case 10
        color = 'y';
        style = '-.';
    case 11
        color = 'r';
        style = '-.';
    case 12
        color = 'g';
        style = '-.';
    case 13
        color = 'k';
        style = '-.';
    case 14
        color = 'b';
        style = '-.';
    case 15
        color = 'c';
        style = '--';
    otherwise
        color ='k';
        style = '--'
end

line(x,y,'LineWidth', width, 'LineStyle', style, 'Color',color);
