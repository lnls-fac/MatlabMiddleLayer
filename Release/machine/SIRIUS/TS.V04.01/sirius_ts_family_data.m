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
data.EjeSeptF.nr_segs = 2;
data.EjeSeptG.nr_segs = 2;
data.InjSeptF.nr_segs = 2;
data.EjeSeptF.nr_segs = 2;

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