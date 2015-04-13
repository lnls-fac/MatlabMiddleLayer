function [k, tab]=reson(ordre,period,fen)
% function reson(ordre, period, fen)
% Recherche des droites de resonance a x + b y = c
% passant dans la fenetre [x1 x2 y1 y2]
% Ordre de la resonance |a| + |b|
% Critere de recherche c = period * entie
% eg:
% [k, tab] = reson(4,1,[18 19 10 11]
%
% Laurent S. Nadolski, Synchrotron SOLEIL, 02/04

%% check argument number
if nargin < 2
    help reson
    return
end

%% window dimensions
x1=fen(1); x2=fen(2); y1=fen(3); y2=fen(4);

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
                        plot_reson(m1,m2,m3,fen)
                    end
                    
                end
            end
        end
    end
end        

function d = distance(m1,m2,m3,fen)
% calcul la distance entre la droite et la centre de la fenetre
% centre de la fenetre
pt= [fen(1) + (fen(2)-fen(1))/2, fen(3) + (fen(4)-fen(3))/2];

d = dist_point_droite(m1,m2,m3,pt);