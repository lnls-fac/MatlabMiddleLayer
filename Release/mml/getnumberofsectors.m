function [N, Nsymmetry] = getnumberofsectors
%GETNUMBEROFSECTORS - Number of sectors in the lattice
%  [N, Nsymmetry] = getnumberofsectors


% Get the sectors from the device list.
% Guess at a few family names.
List = family2dev(gethbpmfamily);
if isempty(List)
    List = family2dev(gethcmfamily);
end
if isempty(List)
    List = family2dev('BEND');
end

if isempty(List)
    N = 1;
else
    N = max(List(:,1));
end

if nargout >= 2
    if strcmpi(getfamilydata('Machine'), 'NSLS2')
        Nsymmetry = 15; %N/2;
    elseif strcmpi(getfamilydata('Machine'), 'SPEAR3')
        Nsymmetry = 2;
    elseif strcmpi(getfamilydata('Machine'), 'SSRF')
        Nsymmetry = 4;
    elseif strcmpi(getfamilydata('Machine'), 'ALBA')
        Nsymmetry = 4;
    elseif strcmpi(getfamilydata('Machine'), 'ELSA')
        Nsymmetry = 1;
    elseif strcmpi(getfamilydata('Machine'), 'Bessy2')
        Nsymmetry = 4;
    elseif strcmpi(getfamilydata('Machine'), 'MLS')
        Nsymmetry = 2;
    else
        Nsymmetry = N;
    end
end

