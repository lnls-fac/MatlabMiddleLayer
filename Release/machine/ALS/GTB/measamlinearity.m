
clear
Family = 'BEND';  % 'HCM' 'VCM' 'BEND' 'Q'
SP = [];
N = 11;
SP0 = getpv(Family, 'Struct');
Name = family2channel(Family);
Max = maxsp(Family);
Min = minsp(Family);
Delta = (Max-Min)/(N-1);
setsp(Family, Min, [], -4);
i = 1;
SP(:,i) = getsp(Family);
AM(:,i) = getam(Family);
for i = 2:N
    stepsp(Family, Delta, [], -4);
    SP(:,i) = getsp(Family);
    AM(:,i) = getam(Family);
end
setpv(SP0);

clear i 
save([Family,'_Linearity']);


