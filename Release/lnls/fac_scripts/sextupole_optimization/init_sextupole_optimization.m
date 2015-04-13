function r = init_sextupole_optimization

global THERING;

[r.pathstr, r.name, ext, versn] = fileparts(mfilename('fullpath'));
lnls1;
cd(r.pathstr);
setcavity('off');
setradiation('off');


%sextupole_families = {'SD', 'SF', {'SXL0', 'SXS0'}, {'SXL1', 'SXS1'}, {'SXL2', 'SXS2'}};
%r.sextupole_families = {'SD', 'SF', 'SXL0', 'SXS0', 'SXL1', 'SXS1', 'SXL2', 'SXS2'};
r.sextupole_families = {'A6SD01', 'A6SD02', 'A6SF'};

small_pos      = 0.01 * 1e-6;
r.small_pos    = small_pos;
r.nr_turns     = 512;
r.nr_sectors   = generate_simple_track_model;

% build 'element_idx' which is a cell array structure with info on AT
% indices for sextupoles of each family
element_idx = {};
for i=1:length(r.sextupole_families)
    famname = r.sextupole_families{i};
    family_idx{i} = [];
    if ischar(famname)
        element_idx{i} = findcells(THERING, 'FamName', famname);
    else
        element_idx{i} = [];
        for j=1:length(famname)
            element_idx{i} = [element_idx{i} findcells(THERING, 'FamName', famname{j})];
        end
    end
end

r.element_idx = element_idx;
r.nr_parms    = length(element_idx);
r.points       = [small_pos 0 small_pos 0 0 0];
r.tune0        = [0 0];
r.values       = get_sextupole_values(r);
r.spread       = calc_tune_spread(r); r.spread.fitness = 0;
r.tune0        = r.spread.tunes;
r.delta        = 0.1;

r.points       =  [ ...
    small_pos 0 small_pos 0 -0.03 0; ...
    small_pos 0 small_pos 0 -0.01 0; ...
    small_pos 0 small_pos 0  0.01 0; ...
    small_pos 0 small_pos 0  0.03 0; ...
    -0.025    0 small_pos 0  0    0; ...
    -0.010    0 small_pos 0  0    0; ...
     0.010    0 small_pos 0  0    0; ...
     0.025    0 small_pos 0  0    0; ...
    small_pos 0 0.001     0  0    0; ...
    small_pos 0 0.005     0  0    0; ...
     0.005    0 0.001     0  0.01 0; ...
];

r.configs      = {};
r = load_sextupole_configs(r);




