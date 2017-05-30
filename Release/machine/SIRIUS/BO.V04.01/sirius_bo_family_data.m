function data = sirius_bo_family_data(the_ring)

data.B.nr_segs   = 20;

data.QF.nr_segs  = 2;
data.QD.nr_segs  = 1;

data.SD.nr_segs  = 1;
data.SF.nr_segs  = 1;

data.BPM.nr_segs = 1;
data.CH.nr_segs  = 1;
data.CV.nr_segs  = 1;
data.QS.nr_segs  = 1;

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
