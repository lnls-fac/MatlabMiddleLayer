function [codx, cody] = calc_cod(the_ring, dim)


if ~exist('dim', 'var')
    dim = '4d';
end

if strcmpi(dim, '6d')
    orb = findorbit6(the_ring, 1:length(the_ring));
else
    orb = findorbit4(the_ring, 0, 1:length(the_ring));
end

codx = orb(1,:);
cody = orb(3,:);
