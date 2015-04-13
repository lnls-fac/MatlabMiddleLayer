function bpm = lnls_AmpFactors_bpms(res)
%function bpm = lnls_AmpFactors_bpms(res)
%
% Calculates the amplification factors for orbit, correctors, betabeating
% and angle of the beam resulting from horizontal and vertical
% misalignments in bpms.
%
% INPUT: structure with fields:
%   the_ring
%   symmetry   - up to which longitudinal position to calculate
%   mis_err    - which is the misalignment error to apply to each bpm
%   cod_cor    - structure with fields: nr_sv, nr_iter, bpm_idx, hcm_idx,
%                vcm_idx, cod_respm;
%   where2calc - cell array of vectors with indexes of points of the_ring
%                where to average the amplification factors;
%
% OUTPUT: structure with fields:
%   pos - longitudinal position of the bpms
%   ind - index of the bpms in the the_ring lattice
%   misx, misy - structures with amplification factors fields: 
%                   orbx, orby - MxN matrices with orbit Amplif. Factors
%                   betx, bety - MxN matrices with betabeating Amplif. Factors
%                   coup       - 1xN vector with beam angle Amplif. Factors
%                   corx,cory  - 1XN vectros with correctors strength AF.
%                where M is the length of where2calc and N is #bpms in the
%                sector of the_ring defined by the symmetry variable.
%   
% Creation 2015-01-31 by Fernando.

if ~isfield(res,'cod_cor')
   error('If there is no orbit correction system defined, the bpms amplification factors are zero.');
end

the_ring = res.the_ring;
twi = calctwiss(the_ring);
position = findspos(the_ring,1:length(the_ring));
max_pos = position(end)/res.symmetry + 1e-3;

miss = {'misx','misy'};
errs = {res.mis_err,res.mis_err};

indcs = res.cod_cor.bpm_idx;
indcs = indcs(position(indcs) < max_pos);
nelem = length(indcs);
for i2=1:nelem
    ind = indcs(i2);
    bpm.pos(i2) = position(ind);
    bpm.ind(i2) = ind;
    for i3=1:length(miss)
        mis = miss{i3};
        mis_err = errs{i3};
        
        goal_codx = zeros(1,size(res.cod_cor.bpm_idx,1));
        goal_cody = zeros(1,size(res.cod_cor.bpm_idx,1));
        if strcmp(mis,'misx'), goal_codx(i2) = mis_err; else goal_cody(i2) = mis_err; end
        [the_ring_err, hkicks, vkicks, ~, ~] = cod_sg(res.cod_cor, the_ring, ...
                                                      goal_codx,goal_cody);
        boba = findorbit4(the_ring_err,0,1:length(the_ring));
        twi_err = calctwiss(the_ring_err);
        for i4=1:length(res.where2calc)
            bpm.(mis).orbx(i4,i2) = sqrt(lnls_meansqr(boba(1,res.where2calc{i4}),2))/mis_err;
            bpm.(mis).orby(i4,i2) = sqrt(lnls_meansqr(boba(3,res.where2calc{i4}),2))/mis_err;
            bpm.(mis).betx(i4,i2) = sqrt(lnls_meansqr((twi.betax(res.where2calc{i4})-twi_err.betax(res.where2calc{i4}))./twi.betax(res.where2calc{i4})))/mis_err;
            bpm.(mis).bety(i4,i2) = sqrt(lnls_meansqr((twi.betay(res.where2calc{i4})-twi_err.betay(res.where2calc{i4}))./twi.betay(res.where2calc{i4})))/mis_err;
        end
        Tilt2 = calccoupling(the_ring_err,false);
        bpm.(mis).coup(i2) =  sqrt(lnls_meansqr(Tilt2))/mis_err;
        bpm.(mis).corx(i2) =  sqrt(lnls_meansqr(hkicks))/mis_err;
        bpm.(mis).cory(i2) =  sqrt(lnls_meansqr(vkicks))/mis_err;
    end
end

fprintf('\n');
[bpm.ind,I] = sort(bpm.ind);
bpm.pos = bpm.pos(I);
for i3=1:length(miss)
    mis = miss{i3};
    bpm.(mis).orbx = bpm.(mis).orbx(:,I);
    bpm.(mis).betx = bpm.(mis).betx(:,I);
    bpm.(mis).corx = bpm.(mis).corx(I);
    bpm.(mis).orby = bpm.(mis).orby(:,I);
    bpm.(mis).bety = bpm.(mis).bety(:,I);
    bpm.(mis).cory = bpm.(mis).cory(I);
    bpm.(mis).coup = bpm.(mis).coup(I);
end