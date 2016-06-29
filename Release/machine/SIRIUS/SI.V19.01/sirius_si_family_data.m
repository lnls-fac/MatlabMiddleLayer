function data = sirius_si_family_data(the_ring)

data.b1.nr_segs    = 30;
data.b2.nr_segs    = 36;
data.bc_hf.nr_segs = 16;
data.bc_lf.nr_segs = 14;
data.bc.nr_segs    = 30;

data.qfa.nr_segs  = 1;
data.qda.nr_segs  = 1;
data.qdb2.nr_segs = 1;
data.qfb.nr_segs  = 1;
data.qdb1.nr_segs = 1;
data.qdp2.nr_segs = 1;
data.qfp.nr_segs  = 1;
data.qdp1.nr_segs = 1;
data.q1.nr_segs   = 1;
data.q2.nr_segs   = 1;
data.q3.nr_segs   = 1;
data.q4.nr_segs   = 1;

data.sda0.nr_segs = 1;
data.sdb0.nr_segs = 1;
data.sdp0.nr_segs = 1;
data.sda1.nr_segs = 1;
data.sdb1.nr_segs = 1;
data.sdp1.nr_segs = 1;
data.sda2.nr_segs = 1;
data.sdb2.nr_segs = 1;
data.sdp2.nr_segs = 1;
data.sda3.nr_segs = 1;
data.sdb3.nr_segs = 1;
data.sdp3.nr_segs = 1;
data.sfa0.nr_segs = 1;
data.sfb0.nr_segs = 1;
data.sfp0.nr_segs = 1;
data.sfa1.nr_segs = 1;
data.sfb1.nr_segs = 1;
data.sfp1.nr_segs = 1;
data.sfa2.nr_segs = 1;
data.sfb2.nr_segs = 1;
data.sfp2.nr_segs = 1;
data.sda4.nr_segs = 1;
data.sdb4.nr_segs = 1;
data.sdp4.nr_segs = 1;

data.bpm.nr_segs  = 1;
data.rbpm.nr_segs = 1;
data.fc.nr_segs   = 1;
data.fch.nr_segs  = 1;
data.fcv.nr_segs  = 1;
data.qs.nr_segs   = 1;
data.ch.nr_segs   = 1;
data.cv.nr_segs   = 1;
data.qn.nr_segs   = 1;
data.sn.nr_segs   = 1;


fams = fields(data);
for i=1:length(fams)
    data.(fams{i}).ATIndex = [];
    data.(fams{i}).ATFamilies = fams{i};
end
for i=1:length(the_ring)
    Fam = the_ring{i}.FamName;
    if any(strcmp(fams,Fam))
        data.(Fam).ATIndex = [data.(Fam).ATIndex; i];
    end
end
data.bc.ATIndex = sort([data.bc_lf.ATIndex; data.bc_hf.ATIndex]);
for i=1:length(fams)
    data.(fams{i}).ATIndex = reshape(data.(fams{i}).ATIndex,data.(fams{i}).nr_segs,[])';
end


% chs - slow horizontal correctors
idx = [];
idx = [idx; data.sda0.ATIndex];
idx = [idx; data.sfb0.ATIndex];
idx = [idx; data.sfp0.ATIndex];
idx = [idx; data.sda1.ATIndex];
idx = [idx; data.sdb1.ATIndex];
idx = [idx; data.sdp1.ATIndex];
idx = [idx; data.sfa2.ATIndex];
idx = [idx; data.sfb2.ATIndex];
idx = [idx; data.sfp2.ATIndex];
idx = sort(idx);
data.ch.ATIndex = reshape(idx,data.ch.nr_segs,[]);
data.ch.ATIndex = data.ch.ATIndex';

% cvs - slow vertical correctors
idx = [];
idx = [idx; data.sda0.ATIndex];
idx = [idx; data.sfb0.ATIndex];
idx = [idx; data.sfp0.ATIndex];
idx = [idx; data.sda1.ATIndex];
idx = [idx; data.sdb1.ATIndex];
idx = [idx; data.sdp1.ATIndex];
idx = [idx; data.sda3.ATIndex];
idx = [idx; data.sdb3.ATIndex];
idx = [idx; data.sdp3.ATIndex];
idx = [idx; data.sda4.ATIndex];
idx = [idx; data.sdb4.ATIndex];
idx = [idx; data.sdp4.ATIndex];


% In this version of the lattice, there is a cv corrector in the sextupoles
% sf2 of every sector C3 of the arc in the lattice. It means the corrector
% alternates between all SF2's. The logic bellow uses the
% dipoles B2 and BC_LF to determine where to put the corrector.
indcs = sort([data.sfa2.ATIndex; data.sfb2.ATIndex; data.sfp2.ATIndex]);
dips = sort([data.b2.ATIndex(:); data.bc_lf.ATIndex(:)]);
for i=1:length(indcs)
    el = find(dips > indcs(i),1,'first');
    if ~isempty(el)
        if strcmpi(the_ring{dips(el)}.FamName,'b2'), idx = [idx; indcs(i)];          
        elseif strcmpi(the_ring{dips(el)}.FamName,'bc_lf')
        else error('Problem with vertical corrector index definition.')
        end
        continue
    end
    el = find(dips < indcs(i),1,'last');
    if ~isempty(el)
        if strcmpi(the_ring{dips(el)}.FamName,'bc_lf'), idx = [idx; indcs(i)];          
        elseif strcmpi(the_ring{dips(el)}.FamName,'b2')
        else error('Problem with vertical corrector index definition.')
        end
    end
end
idx = sort(idx);
data.cv.ATIndex = reshape(idx,data.cv.nr_segs,[]);
data.cv.ATIndex = data.cv.ATIndex';

% bc 
idx = [data.bc_lf.ATIndex, data.bc_hf.ATIndex];
data.bc.ATIndex = sort(idx);

% fch - fast horizontal correctors
idx = [];
idx = [idx; data.fc.ATIndex];
idx = sort(idx);
data.fch.ATIndex = reshape(idx,data.fch.nr_segs,[]);
data.fch.ATIndex = data.fch.ATIndex';

% fcv - fast vertical correctors
idx = [];
idx = [idx; data.fc.ATIndex];
idx = sort(idx);
data.fcv.ATIndex = reshape(idx,data.fcv.nr_segs,[]);
data.fcv.ATIndex = data.fcv.ATIndex';

% qs - skew quad correctors
idx = [];
idx = [idx; data.sfa0.ATIndex];
idx = [idx; data.sdb0.ATIndex];
idx = [idx; data.sdp0.ATIndex];
idx = [idx; data.sda2.ATIndex];
idx = [idx; data.sdb2.ATIndex];
idx = [idx; data.sdp2.ATIndex];
idx = [idx; data.sda4.ATIndex];
idx = [idx; data.sdb4.ATIndex];
idx = [idx; data.sdp4.ATIndex];
idx = sort(idx);
data.qs.ATIndex = reshape(idx,data.qs.nr_segs,[]);
data.qs.ATIndex = data.qs.ATIndex';

% % In this version of the lattice, there are qs correctors in the sextupoles
% % sd2 of every sector C1 of the arc in the lattice. It means the corrector
% % alternates between all SD2's. The logic bellow uses the
% % dipoles B1 and B2 to determine where to put the corrector.
% indqs = sort([data.sda2.ATIndex; data.sdb2.ATIndex; data.sdp2.ATIndex]);
% dips = sort([data.b1.ATIndex(:); data.b2.ATIndex(:)]);
% for i=1:length(indqs)
%     el = find(dips > indqs(i),1,'first');
%     if ~isempty(el)
%         if strcmpi(the_ring{dips(el)}.FamName,'b2'), idx = [idx; indqs(i)];          
%         elseif strcmpi(the_ring{dips(el)}.FamName,'b1')
%         else error('Problem with skew corrector index definition.')
%         end
%         continue
%     end
%     el = find(dips < indqs(i),1,'last');
%     if ~isempty(el)
%         if strcmpi(the_ring{dips(el)}.FamName,'b1'), idx = [idx; indqs(i)];          
%         elseif strcmpi(the_ring{dips(el)}.FamName,'b2')
%         else error('Problem with skew corrector index definition.')
%         end
%     end
% end
% idx = sort(idx);
% data.qs.ATIndex = reshape(idx,data.qs.nr_segs,[]);
% data.qs.ATIndex = data.qs.ATIndex';

% In this version of the lattice, there are qs correctors in the sextupoles
% sd3 of every sector C3 of the arc in the lattice. It means the corrector
% alternates between all SD3's. The logic bellow uses the
% dipoles B2 and BC_LF to determine where to put the corrector.
indqs = sort([data.sda3.ATIndex; data.sdb3.ATIndex; data.sdp3.ATIndex]);
dips = sort([data.b2.ATIndex(:); data.bc_lf.ATIndex(:)]);
for i=1:length(indqs)
    el = find(dips > indqs(i),1,'first');
    if ~isempty(el)
        if strcmpi(the_ring{dips(el)}.FamName,'b2'), idx = [idx; indqs(i)];          
        elseif strcmpi(the_ring{dips(el)}.FamName,'bc_lf')
        else error('Problem with vertical corrector index definition.')
        end
        continue
    end
    el = find(dips < indqs(i),1,'last');
    if ~isempty(el)
        if strcmpi(the_ring{dips(el)}.FamName,'bc_lf'), idx = [idx; indqs(i)];          
        elseif strcmpi(the_ring{dips(el)}.FamName,'b2')
        else error('Problem with vertical corrector index definition.')
        end
    end
end
idx = sort(idx);
data.qs.ATIndex = reshape(idx,data.qs.nr_segs,[]);
data.qs.ATIndex = data.qs.ATIndex';


% kbs - quadrupoles knobs for optics correction
idx = [];
idx = [idx; data.qfa.ATIndex];
idx = [idx; data.qda.ATIndex];
idx = [idx; data.qdb2.ATIndex];
idx = [idx; data.qfb.ATIndex];
idx = [idx; data.qdb1.ATIndex];
idx = [idx; data.qdp2.ATIndex];
idx = [idx; data.qfp.ATIndex];
idx = [idx; data.qdp1.ATIndex];
idx = [idx; data.q1.ATIndex];
idx = [idx; data.q2.ATIndex];
idx = [idx; data.q3.ATIndex];
idx = [idx; data.q4.ATIndex];
idx = sort(idx);
data.qn.ATIndex = reshape(idx,data.qn.nr_segs,[]);
data.qn.ATIndex = data.qn.ATIndex';

% sbs - sextupoles knobs for optics correction
idx = [];
idx = [idx; data.sda0.ATIndex];
idx = [idx; data.sdb0.ATIndex];
idx = [idx; data.sdp0.ATIndex];
idx = [idx; data.sda1.ATIndex];
idx = [idx; data.sdb1.ATIndex];
idx = [idx; data.sdp1.ATIndex];
idx = [idx; data.sda2.ATIndex];
idx = [idx; data.sdb2.ATIndex];
idx = [idx; data.sdp2.ATIndex];
idx = [idx; data.sda3.ATIndex];
idx = [idx; data.sdb3.ATIndex];
idx = [idx; data.sdp3.ATIndex];
idx = [idx; data.sfa0.ATIndex];
idx = [idx; data.sfb0.ATIndex];
idx = [idx; data.sfp0.ATIndex];
idx = [idx; data.sfa1.ATIndex];
idx = [idx; data.sfb1.ATIndex];
idx = [idx; data.sfp1.ATIndex];
idx = [idx; data.sfa2.ATIndex];
idx = [idx; data.sfb2.ATIndex];
idx = [idx; data.sfp2.ATIndex];
idx = sort(idx);
data.sn.ATIndex = reshape(idx,data.sn.nr_segs,[]);
data.sn.ATIndex = data.sn.ATIndex';
