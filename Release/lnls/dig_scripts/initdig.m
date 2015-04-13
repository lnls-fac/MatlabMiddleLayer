current_path = cd;

if strcmpi(current_path(end-10:end), 'dig_scripts')
    addpath(genpath(current_path));
else
    error('Please run this script from the dig_scripts directory.');
end