function [orbit, names] = uvxorbload(filename)

fileid = fopen(filename);

try
    % Read row names
    var = textscan(fileid, '%s%f', 'delimiter', '\t', 'CollectOutput', 1);
    names = var{1};
    orbit = var{2};
end

fclose(fileid);
