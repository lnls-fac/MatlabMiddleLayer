function info = collect_info_coup(the_ring, coup, lattice_symmetry)

if ~exist('lattice_symmetry','var'), lattice_symmetry = 1; end
stepK0 = 0.001;

fprintf('-  collecting info for coupling respm calculation ...\n');
fprintf('   (this routine is yet to be generalized for arbitrary segmented skew quadrupole models!)\n');
fprintf('   qs:%03i\n', size(coup.scm_idx,1));

% Test hysteresis
hyster = 0.0;
stepK = stepK0*(1-hyster);% Test hysteresis

len_scms= size(coup.scm_idx,1)/lattice_symmetry;
len_bpm = size(coup.bpm_idx,1)/lattice_symmetry;
len_hcm = size(coup.hcm_idx,1)/lattice_symmetry;
len_vcm = size(coup.vcm_idx,1)/lattice_symmetry;
if logical(mod(len_scms,1))
    len_scms = len_scms*lattice_symmetry;
    len_bpm = len_bpm*lattice_symmetry;
    len_hcm = len_hcm*lattice_symmetry;
    len_vcm = len_vcm*lattice_symmetry;
    lattice_symmetry = 1;
end

info = cell(1,len_scms*lattice_symmetry);

% this routine has to be generalized for arbitrary skew quad segmented models !!!

lnls_create_waitbar('Colecting Info for Coupling Respm Calculation',0.5,len_scms);
K = getcellstruct(the_ring, 'PolynomA', coup.scm_idx(1:len_scms,1), 1, 2);
the_ring_calc = the_ring;
for i1=1:len_scms
    the_ring_calc = setcellstruct(the_ring_calc, 'PolynomA', coup.scm_idx(i1,:), K(i1) + stepK/2, 1, 2);
    [Mp, Dispp, tunep] = get_matrix_disp(the_ring_calc, coup.bpm_idx, coup.hcm_idx, coup.vcm_idx);
    the_ring_calc = setcellstruct(the_ring_calc, 'PolynomA', coup.scm_idx(i1,:), K(i1) - stepK, 1, 2);
    [Mn, Dispn, tunen] = get_matrix_disp(the_ring_calc, coup.bpm_idx, coup.hcm_idx, coup.vcm_idx);
    the_ring_calc = setcellstruct(the_ring_calc, 'PolynomA', coup.scm_idx(i1,:), K(i1) + stepK/2, 1, 2);
    
    info{i1} = struct('M',(Mp-Mn)/stepK0,'Disp',(Dispp-Dispn)/stepK0, 'Tune',(tunep-tunen)/stepK0);
    lnls_update_waitbar(i1)
end
lnls_delete_waitbar;


if lattice_symmetry ~= 1
    for i1=1:len_scms
        M = mat2cell(info{i1}.M, lattice_symmetry*len_bpm*[1 1], lattice_symmetry*[len_hcm len_vcm]);
        Mxx = M{1,1};
        Mxy = M{1,2};
        Myx = M{2,1};
        Myy = M{2,2};
        Disp = info{i1}.Disp;
        for i2=1:(lattice_symmetry-1)
            Mxx = circshift(Mxx,[len_bpm, len_hcm]);
            Myx = circshift(Myx,[len_bpm, len_hcm]);
            Mxy = circshift(Mxy,[len_bpm, len_vcm]);
            Myy = circshift(Myy,[len_bpm, len_vcm]);
            Disp = circshift(Disp,[0,len_bpm]);
            info{i1+len_scms*i2}.M = [Mxx,Mxy;Myx,Myy];
            info{i1+len_scms*i2}.Disp = Disp;
            info{i1+len_scms*i2}.Tune = info{i1}.Tune;
        end
    end
end