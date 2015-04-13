function convert_fmap

[FileName,PathName,~] = uigetfile('*.out','Selecione arquivo com dados NAFF',fileparts(mfilename('fullpath')));
if isempty(FileName), return; end;
fname = fullfile(PathName, FileName);


% Import the file
DELIMITER = ' ';
HEADERLINES = 3;
data = importdata(fname, DELIMITER, HEADERLINES);
data1 = data.data;

npts = size(data1,1);
x    = unique(data1(:,1));
dx   = diff(x); dx = [dx; dx(end)];
y    = unique(data1(:,2));
dy   = diff(y); dy = [dy; dy(end)];
vdy  = repmat(dy, length(x), 1);
vdx  = repmat(dx, 1, length(y))'; vdx  = vdx(:);
dtun = log10(sqrt(sum(data1(:,[5 6]).^2, 2)));

sel_out = (dtun == -Inf);

data2 = [zeros(npts,2) data1(:,[1 2]) vdx vdy data1(:,[3 4]) dtun];
data2(sel_out,:) = [];

dlmwrite(strrep(fname, '.out', '.txt'), data2, 'delimiter', ' ', 'newline', 'pc');