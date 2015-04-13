function turnoffmps(Sector)
%TURNOFFMPS - Turn off all the storage ring magnet power supplies
%
%  See also turnonmps


% Get all magnet families
MPSFamilies = findmemberof('Magnet');

% Remove families
RemoveFamilyNames = {};
for i = 1:length(RemoveFamilyNames)
    j = find(strcmpi(RemoveFamilyNames{i}, MPSFamilies));
    MPSFamilies(j) = [];
end

% Double check that all magnets are at zero current
for i = 1:length(MPSFamilies)
    try
        setsp(MPSFamilies{i}, 0, [], 0);
    catch
    end
end
% Unfortunately the SP-AM comparison does not work well at zero current
% So test that the AM are not greater than ??? amps  (to be done!!!)
% for i = 1:length(MPSFamilies)
%     try
%         %setsp(MPSFamilies{i}, 0, [], -1);
%     catch
%     end
% end

% If not doing a WaitFlag=-1, then add some delay
% The correctors and chicanes are probably the only magnets stil ramping down
pause(10);

% Turn the magnet off
for i = 1:length(MPSFamilies)
    try    
        fprintf('   Turning off %s\n', MPSFamilies{i});
        setpv(MPSFamilies{i}, 'OnControl', 0);
    catch
    end
end

