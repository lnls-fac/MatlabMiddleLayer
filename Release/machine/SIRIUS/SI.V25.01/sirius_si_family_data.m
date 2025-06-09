function data = sirius_si_family_data(the_ring)

data.B1.nr_segs    = 30;
data.B2.nr_segs    = 36;
data.BC.nr_segs    = 34;

data.QFA.nr_segs  = 1;
data.QDA.nr_segs  = 1;
data.QDB2.nr_segs = 1;
data.QFB.nr_segs  = 1;
data.QDB1.nr_segs = 1;
data.QDP2.nr_segs = 1;
data.QFP.nr_segs  = 1;
data.QDP1.nr_segs = 1;
data.Q1.nr_segs   = 1;
data.Q2.nr_segs   = 1;
data.Q3.nr_segs   = 1;
data.Q4.nr_segs   = 1;

data.SDA0.nr_segs = 1;
data.SDB0.nr_segs = 1;
data.SDP0.nr_segs = 1;
data.SDA1.nr_segs = 1;
data.SDB1.nr_segs = 1;
data.SDP1.nr_segs = 1;
data.SDA2.nr_segs = 1;
data.SDB2.nr_segs = 1;
data.SDP2.nr_segs = 1;
data.SDA3.nr_segs = 1;
data.SDB3.nr_segs = 1;
data.SDP3.nr_segs = 1;
data.SFA0.nr_segs = 1;
data.SFB0.nr_segs = 1;
data.SFP0.nr_segs = 1;
data.SFA1.nr_segs = 1;
data.SFB1.nr_segs = 1;
data.SFP1.nr_segs = 1;
data.SFA2.nr_segs = 1;
data.SFB2.nr_segs = 1;
data.SFP2.nr_segs = 1;

data.BPM.nr_segs  = 1;
data.rBPM.nr_segs = 1;

data.FC1.nr_segs   = 1; % fast correctors with skew quad poles (FCH+FCV and FCH+FCV+FQS)
data.FC2.nr_segs   = 1; % fast correctors with normal quad poles (FCH+FCV)

data.FC.nr_segs   = 1; % all fast correctors
data.FCQ.nr_segs  = 1; % fast skew quad correctors
data.FCH.nr_segs  = 1; % fast CH correctors
data.FCV.nr_segs  = 1; % fast CV correctors

data.QS.nr_segs   = 1; % All QS
data.QSS.nr_segs  = 1; % QSs in sextupoles
data.CH.nr_segs   = 1;
data.CVS.nr_segs  = 1; % CVS in setupole magnets
data.CVM.nr_segs  = 1; % CVM magnets (same as BO correctors)
data.CV.nr_segs   = 1; % All CV magnets
data.QN.nr_segs   = 1;
data.SN.nr_segs   = 1;


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
idx = [idx; data.SDA0.ATIndex];
idx = [idx; data.SFB0.ATIndex];
idx = [idx; data.SFP0.ATIndex];
idx = [idx; data.SDA1.ATIndex];
idx = [idx; data.SDB1.ATIndex];
idx = [idx; data.SDP1.ATIndex];
idx = [idx; data.SFA2.ATIndex];
idx = [idx; data.SFB2.ATIndex];
idx = [idx; data.SFP2.ATIndex];
idx = sort(idx);
data.CH.ATIndex = reshape(idx,data.CH.nr_segs,[]);
data.CH.ATIndex = data.CH.ATIndex';

% CVs - slow vertical corrector magnets
data.CVM.ATIndex = data.CV.ATIndex;

% CVs - slow vertical correctors (all)
idx = [];
idx = [idx; data.SDA0.ATIndex];
idx = [idx; data.SFB0.ATIndex];
idx = [idx; data.SFP0.ATIndex];
idx = [idx; data.SDA1.ATIndex];
idx = [idx; data.SDB1.ATIndex];
idx = [idx; data.SDP1.ATIndex];
idx = [idx; data.SDA3.ATIndex];
idx = [idx; data.SDB3.ATIndex];
idx = [idx; data.SDP3.ATIndex];
idx = [idx; data.CV.ATIndex];

% In this version of the lattice, there is a CV corrector in the sextupoles
% sf2 of every sector C3 of the arc in the lattice. It means the corrector
% alternates between all SF2's. The logic bellow uses the
% dipoles B2 and BC to determine where to put the corrector.
indcs = sort([data.SFA2.ATIndex; data.SFB2.ATIndex; data.SFP2.ATIndex]);
dips = sort([data.B2.ATIndex(:); data.BC.ATIndex(:)]);
for i=1:length(indcs)
    el = find(dips > indcs(i),1,'first');
    if ~isempty(el)
        if strcmpi(the_ring{dips(el)}.FamName,'B2'), idx = [idx; indcs(i)];          
        elseif strcmpi(the_ring{dips(el)}.FamName,'BC')
        else error('Problem with vertical corrector index definition.')
        end
        continue
    end
    el = find(dips < indcs(i),1,'last');
    if ~isempty(el)
        if strcmpi(the_ring{dips(el)}.FamName,'BC'), idx = [idx; indcs(i)];          
        elseif strcmpi(the_ring{dips(el)}.FamName,'B2')
        else error('Problem with vertical corrector index definition.')
        end
    end
end
idx = sort(idx);
data.CV.ATIndex = reshape(idx,data.CV.nr_segs,[]);
data.CV.ATIndex = data.CV.ATIndex';


% CVs - slow vertical correctors (within sextupoles)
idx = [];
idx = [idx; data.SDA0.ATIndex];
idx = [idx; data.SFB0.ATIndex];
idx = [idx; data.SFP0.ATIndex];
idx = [idx; data.SDA1.ATIndex];
idx = [idx; data.SDB1.ATIndex];
idx = [idx; data.SDP1.ATIndex];
idx = [idx; data.SDA3.ATIndex];
idx = [idx; data.SDB3.ATIndex];
idx = [idx; data.SDP3.ATIndex];

% In this version of the lattice, there is a CV corrector in the sextupoles
% sf2 of every sector C3 of the arc in the lattice. It means the corrector
% alternates between all SF2's. The logic bellow uses the
% dipoles B2 and BC to determine where to put the corrector.
indcs = sort([data.SFA2.ATIndex; data.SFB2.ATIndex; data.SFP2.ATIndex]);
dips = sort([data.B2.ATIndex(:); data.BC.ATIndex(:)]);
for i=1:length(indcs)
    el = find(dips > indcs(i),1,'first');
    if ~isempty(el)
        if strcmpi(the_ring{dips(el)}.FamName,'B2'), idx = [idx; indcs(i)];          
        elseif strcmpi(the_ring{dips(el)}.FamName,'BC')
        else error('Problem with vertical corrector index definition.')
        end
        continue
    end
    el = find(dips < indcs(i),1,'last');
    if ~isempty(el)
        if strcmpi(the_ring{dips(el)}.FamName,'BC'), idx = [idx; indcs(i)];          
        elseif strcmpi(the_ring{dips(el)}.FamName,'B2')
        else error('Problem with vertical corrector index definition.')
        end
    end
end
idx = sort(idx);
data.CVS.ATIndex = reshape(idx,data.CVS.nr_segs,[]);
data.CVS.ATIndex = data.CVS.ATIndex';


% FCH - fast horizontal correctors
idx = [];
idx = [idx; data.FC1.ATIndex];
idx = [idx; data.FC2.ATIndex];
idx = sort(idx);
data.FCH.ATIndex = reshape(idx,data.FCH.nr_segs,[]);
data.FCH.ATIndex = data.FCH.ATIndex';
data.FCH.ATFamilies = {'FC1', 'FC2'};

% FCV - fast vertical correctors
idx = [];
idx = [idx; data.FC1.ATIndex];
idx = [idx; data.FC2.ATIndex];
idx = sort(idx);
data.FCV.ATIndex = reshape(idx,data.FCV.nr_segs,[]);
data.FCV.ATIndex = data.FCV.ATIndex';
data.FCV.ATFamilies = {'FC1', 'FC2'};

% FCQ - fast skew correctors
idx = [];
idx = [idx; data.FC1.ATIndex(5:7:end)];
idx = sort(idx);
data.FCQ.ATIndex = reshape(idx,data.FCQ.nr_segs,[]);
data.FCQ.ATIndex = data.FCQ.ATIndex';
data.FCV.ATFamilies = 'FC1';

% FC - fast correctors
data.FC = data.FCH;


% rBPM - BPMs for FOFB
idx = [];
idx = [idx; data.rBPM.ATIndex];
idx = sort(idx);
data.rBPM.ATIndex = reshape(idx,data.rBPM.nr_segs,[]);
data.rBPM.ATIndex = data.rBPM.ATIndex';

% QSS - skew quad correctors (in sextupoles)
idx = [];
idx = [idx; data.SFA0.ATIndex];
idx = [idx; data.SDB0.ATIndex];
idx = [idx; data.SDP0.ATIndex];
idx = sort(idx);
data.QSS.ATIndex = reshape(idx,data.QSS.nr_segs,[]);
data.QSS.ATIndex = data.QSS.ATIndex';


% In this version of the lattice, there are QS correctors in the sextupoles
% sd2 of every sector C1 of the arc in the lattice. It means the corrector
% alternates between all SD2's. The logic bellow uses the
% dipoles B1 and B2 to determine where to put the corrector.
indqs = sort([data.SDA2.ATIndex; data.SDB2.ATIndex; data.SDP2.ATIndex]);
dips = sort([data.B1.ATIndex(:); data.B2.ATIndex(:)]);
for i=1:length(indqs)
    el = find(dips > indqs(i),1,'first');
    if ~isempty(el)
        if strcmpi(the_ring{dips(el)}.FamName,'B2'), idx = [idx; indqs(i)];          
        elseif strcmpi(the_ring{dips(el)}.FamName,'B1')
        else error('Problem with skew corrector index definition.')
        end
        continue
    end
    el = find(dips < indqs(i),1,'last');
    if ~isempty(el)
        if strcmpi(the_ring{dips(el)}.FamName,'B1'), idx = [idx; indqs(i)];          
        elseif strcmpi(the_ring{dips(el)}.FamName,'B2')
        else error('Problem with skew corrector index definition.')
        end
    end
end
idx = sort(idx);
data.QSS.ATIndex = reshape(idx,data.QSS.nr_segs,[]);
data.QSS.ATIndex = data.QSS.ATIndex';


% In this version of the lattice, there are QS correctors in the sextupoles
% sd3 of every sector C3 of the arc in the lattice. It means the corrector
% alternates between all SD3's. The logic bellow uses the
% dipoles B2 and BC to determine where to put the corrector.
indqs = sort([data.SDA3.ATIndex; data.SDB3.ATIndex; data.SDP3.ATIndex]);
dips = sort([data.B2.ATIndex(:); data.BC.ATIndex(:)]);
for i=1:length(indqs)
    el = find(dips > indqs(i),1,'first');
    if ~isempty(el)
        if strcmpi(the_ring{dips(el)}.FamName,'B2'), idx = [idx; indqs(i)];          
        elseif strcmpi(the_ring{dips(el)}.FamName,'BC')
        else error('Problem with vertical corrector index definition.')
        end
        continue
    end
    el = find(dips < indqs(i),1,'last');
    if ~isempty(el)
        if strcmpi(the_ring{dips(el)}.FamName,'BC'), idx = [idx; indqs(i)];          
        elseif strcmpi(the_ring{dips(el)}.FamName,'B2')
        else error('Problem with vertical corrector index definition.')
        end
    end
end
idx = sort(idx);
data.QSS.ATIndex = reshape(idx,data.QSS.nr_segs,[]);
data.QSS.ATIndex = data.QSS.ATIndex';


% QS - skew quad correctors (All)
% fcq_skew = data.FCQ.ATIndex(2:2:end); % remove from the odd Secs.
fcq_skew = data.FCQ.ATIndex(:);
idx = [data.QSS.ATIndex; fcq_skew];
idx = sort(idx);
data.QS.ATIndex = reshape(idx,data.QS.nr_segs,[]);
data.QS.ATIndex = data.QS.ATIndex';


% kbs - quadrupoles knobs for optics correction
idx = [];
idx = [idx; data.QFA.ATIndex];
idx = [idx; data.QDA.ATIndex];
idx = [idx; data.QDB2.ATIndex];
idx = [idx; data.QFB.ATIndex];
idx = [idx; data.QDB1.ATIndex];
idx = [idx; data.QDP2.ATIndex];
idx = [idx; data.QFP.ATIndex];
idx = [idx; data.QDP1.ATIndex];
idx = [idx; data.Q1.ATIndex];
idx = [idx; data.Q2.ATIndex];
idx = [idx; data.Q3.ATIndex];
idx = [idx; data.Q4.ATIndex];
idx = sort(idx);
data.QN.ATIndex = reshape(idx,data.QN.nr_segs,[]);
data.QN.ATIndex = data.QN.ATIndex';

% sbs - sextupoles knobs for optics correction
idx = [];
idx = [idx; data.SDA0.ATIndex];
idx = [idx; data.SDB0.ATIndex];
idx = [idx; data.SDP0.ATIndex];
idx = [idx; data.SDA1.ATIndex];
idx = [idx; data.SDB1.ATIndex];
idx = [idx; data.SDP1.ATIndex];
idx = [idx; data.SDA2.ATIndex];
idx = [idx; data.SDB2.ATIndex];
idx = [idx; data.SDP2.ATIndex];
idx = [idx; data.SDA3.ATIndex];
idx = [idx; data.SDB3.ATIndex];
idx = [idx; data.SDP3.ATIndex];
idx = [idx; data.SFA0.ATIndex];
idx = [idx; data.SFB0.ATIndex];
idx = [idx; data.SFP0.ATIndex];
idx = [idx; data.SFA1.ATIndex];
idx = [idx; data.SFB1.ATIndex];
idx = [idx; data.SFP1.ATIndex];
idx = [idx; data.SFA2.ATIndex];
idx = [idx; data.SFB2.ATIndex];
idx = [idx; data.SFP2.ATIndex];
idx = sort(idx);
data.SN.ATIndex = reshape(idx,data.SN.nr_segs,[]);
data.SN.ATIndex = data.SN.ATIndex';
