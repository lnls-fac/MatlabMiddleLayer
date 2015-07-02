function girder = lnls_AmpFactors_girders(res, bpm_on)
%function girder = lnls_AmpFactors_girders(res, bpm_on)
%
% Calculates the amplification factors for orbit, correctors, betabeating
% and angle of the beam resulting from horizontal and vertical
% misalignments and rotation errors in girders.
%
% INPUTS: 
% bpm_on     - Flag indicating if the bpms move correlated to the girder.
%
% structure with fields:
%   the_ring
%   symmetry   - up to which longitudinal position to calculate
%   mis_err    - which is the misalignment error to apply to each girder
%   rot_err    - Rotation error to apply to the magnets on the girder;
%   cod_cor    - structure with fields: nr_sv, nr_iter, bpm_idx, hcm_idx,
%                vcm_idx, cod_respm. If non-existent, the calculation will
%                be performed without orbit correction;
%   where2calc - cell array of vectors with indexes of points of the_ring
%                where to average the amplification factors;
%
% OUTPUT: structure with fields:
%   bpm_on - Flag indicating if the bpms moved with the girders
%   pos - longitudinal position of the girders
%   ind - index of the first element in the the_ring lattice which belongs
%         to the girder
%   misx, misy - structures with amplification factors fields:
%   roll            orbx, orby - MxN matrices with orbit Amplif. Factors
%                   betx, bety - MxN matrices with betabeating Amplif. Factors
%                   coup       - 1xN vector with beam angle Amplif. Factors
%                   corx,cory  - 1XN vectros with correctors strength AF.
%                where M is the length of where2calc and N is #girders in the
%                sector of the_ring defined by the symmetry variable.
%
% Creation 2015-02-02 by Fernando.
girder.bpm_on = bpm_on;

the_ring = res.the_ring;
twi = calctwiss(the_ring);
position = findspos(the_ring,1:length(the_ring));
max_pos = position(end)/res.symmetry + 1e-3;

funcs = {@lnls_add_misalignmentX,...
    @lnls_add_misalignmentY,...
    @lnls_add_rotation_ROLL};
miss = {'misx','misy','roll'};
errs = {res.mis_err,res.mis_err,res.rot_err};

indcs = findcells(the_ring,'Girder');
indcs = indcs(position(indcs) < max_pos);
girders = unique(getcellstruct(the_ring,'Girder',indcs));
for i1 = 1:length(girders)
    %apply alignment errors
    gir = girders{i1};
    fprintf([gir ', ']);
    ind = findcells(the_ring,'Girder',gir);
    girder.ind(i1) = ind(1);
    girder.pos(i1) = mean(position([ind(1),ind(end)+1]));
    for i2=1:length(miss)
        misalign = funcs{i2};
        mis = miss{i2};
        mis_err = errs{i2};
        err = repmat(mis_err,1,length(ind));
        the_ring_err = misalign(err,ind,the_ring);
        if isfield(res,'cod_cor')
            par = res.cod_cor;
            [~,~,idx] = intersect(ind,par.bpm_idx);
            goal_codx = zeros(1,size(par.bpm_idx,1));
            goal_cody = zeros(1,size(par.bpm_idx,1));
            if bpm_on && ~isempty(idx)
                if strcmp(mis,'misx'), goal_codx(idx) = mis_err;
                elseif strcmp(mis,'misy'), goal_cody(idx) = mis_err; end
            end
            [the_ring_err, hkicks, vkicks, ~, ~] = cod_sg(par, the_ring_err, ...
                                                          goal_codx, goal_cody);
        end

        boba = findorbit4(the_ring_err,0,1:length(the_ring));
        twi_err = calctwiss(the_ring_err);
        for i3=1:length(res.where2calc)
            girder.(mis).orbx(i3,i1) = sqrt(lnls_meansqr(boba(1,res.where2calc{i3}),2))/mis_err;
            girder.(mis).orby(i3,i1) = sqrt(lnls_meansqr(boba(3,res.where2calc{i3}),2))/mis_err;
            girder.(mis).betx(i3,i1) = sqrt(lnls_meansqr((twi.betax(res.where2calc{i3})-twi_err.betax(res.where2calc{i3}))./twi.betax(res.where2calc{i3})))/mis_err;
            girder.(mis).bety(i3,i1) = sqrt(lnls_meansqr((twi.betay(res.where2calc{i3})-twi_err.betay(res.where2calc{i3}))./twi.betay(res.where2calc{i3})))/mis_err;
        end
        Tilt2 = calccoupling(the_ring_err,false);
        girder.(mis).coup(i1) = sqrt(lnls_meansqr(Tilt2))/mis_err;
        if isfield(res,'cod_cor')
            girder.(mis).corx(i1) =  sqrt(lnls_meansqr(hkicks))/mis_err;
            girder.(mis).cory(i1) =  sqrt(lnls_meansqr(vkicks))/mis_err;
        end
    end
end
fprintf('\n');
