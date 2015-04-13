function data = sirius_si_family_data(the_ring)

data.b1.nr_segs   = 2;
data.b2.nr_segs   = 3;
data.b3.nr_segs   = 2;
data.bc.nr_segs   = 12;

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
data.sd1.nr_segs = 1;
data.sf1.nr_segs = 1;
data.sd2.nr_segs = 1;
data.sd3.nr_segs = 1;
data.sf2.nr_segs = 1;
data.sd6.nr_segs = 1;
data.sf4.nr_segs = 1;
data.sd5.nr_segs = 1;
data.sd4.nr_segs = 1;
data.sf3.nr_segs = 1;

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
idx = [idx; data.('sd1').ATIndex];
idx = [idx; data.('sd2').ATIndex];
idx = [idx; data.('sf2').ATIndex];
idx = [idx; data.('sf3').ATIndex];
idx = [idx; data.('sd5').ATIndex];
idx = [idx; data.('sd6').ATIndex];
idx = [idx; data.('sfb').ATIndex];
idx = sort(idx);
data.chs.ATIndex = reshape(idx,data.chs.nr_segs,[]);
data.chs.ATIndex = data.chs.ATIndex';

% cvs - slow horizontal correctors
idx = [];
idx = [idx; data.('sfa').ATIndex];
idx = [idx; data.('sd1').ATIndex];
idx = [idx; data.('sd3').ATIndex];
idx = [idx; data.('sd4').ATIndex];
idx = [idx; data.('sd6').ATIndex];
idx = [idx; data.('sfb').ATIndex];
idx = sort(idx);
data.cvs.ATIndex = reshape(idx,data.cvs.nr_segs,[]);
data.cvs.ATIndex = data.cvs.ATIndex';

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

% qs - skew quad correctors
idx = [];
idx = [idx; data.('cf').ATIndex];
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
