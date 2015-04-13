function r = calc_constraints_LowEmittanceTunes

global THERING;
ML = findcells(THERING, 'FamName', 'ML');
MM = findcells(THERING, 'FamName', 'MM');
MS = findcells(THERING, 'FamName', 'MS');
MC = findcells(THERING, 'FamName', 'MC');


calctwiss;
i=0;

i=i+1; r(i,1) = THERING{end}.Twiss.mu(1)/(2*pi);    % sintonia horizontal
i=i+1; r(i,1) = THERING{end}.Twiss.mu(2)/(2*pi);    % sintonia vertical


for k=1:length(ML)
    i=i+1; r(i,1) = THERING{ML(k)}.Twiss.alpha(1);  % alphaX centro do ML
    i=i+1; r(i,1) = THERING{ML(k)}.Twiss.alpha(2);  % alphaY centro do ML
    i=i+1; r(i,1) = THERING{ML(k)}.Twiss.Dispersion(2);  % etaX centro do ML
end
for k=1:length(MM)
    i=i+1; r(i,1) = THERING{MM(k)}.Twiss.alpha(1);  % alphaX centro do MM
    i=i+1; r(i,1) = THERING{MM(k)}.Twiss.alpha(2);  % alphaY centro do MM
    i=i+1; r(i,1) = THERING{MM(k)}.Twiss.Dispersion(2);  % etaX centro do MM
end
for k=1:length(MS)
    i=i+1; r(i,1) = THERING{MS(k)}.Twiss.alpha(1);  % alphaX centro do MS
    i=i+1; r(i,1) = THERING{MS(k)}.Twiss.alpha(2);  % alphaY centro do MS
    i=i+1; r(i,1) = THERING{MS(k)}.Twiss.Dispersion(2);  % etaX centro do MS
end
for k=1:length(MC)
    i=i+1; r(i,1) = THERING{MC(k)}.Twiss.alpha(1);  % alphaX centro do MC
    i=i+1; r(i,1) = THERING{MC(k)}.Twiss.alpha(2);  % alphaY centro do MC
    i=i+1; r(i,1) = THERING{MC(k)}.Twiss.Dispersion(2);  % etaX centro do MC
end





