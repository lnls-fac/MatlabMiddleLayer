function data = sirius_si_family_data(the_ring)

data.b1.nr_segs     = 2;
data.b2.nr_segs     = 3;
data.bc_hf.nr_segs  = 16;
data.bc_lf.nr_segs  = 14;
data.bc.nr_segs     = 30;

data.qfa.nr_segs  = 1;
data.qda.nr_segs  = 1;
data.qdb2.nr_segs = 1;
data.qfb.nr_segs  = 1;
data.qdb1.nr_segs = 1;
data.qf1.nr_segs  = 1;
data.qf2.nr_segs  = 1;
data.qf3.nr_segs  = 1;
data.qf4.nr_segs  = 1;

data.sda.nr_segs = 1;
data.sfa.nr_segs = 1;
data.sdb.nr_segs = 1;
data.sfb.nr_segs = 1;
data.sd1j.nr_segs = 1;
data.sf1j.nr_segs = 1;
data.sd2j.nr_segs = 1;
data.sd3j.nr_segs = 1;
data.sf2j.nr_segs = 1;
data.sd1k.nr_segs = 1;
data.sf1k.nr_segs = 1;
data.sd2k.nr_segs = 1;
data.sd3k.nr_segs = 1;
data.sf2k.nr_segs = 1;

data.bpm.nr_segs  = 1;
data.rbpm.nr_segs = 1;
data.fc.nr_segs   = 1;
data.fch.nr_segs  = 1;
data.fcv.nr_segs  = 1;
data.qs.nr_segs   = 1;
data.ch.nr_segs   = 1;
data.cv.nr_segs   = 1;
data.qn.nr_segs  = 1;


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
idx = [idx; data.('sfa').ATIndex];
idx = [idx; data.('sd1j').ATIndex];
idx = [idx; data.('sf2j').ATIndex];
idx = [idx; data.('sf2k').ATIndex];
idx = [idx; data.('sd1k').ATIndex];
idx = [idx; data.('sfb').ATIndex];
idx = sort(idx);
data.ch.ATIndex = reshape(idx,data.ch.nr_segs,[]);
data.ch.ATIndex = data.ch.ATIndex';

% cvs - slow vertical correctors
idx = [];
idx = [idx; data.('sfa').ATIndex];
idx = [idx; data.('sd1j').ATIndex];
idx = [idx; data.('sd3j').ATIndex];
idx = [idx; data.('sfb').ATIndex];
idx = [idx; data.('sd1k').ATIndex];
idx = [idx; data.('sd3k').ATIndex];
idx = [idx; data.('cv').ATIndex];


% In this version of the lattice, there is a cv corrector in the sextupoles
% sf2 of every sector C3 of the arc the lattice. It means the corrector
% alternates between a SF2J and SF2K. The logic bellow uses the dipoles B2 
% and BC_LF to determine where to put the corrector.
indcs = sort([data.sf2k.ATIndex; data.sf2j.ATIndex]);
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
idx = [data.('bc_lf').ATIndex, data.('bc_hf').ATIndex];
data.bc.ATIndex = sort(idx);

% fch - fast horizontal correctors
idx = [];
idx = [idx; data.('fc').ATIndex];
idx = sort(idx);
data.fch.ATIndex = reshape(idx,data.fch.nr_segs,[]);
data.fch.ATIndex = data.fch.ATIndex';

% fcv - fast vertical correctors
idx = [];
idx = [idx; data.('fc').ATIndex];
idx = sort(idx);
data.fcv.ATIndex = reshape(idx,data.fcv.nr_segs,[]);
data.fcv.ATIndex = data.fcv.ATIndex';

% qs - skew quad correctors
idx = [];
idx = [idx; data.('sda').ATIndex];
idx = [idx; data.('sf1j').ATIndex];
idx = [idx; data.('sf1k').ATIndex];
idx = [idx; data.('sdb').ATIndex];
idx = sort(idx);
data.qs.ATIndex = reshape(idx,data.qs.nr_segs,[]);
data.qs.ATIndex = data.qs.ATIndex';

% kbs - quadrupoles knobs for optics correction
idx = [];
idx = [idx; data.('qfa').ATIndex];
idx = [idx; data.('qda').ATIndex];
idx = [idx; data.('qf1').ATIndex];
idx = [idx; data.('qf2').ATIndex];
idx = [idx; data.('qf3').ATIndex];
idx = [idx; data.('qf4').ATIndex];
idx = [idx; data.('qdb1').ATIndex];
idx = [idx; data.('qfb').ATIndex];
idx = [idx; data.('qdb2').ATIndex];
idx = sort(idx);
data.qn.ATIndex = reshape(idx,data.qn.nr_segs,[]);
data.qn.ATIndex = data.qn.ATIndex';
