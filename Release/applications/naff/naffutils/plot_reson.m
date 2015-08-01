function plot_reson(a,b,c,fen,ax)
% function plot_reson(a,b,c,fen,ax)
% plot resonance whose equation is: a*fx+ b*fz = c 
% in axes ax, whose dimensions are in fen=[xmin xmax zmin zmax]
% eg:
% plot_reson(3,1,65,[18 19 10 11])
%
% Laurent S. Nadolski, Synchrotron SOLEIL, 02/04

%% Check input argument
if nargin < 3
    help reson
    return
end

if ~exist('ax','var'), ax = gca; end
%% build straight line equation
x=[fen(1) fen(2)];

if (b ~=0)
    y = (c-a*x)/b;
elseif (a ==0 && b ==0)
    % ne fait rien
    return
else
    x = c/a*ones(2,1);
    y = [fen(3) fen(4)];
end

%% define resonance order
order = abs(a)+abs(b);

%% appearance options depending on order
width = 1;
style = '-';

switch order
    case 1
        color = 'k';
        width = 3;
    case 2
        color = 'k';
        width = 2;
    case 3
        color = 'r';
        width = 2;
    case 4
        color = 'b';
        width = 2;
    case 5
        color = 'g';
        width = 2;
    case 6
        color = 'm';
    case 7
        color = 'c';
    case 8
        color = 'b';
        style = '-.';
    case 9
        color = 'r';
        style = '-.';
    case 10
        color = 'g';
        style = '-.';
    case 11
        color = 'k';
        style = '-.';
    case 12
        color = 'm';
        style = '-.';
    case 13
        color = 'k';
        style = '--';
    case 14
        color = 'c';
        style = '-.';
    case 15
        color = 'r';
        style = '--';
    otherwise
        color ='k';
        style = '--';
        width = 0.5;
end

plot(ax,x,y,'LineWidth', width, 'LineStyle', style, 'Color',color);
