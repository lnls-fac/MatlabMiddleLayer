function bo_inj_lattice = build_bo_inj_lattice()
    % TB component
    sirius('TB');
    tb_lattice = sirius_tb_lattice_sept();
    tb_len = length(tb_lattice);
    
    % BO component
    sirius('BO');
    bo_lattice = sirius_bo_lattice();
    bo_len = length(bo_lattice);
    bo_lattice = shift_ring(bo_lattice, 'InjSept');
    bo_lattice = sirius_commis.bo_inj.vchamber_injection(bo_lattice);
    
    % Merging TB and BO
    bo_inj_lattice = cell(1, tb_len + bo_len);
    bo_inj_lattice(1:tb_len) = tb_lattice;
    bo_inj_lattice(tb_len+1:end) = bo_lattice;
end

