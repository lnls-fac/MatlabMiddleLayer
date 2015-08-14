function [k, tab]=reson(ordre,period,fen,ax,Tag)
% reson(ordre, period, fen, ax, Tag)
% Recherche des droites de resonance a x + b y = c
% passant dans la fenetre [x1 x2 y1 y2]
% Ordre de la resonance |a| + |b|
% Critere de recherche c = period * entie
% eg:
% Soleil
% [k, tab] = reson(4,1,[18 19 10 11])
%
% ALS
% [k, tab] = reson(4,1,[14 15 9 10])
%

% Laurent S. Nadolski, Synchrotron SOLEIL, 02/04

%% check argument number
if nargin < 2
    help reson
    return
end


%% window dimensions
x1=fen(1); 
x2=fen(2); 
y1=fen(3); 
y2=fen(4);

tab = [];
k=0;
%% diagonal of the window used to check wether resonsonce is within the
%% window frame
d0 = sqrt(power(fen(2)-fen(1),2) + power(fen(4)-fen(3),2))/2;

%% Look for resonance
for m1 = -ordre:ordre
    am1 = abs(m1);
    for m2 = -ordre+am1:ordre-am1
        %%% Recherche des bornes de C
        if (m2 == 0)
            c(1)=m1*x1;
            c(2)=m1*x2;            
        elseif (m1/m2<=0)
            c(1)= m1*x1+m2*y2;
            c(2)= m1*x2+m2*y1;
        else
            c(1)= m1*x1+m2*y1;
            c(2)= m1*x2+m2*y2;
        end
        cmin = floor(min(c));
        cmax= floor(max(c));
        
        for m3=cmin:cmax        
            if (mod(m3,period) == 0) 
                if (abs(m1) + abs(m2) == ordre)
                    % check whether resonance within the window
                    d = distance(m1,m2,m3,fen);   
                    if (d < d0)
                        k=k+1;
                        tab(k,:)=[m1 m2 m3];
                        plot_reson(m1,m2,m3,fen,ax, Tag)
                    end
                    
                end
            end
        end
    end
end        

if k
    % Force the first coefficient to be positive
    ind = tab(:,1) < 0;
    tab(ind,:) = -tab(ind,:);
    % If the first coefficient is zero, force the second positive
    ind = (tab(:,2) < 0) & (tab(:,1) == 0);
    tab(ind,:)=-tab(ind,:);
    
    %Find the greatest commom divisor of the three coefficients
    greatCommDiv =gcd(gcd(tab(:,1),tab(:,2)),gcd(tab(:,2),tab(:,3)));
    tab = tab./repmat(greatCommDiv,1,3);
    tab = unique(tab,'rows');
end

axis(ax,fen);


function d = distance(m1,m2,m3,fen)
% calcul la distance entre la droite et la centre de la fenetre
% centre de la fenetre
pt= [fen(1) + (fen(2)-fen(1))/2, fen(3) + (fen(4)-fen(3))/2];

d = dist_point_droite(m1,m2,m3,pt);



function d = dist_point_droite(m1,m2,m3,pt)
% calcul la distance entre la droite et un point pt
% droite m1 *x + m2 *y =m3
% pt =[0 2]
% dist_point_droite(1,2,4,pt)

% centre de la fenetre
P= [pt 0];

%vecteur directeur normalise
u = [-m2 m1 0];

if (norm(u)~=0) 
    u = u/norm(u);
end

% vecteur AP, ou A appartient a la droite et P est le centre de la fenetre
if (m1 ~= 0)
    A = [m3/m1 0 0];
elseif (m2 ~=0)
    A=[0 m3/m2 0];
else
    A=[0 0 0]
end

AP= P - A;

d = norm(cross(AP,u),2);
