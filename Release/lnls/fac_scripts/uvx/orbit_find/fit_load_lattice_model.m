function r = fit_load_lattice_model(r0)

global THERING

r = r0;

if any(strcmpi(r.flags, 'load_the_ring')) && exist(r.parms.the_ring_fname, 'file')
    load('the_ring_orb.mat');
    r.the_ring = the_ring;
else
    % loads default ring model
    lnls1_set_server('','','');
    lnls1;
    r.the_ring = THERING;
end

% adds fake correctors if needed
if any(strcmpi(r.flags, 'add_fakecorrectors'))
    cm_idx = findcells(r.the_ring, 'FamName', 'FakeCM');
    if isempty(cm_idx)
        r.the_ring = add_fake_correctors(r.the_ring);
    end
    
    % builds correctors indices
    r.cm_idx = [];
    r.cm_idx = [r.cm_idx findcells(r.the_ring, 'FamName', 'HCM')];
    r.cm_idx = [r.cm_idx findcells(r.the_ring, 'FamName', 'VCM')];
    r.cm_idx = [r.cm_idx findcells(r.the_ring, 'FamName', 'FakeCM')];
    
    % updates MML familydata
    THERING = r.the_ring;
    updateatindex;
end

if any(strcmpi(r.flags, 'load_ids'))
    lnls1_set_id_field('AWG09', 3.5);
    lnls1_set_id_field('AWG01', 2.0);
    lnls1_set_id_field('AON11', 0.54);
end

if any(strcmpi(r.flags, 'load_correctors'))
    setpv('HCM', +1.388, common2dev('ACH01A', 'HCM'), 'Hardware');
    setpv('HCM', +0.784, common2dev('ACH07A', 'HCM'), 'Hardware');
    setpv('HCM', +0.164, common2dev('ACH09A', 'HCM'), 'Hardware');
    setpv('HCM', +0.082, common2dev('ACH05B', 'HCM'), 'Hardware');
    setpv('HCM', -1.296, common2dev('ACH12' , 'HCM'), 'Hardware');
    setpv('HCM', -2.246, common2dev('ACH02' , 'HCM'), 'Hardware');
    setpv('HCM', -2.267, common2dev('ACH03A', 'HCM'), 'Hardware');
    setpv('HCM', -2.513, common2dev('ACH01B', 'HCM'), 'Hardware');
    setpv('HCM', -2.583, common2dev('ACH11A', 'HCM'), 'Hardware');
    setpv('HCM', -2.808, common2dev('ACH11B', 'HCM'), 'Hardware');
    setpv('HCM', -2.895, common2dev('ACH09B', 'HCM'), 'Hardware');
    setpv('HCM', -3.744, common2dev('ACH07B', 'HCM'), 'Hardware');
    setpv('HCM', -3.767, common2dev('ACH08' , 'HCM'), 'Hardware');
    setpv('HCM', -3.896, common2dev('ACH10' , 'HCM'), 'Hardware');
    setpv('HCM', -3.964, common2dev('ACH03B', 'HCM'), 'Hardware');
    setpv('HCM', -4.223, common2dev('ACH05A', 'HCM'), 'Hardware');
    setpv('HCM', -4.225, common2dev('ACH04' , 'HCM'), 'Hardware');
    setpv('HCM', -5.760, common2dev('ACH06' , 'HCM'), 'Hardware');
end

if any(strcmpi(r.flags, '4d'))
    setcavity('off');
    setradiation('off');
else
    setcavity('on');
    setradiation('on');
end

r.parms.bpms = getfamilydata('BPMx', 'AT', 'ATIndex');

if any(strcmpi(r.flags, 'save_the_ring'))
    the_ring = r.the_ring; save(r.parms.the_ring_fname, 'the_ring');
end


function the_ring = add_fake_correctors(the_ring0)


% calcs indices
quads = [];
quads = [quads; getfamilydata('QF', 'AT', 'ATIndex')];
quads = [quads; getfamilydata('QD', 'AT', 'ATIndex')];
quads = [quads; getfamilydata('QFC', 'AT', 'ATIndex')];
quads = sort(quads(:,2));


% creates fake corrector
c = buildlat([corrector('FakeCM', 0, [0 0], 'CorrectorPass')]);

% add correctors
the_ring = {};
idx = 1;
for i=1:length(the_ring0)
    if (idx <= length(quads)) && (i == quads(idx))
        the_ring = [the_ring c{1}];
        idx = idx + 1;
    end
    the_ring = [the_ring the_ring0{i}];
end

global THERING;
THERING = the_ring;
updateatindex;
