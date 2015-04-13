if strcmp(caso,'caso1')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [7, 7];
    IniCond.alpha= [0,0];
    
    %%% QUADRUPOLOS
    %  ===========
    qa1_strength       = -1.863650277967;
    qa2_strength       =  2.589566058775;
    qa3_strength       =  0.0;          
    qb1_strength       = -3.50577646189 ;
    qb2_strength       =  2.305564556093;
    qb3_strength       =  4.631349457614;
    qc1_strength       =  5.635021836813;
    qc2_strength       = -3.854923177754;
    qc3_strength       =  1.014833988424;
    qd1_strength       = -0.394439184761;
    qd2_strength       =  4.243688040476;
    qe1_strength       = -3.200254231701;
    qe2_strength       =  4.613207612477;
    
elseif strcmp(caso,'caso2')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [10, 10];
    IniCond.alpha= [0,0];
    
    %%% QUADRUPOLOS
    %  ===========
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
    
elseif strcmp(caso,'caso3')
    
    %%% Initial Conditions
    IniCond.Dispersion = [0,0,0,0]';
    IniCond.beta = [7, 7];
    IniCond.alpha= [-1.0,-1.0];
    
    %%% QUADRUPOLOS
    %  ===========
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