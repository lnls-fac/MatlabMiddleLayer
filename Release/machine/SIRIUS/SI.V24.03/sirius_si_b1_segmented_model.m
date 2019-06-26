function [model, model_length] = sirius_si_b1_segmented_model(passmethod, m_accep_fam_name)

b_famname = 'B1';
mb_famname = ['m',b_famname];
edge_famname = [b_famname, '_edge'];

if ~exist('passmethod','var'), passmethod = 'BndMPoleSymplectic4Pass'; end
if ~exist('m_accep_fam_name','var'), m_accep_fam_name = 'calc_mom_accep'; end

types = {};
b1      = 1; types{end+1} = struct('fam_name', b_famname, 'passmethod', passmethod);
b1_edge = 2; types{end+1} = struct('fam_name', edge_famname, 'passmethod', 'IdentityPass');
m_accep = 3; types{end+1} = struct('fam_name', m_accep_fam_name, 'passmethod', 'IdentityPass');


% Average Dipole Model for B1 at current 403p6A
% =============================================
% date: 2019-01-30
% Based on multipole expansion around average segmented model trajectory calculated
% from fieldmap analysis of measurement data
% init_rx =  8.527 mm
% ref_rx  = 13.693 mm (average model trajectory)
% goal_tunes = [49.096188917357331, 14.151971558423915];
% goal_chrom = [2.549478494984214, 2.527086095938103];

monomials = [0,1,2,3,4,5,6];
segmodel = [ ...
%type     len[m]   angle[deg]  PolyB(n=0)   PolyB(n=1)   PolyB(n=2)   PolyB(n=3)   PolyB(n=4)   PolyB(n=5)   PolyB(n=6) 
b1,       0.00200, 0.00633, -1.9696e-06, -7.2541e-01, -5.4213e-01, +5.4347e+00, +2.5091e+02, +4.9772e+02, -1.9113e+06; 
b1,       0.00300, 0.00951, -3.8061e-06, -7.2968e-01, -4.5292e-01, +4.3822e+00, +3.1863e+02, +1.5282e+03, -2.3387e+06; 
b1,       0.00500, 0.01592, -4.7568e-07, -7.4227e-01, -2.1669e-01, +2.9544e+00, +2.9316e+02, +1.4632e+03, -2.0877e+06; 
b1,       0.00500, 0.01603, -1.9480e-06, -7.5771e-01, -1.0657e-02, +3.5007e+00, +2.9571e+02, -1.7742e+03, -2.0010e+06; 
b1,       0.00500, 0.01611, -2.7633e-06, -7.6662e-01, +3.3285e-02, +4.7919e+00, +3.3381e+02, -3.3109e+03, -2.0402e+06; 
b1,       0.01000, 0.03236, -1.9098e-06, -7.7081e-01, +1.6451e-02, +5.3028e+00, +3.7119e+02, -4.8877e+03, -2.0590e+06; 
b1,       0.04000, 0.12963, -1.6309e-06, -7.7247e-01, +4.8673e-02, +4.6505e+00, +3.3306e+02, -2.1646e+03, -1.5868e+06; 
b1,       0.15000, 0.48382, -1.9888e-06, -7.7332e-01, +9.7601e-02, +5.3336e+00, +2.5126e+02, +8.0649e+02, -9.2335e+05; 
b1,       0.10000, 0.32247, -2.1025e-06, -7.7271e-01, +1.1969e-01, +5.6811e+00, +2.1496e+02, +5.2023e+03, -6.0518e+05; 
b1,       0.05000, 0.16165, -2.1257e-06, -7.7203e-01, +5.6224e-02, +4.5293e+00, +6.3908e+01, +6.1651e+03, +3.4951e+05; 
b1,       0.03400, 0.10509, -1.8623e-06, -7.7144e-01, -1.2160e-01, +9.1976e+00, -5.3231e+01, +9.0360e+03, +7.2783e+05; 
b1_edge, 0,0,0,0,0,0,0,0,0;
b1,       0.01600, 0.03414, -9.6169e-07, -4.5231e-01, -1.8149e+00, +1.9400e+01, -2.2843e+02, +1.6525e+04, -4.0477e+04; 
b1,       0.04000, 0.03296, -5.2504e-07, -8.6643e-02, -1.7536e+00, +8.5147e+00, -5.8350e+01, +4.2954e+03, -3.7834e+04; 
b1,       0.04000, 0.00774, -1.6259e-07, -8.3065e-03, -3.8990e-01, +1.3183e+00, +2.5814e+01, +3.1642e+02, -5.0464e+04; 
b1,       0.05000, 0.00384, -7.9445e-08, -1.0742e-03, -9.8271e-02, +5.0359e-02, -1.0312e+01, +9.0013e+02, +8.2477e+04; 
m_accep, 0,0,0,0,0,0,0,0,0; 
];


% turns deflection angle error off (convenient for having a nominal model with zero 4d closed orbit)
segmodel(:,4) = 0;


% builds half of the magnet model
d2r = pi/180.0;
b = zeros(1,size(segmodel,1));
maxorder = 1+max(monomials);
for i=1:size(segmodel,1)
    type = types{segmodel(i,1)};
    if strcmpi(type.passmethod, 'IdentityPass')
        b(i) = marker(type.fam_name, 'IdentityPass');
    else
        PolyB = zeros(1,maxorder); PolyA = zeros(1,maxorder);
        PolyB(monomials+1) = segmodel(i,4:end);
        PolyB(1) = 0.0; PolyA(1) = 0.0; % convenience of a nominal lattice with zero 4D closed-orbit.
        b(i) = rbend_sirius(type.fam_name, segmodel(i,2), d2r * segmodel(i,3), 0, 0, 0, 0, 0, PolyA, PolyB, passmethod);
    end
end

% builds entire magnet model, inserting additional markers
model_length = 2*sum(segmodel(:,2));
mb1 = marker(mb_famname, 'IdentityPass');
m_accep = marker(types{m_accep}.fam_name, 'IdentityPass');
model = [fliplr(b), mb1, m_accep, b];
