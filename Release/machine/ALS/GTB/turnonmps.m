function turnonmps(Sector)
%TURNONMPS - Turn on all the storage ring magnet power supplies
%
%  See also turnoffmps


% Get all magnet families
MPSFamilies = findmemberof('Magnet');


% Remove families
RemoveFamilyNames = {};
for i = 1:length(RemoveFamilyNames)
    j = find(strcmpi(RemoveFamilyNames{i}, MPSFamilies));
    MPSFamilies(j) = [];
end


% Turn the magnet on
% setsp_OnControlMagnet will do the work
for i = 1:length(MPSFamilies)
    try
        fprintf('   Turning on %s\n', MPSFamilies{i});
        setpv(MPSFamilies{i}, 'OnControl', 1);
        
        % Some delay between families is a good idea
        pause(1);
    catch
    end
end
