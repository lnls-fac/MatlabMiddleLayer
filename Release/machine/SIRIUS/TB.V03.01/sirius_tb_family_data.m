function data = sirius_tb_family_data(the_ring)


data.QF2L.nr_segs = 1;
data.QD2L.nr_segs = 1;
data.QF3L.nr_segs = 1;

data.B.nr_segs    = 16;
data.QD1.nr_segs  = 1;
data.QF1.nr_segs  = 1;
data.QD2A.nr_segs = 1;
data.QF2A.nr_segs = 1;
data.QF2B.nr_segs = 1;
data.QD2B.nr_segs = 1;
data.QF3.nr_segs  = 1;
data.QD3.nr_segs  = 1;
data.QF4.nr_segs  = 1;
data.QD4.nr_segs  = 1;
data.CHV.nr_segs  = 1; % all corrector magnets
data.CH.nr_segs   = 1;
data.CV.nr_segs   = 1;
data.BPM.nr_segs  = 1;
data.Scrn.nr_segs = 1;

ind = atindex(the_ring);
fams = fields(data);
for i=1:length(fams)
    if isfield(ind, fams{i})
        data.(fams{i}).ATIndex = ind.(fams{i});
    end
end

% correctors
data.CH.ATIndex = data.CHV.ATIndex(1:end-1); % last CHV corrector does not have CH power supply.
data.CV.ATIndex = data.CHV.ATIndex;

for i=1:length(fams)
    if isfield(ind, fams{i})
        data.(fams{i}).ATIndex = reshape(data.(fams{i}).ATIndex,data.(fams{i}).nr_segs,[])';
    end
end