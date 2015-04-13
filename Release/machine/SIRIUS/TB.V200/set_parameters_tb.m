if strcmp(mode_version,'M0')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [7, 7];
    IniCond.alpha= [0,0];
    
    %%% Quadrupoles
    qa1_strength      = -1.903101;
    qa2_strength      = 2.584562;
    qb1_strength      = -3.513677;
    qb2_strength      = 2.317917;
    qb3_strength      = 4.628942;
    qc1_strength      = 5.632629;
    qc2_strength      = -3.862486;
    qc3_strength      = 1.021090;
    qd1_strength      = -0.400945;
    qd2_strength      = 4.251441;
    qe1_strength      = -3.208946;
    qe2_strength      = 4.624046;
    
%     qa1_strength       = -1.863650277967;
%     qa2_strength       =  2.589566058775;
%     qa3_strength       =  0.0;          
%     qb1_strength       = -3.50577646189 ;
%     qb2_strength       =  2.305564556093;
%     qb3_strength       =  4.631349457614;
%     qc1_strength       =  5.635021836813;
%     qc2_strength       = -3.854923177754;
%     qc3_strength       =  1.014833988424;
%     qd1_strength       = -0.394439184761;
%     qd2_strength       =  4.243688040476;
%     qe1_strength       = -3.200254231701;
%     qe2_strength       =  4.613207612477;
    
elseif strcmp(mode_version,'M1')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [10, 10];
    IniCond.alpha= [0,0];
    
    %%% Quadrupoles
    qa1_strength       = -3.27193264225 ;
    qa2_strength       =  4.600795499551;
    qa3_strength       =  0.0;           
    qb1_strength       = -3.518821678585;
    qb2_strength       =  2.298046827144;
    qb3_strength       =  4.596063520186;
    qc1_strength       =  5.536308099179;
    qc2_strength       = -3.756392777494;
    qc3_strength       =  0.855260311875;
    qd1_strength       = -0.64315958981E-3;
    qd2_strength       =  3.971238023463;
    qe1_strength       = -3.230379232491;
    qe2_strength       =  4.441941674487;
    
elseif strcmp(mode_version,'M2')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [7, 7];
    IniCond.alpha= [-1.0,-1.0];
    
    %%% Quadrupoles
    qa1_strength       = -1.533465202697;
    qa2_strength       =  3.777837313931;
    qa3_strength       =  0.0;           
    qb1_strength       = -4.528645048661;
    qb2_strength       =  3.887362225844;
    qb3_strength       =  3.592840115224;
    qc1_strength       =  5.120313891604;
    qc2_strength       = -2.947951602239;
    qc3_strength       =  0.421246108633;
    qd1_strength       = -0.425870175365;
    qd2_strength       =  4.297125035576;
    qe1_strength       = -3.207355323884;
    qe2_strength       =  4.610391362193;
    
else
    error('caso nao implementado');
end