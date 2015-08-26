function IDS = ID_definitions

% units
mm = 1; Tesla = 1;


IDS.IVU19.id_label                   = 'IVU19';
IDS.IVU19.nr_periods                 = 105;
IDS.IVU19.magnetic_gap               = 4.5 * mm;
IDS.IVU19.period                     = 19 * mm;
IDS.IVU19.cassette_separation        = 0.001 * mm; 
IDS.IVU19.block_separation           = 0  * mm;
IDS.IVU19.block_width                = 30 * mm;
IDS.IVU19.block_height               = 60 * mm;
IDS.IVU19.phase_csd                  = 0 * mm;
IDS.IVU19.phase_cie                  = 0 * mm;
IDS.IVU19.chamfer                    = 0  * mm;
IDS.IVU19.magnetization              = 1.511247901808101 * Tesla;   % [1.28T max field]
IDS.IVU19.vchamber_thkness           = 0.075 * mm;
IDS.IVU19.mech_tol                   = 0.025 * mm;
IDS.IVU19.physical_gap               = IDS.IVU19.magnetic_gap - 2 * (IDS.IVU19.vchamber_thkness + IDS.IVU19.mech_tol); 

IDS.IVU25.id_label                   = 'IVU25';
IDS.IVU25.nr_periods                 = 80;
IDS.IVU25.magnetic_gap               = 8.0 * mm;
IDS.IVU25.period                     = 25 * mm;
IDS.IVU25.cassette_separation        = 0.001 * mm; 
IDS.IVU25.block_separation           = 0  * mm;
IDS.IVU25.block_width                = 30 * mm;
IDS.IVU25.block_height               = 60 * mm;
IDS.IVU25.phase_csd                  = 0 * mm;
IDS.IVU25.phase_cie                  = 0 * mm;
IDS.IVU25.chamfer                    = 0  * mm;
IDS.IVU25.magnetization              = 1.432141439952380 * Tesla; % [0.94T max field]
IDS.IVU25.vchamber_thkness           = 0.075 * mm;
IDS.IVU25.mech_tol                   = 0.025 * mm;
IDS.IVU25.physical_gap               = IDS.IVU25.magnetic_gap - 2 * (IDS.IVU25.vchamber_thkness + IDS.IVU25.mech_tol);

IDS.IVU25_2ID.id_label                   = 'IVU25_2ID';
IDS.IVU25_2ID.nr_periods                 = 2*80;
IDS.IVU25_2ID.magnetic_gap               = 8.0 * mm;
IDS.IVU25_2ID.period                     = 25 * mm;
IDS.IVU25_2ID.cassette_separation        = 0.001 * mm; 
IDS.IVU25_2ID.block_separation           = 0  * mm;
IDS.IVU25_2ID.block_width                = 30 * mm;
IDS.IVU25_2ID.block_height               = 60 * mm;
IDS.IVU25_2ID.phase_csd                  = 0 * mm;
IDS.IVU25_2ID.phase_cie                  = 0 * mm;
IDS.IVU25_2ID.chamfer                    = 0  * mm;
IDS.IVU25_2ID.magnetization              = 1.432141439952380 * Tesla; % [0.94T max field]
IDS.IVU25_2ID.vchamber_thkness           = 0.075 * mm;
IDS.IVU25_2ID.mech_tol                   = 0.025 * mm;
IDS.IVU25_2ID.physical_gap               = IDS.IVU25_2ID.magnetic_gap - 2 * (IDS.IVU25_2ID.vchamber_thkness + IDS.IVU25_2ID.mech_tol);


IDS.EPU80_HP.id_label             = 'EPU80_HP';
IDS.EPU80_HP.period               = 80 * mm;
IDS.EPU80_HP.nr_periods           = 45;
IDS.EPU80_HP.magnetic_gap         = 12.0 * mm;
IDS.EPU80_HP.cassette_separation  = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
IDS.EPU80_HP.block_separation     = 0  * mm;
IDS.EPU80_HP.block_width          = 60 * mm;
IDS.EPU80_HP.block_height         = 60 * mm;
IDS.EPU80_HP.phase_csd            = 0 * mm;
IDS.EPU80_HP.phase_cie            = 0 * mm;
IDS.EPU80_HP.chamfer              = 0 * mm;
IDS.EPU80_HP.magnetization        = 1.203709499318410 * Tesla; %[1.30T max field]
IDS.EPU80_HP.vchamber_thkness     = 1.00 * mm;
IDS.EPU80_HP.mech_tol             = 0.50 * mm;
IDS.EPU80_HP.physical_gap         = IDS.EPU80_HP.magnetic_gap - 2 * (IDS.EPU80_HP.vchamber_thkness + IDS.EPU80_HP.mech_tol);

IDS.EPU80_VP.id_label             = 'EPU80_VP';
IDS.EPU80_VP.period               = 80 * mm;
IDS.EPU80_VP.nr_periods           = 45;
IDS.EPU80_VP.magnetic_gap         = 12.0 * mm;
IDS.EPU80_VP.cassette_separation  = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
IDS.EPU80_VP.block_separation     = 0  * mm;
IDS.EPU80_VP.block_width          = 60 * mm;
IDS.EPU80_VP.block_height         = 60 * mm;
IDS.EPU80_VP.phase_csd            = 40 * mm;
IDS.EPU80_VP.phase_cie            = 40 * mm;
IDS.EPU80_VP.chamfer              = 0 * mm;
IDS.EPU80_VP.magnetization        = 1.203709499318410 * Tesla; 
IDS.EPU80_VP.vchamber_thkness     = 1.00 * mm;
IDS.EPU80_VP.mech_tol             = 0.50 * mm;
IDS.EPU80_VP.physical_gap         = IDS.EPU80_VP.magnetic_gap - 2 * (IDS.EPU80_VP.vchamber_thkness + IDS.EPU80_VP.mech_tol);

IDS.EPU80_CP.id_label             = 'EPU80_CP';
IDS.EPU80_CP.period               = 80 * mm;
IDS.EPU80_CP.nr_periods           = 45;
IDS.EPU80_CP.magnetic_gap         = 12.0 * mm;
IDS.EPU80_CP.cassette_separation  = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
IDS.EPU80_CP.block_separation     = 0  * mm;
IDS.EPU80_CP.block_width          = 60 * mm;
IDS.EPU80_CP.block_height         = 60 * mm;
IDS.EPU80_CP.phase_csd            = 22.244202556364680 * mm;
IDS.EPU80_CP.phase_cie            = 22.244202556364680 * mm;
IDS.EPU80_CP.chamfer              =  0 * mm;
IDS.EPU80_CP.magnetization        = 1.203709499318410 * Tesla;
IDS.EPU80_CP.vchamber_thkness     = 1.00 * mm;
IDS.EPU80_CP.mech_tol             = 0.50 * mm;
IDS.EPU80_CP.physical_gap         = IDS.EPU80_CP.magnetic_gap - 2 * (IDS.EPU80_CP.vchamber_thkness + IDS.EPU80_CP.mech_tol);

IDS.EPU50_HP.id_label             = 'EPU50_HP';
IDS.EPU50_HP.period               = 50 * mm;
IDS.EPU50_HP.nr_periods           = 72;
IDS.EPU50_HP.magnetic_gap         = 12.0 * mm;
IDS.EPU50_HP.cassette_separation  = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
IDS.EPU50_HP.block_separation     = 0  * mm;
IDS.EPU50_HP.block_width          = 60 * mm;
IDS.EPU50_HP.block_height         = 60 * mm;
IDS.EPU50_HP.phase_csd            = 0 * mm;
IDS.EPU50_HP.phase_cie            = 0 * mm;
IDS.EPU50_HP.chamfer              = 0 * mm;
IDS.EPU50_HP.magnetization        = 1.192663025704198 * Tesla; %[1.0T max field]
IDS.EPU50_HP.vchamber_thkness     = 1.00 * mm;
IDS.EPU50_HP.mech_tol             = 0.50 * mm;
IDS.EPU50_HP.physical_gap         = IDS.EPU50_HP.magnetic_gap - 2 * (IDS.EPU50_HP.vchamber_thkness + IDS.EPU50_HP.mech_tol);

IDS.EPU50_VP.id_label             = 'EPU50_VP';
IDS.EPU50_VP.period               = 50 * mm;
IDS.EPU50_VP.nr_periods           = 72;
IDS.EPU50_VP.magnetic_gap         = 12.0 * mm;
IDS.EPU50_VP.cassette_separation  = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
IDS.EPU50_VP.block_separation     = 0  * mm;
IDS.EPU50_VP.block_width          = 60 * mm;
IDS.EPU50_VP.block_height         = 60 * mm;
IDS.EPU50_VP.phase_csd            = 25 * mm;
IDS.EPU50_VP.phase_cie            = 25 * mm;
IDS.EPU50_VP.chamfer              = 0 * mm;
IDS.EPU50_VP.magnetization        = 1.192663025704198 * Tesla; 
IDS.EPU50_VP.vchamber_thkness     = 1.00 * mm;
IDS.EPU50_VP.mech_tol             = 0.50 * mm;
IDS.EPU50_VP.physical_gap         = IDS.EPU50_VP.magnetic_gap - 2 * (IDS.EPU50_VP.vchamber_thkness + IDS.EPU50_VP.mech_tol);

IDS.EPU50_CP.id_label             = 'EPU50_CP';
IDS.EPU50_CP.period               = 50 * mm;
IDS.EPU50_CP.nr_periods           = 72;
IDS.EPU50_CP.magnetic_gap         = 12.0 * mm;
IDS.EPU50_CP.cassette_separation  = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
IDS.EPU50_CP.block_separation     = 0  * mm;
IDS.EPU50_CP.block_width          = 60 * mm;
IDS.EPU50_CP.block_height         = 60 * mm;
IDS.EPU50_CP.phase_csd            = 15.057790327662556 * mm;
IDS.EPU50_CP.phase_cie            = 15.057790327662556 * mm;
IDS.EPU50_CP.chamfer              = 0 * mm;
IDS.EPU50_CP.magnetization        = 1.192663025704198 * Tesla; 
IDS.EPU50_CP.vchamber_thkness     = 1.00 * mm;
IDS.EPU50_CP.mech_tol             = 0.50 * mm;
IDS.EPU50_CP.physical_gap         = IDS.EPU50_CP.magnetic_gap - 2 * (IDS.EPU50_CP.vchamber_thkness + IDS.EPU50_CP.mech_tol);

% OLDER THAN 2015-07-30


% %% TEST PLANAR UNDULATORS
% %  ======================
% IDS.UTEST.id_label                   = 'UTEST';
% IDS.UTEST.nr_periods                 = 86;
% IDS.UTEST.magnetic_gap               = 4.2 * mm;
% IDS.UTEST.period                     = 22 * mm;
% IDS.UTEST.cassette_separation        = 0.00001 * mm; 
% IDS.UTEST.block_separation           = 0  * mm;
% IDS.UTEST.block_width                = 25 * mm;
% IDS.UTEST.block_height               = 30 * mm;
% IDS.UTEST.phase_csd                  =  0 * mm;
% IDS.UTEST.phase_cie                  =  0 * mm;
% IDS.UTEST.chamfer                    =  0  * mm;
% IDS.UTEST.magnetization              =  1.44 * Tesla;
% 
% %% WIGGLERs
% %  ========
% 
% IDS.SCW3T.id_label                 = 'SCW3T';
% IDS.SCW3T.nr_periods               = 16;
% IDS.SCW3T.magnetic_gap             = 18.4 * mm;
% IDS.SCW3T.period                   = 59.19 * mm; % from fft of field data
% IDS.SCW3T.cassette_separation      = 0.001 * mm; 
% IDS.SCW3T.block_separation         = 0  * mm;
% IDS.SCW3T.block_width              = 39.734358709704878 * mm; % fits measured sextupolar component
% IDS.SCW3T.block_height             = 40 * mm;
% IDS.SCW3T.phase_csd                =  0 * mm;
% IDS.SCW3T.phase_cie                =  0 * mm;
% IDS.SCW3T.chamfer                  =  0  * mm;
% IDS.SCW3T.magnetization            =  4.53; % gives 3T field
% 
% IDS.SCW4T.id_label                 = 'SCW4T';
% IDS.SCW4T.nr_periods               = 16;
% IDS.SCW4T.magnetic_gap             = 18.4 * mm;
% IDS.SCW4T.period                   = 59.19 * mm; % from fft of field data
% IDS.SCW4T.cassette_separation      = 0.001 * mm; 
% IDS.SCW4T.block_separation         = 0  * mm;
% IDS.SCW4T.block_width              = 39.734358709704878 * mm; % fits measured sextupolar component
% IDS.SCW4T.block_height             = 40 * mm;
% IDS.SCW4T.phase_csd                =  0 * mm;
% IDS.SCW4T.phase_cie                =  0 * mm;
% IDS.SCW4T.chamfer                  =  0  * mm;
% IDS.SCW4T.magnetization            =  4.53 * (4/3); % gives 4T field
% IDS.SCW4T.vchamber_thkness         = 1.00 * mm;
% IDS.SCW4T.mech_tol                 = 0.50 * mm;
% IDS.SCW4T.physical_gap             = IDS.SCW4T.magnetic_gap - 2 * (IDS.SCW4T.vchamber_thkness + IDS.SCW4T.mech_tol);
% 
% IDS.W2T.id_label                   = 'W2T';
% IDS.W2T.nr_periods                 = 15;
% IDS.W2T.magnetic_gap               = 22 * mm;
% IDS.W2T.period                     = 180 * mm;
% IDS.W2T.cassette_separation        = 0.001 * mm; 
% IDS.W2T.block_separation           = 0  * mm;
% IDS.W2T.block_width                = 40 * mm;
% IDS.W2T.block_height               = 100 * mm;
% IDS.W2T.phase_csd                  =  0 * mm;
% IDS.W2T.phase_cie                  =  0 * mm;
% IDS.W2T.chamfer                    =  0  * mm;
% IDS.W2T.magnetization              =  1.9497;
% 
% %% PLANAR UNDULATORS
% %  =================
% IDS.U18.id_label                   = 'U18';
% IDS.U18.nr_periods                 = 111;
% IDS.U18.magnetic_gap               = 4.2 * mm;
% IDS.U18.period                     = 18 * mm;
% IDS.U18.cassette_separation        = 0.001 * mm; 
% IDS.U18.block_separation           = 0  * mm;
% IDS.U18.block_width                = 30 * mm;
% IDS.U18.block_height               = 60 * mm;
% IDS.U18.phase_csd                  =  0 * mm;
% IDS.U18.phase_cie                  =  0 * mm;
% IDS.U18.chamfer                    =  0  * mm;
% IDS.U18.magnetization              =  1.44 * Tesla;
% 
% IDS.U19.id_label                   = 'U19';
% IDS.U19.nr_periods                 = 105;
% IDS.U19.magnetic_gap               = 4.2 * mm;
% IDS.U19.period                     = 19 * mm;
% IDS.U19.cassette_separation        = 0.001 * mm; 
% IDS.U19.block_separation           = 0  * mm;
% IDS.U19.block_width                = 30 * mm;
% IDS.U19.block_height               = 60 * mm;
% IDS.U19.phase_csd                  =  0 * mm;
% IDS.U19.phase_cie                  =  0 * mm;
% IDS.U19.chamfer                    =  0  * mm;
% IDS.U19.magnetization              =  1.44 * Tesla;
% IDS.U19.vchamber_thkness           = 0.075 * mm;
% IDS.U19.mech_tol                   = 0.025 * mm;
% IDS.U19.physical_gap               = IDS.U19.magnetic_gap - 2 * (IDS.U19.vchamber_thkness + IDS.U19.mech_tol);
% 
% IDS.U25.id_label                   = 'U25';
% IDS.U25.nr_periods                 = 80;
% IDS.U25.magnetic_gap               = 8.0 * mm;
% IDS.U25.period                     = 25 * mm;
% IDS.U25.cassette_separation        = 0.001 * mm; 
% IDS.U25.block_separation           = 0  * mm;
% IDS.U25.block_width                = 30 * mm;
% IDS.U25.block_height               = 60 * mm;
% IDS.U25.phase_csd                  =  0 * mm;
% IDS.U25.phase_cie                  =  0 * mm;
% IDS.U25.chamfer                    =  0  * mm;
% IDS.U25.magnetization              =  1.44 * Tesla;
% IDS.U25.vchamber_thkness           = 0.075 * mm;
% IDS.U25.mech_tol                   = 0.025 * mm;
% IDS.U25.physical_gap               = IDS.U25.magnetic_gap - 2 * (IDS.U25.vchamber_thkness + IDS.U25.mech_tol);
% 
% IDS.U25_2ID.id_label                   = 'U25_2ID';
% IDS.U25_2ID.nr_periods                 = 160;
% IDS.U25_2ID.magnetic_gap               = 8.0 * mm;
% IDS.U25_2ID.period                     = 25 * mm;
% IDS.U25_2ID.cassette_separation        = 0.001 * mm; 
% IDS.U25_2ID.block_separation           = 0  * mm;
% IDS.U25_2ID.block_width                = 30 * mm;
% IDS.U25_2ID.block_height               = 60 * mm;
% IDS.U25_2ID.phase_csd                  =  0 * mm;
% IDS.U25_2ID.phase_cie                  =  0 * mm;
% IDS.U25_2ID.chamfer                    =  0  * mm;
% IDS.U25_2ID.magnetization              =  1.44 * Tesla;
% IDS.U25_2ID.vchamber_thkness           = 0.075 * mm;
% IDS.U25_2ID.mech_tol                   = 0.025 * mm;
% IDS.U25_2ID.physical_gap               = IDS.U25_2ID.magnetic_gap - 2 * (IDS.U25_2ID.vchamber_thkness + IDS.U25_2ID.mech_tol);



% 
% 
% %% EPUs
% %  ====
% 
% IDS.EPU80_PH.id_label             = 'EPU80_PH';
% IDS.EPU80_PH.period               = 80 * mm;
% IDS.EPU80_PH.nr_periods           = 38;
% IDS.EPU80_PH.magnetic_gap         = 16.0 * mm;
% IDS.EPU80_PH.cassette_separation  = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
% IDS.EPU80_PH.block_separation     = 0  * mm;
% IDS.EPU80_PH.block_width          = 40 * mm;
% IDS.EPU80_PH.block_height         = 60 * mm;
% IDS.EPU80_PH.phase_csd            =  0 * mm;
% IDS.EPU80_PH.phase_cie            =  0 * mm;
% IDS.EPU80_PH.chamfer              =  0 * mm;
% IDS.EPU80_PH.magnetization        =  (0.9/0.7037) * 0.7634 * Tesla;
% IDS.EPU80_PH.vchamber_thkness     = 1.00 * mm;
% IDS.EPU80_PH.mech_tol             = 0.50 * mm;
% IDS.EPU80_PH.physical_gap         = IDS.EPU80_PH.magnetic_gap - 2 * (IDS.EPU80_PH.vchamber_thkness + IDS.EPU80_PH.mech_tol);
% 
% IDS.EPU80_PV.id_label             = 'EPU80_PV';
% IDS.EPU80_PV.period               = 80 * mm;
% IDS.EPU80_PV.nr_periods           = 38;
% IDS.EPU80_PV.magnetic_gap         = 16.0 * mm;
% IDS.EPU80_PV.cassette_separation  = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
% IDS.EPU80_PV.block_separation     = 0  * mm;
% IDS.EPU80_PV.block_width          = 40 * mm;
% IDS.EPU80_PV.block_height         = 60 * mm;
% IDS.EPU80_PV.phase_csd            = 40 * mm;
% IDS.EPU80_PV.phase_cie            = 40 * mm;
% IDS.EPU80_PV.chamfer              =  0 * mm;
% IDS.EPU80_PV.magnetization        =  (0.9/0.7037) * 0.7634 * Tesla;
% IDS.EPU80_PV.vchamber_thkness     = 1.00 * mm;
% IDS.EPU80_PV.mech_tol             = 0.50 * mm;
% IDS.EPU80_PV.physical_gap         = IDS.EPU80_PV.magnetic_gap - 2 * (IDS.EPU80_PV.vchamber_thkness + IDS.EPU80_PV.mech_tol);
% 
% 
% IDS.EPU80_2ID_PH.id_label             = 'EPU80_2ID_PH';
% IDS.EPU80_2ID_PH.period               = 80 * mm;
% IDS.EPU80_2ID_PH.nr_periods           = 67;
% IDS.EPU80_2ID_PH.magnetic_gap         = 16.0 * mm;
% IDS.EPU80_2ID_PH.cassette_separation  = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
% IDS.EPU80_2ID_PH.block_separation     = 0  * mm;
% IDS.EPU80_2ID_PH.block_width          = 40 * mm;
% IDS.EPU80_2ID_PH.block_height         = 60 * mm;
% IDS.EPU80_2ID_PH.phase_csd            =  0 * mm;
% IDS.EPU80_2ID_PH.phase_cie            =  0 * mm;
% IDS.EPU80_2ID_PH.chamfer              =  0 * mm;
% IDS.EPU80_2ID_PH.magnetization        =  (0.9/0.7037) * 0.7634 * Tesla;
% IDS.EPU80_2ID_PH.vchamber_thkness     = 1.00 * mm;
% IDS.EPU80_2ID_PH.mech_tol             = 0.50 * mm;
% IDS.EPU80_2ID_PH.physical_gap         = IDS.EPU80_2ID_PH.magnetic_gap - 2 * (IDS.EPU80_2ID_PH.vchamber_thkness + IDS.EPU80_2ID_PH.mech_tol);
% 
% IDS.EPU80_2ID_PV.id_label             = 'EPU80_2ID_PV';
% IDS.EPU80_2ID_PV.period               = 80 * mm;
% IDS.EPU80_2ID_PV.nr_periods           = 67;
% IDS.EPU80_2ID_PV.magnetic_gap         = 16.0 * mm;
% IDS.EPU80_2ID_PV.cassette_separation  = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
% IDS.EPU80_2ID_PV.block_separation     = 0  * mm;
% IDS.EPU80_2ID_PV.block_width          = 40 * mm;
% IDS.EPU80_2ID_PV.block_height         = 60 * mm;
% IDS.EPU80_2ID_PV.phase_csd            = 40 * mm;
% IDS.EPU80_2ID_PV.phase_cie            = 40 * mm;
% IDS.EPU80_2ID_PV.chamfer              =  0 * mm;
% IDS.EPU80_2ID_PV.magnetization        =  (0.9/0.7037) * 0.7634 * Tesla;
% IDS.EPU80_2ID_PV.vchamber_thkness     = 1.00 * mm;
% IDS.EPU80_2ID_PV.mech_tol             = 0.50 * mm;
% IDS.EPU80_2ID_PV.physical_gap         = IDS.EPU80_2ID_PV.magnetic_gap - 2 * (IDS.EPU80_2ID_PV.vchamber_thkness + IDS.EPU80_2ID_PV.mech_tol);
% 
% IDS.EPU80_2ID_PC.id_label             = 'EPU80_2ID_PC';
% IDS.EPU80_2ID_PC.period               = 80 * mm;
% IDS.EPU80_2ID_PC.nr_periods           = 67;
% IDS.EPU80_2ID_PC.magnetic_gap         = 16.0 * mm;
% IDS.EPU80_2ID_PC.cassette_separation  = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
% IDS.EPU80_2ID_PC.block_separation     = 0  * mm;
% IDS.EPU80_2ID_PC.block_width          = 40 * mm;
% IDS.EPU80_2ID_PC.block_height         = 60 * mm;
% IDS.EPU80_2ID_PC.phase_csd            = 23.7 * mm;
% IDS.EPU80_2ID_PC.phase_cie            = 23.7 * mm;
% IDS.EPU80_2ID_PC.chamfer              =  0 * mm;
% IDS.EPU80_2ID_PC.magnetization        =  (0.9/0.7037) * 0.7634 * Tesla;
% IDS.EPU80_2ID_PC.vchamber_thkness     = 1.00 * mm;
% IDS.EPU80_2ID_PC.mech_tol             = 0.50 * mm;
% IDS.EPU80_2ID_PC.physical_gap         = IDS.EPU80_2ID_PC.magnetic_gap - 2 * (IDS.EPU80_2ID_PC.vchamber_thkness + IDS.EPU80_2ID_PC.mech_tol);
% 
% % --- tests ---
% 
% IDS.EPU80_2ID_W60_LH.id_label             = 'EPU80_2ID_W60_LH';
% IDS.EPU80_2ID_W60_LH.period               = 80 * mm;
% IDS.EPU80_2ID_W60_LH.nr_periods           = 67;
% IDS.EPU80_2ID_W60_LH.magnetic_gap         = 16.0 * mm;
% IDS.EPU80_2ID_W60_LH.cassette_separation  = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
% IDS.EPU80_2ID_W60_LH.block_separation     = 0  * mm;
% IDS.EPU80_2ID_W60_LH.block_width          = 60 * mm;
% IDS.EPU80_2ID_W60_LH.block_height         = 60 * mm;
% IDS.EPU80_2ID_W60_LH.phase_csd            =  0 * mm;
% IDS.EPU80_2ID_W60_LH.phase_cie            =  0 * mm;
% IDS.EPU80_2ID_W60_LH.chamfer              =  0 * mm;
% IDS.EPU80_2ID_W60_LH.magnetization        =  (0.9/0.7037) * 0.7634 * Tesla;
% IDS.EPU80_2ID_W60_LH.vchamber_thkness     = 1.00 * mm;
% IDS.EPU80_2ID_W60_LH.mech_tol             = 0.50 * mm;
% IDS.EPU80_2ID_W60_LH.physical_gap         = IDS.EPU80_2ID_W60_LH.magnetic_gap - 2 * (IDS.EPU80_2ID_W60_LH.vchamber_thkness + IDS.EPU80_2ID_W60_LH.mech_tol);
% 
% IDS.EPU80_2ID_W60_LV.id_label             = 'EPU80_2ID_W60_LV';
% IDS.EPU80_2ID_W60_LV.period               = 80 * mm;
% IDS.EPU80_2ID_W60_LV.nr_periods           = 67;
% IDS.EPU80_2ID_W60_LV.magnetic_gap         = 16.0 * mm;
% IDS.EPU80_2ID_W60_LV.cassette_separation  = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
% IDS.EPU80_2ID_W60_LV.block_separation     = 0  * mm;
% IDS.EPU80_2ID_W60_LV.block_width          = 60 * mm;
% IDS.EPU80_2ID_W60_LV.block_height         = 60 * mm;
% IDS.EPU80_2ID_W60_LV.phase_csd            = 40 * mm;
% IDS.EPU80_2ID_W60_LV.phase_cie            = 40 * mm;
% IDS.EPU80_2ID_W60_LV.chamfer              =  0 * mm;
% IDS.EPU80_2ID_W60_LV.magnetization        =  (0.9/0.7037) * 0.7634 * Tesla;
% IDS.EPU80_2ID_W60_LV.vchamber_thkness     = 1.00 * mm;
% IDS.EPU80_2ID_W60_LV.mech_tol             = 0.50 * mm;
% IDS.EPU80_2ID_W60_LV.physical_gap         = IDS.EPU80_2ID_W60_LV.magnetic_gap - 2 * (IDS.EPU80_2ID_W60_LV.vchamber_thkness + IDS.EPU80_2ID_W60_LV.mech_tol);
% 
% IDS.EPU80_2ID_W60_CP.id_label             = 'EPU80_2ID_W60_CP';
% IDS.EPU80_2ID_W60_CP.period               = 80 * mm;
% IDS.EPU80_2ID_W60_CP.nr_periods           = 67;
% IDS.EPU80_2ID_W60_CP.magnetic_gap         = 16.0 * mm;
% IDS.EPU80_2ID_W60_CP.cassette_separation  = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
% IDS.EPU80_2ID_W60_CP.block_separation     = 0  * mm;
% IDS.EPU80_2ID_W60_CP.block_width          = 60 * mm;
% IDS.EPU80_2ID_W60_CP.block_height         = 60 * mm;
% IDS.EPU80_2ID_W60_CP.phase_csd            = 23.7 * mm;
% IDS.EPU80_2ID_W60_CP.phase_cie            = 23.7 * mm;
% IDS.EPU80_2ID_W60_CP.chamfer              =  0 * mm;
% IDS.EPU80_2ID_W60_CP.magnetization        =  (0.9/0.7037) * 0.7634 * Tesla;
% IDS.EPU80_2ID_W60_CP.vchamber_thkness     = 1.00 * mm;
% IDS.EPU80_2ID_W60_CP.mech_tol             = 0.50 * mm;
% IDS.EPU80_2ID_W60_CP.physical_gap         = IDS.EPU80_2ID_W60_CP.magnetic_gap - 2 * (IDS.EPU80_2ID_W60_CP.vchamber_thkness + IDS.EPU80_2ID_W60_CP.mech_tol);
% 
% 
% 
% IDS.EPU80_2ID_W80_LH.id_label             = 'EPU80_2ID_W80_LH';
% IDS.EPU80_2ID_W80_LH.period               = 80 * mm;
% IDS.EPU80_2ID_W80_LH.nr_periods           = 67;
% IDS.EPU80_2ID_W80_LH.magnetic_gap         = 16.0 * mm;
% IDS.EPU80_2ID_W80_LH.cassette_separation  = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
% IDS.EPU80_2ID_W80_LH.block_separation     = 0  * mm;
% IDS.EPU80_2ID_W80_LH.block_width          = 80 * mm;
% IDS.EPU80_2ID_W80_LH.block_height         = 60 * mm;
% IDS.EPU80_2ID_W80_LH.phase_csd            =  0 * mm;
% IDS.EPU80_2ID_W80_LH.phase_cie            =  0 * mm;
% IDS.EPU80_2ID_W80_LH.chamfer              =  0 * mm;
% IDS.EPU80_2ID_W80_LH.magnetization        =  (0.9/0.7037) * 0.7634 * Tesla;
% IDS.EPU80_2ID_W80_LH.vchamber_thkness     = 1.00 * mm;
% IDS.EPU80_2ID_W80_LH.mech_tol             = 0.50 * mm;
% IDS.EPU80_2ID_W80_LH.physical_gap         = IDS.EPU80_2ID_W80_LH.magnetic_gap - 2 * (IDS.EPU80_2ID_W80_LH.vchamber_thkness + IDS.EPU80_2ID_W80_LH.mech_tol);
% 
% IDS.EPU80_2ID_W80_LV.id_label             = 'EPU80_2ID_W80_LV';
% IDS.EPU80_2ID_W80_LV.period               = 80 * mm;
% IDS.EPU80_2ID_W80_LV.nr_periods           = 67;
% IDS.EPU80_2ID_W80_LV.magnetic_gap         = 16.0 * mm;
% IDS.EPU80_2ID_W80_LV.cassette_separation  = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
% IDS.EPU80_2ID_W80_LV.block_separation     = 0  * mm;
% IDS.EPU80_2ID_W80_LV.block_width          = 80 * mm;
% IDS.EPU80_2ID_W80_LV.block_height         = 60 * mm;
% IDS.EPU80_2ID_W80_LV.phase_csd            = 40 * mm;
% IDS.EPU80_2ID_W80_LV.phase_cie            = 40 * mm;
% IDS.EPU80_2ID_W80_LV.chamfer              =  0 * mm;
% IDS.EPU80_2ID_W80_LV.magnetization        =  (0.9/0.7037) * 0.7634 * Tesla;
% IDS.EPU80_2ID_W80_LV.vchamber_thkness     = 1.00 * mm;
% IDS.EPU80_2ID_W80_LV.mech_tol             = 0.50 * mm;
% IDS.EPU80_2ID_W80_LV.physical_gap         = IDS.EPU80_2ID_W80_LV.magnetic_gap - 2 * (IDS.EPU80_2ID_W80_LV.vchamber_thkness + IDS.EPU80_2ID_W80_LV.mech_tol);
% 
% IDS.EPU80_2ID_W80_CP.id_label             = 'EPU80_2ID_W80_CP';
% IDS.EPU80_2ID_W80_CP.period               = 80 * mm;
% IDS.EPU80_2ID_W80_CP.nr_periods           = 67;
% IDS.EPU80_2ID_W80_CP.magnetic_gap         = 16.0 * mm;
% IDS.EPU80_2ID_W80_CP.cassette_separation  = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
% IDS.EPU80_2ID_W80_CP.block_separation     = 0  * mm;
% IDS.EPU80_2ID_W80_CP.block_width          = 80 * mm;
% IDS.EPU80_2ID_W80_CP.block_height         = 60 * mm;
% IDS.EPU80_2ID_W80_CP.phase_csd            = 23.7 * mm;
% IDS.EPU80_2ID_W80_CP.phase_cie            = 23.7 * mm;
% IDS.EPU80_2ID_W80_CP.chamfer              =  0 * mm;
% IDS.EPU80_2ID_W80_CP.magnetization        =  (0.9/0.7037) * 0.7634 * Tesla;
% IDS.EPU80_2ID_W80_CP.vchamber_thkness     = 1.00 * mm;
% IDS.EPU80_2ID_W80_CP.mech_tol             = 0.50 * mm;
% IDS.EPU80_2ID_W80_CP.physical_gap         = IDS.EPU80_2ID_W80_CP.magnetic_gap - 2 * (IDS.EPU80_2ID_W80_CP.vchamber_thkness + IDS.EPU80_2ID_W80_CP.mech_tol);
% 
% 
% % --- epu50 ---
% IDS.EPU50_PH.id_label             = 'EPU50_PH';
% IDS.EPU50_PH.period               = 50 * mm;
% IDS.EPU50_PH.nr_periods           = 60;
% IDS.EPU50_PH.magnetic_gap         = 10.0 * mm;
% IDS.EPU50_PH.cassette_separation  = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
% IDS.EPU50_PH.block_separation     = 0  * mm;
% IDS.EPU50_PH.block_width          = 40 * mm;
% IDS.EPU50_PH.block_height         = 60 * mm;
% IDS.EPU50_PH.phase_csd            =  0 * mm;
% IDS.EPU50_PH.phase_cie            =  0 * mm;
% IDS.EPU50_PH.chamfer              =  0  * mm;
% IDS.EPU50_PH.magnetization        =  0.7634 * Tesla;
% 
% IDS.EPU50_PC.id_label             = 'EPU50_PC';
% IDS.EPU50_PC.period               = 50 * mm;
% IDS.EPU50_PC.nr_periods           = 60;
% IDS.EPU50_PC.magnetic_gap         = 10.0 * mm;
% IDS.EPU50_PC.cassette_separation  = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
% IDS.EPU50_PC.block_separation     = 0  * mm;
% IDS.EPU50_PC.block_width          = 40 * mm;
% IDS.EPU50_PC.block_height         = 60 * mm;
% IDS.EPU50_PC.phase_csd            =  14.5 * mm;
% IDS.EPU50_PC.phase_cie            =  14.5 * mm;
% IDS.EPU50_PC.chamfer              =  0  * mm;
% IDS.EPU50_PC.magnetization        =  0.7634 * Tesla;
% 
% IDS.EPU50_PV.id_label             = 'EPU50_PV';
% IDS.EPU50_PV.period               = 50 * mm;
% IDS.EPU50_PV.nr_periods           = 60;
% IDS.EPU50_PV.magnetic_gap         = 10.0 * mm;
% IDS.EPU50_PV.cassette_separation  = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
% IDS.EPU50_PV.block_separation     = 0  * mm;
% IDS.EPU50_PV.block_width          = 40 * mm;
% IDS.EPU50_PV.block_height         = 60 * mm;
% IDS.EPU50_PV.phase_csd            =  25 * mm;
% IDS.EPU50_PV.phase_cie            =  25 * mm;
% IDS.EPU50_PV.chamfer              =  0  * mm;
% IDS.EPU50_PV.magnetization        =  0.7634 * Tesla;
% 
% % --- epu200 ---
% IDS.EPU200_PH.id_label            = 'EPU200_PH';
% IDS.EPU200_PH.nr_periods          = 15;
% IDS.EPU200_PH.magnetic_gap        = 10.0 * mm;
% IDS.EPU200_PH.period              = 200 * mm;
% IDS.EPU200_PH.cassette_separation = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
% IDS.EPU200_PH.block_separation    = 0  * mm;
% IDS.EPU200_PH.block_width         = 40 * mm;
% IDS.EPU200_PH.block_height        = 60 * mm;
% IDS.EPU200_PH.phase_csd           =  0 * mm;
% IDS.EPU200_PH.phase_cie           =  0 * mm;
% IDS.EPU200_PH.chamfer             =  0  * mm;
% IDS.EPU200_PH.magnetization       =  0.3558 * Tesla;
% 
% IDS.EPU200_PC.id_label            = 'EPU200_PC';
% IDS.EPU200_PC.nr_periods          = 15;
% IDS.EPU200_PC.magnetic_gap        = 10.0 * mm;
% IDS.EPU200_PC.period              = 200 * mm;
% IDS.EPU200_PC.cassette_separation = 0.001 * mm; % diferente de zero para evitar singularidades nas express?es
% IDS.EPU200_PC.block_separation    = 0  * mm;
% IDS.EPU200_PC.block_width         = 40 * mm;
% IDS.EPU200_PC.block_height        = 60 * mm;
% IDS.EPU200_PC.phase_csd           =  50.5 * mm;
% IDS.EPU200_PC.phase_cie           =  50.5 * mm;
% IDS.EPU200_PC.chamfer             =  0  * mm;
% IDS.EPU200_PC.magnetization       =  0.3558 * Tesla;
% 
% IDS.EPU200_PV.id_label            = 'EPU200_PV';
% IDS.EPU200_PV.nr_periods          = 15;
% IDS.EPU200_PV.magnetic_gap        = 10.0 * mm;
% IDS.EPU200_PV.period              = 200 * mm;
% IDS.EPU200_PV.cassette_separation = 0.001 * mm; % diferente de zero para evitar singularidades nas expressoes
% IDS.EPU200_PV.block_separation    = 0  * mm;
% IDS.EPU200_PV.block_width         = 40 * mm;
% IDS.EPU200_PV.block_height        = 60 * mm;
% IDS.EPU200_PV.phase_csd           =  100 * mm;
% IDS.EPU200_PV.phase_cie           =  100 * mm;
% IDS.EPU200_PV.chamfer             =  0  * mm;
% IDS.EPU200_PV.magnetization       =  0.3558 * Tesla;