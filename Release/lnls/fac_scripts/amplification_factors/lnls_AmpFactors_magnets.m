function mag = lnls_AmpFactors_magnets(res)
%function mag = lnls_AmpFactors_magnets(res)
%
% Calculates the amplification factors for orbit, correctors, betabeating
% and angle of the beam resulting from horizontal and vertical
% misalignments, excitation and rotation erros in magnets.
%
% INPUT: structure with fields:
%   the_ring
%   symmetry   - up to which longitudinal position to calculate;
%   mis_err    - The misalignment error to apply to each magnet;
%   exc_err    - The excitation error to apply to each magnet;
%   rot_err    - The rotation error to apply to each magnet;
%   cod_cor    - Structure with fields: nr_sv, nr_iter, bpm_idx, hcm_idx,
%                vcm_idx, cod_respm. If non-existent, the calculation will
%                be performed without orbit correction;
%   where2calc - Cell array of vectors with indexes of points of the_ring
%                where to average the amplification factors;
%   labels     - Cell array of strings with the family names of the magnets
%                to be included in the calculations;
%   nrsegs     - Vector with the number of segments each magnet from a
%                given family is divided in the model.
%
% OUTPUT: structure with fields:
%   pos - longitudinal position of the bpms
%   ind - index of the bpms in the the_ring lattice
%   misx, misy - structures with amplification factors fields: 
%   exci, roll      orbx, orby - MxN matrices with orbit Amplif. Factors
%                   betx, bety - MxN matrices with betabeating Amplif. Factors
%                   coup       - 1xN vector with beam angle Amplif. Factors
%                   corx,cory  - 1XN vectros with correctors strength AF.
%                where M is the length of where2calc and N is #magnets in 
%                the sector of the_ring defined by the symmetry variable and
%                selected for calculation with the labels variable.
%   
% Creation 2015-01-31 by Fernando.

the_ring = res.the_ring;
twi = calctwiss(the_ring);
position = findspos(the_ring,1:length(the_ring));
max_pos = position(end)/res.symmetry + 1e-3;

funcs = {@lnls_add_misalignmentX,...
    @lnls_add_misalignmentY,...
    @lnls_add_excitation,...
    @lnls_add_rotation_ROLL};
miss = {'misx','misy','exci','roll'};
errs = {res.mis_err,res.mis_err,res.exc_err,res.rot_err};

mags = 0;
for i1 = 1:length(res.labels)
    %apply alignment errors
    fprintf([res.labels{i1} ', ']);
    indcs = findcells(the_ring, 'FamName',res.labels{i1});
    indcs = indcs(position(indcs) < max_pos);
    nelem = floor(length(indcs)/res.nrsegs(i1));
    for i2=1:nelem
        mags = mags+1;
        ind = indcs((i2-1)*res.nrsegs(i1)+1:i2*res.nrsegs(i1));
        mag.pos(mags) = mean(position([ind(1),ind(end)+1]));
        mag.ind(mags) = ind(1);
        for i3=1:length(miss)
            misalign = funcs{i3};
            mis = miss{i3};
            mis_err = errs{i3};
            err = repmat(mis_err,1,res.nrsegs(i1));
            the_ring_err = misalign(err,ind,the_ring);
            if isfield(res,'cod_cor')
                [the_ring_err, hkicks, vkicks, ~, ~] = cod_sg(res.cod_cor, the_ring_err);
            end
            boba = findorbit4(the_ring_err,0,1:length(the_ring));
            twi_err = calctwiss(the_ring_err);
            for i4=1:length(res.where2calc)
                mag.(mis).orbx(i4,mags) = sqrt(lnls_meansqr(boba(1,res.where2calc{i4}),2))/mis_err;
                mag.(mis).orby(i4,mags) = sqrt(lnls_meansqr(boba(3,res.where2calc{i4}),2))/mis_err;
                mag.(mis).betx(i4,mags) = sqrt(lnls_meansqr((twi.betax(res.where2calc{i4})-twi_err.betax(res.where2calc{i4}))./twi.betax(res.where2calc{i4})))/mis_err;
                mag.(mis).bety(i4,mags) = sqrt(lnls_meansqr((twi.betay(res.where2calc{i4})-twi_err.betay(res.where2calc{i4}))./twi.betay(res.where2calc{i4})))/mis_err;
            end
            Tilt2 = calccoupling(the_ring_err,false);
            mag.(mis).coup(mags) = sqrt(lnls_meansqr(Tilt2))/mis_err;
            if isfield(res,'cod_cor')
                mag.(mis).corx(mags) =  sqrt(lnls_meansqr(hkicks))/mis_err;
                mag.(mis).cory(mags) =  sqrt(lnls_meansqr(vkicks))/mis_err;
            end
        end
    end
end

fprintf('\n');
[mag.ind,I] = sort(mag.ind);
mag.pos = mag.pos(I);
for i3=1:length(miss)
    mis = miss{i3};
    mag.(mis).orbx = mag.(mis).orbx(:,I);
    mag.(mis).betx = mag.(mis).betx(:,I);
    mag.(mis).orby = mag.(mis).orby(:,I);
    mag.(mis).bety = mag.(mis).bety(:,I);
    mag.(mis).coup = mag.(mis).coup(I);
    if isfield(res,'cod_cor')
        mag.(mis).corx = mag.(mis).corx(I);
        mag.(mis).cory = mag.(mis).cory(I);
    end
end
