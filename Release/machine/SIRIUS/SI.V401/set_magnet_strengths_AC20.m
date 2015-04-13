% set_magnet_strengths_V200_AC20
% ==============================
% 2013-01-15 Agora variavel 'mode_version' � passada com a vers�o do modo. Inclus�o do modo AC20_2. (ximenes)
% 2012-10-02 Alterado de AC20_0 para AC20_1 (fernando)
% 2012-09-21 Vinculos para AC20 expl�citos (ximenes)
% 2012-08-28 Ximenes


if strcmpi(mode_version,'AC20_0')
    
    %% Sirius_v200_AC20_0
    %  ------------------
    % %% QUADRUPOLOS
    % %  ===========
    %
    qaf_strength   = +2.537739196953;
    qad_strength   = -2.647795126552;
    qf1_strength   = +2.371968525991;
    qf2_strength   = +3.352302908836;
    qf3_strength   = +3.061654370234;
    qf4_strength   = +2.726693656859;
    
    % vinculos para o modo AC20
    qbd1_strength  = qad_strength;
    qbf_strength   = qaf_strength;
    qbd2_strength  = +0.000000000000;
    
    
    %% SEXTUPOLOS
    %  ==========
    sa2_strength   =   27.779064;
    sa1_strength   =  -47.549808;
    sd1_strength   = -161.429406;
    sf1_strength   =  170.600777;
    sd2_strength   =  -52.775815;
    sd3_strength   = -142.864917;
    sf2_strength   =  158.100678;
    
    % v�nculos para o modo AC20
    sb1_strength   = sa1_strength;
    sb2_strength   = sa2_strength;

elseif strcmpi(mode_version, 'AC20_1')
    
    %% Sirius_v200_AC20_1
    %  ------------------
    % %% QUADRUPOLOS
    % % ===========+
    
    qaf_strength   = 2.515526;
    qad_strength   = -2.602399;
    qf1_strength   = 2.372377;
    qf2_strength   = 3.351939;
    qf3_strength   = 3.062241;
    qf4_strength   = 2.726014;
    
    % vinculos para o modo AC20
    qbd1_strength  = qad_strength;
    qbf_strength   = qaf_strength;
    qbd2_strength  = +0.000000000000;
    
    
    %% SEXTUPOLOS
    %  ==========
    sa2_strength   =   23.203597;
    sa1_strength   =  -46.856865;
    sd1_strength   = -143.235386;
    sf1_strength   =  158.653188;
    sd2_strength   =  -58.318451;
    sd3_strength   = -159.219707;
    sf2_strength   =  186.119501;
    
    % sa2_strength   =   23.640718482123884;
    % sa1_strength   =   -46.35191300514661;
    % sd1_strength   =   -143.1801812273001;
    % sf1_strength   =   157.11905854284336;
    % sd2_strength   =   -58.86712708750172;
    % sd3_strength   =   -157.91165956837887;
    % sf2_strength   =   186.57364305779396;
    
    % v�nculos para o modo AC20
    sb1_strength   = sa1_strength;
    sb2_strength   = sa2_strength;


elseif strcmpi(mode_version, 'AC20_2')
        
    % Ao analisarmos o efeito dos IDs sobre a abertura din�mica a vers�o AC20_1 com a qual
    % v�nhamos trabalhando se mostrou suscept�vel � perturba��o. Houve consider�vel redu��o
    % da abertura din�mica. Resolvemos ent�o testar a vers�o antiga 3mad que se mostrou mais
    % imune aos IDs e renome�-la para AC20_2
    
    %% teste 3mad
    %%% QUADRUPOLOS
    %  ===========
    
    qaf_strength   = 2.515526;
    qad_strength   = -2.602399;
    qf1_strength   = 2.372377;
    qf2_strength   = 3.351939;
    qf3_strength   = 3.062241;
    qf4_strength   = 2.726014;
    
    % vinculos para o modo AC20
    qbd1_strength  = qad_strength;
    qbf_strength   = qaf_strength;
    qbd2_strength  = +0.000000000000;
    
    %%% SEXTUPOLOS
    % ==========
    sa2_strength   =   27.260886;
    sa1_strength   =  -53.895434;
    sd1_strength   = -85.452385;
    sf1_strength   =  186.287910;
    sd2_strength   =  -127.382337;
    sd3_strength   = -154.506764;
    sf2_strength   =  156.861444;
    
    % v�nculos para o modo AC20
    sb1_strength   = sa1_strength;
    sb2_strength   = sa2_strength;
    
%     %% Resultados da otimizacao do MOGA para o AC20_2
%     
%     %rede 000343
%      
%     %%% QUADRUPOLOS
%     %  ===========
%     
%     qaf_strength   = 2.517375947939487;
%     qad_strength   = -2.60126522469269;
%     qf1_strength   = 2.373241124267687;
%     qf2_strength   = 3.351872820048426;
%     qf3_strength   = 3.062039901174024;
%     qf4_strength   = 2.727229498952322;
%     
%     % vinculos para o modo AC20
%     qbd1_strength  = qad_strength;
%     qbf_strength   = qaf_strength;
%     qbd2_strength  = +0.000000000000;
%     
%     %%% SEXTUPOLOS
%     %  ==========
%     sa2_strength   =   57.13202188411454/2;
%     sa1_strength   = -110.9233585707545/2;
%     sd1_strength   = -176.4849369002052/2;
%     sf1_strength   =  366.7293174940256/2;
%     sd2_strength   = -241.7114233639737/2;
%     sd3_strength   = -316.9692628864151/2;
%     sf2_strength   =  318.7623376459362/2;
%     
%     % v�nculos para o modo AC20
%     sb1_strength   =  -99.0882698027971/2;
%     sb2_strength   =   56.32442471180599/2;
%     
%     
%     
%     %rede 000276
%     
%     %%% QUADRUPOLOS
%     %  ===========
%     qaf_strength   = 2.514610651223713;
%     qad_strength   = -2.601189874632874;
%     qf1_strength   = 2.373527823370604;
%     qf2_strength   = 3.352347731858433;
%     qf3_strength   = 3.069066575332793;
%     qf4_strength   = 2.725229475477023;
%     
%     % vinculos para o modo AC20
%     qbd1_strength  = qad_strength;
%     qbf_strength   = qaf_strength;
%     qbd2_strength  = +0.000000000000;
%   
%     %%% SEXTUPOLOS
%     %  ==========
%     sa2_strength   =   53.60682030885982/2;
%     sa1_strength   = -103.9727075363453/2;
%     sd1_strength   = -188.0939927285275/2;
%     sf1_strength   =  371.9152719464539/2;
%     sd2_strength   = -234.1702591364724/2;
%     sd3_strength   = -314.3083428489527/2;
%     sf2_strength   =  308.723856524012/2;
%     
%     % v�nculos para o modo AC20
%     sb1_strength   = -106.5538582669509/2;
%     sb2_strength   =   54.11201556116226/2;
    
    
    
    

end

%%
%As redes abaixo foram usadas como teste para mudan�a do AC20_0 para o
%AC20_1. A escolhida foi a 3mad1;

%%% teste 2
% %%% QUADRUPOLOS
% %  ===========
% 
% qaf_strength   = 2.520642;
% qad_strength   = -2.647795;
% qf1_strength   = 2.498217;
% qf2_strength   = 3.255207;
% qf3_strength   = 3.061654;
% qf4_strength   = 2.726694;
% 
% % vinculos para o modo AC20
% qbd1_strength  = qad_strength;
% qbf_strength   = qaf_strength;
% qbd2_strength  = +0.000000000000;
% 
% 
% %% SEXTUPOLOS
% %  ==========
% sa2_strength   =   24.118262;
% sa1_strength   =  -52.481231;
% sd1_strength   = -82.687162;
% sf1_strength   =  177.136365;
% sd2_strength   =  -123.269755;
% sd3_strength   = -164.347610;
% sf2_strength   =  176.396785;
% 
% % v�nculos para o modo AC20
% sb1_strength   = sa1_strength;
% sb2_strength   = sa2_strength;

%%% teste 4
% %%% QUADRUPOLOS
% %  ===========
% 
% qaf_strength   = 2.522244;
% qad_strength   = -2.647795;
% qf1_strength   = 2.476355;
% qf2_strength   = 3.272310;
% qf3_strength   = 3.061654;
% qf4_strength   = 2.726694;
% 
% % vinculos para o modo AC20
% qbd1_strength  = qad_strength;
% qbf_strength   = qaf_strength;
% qbd2_strength  = +0.000000000000;
% 
% 
% %% SEXTUPOLOS
% %  ==========
% sa2_strength   =   29.555299;
% sa1_strength   =  -50.722799;
% sd1_strength   = -166.183310;
% sf1_strength   =  179.626684;
% sd2_strength   =  -56.977283;
% sd3_strength   = -137.872920;
% sf2_strength   =  151.535312;
% 
% % v�nculos para o modo AC20
% sb1_strength   = sa1_strength;
% sb2_strength   = sa2_strength;

%%% teste 5
% %%% QUADRUPOLOS
% %  ===========
% 
% qaf_strength   = 2.515821;
% qad_strength   = -2.647795;
% qf1_strength   = 2.601338;
% qf2_strength   = 3.172845;
% qf3_strength   = 3.061654;
% qf4_strength   = 2.726694;
% 
% % vinculos para o modo AC20
% qbd1_strength  = qad_strength;
% qbf_strength   = qaf_strength;
% qbd2_strength  = +0.000000000000;
% 
% 
% %% SEXTUPOLOS
% %  ==========
% sa2_strength   =   24.266760;
% sa1_strength   =  -52.768140;
% sd1_strength   = -80.374219;
% sf1_strength   =  180.636920;
% sd2_strength   =  -128.230234;
% sd3_strength   = -163.363364;
% sf2_strength   =  174.337074;
% 
% % v�nculos para o modo AC20
% sb1_strength   = sa1_strength;
% sb2_strength   = sa2_strength;

%%% teste 1
% %%% QUADRUPOLOS
% %  ===========
% 
% qaf_strength   = 2.519302;
% qad_strength   = -2.647795;
% qf1_strength   = 2.560672;
% qf2_strength   = 3.205663;
% qf3_strength   = 3.061654;
% qf4_strength   = 2.726694;
% 
% % vinculos para o modo AC20
% qbd1_strength  = qad_strength;
% qbf_strength   = qaf_strength;
% qbd2_strength  = +0.000000000000;
% 
% 
% %% SEXTUPOLOS
% %  ==========
% sa2_strength   =   24.822932;
% sa1_strength   =  -51.852777;
% sd1_strength   = -112.394799;
% sf1_strength   =  173.040965;
% sd2_strength   =  -96.185873;
% sd3_strength   = -159.821674;
% sf2_strength   =  178.989988;
% 
% % v�nculos para o modo AC20
% sb1_strength   = sa1_strength;
% sb2_strength   = sa2_strength;

%%% teste 3
% %%% QUADRUPOLOS
% %  ===========
% 
% qaf_strength   = 2.519302;
% qad_strength   = -2.647795;
% qf1_strength   = 2.560672;
% qf2_strength   = 3.205663;
% qf3_strength   = 3.061654;
% qf4_strength   = 2.726694;
% 
% % vinculos para o modo AC20
% qbd1_strength  = qad_strength;
% qbf_strength   = qaf_strength;
% qbd2_strength  = +0.000000000000;
% 
% 
% %% SEXTUPOLOS
% %  ==========
% sa2_strength   =   24.118262;
% sa1_strength   =  -52.481231;
% sd1_strength   =  -83.280635;
% sf1_strength   =  177.804130;
% sd2_strength   = -123.269755;
% sd3_strength   = -164.347610;
% sf2_strength   =  176.396785;
% 
% % v�nculos para o modo AC20
% sb1_strength   = sa1_strength;
% sb2_strength   = sa2_strength;

%%% teste 6
% %%% QUADRUPOLOS
% %  ===========
% 
% qaf_strength   = 2.519302;
% qad_strength   = -2.647795;
% qf1_strength   = 2.560672;
% qf2_strength   = 3.205663;
% qf3_strength   = 3.061654;
% qf4_strength   = 2.726694;
% 
% % vinculos para o modo AC20
% qbd1_strength  = qad_strength;
% qbf_strength   = qaf_strength;
% qbd2_strength  = +0.000000000000;
% 
% 
% %% SEXTUPOLOS
% %  ==========
% sa2_strength   =   21.046012;
% sa1_strength   =  -49.272587;
% sd1_strength   = -106.813749;
% sf1_strength   =  163.259590;
% sd2_strength   =  -92.962969;
% sd3_strength   = -169.550332;
% sf2_strength   =  196.807566;
% 
% % v�nculos para o modo AC20
% sb1_strength   = sa1_strength;
% sb2_strength   = sa2_strength;

%%% teste 7
% %%% QUADRUPOLOS
% %  ===========
% 
% qaf_strength   = 2.519302;
% qad_strength   = -2.647795;
% qf1_strength   = 2.560672;
% qf2_strength   = 3.205663;
% qf3_strength   = 3.061654;
% qf4_strength   = 2.726694;
% 
% % vinculos para o modo AC20
% qbd1_strength  = qad_strength;
% qbf_strength   = qaf_strength;
% qbd2_strength  = +0.000000000000;
% 
% 
% %% SEXTUPOLOS
% %  ==========
% sa2_strength   =   22.250979;
% sa1_strength   =  -49.509570;
% sd1_strength   = -126.259260;
% sf1_strength   =  162.424497;
% sd2_strength   =  -77.014727;
% sd3_strength   = -164.091793;
% sf2_strength   =  194.605313;
% 
% % v�nculos para o modo AC20
% sb1_strength   = sa1_strength;
% sb2_strength   = sa2_strength;

% % % teste 8
% %%% QUADRUPOLOS
% %  ===========
% 
% qaf_strength   = 2.524988;
% qad_strength   = -2.647795;
% qf1_strength   = 2.549802;
% qf2_strength   = 3.214359;
% qf3_strength   = 3.061654;
% qf4_strength   = 2.726694;
% 
% % vinculos para o modo AC20
% qbd1_strength  = qad_strength;
% qbf_strength   = qaf_strength;
% qbd2_strength  = +0.000000000000;
% 
% 
% %% SEXTUPOLOS
% %  ==========
% sa2_strength   =   19.842019;
% sa1_strength   =  -47.758396;
% sd1_strength   = -120.117711;
% sf1_strength   =  153.332134;
% sd2_strength   =  -74.683153;
% sd3_strength   = -171.752806;
% sf2_strength   =  207.939860;
% 
% % v�nculos para o modo AC20
% sb1_strength   = sa1_strength;
% sb2_strength   = sa2_strength;

% %% teste 3mad
% %%% QUADRUPOLOS
% %  ===========
% 
% qaf_strength   = 2.515526;
% qad_strength   = -2.602399;
% qf1_strength   = 2.372377;
% qf2_strength   = 3.351939;
% qf3_strength   = 3.062241;
% qf4_strength   = 2.726014;
% 
% % vinculos para o modo AC20
% qbd1_strength  = qad_strength;
% qbf_strength   = qaf_strength;
% qbd2_strength  = +0.000000000000;
% 
% 
% %%% SEXTUPOLOS
% %  ==========
% sa2_strength   =   27.260886;
% sa1_strength   =  -53.895434;
% sd1_strength   = -85.452385;
% sf1_strength   =  186.287910;
% sd2_strength   =  -127.382337;
% sd3_strength   = -154.506764;
% sf2_strength   =  156.861444;
% 
% % v�nculos para o modo AC20
% sb1_strength   = sa1_strength;
% sb2_strength   = sa2_strength;

% %% teste 3mad1
% %%% QUADRUPOLOS
% %  ===========
% 
% qaf_strength   = 2.515526;
% qad_strength   = -2.602399;
% qf1_strength   = 2.372377;
% qf2_strength   = 3.351939;
% qf3_strength   = 3.062241;
% qf4_strength   = 2.726014;
% 
% % vinculos para o modo AC20
% qbd1_strength  = qad_strength;
% qbf_strength   = qaf_strength;
% qbd2_strength  = +0.000000000000;
% 
% 
% %%% SEXTUPOLOS
% %  ==========
% sa2_strength   =   23.203597;
% sa1_strength   =  -46.856865;
% sd1_strength   = -143.235386;
% sf1_strength   =  158.653188;
% sd2_strength   =  -58.318451;
% sd3_strength   = -159.219707;
% sf2_strength   =  186.119501;
% 
% % v�nculos para o modo AC20
% sb1_strength   = sa1_strength;
% sb2_strength   = sa2_strength;

% %% teste 8mad
% %%% QUADRUPOLOS
% %  ===========
% 
% qaf_strength   = 2.522006;
% qad_strength   = -2.605557;
% qf1_strength   = 2.372938;
% qf2_strength   = 3.351443;
% qf3_strength   = 3.063031;
% qf4_strength   = 2.725104;
% 
% % vinculos para o modo AC20
% qbd1_strength  = qad_strength;
% qbf_strength   = qaf_strength;
% qbd2_strength  = +0.000000000000;
% 
% 
% %%% SEXTUPOLOS
% %  ==========
% sa2_strength   =   19.740620;
% sa1_strength   =  -45.816103;
% sd1_strength   = -120.075474;
% sf1_strength   =  154.311362;
% sd2_strength   =  -74.090103;
% sd3_strength   = -168.115159;
% sf2_strength   =  197.613883;
% 
% % v�nculos para o modo AC20
% sb1_strength   = sa1_strength;
% sb2_strength   = sa2_strength;

% %% teste 8mad1
% %%% QUADRUPOLOS
% %  ===========
% 
% qaf_strength   = 2.522006;
% qad_strength   = -2.605557;
% qf1_strength   = 2.372938;
% qf2_strength   = 3.351443;
% qf3_strength   = 3.063031;
% qf4_strength   = 2.725104;
% 
% % vinculos para o modo AC20
% qbd1_strength  = qad_strength;
% qbf_strength   = qaf_strength;
% qbd2_strength  = +0.000000000000;
% 
% 
% %%% SEXTUPOLOS
% %  ==========
% sa2_strength   =   19.842019;
% sa1_strength   =  -47.758396;
% sd1_strength   = -115.580441;
% sf1_strength   =  148.932159;
% sd2_strength   =  -74.683153;
% sd3_strength   = -171.752806;
% sf2_strength   =  207.939860;
% 
% % v�nculos para o modo AC20
% sb1_strength   = sa1_strength;
% sb2_strength   = sa2_strength;