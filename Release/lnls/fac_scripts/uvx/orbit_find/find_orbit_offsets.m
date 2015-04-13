function find_orbit_offsets


r.flags = {...
    '~4d', 'load_ids', '~add_fakecorrectors', '~load_correctors', ...
    '~change_quads', 'change_hkicks', 'change_vkicks', 'load_the_ring', 'save_the_ring', ...
    '~plot_codx', '~plot_cody', 'plot_orb'...
    };

r.parms.families =  {'A2QF01', 'A2QF03', 'A2QF05', 'A2QF07', 'A2QF09', 'A2QF11', 'A2QD01', 'A2QD03', 'A2QD05', 'A2QD07', 'A2QD09', 'A2QD11', 'A6QF01', 'A6QF02'};
r.parms.nr_sgvalues.A6QF01 = 3;
r.parms.nr_sgvalues.A6QF02 = 3;
r.parms.the_ring_fname = 'the_ring_orb.mat';
r.parms.delta_pos = 001e-6; % [m]
r.parms.delta_K   = 0.02;


r = fit_load_lattice_model(r);
r = fit_get_measured_data(r);
r = fit_calc_respm(r);
r = fit_calc_orb(r);


r.ripple = load('ripple amplitudes at power harmonics.mat');

visualize_results(r);



function visualize_results(r)

pos = [];
orbx = [];
orby = [];

families = r.parms.families;

spos = findspos(r.the_ring, 1:length(r.the_ring));
for i=1:length(families)
    family = families{i};
    idx = r.meas_data.(family).idx(:,2);
    forbx = r.meas_data.(family).orbx;
    forby = r.meas_data.(family).orby;
    for j=1:length(idx)
        pos = [pos spos(idx(j))];
        orbx = [orbx; forbx(j)];
        orby = [orby; forby(j)];
    end
end

L = findspos(r.the_ring, 1+length(r.the_ring));

if any(strcmpi(r.flags, 'plot_orb'))
    figure; hold all; plot([0 L],[0 0], '--k'); plot(pos, 1e6*orbx, '.b'); xlabel('Pos [m]'); ylabel('Orbit Offset [um]'); title('Horizontal Orbit Offset w.r.t. Magnetic Centers');
    miny = 1e6*min(orbx(:)); maxy = 1e6*max(orbx(:)); heig = (maxy -miny)/2; offs = miny - heig/2; scal = heig/3; drawlattice(offs, scal, gca);
    
    figure; hold all; plot([0 L],[0 0], '--k'); plot(pos, 1e6*orby, '.r'); xlabel('Pos [m]'); ylabel('Orbit Offset [um]'); title('Vertical Orbit Offset w.r.t. Magnetic Centers');
    miny = 1e6*min(orby(:)); maxy = 1e6*max(orby(:)); heig = (maxy -miny)/2; offs = miny - heig/2; scal = heig/3; drawlattice(offs, scal, gca);
end


for j=1:length(families)
    family = families{j};
    idx = r.meas_data.(family).idx;
    cnames = family2common(family);
    for i=1:size(idx,1);
        orbx = 1e6 * r.meas_data.(family).orbx(i);
        orby = 1e6 * r.meas_data.(family).orby(i);
        fprintf('%s [um] -  H:%+8.2f  V:%+8.2f\n', cnames(i,:), orbx, orby);
    end
end


% hx = figure; hold all;
% hy = figure; hold all;
% leg = {};
% for j=1:length(families)
%     family = families{j};
%     A2K = hw2physics(family, 'Monitor', 1);
%     data = r.meas_data.(family);
%     signx = (data.codx / data.dK) * (r.ripple.ripples.(family)/1000) * A2K(1);
%     signy = (data.cody / data.dK) * (r.ripple.ripples.(family)/1000) * A2K(1);
%     leg = [leg family]; 
%     figure(hx); plot(signx(:,1) * 1e6);
%     figure(hy); plot(signy(:,1) * 1e6);
% end
% figure(hx); xlabel('BPM Index'); ylabel('CODx [um]'); legend(leg);
% figure(hx); xlabel('BPM Index'); ylabel('CODy [um]'); legend(leg);







function r = fit_calc_respm(r0)

r = r0;
families = r.parms.families;
for i=1:length(families)
    family = families{i};
    idx    = r.meas_data.(family).idx;
    dK     = r.meas_data.(family).dK;
    for j=1:size(idx,1)
       
        % horizontal
        the_ring = lnls_add_misalignmentX(+r.parms.delta_pos/2, idx(j,:), r.the_ring);        
        do_p = get_dorb_dK(the_ring, r.flags, family, dK);
        the_ring = lnls_add_misalignmentX(-r.parms.delta_pos/2, idx(j,:), r.the_ring);        
        do_n = get_dorb_dK(the_ring, r.flags, family, dK);
        r.meas_data.(family).RespMx(:,j) = (do_p(1,r.parms.bpms) - do_n(1,r.parms.bpms)) / r.parms.delta_pos;
        
        % vertical
        the_ring = lnls_add_misalignmentY(+r.parms.delta_pos/2, idx(j,:), r.the_ring);        
        do_p = get_dorb_dK(the_ring, r.flags, family, dK);
        the_ring = lnls_add_misalignmentY(-r.parms.delta_pos/2, idx(j,:), r.the_ring);        
        do_n = get_dorb_dK(the_ring, r.flags, family, dK);
        r.meas_data.(family).RespMy(:,j) = (do_p(3,r.parms.bpms) - do_n(3,r.parms.bpms)) / r.parms.delta_pos; 
    end
    
    do = get_dorb_dK(r.the_ring, r.flags, family, dK);
    r.meas_data.(family).codx0 = do(1,r.parms.bpms)';
    r.meas_data.(family).cody0 = do(3,r.parms.bpms)';
    
    Mx = r.meas_data.(family).RespMx; My = r.meas_data.(family).RespMy;
    [U,S,V] = svd(Mx,'econ'); r.meas_data.(family).Ux = U; r.meas_data.(family).Vx = V; r.meas_data.(family).Sx = diag(S);
    [U,S,V] = svd(My,'econ'); r.meas_data.(family).Uy = U; r.meas_data.(family).Vy = V; r.meas_data.(family).Sy = diag(S);
end

function do = get_dorb_dK(the_ring, flags, family, dK)

global THERING

THERING = the_ring;
ob = get_orbit(THERING, flags);
steppv(family, 'Physics', dK);
oa = get_orbit(THERING, flags);
steppv(family, 'Physics', -dK);
do = oa - ob;
        
function o = get_orbit(the_ring, flags)

if any(strcmpi(flags, '4d'))
    o   = findorbit4(the_ring, 0, 1:length(the_ring));
else
    o   = findorbit6(the_ring, 1:length(the_ring));
end

function r = fit_calc_orb(r0)


r = r0;
families = r.parms.families;

r.residue_x = [];
r.residue_y = [];

for i=1:length(families)
    
    family = families{i};
    fd = r.meas_data.(family);
    if isfield(r.parms, 'nr_sgvalues') && isfield(r.parms.nr_sgvalues, family)
        nr_svs = r.parms.nr_sgvalues.(family);
    else
        nr_svs = length(fd.Sx);
    end
    
    dK  = r.meas_data.(family).dK;
    idx = r.meas_data.(family).idx;
    
    % horizontal
    sel = ((1:length(fd.Sx)) > nr_svs);
    ivs = 1./fd.Sx;
    ivs(sel) = 0;
    iS = diag(ivs);
    r.meas_data.(family).orbx = (fd.Vx*iS*fd.Ux')*(fd.codx - fd.codx0);
    
    the_ring = lnls_add_misalignmentX(r.meas_data.(family).orbx, idx, r.the_ring);        
    do = get_dorb_dK(the_ring, r.flags, family, dK);
    r.meas_data.(family).dcodx = do(1,r.parms.bpms)';
    r.meas_data.(family).codx_calc = r.meas_data.(family).codx0 + r.meas_data.(family).dcodx;
    
    if any(strcmpi(r.flags, 'plot_codx'))
        figure; hold all; plot(1e6*r.meas_data.(family).codx);  plot(1e6*r.meas_data.(family).codx_calc); xlabel('BPM Index'); ylabel('COD [um]'); title(['HCOD for ' family]);
    end
    
    r.residue_x = [r.residue_x; r.meas_data.(family).codx - r.meas_data.(family).codx_calc];
    
    % vertical
    sel = ((1:length(fd.Sy)) > nr_svs);
    ivs = 1./fd.Sy;
    ivs(sel) = 0;
    iS = diag(ivs);
    r.meas_data.(family).orby = (fd.Vy*iS*fd.Uy')*(fd.cody - fd.cody0);
    
    the_ring = lnls_add_misalignmentY(r.meas_data.(family).orby, idx, r.the_ring);        
    do = get_dorb_dK(the_ring, r.flags, family, dK);
    r.meas_data.(family).dcody = do(3,r.parms.bpms)';
    r.meas_data.(family).cody_calc = r.meas_data.(family).cody0 + r.meas_data.(family).dcody;
    
    if any(strcmpi(r.flags, 'plot_cody'))
        figure; hold all; plot(1e6*r.meas_data.(family).cody);  plot(1e6*r.meas_data.(family).cody_calc); xlabel('BPM Index'); ylabel('COD [um]'); title(['VCOD for ' family]);
    end
    
    r.residue_y = [r.residue_y; r.meas_data.(family).cody - r.meas_data.(family).cody_calc];
    
    
end




        




