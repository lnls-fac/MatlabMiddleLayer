function R = tunespaceplot(XTUNE,YTUNE,RESORDER,varargin)
%tunespaceplot draws a tune diagram
% resonance lines: m*nu_x + n*nu_y = p
%
% R = tunespaceplot(XTUNE, YTUNE, RESORDER)
%
% XTUNE = [XTUNEMIN,XTUNEMAX] 
% YTUNE = [YTUNEMIN,YTUNEMAX] - plotting range in tune space
% RESORDER = vector of resonance orders: |m| + |n|
%
% R = Matrix in which each line represents a ressonance plotted, with the
% following informations:
%  order  m   n   p   extreme points of the drawn lines
%
% TUNESPACEPLOT(XTUNE, YTUNE, ORDER, AXESHANDLE): axeshandle is the handle
% to the axes to plot the resonances. If not present, the function
% generates a new figure;



 
% agora o script aceita o handle do eixo no qual as ressonancias serao
% plotadas e nao a figura:
if nargin>3
    if ishandle(varargin{1}) 
        % Plot tune space plot
        axes1 = varargin{1};
    else % create new figure
        h = figure;
        axes1 = axes('Parent',h);   
    end
end


box(axes1,'on');
axis(axes1, [XTUNE,YTUNE]);
axis square
        

R = zeros(8*length(RESORDER),6);
NLMAX = 0;
for r = RESORDER
    for m = 0:r
        n = r-m;
        
        % Lower
        p1 = ceil(m*XTUNE(1)+n*YTUNE(1));
        p2 = floor(m*XTUNE(2)+n*YTUNE(1));
        
            
        for p =p1:p2 
            if m % lines with m=0 do not cross upper and lower sides 
                NLMAX = NLMAX+1;
                R(NLMAX,:) = [abs(m)+abs(n),m,n,p,(p-n*YTUNE(1))/m,YTUNE(1)];
            end
        end
        
        % Left
        p1 = ceil(m*XTUNE(1)+n*YTUNE(1));
        p2 = floor(m*XTUNE(1)+n*YTUNE(2));
        
        
        for p =p1:p2
            if n % lines with n=0 do not cross left and right sides 
                NLMAX = NLMAX+1;
                R(NLMAX,:) = [abs(m)+abs(n),m,n,p,XTUNE(1),(p-m*XTUNE(1))/n];
            end
        end
        
        % Upper
        p1 = ceil(m*XTUNE(1)+n*YTUNE(2));
        p2 = floor(m*XTUNE(2)+n*YTUNE(2));
        
        for p=p1:p2
            if m
                NLMAX = NLMAX+1;
                R(NLMAX,:) = [abs(m)+abs(n),m,n,p,(p-n*YTUNE(2))/m,YTUNE(2)];
            end
        end
        
        % Right
        p1 = ceil(m*XTUNE(2)+n*YTUNE(1));
        p2 = floor(m*XTUNE(2)+n*YTUNE(2));
        
        for p=p1:p2
            if n
                NLMAX = NLMAX+1;
                R(NLMAX,:) = [abs(m)+abs(n),m,n,p,XTUNE(2),(p-m*XTUNE(2))/n];
            end
        end
        
        % ======================== 
        n = -r+m;
        
        % Lower
        p1 = ceil(m*XTUNE(1)+n*YTUNE(1));
        p2 = floor(m*XTUNE(2)+n*YTUNE(1));
        
        for p =p1:p2 
            if m % lines with m=0 do not cross upper and lower sides 
                NLMAX = NLMAX+1;
                R(NLMAX,:) = [abs(m)+abs(n),m,n,p,(p-n*YTUNE(1))/m,YTUNE(1)];
            end
        end
        
        % Left
        % Note: negative n
        p1 = floor(m*XTUNE(1)+n*YTUNE(1));
        p2 = ceil(m*XTUNE(1)+n*YTUNE(2));
        
        for p =p2:p1
            if n % lines with n=0 do not cross left and right sides 
                NLMAX = NLMAX+1;
                R(NLMAX,:) = [abs(m)+abs(n),m,n,p,XTUNE(1),(p-m*XTUNE(1))/n];
            end
        end
        
        % Upper
        p1 = ceil(m*XTUNE(1)+n*YTUNE(2));
        p2 = floor(m*XTUNE(2)+n*YTUNE(2));
        
        for p=p1:p2
            if m
                NLMAX = NLMAX+1;
                R(NLMAX,:) = [abs(m)+abs(n),m,n,p,(p-n*YTUNE(2))/m,YTUNE(2)];
            end
        end
        
        % Right
        % Note: negative n
        
        p1 = floor(m*XTUNE(2)+n*YTUNE(1));
        p2 = ceil(m*XTUNE(2)+n*YTUNE(2));
        for p=p2:p1
            if n
                NLMAX = NLMAX+1;
                R(NLMAX,:) = [abs(m)+abs(n),m,n,p,XTUNE(2),(p-m*XTUNE(2))/n];
            end
        end
    end
end
%R = sortrows(R(1:NLMAX,:));
R = unique(R(1:NLMAX,:),'rows');
[temp,I,J] = unique(R(:,1:4),'rows');
K = I(find(diff([0;I])==2))-1;

RESNUM = [R(K,1:4)]; % [o, m, n, p] O = |m| + |n|
X1 = R(K,5);
X2 = R(K+1,5);
Y1 = R(K,6);
Y2 = R(K+1,6);


% Remove accidental lines that are on the box edge
K1 = (X1==X2) & (X1==XTUNE(1));
K2 = (X1==X2) & (X1==XTUNE(2));
K3 = (Y1==Y2) & (Y1==YTUNE(1));
K4 = (Y1==Y2) & (Y1==YTUNE(2));

K = find(~(K1 | K2 | K3 | K4));


RESNUM = RESNUM(K,:);
X1 = X1(K);
X2 = X2(K);
Y1 = Y1(K);
Y2 = Y2(K);


R = [RESNUM,X1,Y1,X2,Y2];





% mudei o script original para plotar ressonancias de ordens diferentes com
% cores diferentes:
NL = size(RESNUM,1);
for i = 1:NL
    width = 0.5;
    style = '-';
    switch RESNUM(i,1)
        case 1
            color = 'k';
            width = 3;
        case 2
            color = 'k';
            width = 2;
        case 3
            color = 'b';
        case 4
            color = 'r';
        case 5
            color = 'm';
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
            style = '--';
    end
    
    hl = line([X1(i) X2(i)],[Y1(i) Y2(i)], 'Parent',axes1, 'Color', color, 'LineStyle',style,'LineWidth',width);
end


    