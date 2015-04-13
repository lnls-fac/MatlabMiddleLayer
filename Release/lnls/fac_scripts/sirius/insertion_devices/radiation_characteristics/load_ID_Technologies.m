function IDTechs = load_ID_Technologies(Params)


vaccum_chamber_thickness = Params.VaccumChamberThickness;
vaccum_chamber_tolerance = Params.VaccumChamberTolerance;
phase_error              = Params.PhaseError;
max_Br                   = Params.MaxBr;

SupLim = 1;

%% Out of vacuum

% Halbach PPM
IDTechs.PPM.Label  = 'PPM';
IDTechs.PPM.Params = Params;
IDTechs.PPM.Coeff  = 1.72 * max_Br; % T
IDTechs.PPM.a1     = -pi;
IDTechs.PPM.a2     = 0;
IDTechs.PPM.Limits = [-Inf,Inf];
IDTechs.PPM.PhaseError = phase_error;
IDTechs.PPM.ChamberThickness = vaccum_chamber_thickness;
IDTechs.PPM.ChamberTolerance = vaccum_chamber_tolerance;

% Híbrido de SmCo
IDTechs.HYB_SmCo.Label  = 'HYB SmCo';
IDTechs.HYB_SmCo.Params = Params;
IDTechs.HYB_SmCo.Coeff  = 3.33; % T
IDTechs.HYB_SmCo.a1     = -5.47;
IDTechs.HYB_SmCo.a2     = 1.8;
IDTechs.HYB_SmCo.Limits = [0.07,0.7 * SupLim];
IDTechs.HYB_SmCo.PhaseError = 1.0;
IDTechs.HYB_SmCo.PhaseError = phase_error;
IDTechs.HYB_SmCo.ChamberThickness = vaccum_chamber_thickness;
IDTechs.HYB_SmCo.ChamberTolerance = vaccum_chamber_tolerance;

% Híbrido de NdFeB
IDTechs.HYB_NdFeB.Label  = 'HYB NdFeB';
IDTechs.HYB_NdFeB.Params = Params;
IDTechs.HYB_NdFeB.Coeff  = 3.44; % T
IDTechs.HYB_NdFeB.a1     = -5.08;
IDTechs.HYB_NdFeB.a2     = 1.54;
IDTechs.HYB_NdFeB.Limits = [0.07,0.7 * SupLim];
IDTechs.HYB_NdFeB.PhaseError = 1.0;
IDTechs.HYB_NdFeB.PhaseError = phase_error;
IDTechs.HYB_NdFeB.ChamberThickness = vaccum_chamber_thickness;
IDTechs.HYB_NdFeB.ChamberTolerance = vaccum_chamber_tolerance;

% Optimum Design
IDTechs.OptDesign.Label  = 'OptDesign';
IDTechs.OptDesign.Params = Params;
IDTechs.OptDesign.Coeff  = 4.3; % T
IDTechs.OptDesign.a1     = -6.45;
IDTechs.OptDesign.a2     = 1;
IDTechs.OptDesign.Limits = [0.04,0.2 * SupLim];
IDTechs.OptDesign.PhaseError = 1.0;
IDTechs.OptDesign.PhaseError = phase_error;
IDTechs.OptDesign.ChamberThickness = vaccum_chamber_thickness;
IDTechs.OptDesign.ChamberTolerance = vaccum_chamber_tolerance;

%% In of vacuum

% Halbach PPM
IDTechs.IV_PPM.Label  = 'IVU_PPM';
IDTechs.IV_PPM.Params = Params;
IDTechs.IV_PPM.Coeff  = 1.72 * max_Br; % T
IDTechs.IV_PPM.a1     = -pi;
IDTechs.IV_PPM.a2     = 0;
IDTechs.IV_PPM.Limits = [-Inf,Inf];
IDTechs.IV_PPM.PhaseError = phase_error;
IDTechs.IV_PPM.ChamberThickness = 0.0 / 1000;
IDTechs.IV_PPM.ChamberTolerance = 0.0 / 1000;

% Halbach PPM
IDTechs.SoleilCryo.Label  = 'SoleilCryo';
IDTechs.SoleilCryo.Params = Params;
IDTechs.SoleilCryo.Coeff  = 3.047590328452411; % T
IDTechs.SoleilCryo.a1     = -3.205641890813808;
IDTechs.SoleilCryo.a2     = -0.017451373985446;
IDTechs.SoleilCryo.Limits = [0.25,Inf];
IDTechs.SoleilCryo.PhaseError = phase_error;
IDTechs.SoleilCryo.ChamberThickness = 0.0 / 1000;
IDTechs.SoleilCryo.ChamberTolerance = 0.0 / 1000;


% Híbrido de SmCo
IDTechs.IV_HYB_SmCo.Label  = 'IVU_HYB_SmCo';
IDTechs.IV_HYB_SmCo.Params = Params;
IDTechs.IV_HYB_SmCo.Coeff  = 3.33; % T
IDTechs.IV_HYB_SmCo.a1     = -5.47;
IDTechs.IV_HYB_SmCo.a2     = 1.8;
IDTechs.IV_HYB_SmCo.Limits = [0.07,0.7 * SupLim];
IDTechs.IV_HYB_SmCo.PhaseError = 1.0;
IDTechs.IV_HYB_SmCo.PhaseError = phase_error;
IDTechs.IV_HYB_SmCo.ChamberThickness = 0.0 / 1000;
IDTechs.IV_HYB_SmCo.ChamberTolerance = 0.0 / 1000;

% Híbrido de NdFeB
IDTechs.IV_HYB_NdFeB.Label  = 'IVU_HYB_NdFeB';
IDTechs.IV_HYB_NdFeB.Params = Params;
IDTechs.IV_HYB_NdFeB.Coeff  = 3.44; % T
IDTechs.IV_HYB_NdFeB.a1     = -5.08;
IDTechs.IV_HYB_NdFeB.a2     = 1.54;
IDTechs.IV_HYB_NdFeB.Limits = [0.07,0.7 * SupLim];
IDTechs.IV_HYB_NdFeB.PhaseError = 1.0;
IDTechs.IV_HYB_NdFeB.PhaseError = phase_error;
IDTechs.IV_HYB_NdFeB.ChamberThickness = 0.0 / 1000;
IDTechs.IV_HYB_NdFeB.ChamberTolerance = 0.0 / 1000;

% Optimum Design
IDTechs.IV_OptDesign.Label  = 'IVU_OptDesign';
IDTechs.IV_OptDesign.Params = Params;
IDTechs.IV_OptDesign.Coeff  = 4.3; % T
IDTechs.IV_OptDesign.a1     = -6.45;
IDTechs.IV_OptDesign.a2     = 1;
IDTechs.IV_OptDesign.Limits = [0.04,0.2 * SupLim];
IDTechs.IV_OptDesign.PhaseError = 1.0;
IDTechs.IV_OptDesign.PhaseError = phase_error;
IDTechs.IV_OptDesign.ChamberThickness = 0.0 / 1000;
IDTechs.IV_OptDesign.ChamberTolerance = 0.0 / 1000;