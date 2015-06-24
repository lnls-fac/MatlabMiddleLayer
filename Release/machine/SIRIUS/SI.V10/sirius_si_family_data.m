function data = sirius_si_family_data(the_ring)

data.b1.nr_segs   = 2;
data.b2.nr_segs   = 3;
data.b3.nr_segs   = 7;
data.bc.nr_segs   = 14;

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

data.bpm.nr_segs = 1;
data.cf.nr_segs  = 1;
data.chf.nr_segs = 1;
data.cvf.nr_segs = 1;
data.qs.nr_segs  = 1;
data.chs.nr_segs = 1;
data.cvs.nr_segs = 1;
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
for i=1:length(fams)
    data.(fams{i}).ATIndex = reshape(data.(fams{i}).ATIndex,data.(fams{i}).nr_segs,[])';
end


% chs - slow horizontal correctors
idx = [];
idx = [idx; data.('sfa').ATIndex];
idx = [idx; data.('sd1j').ATIndex];
% idx = [idx; data.('sd2j').ATIndex];
idx = [idx; data.('sf2j').ATIndex];
idx = [idx; data.('sfb').ATIndex];
idx = [idx; data.('sd1k').ATIndex];
% idx = [idx; data.('sd2k').ATIndex];
idx = [idx; data.('sf2k').ATIndex];
idx = sort(idx);
data.chs.ATIndex = reshape(idx,data.chs.nr_segs,[]);
data.chs.ATIndex = data.chs.ATIndex';
data.chs.ATFamilies = {'sfa','sd1j','sf2j','sf2k','sd1k','sfb'};

% cvs - slow horizontal correctors
idx = [];
idx = [idx; data.('sfa').ATIndex];
idx = [idx; data.('sd1j').ATIndex];
idx = [idx; data.('sd3j').ATIndex];
idx = [idx; data.('sfb').ATIndex];
idx = [idx; data.('sd1k').ATIndex];
idx = [idx; data.('sd3k').ATIndex];
idx = sort(idx);
data.cvs.ATIndex = reshape(idx,data.cvs.nr_segs,[]);
data.cvs.ATIndex = data.cvs.ATIndex';
data.cvs.ATFamilies = {'sfa','sd1j','sd3j','sd3k','sd1k','sfb'};

% chf - fast horizontal correctors
idx = [];
idx = [idx; data.('cf').ATIndex];
idx = sort(idx);
data.chf.ATIndex = reshape(idx,data.chf.nr_segs,[]);
data.chf.ATIndex = data.chf.ATIndex';

% cvf - fast vertical correctors
idx = [];
idx = [idx; data.('cf').ATIndex];
idx = sort(idx);
data.cvf.ATIndex = reshape(idx,data.cvf.nr_segs,[]);
data.cvf.ATIndex = data.cvf.ATIndex';
data.cvf.ATFamilies = {'cf'};

% qs - skew quad correctors
idx = [];
idx = [idx; data.('sda').ATIndex];
idx = [idx; data.('sf1j').ATIndex];
idx = [idx; data.('sf1k').ATIndex];
idx = [idx; data.('sdb').ATIndex];
idx = sort(idx);
data.qs.ATIndex = reshape(idx,data.qs.nr_segs,[]);
data.qs.ATIndex = data.qs.ATIndex';
data.qs.ATFamilies = {'sda','sf1j','sf1k','sdb'};

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
data.qn.ATFamilies = {'qfa','qda','qf1','qf2','qf3','qf4','qdb1','qfb','qdb2'};
