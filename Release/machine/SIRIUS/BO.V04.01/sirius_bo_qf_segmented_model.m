function [model, model_length] = sirius_bo_qf_segmented_model(energy, fam_name, passmethod, hardedge_KL)

% This script build an AT quadrupole model based on analysis of a fieldmap generated for a 3D magnetic model
% of the magnet and based on rotating coil measurement data for the constructed magnet.
%
% Input:
%
% energy [eV]       : beam energy
% hardedge_KL [1/m] : nominal integrated quadrupole strength
%
% Output:
%
% model            : AT segmented model
% model_length [m] : total model length
%
% Procedure:
%
% 1. Renormalizes all multipoles of the fieldmap segmented model so that
%    its main integrated multipole matches the nominal one.
% 2. Takes the rotating coild integrated multipoles and divides them by 
%    the magnetic rigidity corresponding to the beam energy. This yields
%    the normalized integrated multipolar strengths (PolynomB) for the model
% 3. Merges the fieldmap and rotating coild data into one segmented structure.
%    It does so by making sure that each corresponding fieldmap integrated multipole 
%    matches the rotating coil integrated multipole. It keeps the
%    longitudinal multipole profile of the segmented model.


magnet_type = 1;  % 0:dipole, 1:quadrupole, 2:sextupole

types = {};
b = 1; types{end+1} = struct('fam_name', fam_name, 'passmethod', passmethod);


% FIELDMAP
% trajectory centered in good-field region. init_rx is set to 0.0 mm
% *** interpolation of fields is now cubic ***
% *** more refined segmented model.
% *** dipole angle is now in units of degrees
%--- model polynom_b (rz > 0). units: [m] for length, [rad] for angle and [m],[T] for polynom_b ---
fmap_monomials = [1,5,9,13];

% QF model 2017-01-09 (3GeV)
% ===========================
% quadrupole model06
% filename: 2016-11-23_BQF_Model06_Sim_X=-20_20mm_Z=-450_450mm_I=110.8A.txt
segmodel_3GeV = [ ...
%type  len[m]   angle[deg]  PolyB(n=1)   PolyB(n=5)   PolyB(n=9)   PolyB(n=13)  
b,     0.114  ,  +0.00000 ,  +1.78e+00 ,  -1.91e+04 ,  +2.37e+11 ,  +4.91e+16 ;
];

% QF model 2017-01-09 (150MeV)
% ============================
% quadrupole model06
% filename: 2016-12-06_BQF_Model06_Sim_X=-20_20mm_Z=-450_450mm_I=5.28A.txt
segmodel_150MeV = [ ...
%type  len[m]   angle[deg]  PolyB(n=1)   PolyB(n=5)   PolyB(n=9)   PolyB(n=13)  
b,     0.114  ,  +0.00000 ,  +1.78e+00 ,  -1.91e+04 ,  +2.38e+11 ,  +4.91e+16 ;
];

% interpolates multipoles linearly in energy
segmodelo = segmodel_3GeV;
segmodelo(:,4:end) = segmodel_150MeV(:,4:end) + (energy - 150e6)/(3e9-150e6) * (segmodel_3GeV(:,4:end) - segmodel_150MeV(:,4:end));


% ROTATING COIL MEASUREMENT
% =========================
% data based on quadrupole prototype
% Rescale multipolar profile according to rotating coil measurement
rcoil_monomials  = [1,5,9,13];
rcoil_integrated_multipoles = [1,-1.066222407330279e+04,1.250513244082492e+11,9.696910847302045e+16]; % based on relative [1.0, -1.0e-3, 1.1e-3, 0.08e-3];
% ---------------------------------------------------------------



fmap_lens = segmodelo(:,2);

% rescale multipoles of the model according to nominal strength value passed as argument
% --------------------------------------------------------------------------------------
if exist('hardedge_KL','var')
    idx = find(fmap_monomials == magnet_type); 
    model_KL = 2*sum(segmodelo(:,3+idx) .* fmap_lens); 
    rescaling = hardedge_KL / model_KL;
    segmodelo(:,4:end) = segmodelo(:,4:end) * rescaling;
end

% rescale multipoles of the rotating coild data according to nominal strength value passed as argument
% ----------------------------------------------------------------------------------------------------
if ~isempty(rcoil_monomials)
    [~,~,brho] = lnls_beta_gamma(energy/1e9);
    rcoil_normalized_integrated_multipoles = -rcoil_integrated_multipoles / brho;
    rcoil_main_multipole_idx = find(rcoil_monomials == magnet_type, 1);
    rescaling = hardedge_KL / rcoil_normalized_integrated_multipoles(rcoil_main_multipole_idx);
    rcoil_normalized_integrated_multipoles = rcoil_normalized_integrated_multipoles * rescaling;
end        

% builds final model with fieldmap and rotating coild measurements
% ----------------------------------------------------------------
monomials = unique([fmap_monomials rcoil_monomials]);
segmodel = zeros(size(segmodelo,1),length(monomials));
segmodel(:,1:3) = segmodelo(:,1:3);
for i=1:length(monomials)
    rcoil_idx = find(rcoil_monomials == monomials(i), 1);
    fmap_idx  = find(fmap_monomials == monomials(i), 1);
    if isempty(rcoil_idx)
        % this multipole is not in rotating coil data: does nothing then.
        segmodel(:,i+3) = segmodelo(:,fmap_idx+3);
    else
        if isempty(fmap_idx)
            % if this multipole is not in fmap model then uses main multipole to build a multipolar profile
            fmap_integrated_multipole = 2*sum(segmodelo(:,magnet_type+3) .* fmap_lens);
        else
            fmap_integrated_multipole = 2*sum(segmodelo(:,fmap_idx+3) .* fmap_lens);
        end    
        rescaling = rcoil_normalized_integrated_multipoles(rcoil_idx) / fmap_integrated_multipole;
        segmodel(:,i+3) = segmodelo(:,fmap_idx+3) * rescaling;
    end
end

% converts deflection angle from degress to radians
segmodel(:,3) = segmodel(:,3) * (pi/180.0);

% turns deflection angle error off (convenient for having a nominal model with zero 4d closed orbit)
sel = (monomials == 0);
segmodel(:,sel) = 0;

% builds half of the magnet model
b = zeros(1,size(segmodel,1));
maxorder = 1+max(monomials);
for i=1:size(segmodel,1)
    type = types{segmodel(i,1)};
    if strcmpi(type.passmethod, 'IdentityPass')
        b(i) = marker(type.fam_name, 'IdentityPass');
    else
        PolyB = zeros(1,maxorder); PolyA = zeros(1,maxorder);
        PolyB(monomials+1) = segmodel(i,4:end); 
        b(i) = quadrupole_sirius(type.fam_name, segmodel(i,2), PolyA, PolyB, passmethod); 
    end
end

model_length = 2*sum(segmodel(:,2));
mqf  = marker('mQF',     'IdentityPass');
model = [b mqf b];


