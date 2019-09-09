function data = bpm_quality_bba(stat_bba, n_mach)

bpm_bom_x = zeros(n_mach, 160);
bpm_bom_y = zeros(n_mach, 160);
bpm_ruim_x = zeros(n_mach, 160);
bpm_ruim_y = zeros(n_mach, 160);


for i = 1:n_mach
    dcsv(i, :, :) = stat_bba{i}.decrease_value;
    dcsvx(i, :) = dcsv(i, :, 1);
    dcsvy(i, :) = dcsv(i, :, 2);
    result{i}.bpm_bom_x = find(dcsvx(i, :) < 0);
    result{i}.bpm_bom_y = find(dcsvy(i, :) < 0);
    result{i}.bpm_ruim_x = find(dcsvx(i, :) > 0);
    result{i}.bpm_ruim_y = find(dcsvy(i, :) > 0);
end

runIntersect_bom_x = result{1}.bpm_bom_x;
runIntersect_bom_y = result{1}.bpm_bom_y;
runIntersect_ruim_x = result{1}.bpm_ruim_x;
runIntersect_ruim_y = result{1}.bpm_ruim_y;
for k = 2:n_mach
    current_bom_x = result{i}.bpm_bom_x;
    runIntersect_bom_x = intersect(runIntersect_bom_x, current_bom_x);
    current_bom_y = result{i}.bpm_bom_y;
    runIntersect_bom_y = intersect(runIntersect_bom_y, current_bom_y);
    current_ruim_x = result{i}.bpm_ruim_x;
    runIntersect_ruim_x = intersect(runIntersect_ruim_x, current_ruim_x);
    current_ruim_y = result{i}.bpm_ruim_y;
    runIntersect_ruim_y= intersect(runIntersect_ruim_y, current_ruim_y);
end

data.good_bpm_x = runIntersect_bom_x;
data.good_bpm_y = runIntersect_bom_y;
data.bad_bpm_x = runIntersect_ruim_x;
data.bad_bpm_y = runIntersect_ruim_y;


end
function runIntersect = mintersect(varargin)
%MINTERSECT Multiple set intersection.
%   MINTERSECT(A,B,C,...) when A,B,C... are vectors returns the values 
%   common to all A,B,C... The result will be sorted.  A,B,C... can be cell
%   arrays of strings.  
%
%   MINTERSECT repeatedly evaluates INTERSECT on successive pairs of sets, 
%   which may not be very efficient.  For a large number of sets, this should
%   probably be reimplemented using some kind of tree algorithm.
%
%   MINTERSECT(A,B,'rows') when A,B,C... are matrices with the same
%   number of columns returns the rows common to all A,B,C...
%
%   See also INTERSECT
flag = 0;
if isempty(varargin)
    error('No inputs specified.')
else
    if isequal(varargin{end},'rows')
        flag = 'rows';
        setArray = varargin(1:end-1);
    else
        setArray = varargin;
    end
end
runIntersect = setArray{1};
for i = 2:length(setArray)
    
    if isequal(flag,'rows')
        runIntersect = intersect(runIntersect,setArray{i},'rows');
    elseif flag == 0
        runIntersect = intersect(runIntersect,setArray{i});
    else 
        error('Flag not set.')
    end
    
    if isempty(runIntersect)
        return
    end
    
end
end
