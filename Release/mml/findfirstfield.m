function Field = getfirstfield(Family)
%GETFIRSTFIELD - Return the first field of a family that has a .Mode and .Units field
% Field = getfirstfield(Family)

Field = '';

AOStruct = getfamilydata(Family);
if isempty(AOStruct)
    return;
end

FieldNames = fieldnames(AOStruct);
for j = 1:length(FieldNames)
    % Search for a field that has a .Mode and .Units subfields
    if isfield(AOStruct.(FieldNames{j}),'Mode') && isfield(AOStruct.(FieldNames{j}),'Units')
        Field = FieldNames{j};
        break;
    end
end
