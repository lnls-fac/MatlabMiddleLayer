if strcmp(caso,'matched')
    
    
    %%% QUADRUPOLOS
    %  ===========
%         qa1_strength       = -2.316153063759;
%         qa2_strength       =  1.54728475705;
%         qa3_strength       =  2.365938516692;
%         qb1_strength       = -1.986733847103;
%         qb2_strength       =  2.395940070594;
%         qb3_strength       =  0.91034775695 ;
%         qc1_strength       = -1.454044303505;
%         qc2_strength       =  1.88578008915 ;
%         qc3_strength       = -2.139854347333;
%         qc4_strength       =  1.5583903071;

    qa1_strength       =-1.718520388151;
    qa2_strength       = 1.081844520151;
    qa3_strength       = 2.114730980595;
    qb1_strength       =-2.160265804217;
    qb2_strength       = 2.347589037304;
    qb3_strength       = 1.313510544443;
    qc1_strength       =-1.930285436467;
    qc2_strength       = 2.322100754492;
    qc3_strength       =-2.210096036344;
    qc4_strength       = 2.192653749057;

elseif strcmp(caso,'mismatched_pmm')
    
    %final conditions at the end of the septum
    %casado em y e dispersao betax=11 alphax=1.66
    
    %%% QUADRUPOLOS
    %  ===========
%     qa1_strength       = -2.304614431869;
%     qa2_strength       =  1.428371766545;
%     qa3_strength       =  2.288186118724;
%     qb1_strength       = -2.002890069526;
%     qb2_strength       =  1.356774638251;
%     qb3_strength       =  1.998941619753;
%     qc1_strength       = -0.647509291031;
%     qc2_strength       =  1.140414712945;
%     qc3_strength       = -2.39399371233 ;
%     qc4_strength       =  2.106941869186;
    
    qa1_strength       =-2.069103759455;
    qa2_strength       = 2.040718807685;
    qa3_strength       = 1.45079745233 ;
    qb1_strength       =-2.046431253604;
    qb2_strength       = 2.399999536702;
    qb3_strength       = 1.418080060125;
    qc1_strength       =-2.154202558362;
    qc2_strength       = 2.399999997719;
    qc3_strength       =-2.164944945213;
    qc4_strength       = 2.298308667034;
    
elseif strcmp(caso,'mismatched_pmm_optimum') 
    
    %final conditions at the end of the septum
    %casado em y e dispersao betax=25 alphax=6.8
    
    %%% QUADRUPOLOS
    %  ===========
%     qa1_strength       = -1.700173668171;
%     qa2_strength       =  2.366600033209; 
%     qa3_strength       =  0.777737772901;
%     qb1_strength       = -1.173077523318;
%     qb2_strength       = -1.493338802133;
%     qb3_strength       =  1.888600428553;
%     qc1_strength       =  2.398526864168;
%     qc2_strength       = -0.465048245813;
%     qc3_strength       = -1.817491290307;
%     qc4_strength       =  2.391582819203;
    qa1_strength       =-1.266260380979;
    qa2_strength       = 2.343622495746; 
    qa3_strength       = 1.53499435989 ;
    qb1_strength       =-2.070518697045;
    qb2_strength       = 1.27096414668 ;
    qb3_strength       = 2.399343820248;
    qc1_strength       =-1.96435965943 ;
    qc2_strength       = 0.323284486391;
    qc3_strength       =-0.101187399114;
    qc4_strength       = 1.768083055196;


    
elseif strcmp(caso,'mismatched_4k')
    
    %final conditions at the end of the septum
    %casado em y e dispersao betax=8 alphax=1.23
    
    %%% QUADRUPOLOS
    %  ===========
%     qa1_strength       = -2.399996567559;
%     qa2_strength       =  1.497331734662; 
%     qa3_strength       =  2.399996302294;
%     qb1_strength       = -1.454446525878;
%     qb2_strength       =  2.397669914002;
%     qb3_strength       =  1.379172057448;
%     qc1_strength       = -2.253714979459;
%     qc2_strength       =  1.705983187645;
%     qc3_strength       = -1.807809428136;
%     qc4_strength       =  1.846433139872;
    
    qa1_strength       =-1.685669145338;
    qa2_strength       = 0.348328531054;
    qa3_strength       = 2.38614241046 ;
    qb1_strength       =-1.889002603269;
    qb2_strength       = 2.368731568632;
    qb3_strength       = 1.777787621596;
    qc1_strength       =-2.399999562873;
    qc2_strength       = 2.399999953933;
    qc3_strength       =-2.158013966308;
    qc4_strength       = 2.249635735253;
    
else
    error('caso nao implementado');
end