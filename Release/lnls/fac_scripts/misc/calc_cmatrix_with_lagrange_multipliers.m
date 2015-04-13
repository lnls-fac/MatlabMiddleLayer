function calc_cmatrix_with_lagrange_multipliers(varargin)

% default input arguments
extract_bpm_list  = {'AMP11A', 'AMP11B'};
extract_hcm_list  = {};
extract_vcm_list  = {};
lagrange_bpm_list = {'AMU11A', 'AMU11B'}; 
toler             = 0.0001;


disp('BPMs extraídos:');
disp(extract_bpm_list);
disp('HCMs extraídos:');
disp(extract_hcm_list);
disp('VCMs extraídos:');
disp(extract_vcm_list);

% reads data from response matrix file
[FileName,PathName,FilterIndex] = uigetfile({'*.resp'});
if FileName == 0, return; end
filename = fullfile(PathName,FileName);
data = importdata(filename);
bpms = data.textdata(3:(size(data.textdata,1)+2)/2,1);
corr = data.textdata(2,2:end)';
for i=1:length(bpms)
    bpms{i} = bpms{i}(1:end-1);
end
% calcs number of bpms, hcors and vcors. 
% creates lists 'hcor' and 'vcor' with correctors names
nr_bpms = length(bpms);
nr_hcor = 0;
nr_vcor = 0;
for i=1:length(corr)
    cor_name = corr{i};
    if cor_name(3) == 'H'
        nr_hcor = nr_hcor + 1;
        hcor{nr_hcor} = cor_name;
    else
        nr_vcor = nr_vcor + 1;
        vcor{nr_vcor} = cor_name;
    end
end

% extracts response matrices for horiz. and vert. orbit corrections
mrx = data.data(1:nr_bpms, 1:nr_hcor);
mry = data.data(nr_bpms+1:end, nr_hcor+1:end);

% builds index 'extract_bpm_index_list' list of bpms to be extracted
extract_bpm_index_list = [];
for i=1:length(extract_bpm_list)
    for j=1:length(bpms)
        if strcmpi(bpms{j},extract_bpm_list{i})
            break;
        end
    end
    extract_bpm_index_list(end+1) = j;
end
extract_bpm_index_list = sort(extract_bpm_index_list);

% builds index 'extract_hcm_index_list' list of hcm to be extracted
extract_hcm_index_list = [];
for i=1:length(extract_hcm_list)
    for j=1:nr_hcor
        if strcmpi(hcor{j},extract_hcm_list{i})
            break;
        end
    end
    extract_hcm_index_list(end+1) = j;
end
extract_hcm_index_list = sort(extract_hcm_index_list);

% builds index 'extract_vcm_index_list' list of vcm to be extracted
extract_vcm_index_list = [];
for i=1:length(extract_vcm_list)
    for j=1:nr_vcor
        if strcmpi(vcor{j},extract_vcm_list{i})
            break;
        end
    end
    extract_vcm_index_list(end+1) = j;
end
extract_vcm_index_list = sort(extract_vcm_index_list);


% builds index 'lagrande_bpm_index_list' list of bpms to be corrected
lagrange_bpm_index_list = [];
for i=1:length(lagrange_bpm_list)
    for j=1:length(bpms)
        if strcmpi(bpms{j},lagrange_bpm_list{i})
            break;
        end
    end
    lagrange_bpm_index_list(end+1) = j;
end
lagrange_bpm_index_list = sort(lagrange_bpm_index_list);

% updates mrx and mry without extracted hcm and vcm
mrx(:,extract_hcm_index_list) = [];
mry(:,extract_vcm_index_list) = [];

ccx = mrx(lagrange_bpm_index_list, :); 

% updates mrx and mry without extracted bpms
mrx(extract_bpm_index_list, :) = [];
mry(extract_bpm_index_list, :) = [];





% generates correction matrices 'mcx' and 'mcy'

A = mrx' * mrx;
n = size(A,1);
[U W V] = svd(A, 'econ');
IW = W';
for i=1:n
    if (W(i,i)>toler), IW(i,i) = 1 / W(i,i); else IW(i,i) = 0; end
end
AI = V * IW * U';


P  = ccx * AI * ccx';
n = size(P,1);
[U W V] = svd(P, 'econ');
IW = W';
for i=1:n
    if (W(i,i)>toler), IW(i,i) = 1 / W(i,i); else IW(i,i) = 0; end
end
PI = V * IW * U';

B  = (-AI + AI * ccx' * PI * ccx * AI) * mrx';
DD = AI * ccx' * PI;


idx = 1:nr_bpms;
idx(extract_bpm_index_list) = [];
idx_hcm = 1:nr_hcor;
idx_hcm(extract_hcm_index_list) = []; %XIMENES
idx_vcm = 1:nr_vcor; %XIMENES
idx_vcm(extract_vcm_index_list) = []; %XIMENES


m1 = zeros(nr_hcor, nr_bpms);
%m1(:,lagrange_bpm_index_list) = DD;
m1(idx_hcm,lagrange_bpm_index_list) = DD; %XIMENES

m2 = zeros(nr_hcor, nr_bpms);
% m2(:,idx) = B;
m2(idx_hcm, idx) = B;  %XIMENES

mcx = m2 - m1;

n = nr_vcor;
[U W V] = svd(mry, 'econ');
IW = W';
for i=1:n
    if (W(i,i)>toler), IW(i,i) = 1 / W(i,i); else IW(i,i) = 0; end
end
m1 = - V * IW * U';

m2 = zeros(nr_vcor, nr_bpms);
%mcy(:,idx) = m1;
mcy(idx_vcm,idx) = m1;




mc = zeros(nr_hcor+nr_vcor, 2*nr_bpms);
mc(1:nr_hcor, 1:nr_bpms) = mcx;
mc(nr_hcor+1:(nr_hcor+nr_vcor), nr_bpms+1:2*nr_bpms) = mcy;

% saves the correction matrix
DefaultName = fullfile(PathName, strrep(FileName, '.resp', '.corr'));
[FileName,PathName,FilterIndex] = uiputfile({'*.*'},'Gravar Matrix de Correção', DefaultName);
filename = fullfile(PathName, FileName);

fid = fopen(filename, 'w');
comments = ['Matrix de correção gerada automaticamente pelo script ''' mfilename ''' em ' datestr(now, 'yyyy-mm-dd HH:MM:SS') '.'];
fprintf(fid, '%s\r\n', comments);
for i=1:length(bpms)
    fprintf(fid, '%s\t', [bpms{i} 'H']);
end
for i=1:length(bpms)
    fprintf(fid, '%s\t', [bpms{i} 'V']);
end
fprintf(fid, '\r\n');

for i=1:size(mc,1)
    for j=1:size(mc,2)
        fprintf(fid,'%+12.9f\t', mc(i,j));
    end
    fprintf(fid,'\r\n');
end
fclose(fid);


