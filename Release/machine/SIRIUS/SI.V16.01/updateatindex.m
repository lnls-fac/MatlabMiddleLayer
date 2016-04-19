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
    % BC
    AO.bc.AT.ATType = 'BEND';
    AO.bc.AT.ATIndex = buildatindex(AO.bc.FamilyName, sort([Indices.bc_lf, Indices.bc_hf]));
    AO.bc.Position = findspos(THERING, AO.bc.AT.ATIndex(:,1+floor(size(AO.bc.AT.ATIndex,2)/2)))';
      
catch
    warning('bc family not found in the model.');
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
    AO.qfa_fam.AT.ATType   = 'FamilyPS';
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
	AO.qda_fam.AT.ATType = 'FamilyPS';
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
	AO.qfb_fam.AT.ATType = 'FamilyPS';
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
	AO.qdb2_fam.AT.ATType = 'FamilyPS';
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
	AO.qdb1_fam.AT.ATType = 'FamilyPS';
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
    % qfp
    AO.qfp.AT.ATType = 'Quad';
    AO.qfp.AT.ATIndex = buildatindex(AO.qfp.FamilyName, Indices.qfp);
    AO.qfp.Position = findspos(THERING, AO.qfp.AT.ATIndex(:,1))';
catch
    warning('qfp family not found in the model.');
end

try
	% qfp_fam
	AO.qfp_fam.AT.ATType = 'FamilyPS';
    AO.qfp_fam.AT.ATMagnet = 'qfp';
	AO.qfp_fam.AT.ATIndex = buildatindex(AO.qfp.FamilyName, Indices.qfp);
	AO.qfp_fam.Position = findspos(THERING, AO.qfp_fam.AT.ATIndex(:,1));
catch
	warning('qfp_fam family not found in the model.');
end

try
	% qfp_shunt
	AO.qfp_shunt.AT.ATType = 'ShuntPS';
    AO.qfp_shunt.AT.ATMagnet = 'qfp';
	AO.qfp_shunt.AT.ATIndex = buildatindex(AO.qfp.FamilyName, Indices.qfp);
	AO.qfp_shunt.Position = findspos(THERING, AO.qfp_shunt.AT.ATIndex(:,1));
catch
	warning('qfp_shunt family not found in the model.');
end

try
    % qdp2
    AO.qdp2.AT.ATType = 'Quad';
    AO.qdp2.AT.ATIndex = buildatindex(AO.qdp2.FamilyName, Indices.qdp2);
    AO.qdp2.Position = findspos(THERING, AO.qdp2.AT.ATIndex(:,1))';
catch
    warning('qdp2 family not found in the model.');
end

try
	% qdp2_fam
	AO.qdp2_fam.AT.ATType = 'FamilyPS';
    AO.qdp2_fam.AT.ATMagnet = 'qdp2';
	AO.qdp2_fam.AT.ATIndex = buildatindex(AO.qdp2.FamilyName, Indices.qdp2);
	AO.qdp2_fam.Position = findspos(THERING, AO.qdp2_fam.AT.ATIndex(:,1));
catch
	warning('qdp2_fam family not found in the model.');
end

try
	% qdp2_shunt
	AO.qdp2_shunt.AT.ATType = 'ShuntPS';
    AO.qdp2_shunt.AT.ATMagnet = 'qdp2';
	AO.qdp2_shunt.AT.ATIndex = buildatindex(AO.qdp2.FamilyName, Indices.qdp2);
	AO.qdp2_shunt.Position = findspos(THERING, AO.qdp2_shunt.AT.ATIndex(:,1));
catch
	warning('qdp2_shunt family not found in the model.');
end

try
    % qdp1
    AO.qdp1.AT.ATType = 'Quad';
    AO.qdp1.AT.ATIndex = buildatindex(AO.qdp1.FamilyName, Indices.qdp1);
    AO.qdp1.Position = findspos(THERING, AO.qdp1.AT.ATIndex(:,1))';
catch
    warning('qdp1 family not found in the model.');
end

try
	% qdp1_fam
	AO.qdp1_fam.AT.ATType = 'FamilyPS';
    AO.qdp1_fam.AT.ATMagnet = 'qdp1';
	AO.qdp1_fam.AT.ATIndex = buildatindex(AO.qdp1.FamilyName, Indices.qdp1);
	AO.qdp1_fam.Position = findspos(THERING, AO.qdp1_fam.AT.ATIndex(:,1));
catch
	warning('qdp1_fam family not found in the model.');
end

try
	% qdp1_shunt
	AO.qdp1_shunt.AT.ATType = 'ShuntPS';
    AO.qdp1_shunt.AT.ATMagnet = 'qdp1';
	AO.qdp1_shunt.AT.ATIndex = buildatindex(AO.qdp1.FamilyName, Indices.qdp1);
	AO.qdp1_shunt.Position = findspos(THERING, AO.qdp1_shunt.AT.ATIndex(:,1));
catch
	warning('qdp1_shunt family not found in the model.');
end

try
    % q1
    AO.q1.AT.ATType = 'Quad';
    AO.q1.AT.ATIndex = buildatindex(AO.q1.FamilyName, Indices.q1);
    AO.q1.Position = findspos(THERING, AO.q1.AT.ATIndex(:,1))';
    % q2
    AO.q2.AT.ATType = 'Quad';
    AO.q2.AT.ATIndex = buildatindex(AO.q2.FamilyName, Indices.q2);
    AO.q2.Position = findspos(THERING, AO.q2.AT.ATIndex(:,1))';
    % q3
    AO.q3.AT.ATType = 'Quad';
    AO.q3.AT.ATIndex = buildatindex(AO.q3.FamilyName, Indices.q3);
    AO.q3.Position = findspos(THERING, AO.q3.AT.ATIndex(:,1))';
    % q4
    AO.q4.AT.ATType = 'Quad';
    AO.q4.AT.ATIndex = buildatindex(AO.q4.FamilyName, Indices.q4);
    AO.q4.Position = findspos(THERING, AO.q4.AT.ATIndex(:,1))';
catch
    warning('q1 q2 q3 q4 families not found in the model.');
end

try
	% q1_fam
	AO.q1_fam.AT.ATType = 'FamilyPS';
    AO.q1_fam.AT.ATMagnet = 'q1';
	AO.q1_fam.AT.ATIndex = buildatindex(AO.q1.FamilyName, Indices.q1);
	AO.q1_fam.Position = findspos(THERING, AO.q1_fam.AT.ATIndex(:,1));
	% q2_fam
	AO.q2_fam.AT.ATType = 'FamilyPS';
    AO.q2_fam.AT.ATMagnet = 'q2';
	AO.q2_fam.AT.ATIndex = buildatindex(AO.q2.FamilyName, Indices.q2);
	AO.q2_fam.Position = findspos(THERING, AO.q2_fam.AT.ATIndex(:,1));
	% q3_fam
	AO.q3_fam.AT.ATType = 'FamilyPS';
    AO.q3_fam.AT.ATMagnet = 'q3';
	AO.q3_fam.AT.ATIndex = buildatindex(AO.q3.FamilyName, Indices.q3);
	AO.q3_fam.Position = findspos(THERING, AO.q3_fam.AT.ATIndex(:,1));
	% q4_fam
	AO.q4_fam.AT.ATType = 'FamilyPS';
    AO.q4_fam.AT.ATMagnet = 'q4';
	AO.q4_fam.AT.ATIndex = buildatindex(AO.q4.FamilyName, Indices.q4);
	AO.q4_fam.Position = findspos(THERING, AO.q4_fam.AT.ATIndex(:,1));
catch
	warning('q1_fam q2_fam q3_fam q4_fam families not found in the model.');
end

try
	% q1_shunt
	AO.q1_shunt.AT.ATType = 'ShuntPS';
    AO.q1_shunt.AT.ATMagnet = 'q1';
	AO.q1_shunt.AT.ATIndex = buildatindex(AO.q1.FamilyName, Indices.q1);
	AO.q1_shunt.Position = findspos(THERING, AO.q1_shunt.AT.ATIndex(:,1));
	% q2_shunt
	AO.q2_shunt.AT.ATType = 'ShuntPS';
    AO.q2_shunt.AT.ATMagnet = 'q2';
	AO.q2_shunt.AT.ATIndex = buildatindex(AO.q2.FamilyName, Indices.q2);
	AO.q2_shunt.Position = findspos(THERING, AO.q2_shunt.AT.ATIndex(:,1));
	% q3_shunt
	AO.q3_shunt.AT.ATType = 'ShuntPS';
    AO.q3_shunt.AT.ATMagnet = 'q3';
	AO.q3_shunt.AT.ATIndex = buildatindex(AO.q3.FamilyName, Indices.q3);
	AO.q3_shunt.Position = findspos(THERING, AO.q3_shunt.AT.ATIndex(:,1));
	% q4_shunt
	AO.q4_shunt.AT.ATType = 'ShuntPS';
    AO.q4_shunt.AT.ATMagnet = 'q4';
	AO.q4_shunt.AT.ATIndex = buildatindex(AO.q4.FamilyName, Indices.q4);
	AO.q4_shunt.Position = findspos(THERING, AO.q4_shunt.AT.ATIndex(:,1));
catch
	warning('q1_shunt q2_shunt q3_shunt q4_shunt families not found in the model.');
end

try
    % sda0
    AO.sda0.AT.ATType = 'Sext';
    AO.sda0.AT.ATIndex = buildatindex(AO.sda0.FamilyName, Indices.sda0);
    AO.sda0.Position = findspos(THERING, AO.sda0.AT.ATIndex(:,1))';
catch
    warning('sda0 family not found in the model.');
end

try
    % sdb0
    AO.sdb0.AT.ATType = 'Sext';
    AO.sdb0.AT.ATIndex = buildatindex(AO.sdb0.FamilyName, Indices.sdb0);
    AO.sdb0.Position = findspos(THERING, AO.sdb0.AT.ATIndex(:,1))';
catch
    warning('sdb0 family not found in the model.');
end

try
    % sdp0
    AO.sdp0.AT.ATType = 'Sext';
    AO.sdp0.AT.ATIndex = buildatindex(AO.sdp0.FamilyName, Indices.sdp0);
    AO.sdp0.Position = findspos(THERING, AO.sdp0.AT.ATIndex(:,1))';
catch
    warning('sdp0 family not found in the model.');
end

try
    % sda1
    AO.sda1.AT.ATType = 'Sext';
    AO.sda1.AT.ATIndex = buildatindex(AO.sda1.FamilyName, Indices.sda1);
    AO.sda1.Position = findspos(THERING, AO.sda1.AT.ATIndex(:,1))';
catch
    warning('sda1 family not found in the model.');
end

try
    % sdb1
    AO.sdb1.AT.ATType = 'Sext';
    AO.sdb1.AT.ATIndex = buildatindex(AO.sdb1.FamilyName, Indices.sdb1);
    AO.sdb1.Position = findspos(THERING, AO.sdb1.AT.ATIndex(:,1))';
catch
    warning('sdb1 family not found in the model.');
end

try
    % sdp1
    AO.sdp1.AT.ATType = 'Sext';
    AO.sdp1.AT.ATIndex = buildatindex(AO.sdp1.FamilyName, Indices.sdp1);
    AO.sdp1.Position = findspos(THERING, AO.sdp1.AT.ATIndex(:,1))';
catch
    warning('sdp1 family not found in the model.');
end

try
    % sda2
    AO.sda2.AT.ATType = 'Sext';
    AO.sda2.AT.ATIndex = buildatindex(AO.sda2.FamilyName, Indices.sda2);
    AO.sda2.Position = findspos(THERING, AO.sda2.AT.ATIndex(:,1))';
catch
    warning('sda2 family not found in the model.');
end

try
    % sdb2
    AO.sdb2.AT.ATType = 'Sext';
    AO.sdb2.AT.ATIndex = buildatindex(AO.sdb2.FamilyName, Indices.sdb2);
    AO.sdb2.Position = findspos(THERING, AO.sdb2.AT.ATIndex(:,1))';
catch
    warning('sdb2 family not found in the model.');
end

try
    % sdp2
    AO.sdp2.AT.ATType = 'Sext';
    AO.sdp2.AT.ATIndex = buildatindex(AO.sdp2.FamilyName, Indices.sdp2);
    AO.sdp2.Position = findspos(THERING, AO.sdp2.AT.ATIndex(:,1))';
catch
    warning('sdp2 family not found in the model.');
end

try
    % sda3
    AO.sda3.AT.ATType = 'Sext';
    AO.sda3.AT.ATIndex = buildatindex(AO.sda3.FamilyName, Indices.sda3);
    AO.sda3.Position = findspos(THERING, AO.sda3.AT.ATIndex(:,1))';
catch
    warning('sda3 family not found in the model.');
end

try
    % sdb3
    AO.sdb3.AT.ATType = 'Sext';
    AO.sdb3.AT.ATIndex = buildatindex(AO.sdb3.FamilyName, Indices.sdb3);
    AO.sdb3.Position = findspos(THERING, AO.sdb3.AT.ATIndex(:,1))';
catch
    warning('sdb3 family not found in the model.');
end

try
    % sdp3
    AO.sdp3.AT.ATType = 'Sext';
    AO.sdp3.AT.ATIndex = buildatindex(AO.sdp3.FamilyName, Indices.sdp3);
    AO.sdp3.Position = findspos(THERING, AO.sdp3.AT.ATIndex(:,1))';
catch
    warning('sdp3 family not found in the model.');
end

try
    % sfa0
    AO.sfa0.AT.ATType = 'Sext';
    AO.sfa0.AT.ATIndex = buildatindex(AO.sfa0.FamilyName, Indices.sfa0);
    AO.sfa0.Position = findspos(THERING, AO.sfa0.AT.ATIndex(:,1))';
catch
    warning('sfa0 family not found in the model.');
end

try
    % sfb0
    AO.sfb0.AT.ATType = 'Sext';
    AO.sfb0.AT.ATIndex = buildatindex(AO.sfb0.FamilyName, Indices.sfb0);
    AO.sfb0.Position = findspos(THERING, AO.sfb0.AT.ATIndex(:,1))';
catch
    warning('sfb0 family not found in the model.');
end

try
    % sfp0
    AO.sfp0.AT.ATType = 'Sext';
    AO.sfp0.AT.ATIndex = buildatindex(AO.sfp0.FamilyName, Indices.sfp0);
    AO.sfp0.Position = findspos(THERING, AO.sfp0.AT.ATIndex(:,1))';
catch
    warning('sfp0 family not found in the model.');
end

try
    % sfa1
    AO.sfa1.AT.ATType = 'Sext';
    AO.sfa1.AT.ATIndex = buildatindex(AO.sfa1.FamilyName, Indices.sfa1);
    AO.sfa1.Position = findspos(THERING, AO.sfa1.AT.ATIndex(:,1))';
catch
    warning('sfa1 family not found in the model.');
end

try
    % sfb1
    AO.sfb1.AT.ATType = 'Sext';
    AO.sfb1.AT.ATIndex = buildatindex(AO.sfb1.FamilyName, Indices.sfb1);
    AO.sfb1.Position = findspos(THERING, AO.sfb1.AT.ATIndex(:,1))';
catch
    warning('sfb1 family not found in the model.');
end

try
    % sfp1
    AO.sfp1.AT.ATType = 'Sext';
    AO.sfp1.AT.ATIndex = buildatindex(AO.sfp1.FamilyName, Indices.sfp1);
    AO.sfp1.Position = findspos(THERING, AO.sfp1.AT.ATIndex(:,1))';
catch
    warning('sfp1 family not found in the model.');
end

try
    % sfa2
    AO.sfa2.AT.ATType = 'Sext';
    AO.sfa2.AT.ATIndex = buildatindex(AO.sfa2.FamilyName, Indices.sfa2);
    AO.sfa2.Position = findspos(THERING, AO.sfa2.AT.ATIndex(:,1))';
catch
    warning('sfa2 family not found in the model.');
end

try
    % sfb2
    AO.sfb2.AT.ATType = 'Sext';
    AO.sfb2.AT.ATIndex = buildatindex(AO.sfb2.FamilyName, Indices.sfb2);
    AO.sfb2.Position = findspos(THERING, AO.sfb2.AT.ATIndex(:,1))';
catch
    warning('sfb2 family not found in the model.');
end

try
    % sfp2
    AO.sfp2.AT.ATType = 'Sext';
    AO.sfp2.AT.ATIndex = buildatindex(AO.sfp2.FamilyName, Indices.sfp2);
    AO.sfp2.Position = findspos(THERING, AO.sfp2.AT.ATIndex(:,1))';
catch
    warning('sfp2 family not found in the model.');
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
    % ch
    AO.ch.AT.ATType = 'HCM';
    AO.ch.AT.ATIndex = family_data.ch.ATIndex;
    AO.ch.Position   = findspos(THERING, AO.ch.AT.ATIndex(:,1))';   
catch
    warning('ch family not found in the model.');
end

try
    % cv
    AO.cv.AT.ATType = 'VCM';
    AO.cv.AT.ATIndex = family_data.cv.ATIndex;
    AO.cv.Position   = findspos(THERING, AO.cv.AT.ATIndex(:,1))';   
catch
    warning('cv family not found in the model.');
end

try
    % fch
    AO.fch.AT.ATType = 'HCM';
    AO.fch.AT.ATIndex = family_data.fch.ATIndex;
    AO.fch.Position   = findspos(THERING, AO.fch.AT.ATIndex(:,1))';   
catch
    warning('fch family not found in the model.');
end

try
    % fcv
    AO.fcv.AT.ATType = 'VCM';
    AO.fcv.AT.ATIndex = family_data.fcv.ATIndex;
    AO.fcv.Position   = findspos(THERING, AO.fcv.AT.ATIndex(:,1))';   
catch
    warning('fcv family not found in the model.');
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
