function analysis4


r.flags = {'~4d', 'load_ids', '~add_fakecorrectors', '~load_correctors', '~change_quads', 'change_hkicks', 'change_vkicks', 'load_the_ring', 'save_the_ring'};

r.parms.families =  {'A2QF01'};
r.parms.nr_sgvalues.A2QF01 = 2;
r.parms.the_ring_fname = 'the_ring_orb.mat';
r.parms.delta_pos = 001e-6; % [m]


r = fit_load_lattice_model(r); 
r = fit_get_measured_data(r);

r = fit_calcs_respm(r);

r = fit_calc_cod_from_magnets(r);
r = fit_calc_dcod_vectors(r);
r = fit_calc_dorb(r);

function r = fit_calc_dorb(r0)

r = r0;
families = r.parms.families;
for i=1:length(families)
    
    family = families{i};
    fd = r.respm.(family);
    if isfield(r.parms, 'nr_sgvalues') && isfield(r.parms.nr_sgvalues, family)
        nr_svs = r.parms.nr_sgvalues.(family);
    else
        nr_svs = length(fd.Sx);
    end
    
    % horizontal
    sel = ((1:length(fd.Sx)) > nr_svs);
    ivs = 1./fd.Sx;
    ivs(sel) = 0;
    iS = diag(ivs);
    r.respm.(family).dorbx = (fd.Vx*iS*fd.Ux')*fd.dcodx;
    % vertical
    sel = ((1:length(fd.Sy)) > nr_svs);
    ivs = 1./fd.Sy;
    ivs(sel) = 0;
    iS = diag(ivs);
    r.respm.(family).dorby = (fd.Vy*iS*fd.Uy')*fd.dcody;
    
    r_tmp = r;
    for j=1:length(r.respm.(family).dorbx
    r_tmp.the_ring = lnls_add_misalignmentX(+r.parms.delta_pos/2, quad_idx, r_tmp.the_ring0);
    
end


function r = fit_calc_dcod_vectors(r0)


r = r0;

families = r.parms.families;
for i=1:length(families)
    family = families{i};
    codx1 = r.meas_data.(family).codx;
    codx2 = r.calc_data.(family).codx;
    cody1 = r.meas_data.(family).cody;
    cody2 = r.calc_data.(family).cody;
    dcodx = codx1 - codx2;
    dcody = cody1 - cody2;
    r.respm.(family).dcodx = dcodx(:);
    r.respm.(family).dcody = dcody(:);
end



        
function r = fit_calcs_respm(r0)

r = r0;

families  = r.parms.families;
the_ring0 = r.the_ring; 

for i=1:length(families)
    family = families{i};
    idx = r.meas_data.(family).idx;
    for j=1:size(idx,1)
        quad_idx = idx(j,:);
        
        % horizontal
        r.the_ring = lnls_add_misalignmentX(+r.parms.delta_pos/2, quad_idx, the_ring0);
        rp = fit_calc_cod_from_magnets(r);
        r.the_ring = lnls_add_misalignmentX(-r.parms.delta_pos/2, quad_idx, the_ring0);
        rn = fit_calc_cod_from_magnets(r);
        codx = rp.calc_data.(family).codx - rn.calc_data.(family).codx;
        Mx(:,j) = codx / r.parms.delta_pos;
        % vertical
        r.the_ring = lnls_add_misalignmentY(+r.parms.delta_pos/2, quad_idx, the_ring0);
        rp = fit_calc_cod_from_magnets(r);
        r.the_ring = lnls_add_misalignmentY(-r.parms.delta_pos/2, quad_idx, the_ring0);
        rn = fit_calc_cod_from_magnets(r);
        cody = rp.calc_data.(family).cody - rn.calc_data.(family).cody;
        My(:,j) = cody / r.parms.delta_pos;
        
    end
    [U,S,V] = svd(Mx,'econ'); r.respm.(family).Mx = Mx; r.respm.(family).Ux = U; r.respm.(family).Vx = V; r.respm.(family).Sx = diag(S);
    [U,S,V] = svd(My,'econ'); r.respm.(family).My = My; r.respm.(family).Uy = U; r.respm.(family).Vy = V; r.respm.(family).Sy = diag(S);
end

r.the_ring = the_ring0;




