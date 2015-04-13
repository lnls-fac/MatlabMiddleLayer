function the_ring = lnls_simplify_lattice(the_ring0, varargin)

for i=1:length(varargin)
    if isstr(varargin{i}) && strcmpi(varargin{i}, 'CORout'), corout_flag = true; end;
end

the_ring = the_ring0;

% retira corretoras
if exist('corout_flag','var')
    idx = findcells(the_ring, 'PassMethod', 'CorrectorPass');
    the_ring(idx) = [];
end

% retira marcadores
idx = findcells(the_ring, 'PassMethod', 'IdentityPass');
the_ring(idx) = [];

% une driftspaces
the_ring1 = the_ring;
the_ring = {};
the_ring{1} = the_ring1{1};
for i=2:length(the_ring1)
    if strcmpi(the_ring{end}.PassMethod, 'DriftPass') && strcmpi(the_ring1{i}.PassMethod, 'DriftPass')
        the_ring{end}.Length = the_ring{end}.Length + the_ring1{i}.Length;
    else
        the_ring{end+1} = the_ring1{i};
    end
end