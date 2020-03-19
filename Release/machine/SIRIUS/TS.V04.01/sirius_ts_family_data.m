function data = sirius_ts_family_data(the_ring)

data.B.nr_segs    = 20;
data.QF1A.nr_segs  = 1;
data.QF1B.nr_segs  = 1;
data.QD2.nr_segs = 1;
data.QF2.nr_segs = 1;
data.QF3.nr_segs = 1;
data.QD4A.nr_segs = 1;
data.QF4.nr_segs  = 1;
data.QD4B.nr_segs  = 1;
data.CH.nr_segs   = 1;
data.CV.nr_segs   = 1;
data.BPM.nr_segs  = 1;
data.Scrn.nr_segs = 1;
data.ICT.nr_segs = 1;
data.FCT.nr_segs = 1;
data.EjeSeptF.nr_segs = 6;
data.EjeSeptG.nr_segs = 6;
data.InjSeptF.nr_segs = 6;
data.InjSeptG.nr_segs = 6;

data.QN.nr_segs   = 1;

ind = atindex(the_ring);
fams = fields(data);
for i=1:length(fams)
    if isfield(ind, fams{i})
        data.(fams{i}).ATIndex = ind.(fams{i});
    end
end

for i=1:length(fams)
    if isfield(ind, fams{i})
        data.(fams{i}).ATIndex = reshape(data.(fams{i}).ATIndex,data.(fams{i}).nr_segs,[])';
    end
end

% chs - slow horizontal correctors
idx = [];
idx = [idx; data.QF1B.ATIndex];
idx = [idx; data.QF2.ATIndex];
idx = [idx; data.QF3.ATIndex];
idx = [idx; data.QF4.ATIndex];
idx = sort(idx);
data.CH.ATIndex = reshape(idx,data.CH.nr_segs,[]);
data.CH.ATIndex = data.CH.ATIndex';

% kbs - quadrupoles knobs for optics correction
idx = [];
idx = [idx; data.QF1A.ATIndex];
idx = [idx; data.QF1B.ATIndex];
idx = [idx; data.QD2.ATIndex];
idx = [idx; data.QF2.ATIndex];
idx = [idx; data.QF3.ATIndex];
idx = [idx; data.QD4A.ATIndex];
idx = [idx; data.QF4.ATIndex];
idx = [idx; data.QD4B.ATIndex];
idx = sort(idx);
data.QN.ATIndex = reshape(idx,data.QN.nr_segs,[]);
data.QN.ATIndex = data.QN.ATIndex';

