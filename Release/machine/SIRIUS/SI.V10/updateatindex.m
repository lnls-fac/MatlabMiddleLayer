function updateatindex
%UPDATEATINDEX - Updates the AT indices in the MiddleLayer with the present AT lattice (THERING)
% 2012-07-10 Modificado para sirius3_lattice_e025 - Afonso


global THERING


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Append Accelerator Toolbox information %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Since changes in the AT model could change the AT indexes, etc,
% It's best to regenerate all the model indices whenever a model is loaded

% Sort by family first (findcells is linear and slow)
Indices = atindex(THERING);

AO = getao;

family_data = sirius_si_family_data(THERING);


try
    % B1
    AO.b1.AT.ATType = 'BEND';
    AO.b1.AT.ATIndex = buildatindex(AO.b1.FamilyName, Indices.b1);
    AO.b1.Position = findspos(THERING, AO.b1.AT.ATIndex(:,1+floor(size(AO.b1.AT.ATIndex,2)/2)))';
      
catch
    warning('b1 family not found in the model.');
end

try
    % B2
    AO.b2.AT.ATType = 'BEND';
    AO.b2.AT.ATIndex = buildatindex(AO.b2.FamilyName, Indices.b2);
    AO.b2.Position = findspos(THERING, AO.b2.AT.ATIndex(:,1+floor(size(AO.b2.AT.ATIndex,2)/2)))';
      
catch
    warning('b2 family not found in the model.');
end

try
    % BC_LF
    AO.bc_lf.AT.ATType = 'BEND';
    AO.bc_lf.AT.ATIndex = buildatindex(AO.bc_lf.FamilyName, Indices.bc_lf);
    AO.bc_lf.Position = findspos(THERING, AO.bc_lf.AT.ATIndex(:,1+floor(size(AO.bc_lf.AT.ATIndex,2)/2)))';
      
catch
    warning('bc_lf family not found in the model.');
end

try
    % BC_HF
    AO.bc_hf.AT.ATType = 'BEND';
    AO.bc_hf.AT.ATIndex = buildatindex(AO.bc_hf.FamilyName, Indices.bc_hf);
    AO.bc_hf.Position = findspos(THERING, AO.bc_hf.AT.ATIndex(:,1+floor(size(AO.bc_hf.AT.ATIndex,2)/2)))';
      
catch
    warning('bc_hf family not found in the model.');
end

try
    % qfa
    AO.qfa.AT.ATType = 'Quad';
    AO.qfa.AT.ATIndex = buildatindex(AO.qfa.FamilyName, Indices.qfa);
    AO.qfa.Position = findspos(THERING, AO.qfa.AT.ATIndex(:,1))';
catch
    warning('qfa family not found in the model.');
end

try
    % qfa_fam
    AO.qfa_fam.AT.ATType   = 'FamPS';
    AO.qfa_fam.AT.ATMagnet = 'qfa';
    AO.qfa_fam.AT.ATIndex  = buildatindex(AO.qfa.FamilyName, Indices.qfa);
    AO.qfa_fam.Position    = findspos(THERING, AO.qfa_fam.AT.ATIndex(:,1))';
catch
    warning('qfa_fam family not found in the model.');
end

try
    % qfa_shunt
    AO.qfa_shunt.AT.ATType   = 'ShuntPS';
    AO.qfa_shunt.AT.ATMagnet = 'qfa';
    AO.qfa_shunt.AT.ATIndex  = buildatindex(AO.qfa.FamilyName, Indices.qfa);
    AO.qfa_shunt.Position    = findspos(THERING, AO.qfa_shunt.AT.ATIndex(:,1))';
catch
    warning('qfa_shunt family not found in the model.');
end

try
    % qda
    AO.qda.AT.ATType = 'Quad';
    AO.qda.AT.ATIndex = buildatindex(AO.qda.FamilyName, Indices.qda);
    AO.qda.Position = findspos(THERING, AO.qda.AT.ATIndex(:,1))';
catch
    warning('qda1 family not found in the model.');
end

try
	% qda_fam
	AO.qda_fam.AT.ATType = 'FamPS';
    AO.qda_fam.AT.ATMagnet = 'qda';
	AO.qda_fam.AT.ATIndex = buildatindex(AO.qda.FamilyName, Indices.qda);
	AO.qda_fam.Position = findspos(THERING, AO.qda_fam.AT.ATIndex(:,1));
catch
	warning('qda_fam family not found in the model.');
end

try
	% qda_shunt
	AO.qda_shunt.AT.ATType = 'ShuntPS';
    AO.qda_shunt.AT.ATMagnet = 'qda';
	AO.qda_shunt.AT.ATIndex = buildatindex(AO.qda.FamilyName, Indices.qda);
	AO.qda_shunt.Position = findspos(THERING, AO.qda_shunt.AT.ATIndex(:,1));
catch
	warning('qda_shunt family not found in the model.');
end

try
    % qfb
    AO.qfb.AT.ATType = 'Quad';
    AO.qfb.AT.ATIndex = buildatindex(AO.qfb.FamilyName, Indices.qfb);
    AO.qfb.Position = findspos(THERING, AO.qfb.AT.ATIndex(:,1))';
catch
    warning('qfb family not found in the model.');
end

try
	% qfb_fam
	AO.qfb_fam.AT.ATType = 'FamPS';
    AO.qfb_fam.AT.ATMagnet = 'qfb';
	AO.qfb_fam.AT.ATIndex = buildatindex(AO.qfb.FamilyName, Indices.qfb);
	AO.qfb_fam.Position = findspos(THERING, AO.qfb_fam.AT.ATIndex(:,1));
catch
	warning('qfb_fam family not found in the model.');
end

try
	% qfb_shunt
	AO.qfb_shunt.AT.ATType = 'ShuntPS';
    AO.qfb_shunt.AT.ATMagnet = 'qfb';
	AO.qfb_shunt.AT.ATIndex = buildatindex(AO.qfb.FamilyName, Indices.qfb);
	AO.qfb_shunt.Position = findspos(THERING, AO.qfb_shunt.AT.ATIndex(:,1));
catch
	warning('qfb_shunt family not found in the model.');
end

try
    % qdb2
    AO.qdb2.AT.ATType = 'Quad';
    AO.qdb2.AT.ATIndex = buildatindex(AO.qdb2.FamilyName, Indices.qdb2);
    AO.qdb2.Position = findspos(THERING, AO.qdb2.AT.ATIndex(:,1))';
catch
    warning('qdb2 family not found in the model.');
end

try
	% qdb2_fam
	AO.qdb2_fam.AT.ATType = 'FamPS';
    AO.qdb2_fam.AT.ATMagnet = 'qdb2';
	AO.qdb2_fam.AT.ATIndex = buildatindex(AO.qdb2.FamilyName, Indices.qdb2);
	AO.qdb2_fam.Position = findspos(THERING, AO.qdb2_fam.AT.ATIndex(:,1));
catch
	warning('qdb2_fam family not found in the model.');
end

try
	% qdb2_shunt
	AO.qdb2_shunt.AT.ATType = 'ShuntPS';
    AO.qdb2_shunt.AT.ATMagnet = 'qdb2';
	AO.qdb2_shunt.AT.ATIndex = buildatindex(AO.qdb2.FamilyName, Indices.qdb2);
	AO.qdb2_shunt.Position = findspos(THERING, AO.qdb2_shunt.AT.ATIndex(:,1));
catch
	warning('qdb2_shunt family not found in the model.');
end

try
    % qdb1
    AO.qdb1.AT.ATType = 'Quad';
    AO.qdb1.AT.ATIndex = buildatindex(AO.qdb1.FamilyName, Indices.qdb1);
    AO.qdb1.Position = findspos(THERING, AO.qdb1.AT.ATIndex(:,1))';
catch
    warning('qdb1 family not found in the model.');
end

try
	% qdb1_fam
	AO.qdb1_fam.AT.ATType = 'FamPS';
    AO.qdb1_fam.AT.ATMagnet = 'qdb1';
	AO.qdb1_fam.AT.ATIndex = buildatindex(AO.qdb1.FamilyName, Indices.qdb1);
	AO.qdb1_fam.Position = findspos(THERING, AO.qdb1_fam.AT.ATIndex(:,1));
catch
	warning('qdb1_fam family not found in the model.');
end

try
	% qdb1_shunt
	AO.qdb1_shunt.AT.ATType = 'ShuntPS';
    AO.qdb1_shunt.AT.ATMagnet = 'qdb1';
	AO.qdb1_shunt.AT.ATIndex = buildatindex(AO.qdb1.FamilyName, Indices.qdb1);
	AO.qdb1_shunt.Position = findspos(THERING, AO.qdb1_shunt.AT.ATIndex(:,1));
catch
	warning('qdb1_shunt family not found in the model.');
end

try
    % qf1
    AO.qf1.AT.ATType = 'Quad';
    AO.qf1.AT.ATIndex = buildatindex(AO.qf1.FamilyName, Indices.qf1);
    AO.qf1.Position = findspos(THERING, AO.qf1.AT.ATIndex(:,1))';
    % qf2
    AO.qf2.AT.ATType = 'Quad';
    AO.qf2.AT.ATIndex = buildatindex(AO.qf2.FamilyName, Indices.qf2);
    AO.qf2.Position = findspos(THERING, AO.qf2.AT.ATIndex(:,1))';
    % qf3
    AO.qf3.AT.ATType = 'Quad';
    AO.qf3.AT.ATIndex = buildatindex(AO.qf3.FamilyName, Indices.qf3);
    AO.qf3.Position = findspos(THERING, AO.qf3.AT.ATIndex(:,1))';
    % qf4
    AO.qf4.AT.ATType = 'Quad';
    AO.qf4.AT.ATIndex = buildatindex(AO.qf4.FamilyName, Indices.qf4);
    AO.qf4.Position = findspos(THERING, AO.qf4.AT.ATIndex(:,1))';
catch
    warning('qf1 qf2 qf3 qf4 families not found in the model.');
end

try
	% qf1_fam
	AO.qf1_fam.AT.ATType = 'FamPS';
    AO.qf1_fam.AT.ATMagnet = 'qf1';
	AO.qf1_fam.AT.ATIndex = buildatindex(AO.qf1.FamilyName, Indices.qf1);
	AO.qf1_fam.Position = findspos(THERING, AO.qf1_fam.AT.ATIndex(:,1));
	% qf2_fam
	AO.qf2_fam.AT.ATType = 'FamPS';
    AO.qf2_fam.AT.ATMagnet = 'qf2';
	AO.qf2_fam.AT.ATIndex = buildatindex(AO.qf2.FamilyName, Indices.qf2);
	AO.qf2_fam.Position = findspos(THERING, AO.qf2_fam.AT.ATIndex(:,1));
	% qf3_fam
	AO.qf3_fam.AT.ATType = 'FamPS';
    AO.qf3_fam.AT.ATMagnet = 'qf3';
	AO.qf3_fam.AT.ATIndex = buildatindex(AO.qf3.FamilyName, Indices.qf3);
	AO.qf3_fam.Position = findspos(THERING, AO.qf3_fam.AT.ATIndex(:,1));
	% qf4_fam
	AO.qf4_fam.AT.ATType = 'FamPS';
    AO.qf4_fam.AT.ATMagnet = 'qf4';
	AO.qf4_fam.AT.ATIndex = buildatindex(AO.qf4.FamilyName, Indices.qf4);
	AO.qf4_fam.Position = findspos(THERING, AO.qf4_fam.AT.ATIndex(:,1));
catch
	warning('qf1_fam qf2_fam qf3_fam qf4_fam families not found in the model.');
end

try
	% qf1_shunt
	AO.qf1_shunt.AT.ATType = 'ShuntPS';
    AO.qf1_shunt.AT.ATMagnet = 'qf1';
	AO.qf1_shunt.AT.ATIndex = buildatindex(AO.qf1.FamilyName, Indices.qf1);
	AO.qf1_shunt.Position = findspos(THERING, AO.qf1_shunt.AT.ATIndex(:,1));
	% qf2_shunt
	AO.qf2_shunt.AT.ATType = 'ShuntPS';
    AO.qf2_shunt.AT.ATMagnet = 'qf2';
	AO.qf2_shunt.AT.ATIndex = buildatindex(AO.qf2.FamilyName, Indices.qf2);
	AO.qf2_shunt.Position = findspos(THERING, AO.qf2_shunt.AT.ATIndex(:,1));
	% qf3_shunt
	AO.qf3_shunt.AT.ATType = 'ShuntPS';
    AO.qf3_shunt.AT.ATMagnet = 'qf3';
	AO.qf3_shunt.AT.ATIndex = buildatindex(AO.qf3.FamilyName, Indices.qf3);
	AO.qf3_shunt.Position = findspos(THERING, AO.qf3_shunt.AT.ATIndex(:,1));
	% qf4_shunt
	AO.qf4_shunt.AT.ATType = 'ShuntPS';
    AO.qf4_shunt.AT.ATMagnet = 'qf4';
	AO.qf4_shunt.AT.ATIndex = buildatindex(AO.qf4.FamilyName, Indices.qf4);
	AO.qf4_shunt.Position = findspos(THERING, AO.qf4_shunt.AT.ATIndex(:,1));
catch
	warning('qf1_shunt qf2_shunt qf3_shunt qf4_shunt families not found in the model.');
end

try
    % sda
    AO.sda.AT.ATType = 'Sext';
    AO.sda.AT.ATIndex = buildatindex(AO.sda.FamilyName, Indices.sda);
    AO.sda.Position = findspos(THERING, AO.sda.AT.ATIndex(:,1))';
catch
    warning('sda family not found in the model.');
end

try
    % sfa
    AO.sfa.AT.ATType = 'Sext';
    AO.sfa.AT.ATIndex = buildatindex(AO.sfa.FamilyName, Indices.sfa);
    AO.sfa.Position = findspos(THERING, AO.sfa.AT.ATIndex(:,1))';
catch
    warning('sfa family not found in the model.');
end

try
    % sd1j
    AO.sd1j.AT.ATType = 'Sext';
    AO.sd1j.AT.ATIndex = buildatindex(AO.sd1j.FamilyName, Indices.sd1j);
    AO.sd1j.Position = findspos(THERING, AO.sd1j.AT.ATIndex(:,1))';
catch
    warning('sd1j family not found in the model.');
end

try
    % sf1j
    AO.sf1j.AT.ATType = 'Sext';
    AO.sf1j.AT.ATIndex = buildatindex(AO.sf1j.FamilyName, Indices.sf1j);
    AO.sf1j.Position = findspos(THERING, AO.sf1j.AT.ATIndex(:,1))';
catch
    warning('sf1j family not found in the model.');
end

try
    % sd2j
    AO.sd2j.AT.ATType = 'Sext';
    AO.sd2j.AT.ATIndex = buildatindex(AO.sd2j.FamilyName, Indices.sd2j);
    AO.sd2j.Position = findspos(THERING, AO.sd2j.AT.ATIndex(:,1))';
catch
    warning('sd2j family not found in the model.');
end

try
    % sd3j
    AO.sd3j.AT.ATType = 'Sext';
    AO.sd3j.AT.ATIndex = buildatindex(AO.sd3j.FamilyName, Indices.sd3j);
    AO.sd3j.Position = findspos(THERING, AO.sd3j.AT.ATIndex(:,1))';
catch
    warning('sd3j family not found in the model.');
end

try
    % sf2j
    AO.sf2j.AT.ATType = 'Sext';
    AO.sf2j.AT.ATIndex = buildatindex(AO.sf2j.FamilyName, Indices.sf2j);
    AO.sf2j.Position = findspos(THERING, AO.sf2j.AT.ATIndex(:,1))';
catch
    warning('sf2j family not found in the model.');
end

try
    % sd1k
    AO.sd1k.AT.ATType = 'Sext';
    AO.sd1k.AT.ATIndex = buildatindex(AO.sd1k.FamilyName, Indices.sd1k);
    AO.sd1k.Position = findspos(THERING, AO.sd1k.AT.ATIndex(:,1))';
catch
    warning('sd1k family not found in the model.');
end

try
    % sf1k
    AO.sf1k.AT.ATType = 'Sext';
    AO.sf1k.AT.ATIndex = buildatindex(AO.sf1k.FamilyName, Indices.sf1k);
    AO.sf1k.Position = findspos(THERING, AO.sf1k.AT.ATIndex(:,1))';
catch
    warning('sf1k family not found in the model.');
end

try
    % sd2k
    AO.sd2k.AT.ATType = 'Sext';
    AO.sd2k.AT.ATIndex = buildatindex(AO.sd2k.FamilyName, Indices.sd2k);
    AO.sd2k.Position = findspos(THERING, AO.sd2k.AT.ATIndex(:,1))';
catch
    warning('sd2k family not found in the model.');
end


try
    % sd3k
    AO.sd3k.AT.ATType = 'Sext';
    AO.sd3k.AT.ATIndex = buildatindex(AO.sd3k.FamilyName, Indices.sd3k);
    AO.sd3k.Position = findspos(THERING, AO.sd3k.AT.ATIndex(:,1))';
catch
    warning('sd3k family not found in the model.');
end

try
    % sf2k
    AO.sf2k.AT.ATType = 'Sext';
    AO.sf2k.AT.ATIndex = buildatindex(AO.sf2k.FamilyName, Indices.sf2k);
    AO.sf2k.Position = findspos(THERING, AO.sf2k.AT.ATIndex(:,1))';
catch
    warning('sf2k family not found in the model.');
end

try
    % sfb
    AO.sfb.AT.ATType = 'Sext';
    AO.sfb.AT.ATIndex = buildatindex(AO.sfb.FamilyName, Indices.sfb);
    AO.sfb.Position = findspos(THERING, AO.sfb.AT.ATIndex(:,1))';
catch
    warning('sfb family not found in the model.');
end

try
    % sdb
    AO.sdb.AT.ATType = 'Sext';
    AO.sdb.AT.ATIndex = buildatindex(AO.sdb.FamilyName, Indices.sdb);
    AO.sdb.Position = findspos(THERING, AO.sdb.AT.ATIndex(:,1))';
catch
    warning('sdb family not found in the model.');
end

try
    % BPMx
    AO.bpmx.AT.ATType = 'X';
    AO.bpmx.AT.ATIndex = buildatindex(AO.bpmx.FamilyName, Indices.bpm);
    AO.bpmx.Position = findspos(THERING, AO.bpmx.AT.ATIndex(:,1))';   
catch
    warning('bpmx family not found in the model.');
end

try
    % BPMy
    AO.bpmy.AT.ATType = 'Y';
    AO.bpmy.AT.ATIndex = buildatindex(AO.bpmy.FamilyName, Indices.bpm);
    AO.bpmy.Position = findspos(THERING, AO.bpmy.AT.ATIndex(:,1))';   
catch
    warning('bpmy family not found in the model.');
end

try
    % chs
    AO.chs.AT.ATType = 'HCM';
    AO.chs.AT.ATIndex = family_data.chs.ATIndex;
    AO.chs.Position   = findspos(THERING, AO.chs.AT.ATIndex(:,1))';   
catch
    warning('chs family not found in the model.');
end

try
    % cvs
    AO.cvs.AT.ATType = 'VCM';
    AO.cvs.AT.ATIndex = family_data.chs.ATIndex;
    AO.cvs.Position   = findspos(THERING, AO.cvs.AT.ATIndex(:,1))';   
catch
    warning('cvs family not found in the model.');
end

try
    % chf
    AO.chf.AT.ATType = 'HCM';
    AO.chf.AT.ATIndex = family_data.chf.ATIndex;
    AO.chf.Position   = findspos(THERING, AO.chf.AT.ATIndex(:,1))';   
catch
    warning('chf family not found in the model.');
end

try
    % cvf
    AO.cvf.AT.ATType = 'VCM';
    AO.cvf.AT.ATIndex = family_data.cvf.ATIndex;
    AO.cvf.Position   = findspos(THERING, AO.cvf.AT.ATIndex(:,1))';   
catch
    warning('cvf family not found in the model.');
end

try
    % qs
    AO.qs.AT.ATType = 'SKEWQUAD';
    AO.qs.AT.ATIndex = family_data.qs.ATIndex;
    AO.qs.Position   = findspos(THERING, AO.qs.AT.ATIndex(:,1))';   
catch
    warning('qs family not found in the model.');
end

% RF Cavity
try
    AO.RF.AT.ATType = 'RF Cavity';
    AO.RF.AT.ATIndex = findcells(THERING,'Frequency')';
    AO.RF.Position = findspos(THERING, AO.RF.AT.ATIndex(:,1))';
catch
    warning('RF cavity not found in the model.');
end

% DCCT
try
    AO.DCCT.AT.ATType = 'DCCT';
    AO.DCCT.AT.ATIndex = [findcells(THERING, 'FamName', 'dcct1'); findcells(THERING, 'FamName', 'dcct2')];
    AO.DCCT.Position = findspos(THERING, AO.DCCT.AT.ATIndex(:,1))';
catch
    warning('DCCT not found in the model.');
end


setao(AO);
