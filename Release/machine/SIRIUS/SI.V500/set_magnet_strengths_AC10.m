% set_magnet_strengths_V500_AC10
% ==============================
% 2013-04-25 Ximenes
% retirei os modos ac10.{1,2,3} e alguns resultados antigos do moga dessa
% versao (v500) do sirius. Para ver ou recurar esses modos antigos, ver
% sirius_v403. Fernando 2013-11-26


%% Antigo Moga0473modif-0512
% Um pouco de historia: esse modo eh o resultado de duas otimizacoes do
% MOGA. Primeiro, otimizei usando o ac10.3 como ponto inicial e peguei o
% resultado 0473. Mas esse resultado tinha uma sintonia vertical muito
% proxima do inteiro, entao aumentei a sintonia com o OPA e usei o
% resultado como ponto inicial para outra otimizacao, mas coloquei um
% vinculo adicional de que as sintonias deveriam ser maiores que 0.12.
% Peguei o resultado 0512 dessa simulacao e vi que ele melhorava tanto o
% tempo de vida, como a abertura dinamica, quando simulado com o conjunto
% padrao de erros, no tracy3.
%
if strcmpi(mode_version,'AC10.4')
    %%% QUADRUPOLOS
    %  ===========
    
    qaf_strength       =  2.53733156985179;
    qad_strength       = -2.729928269122092;
    qbd2_strength      = -3.960473342625189;
    qbf_strength       =  3.902662679038675;
    qbd1_strength      = -2.9676529175558;
    qf1_strength       =  2.368979188452946;
    qf2_strength       =  3.354162681362089;
    qf3_strength       =  3.080099756299886;
    qf4_strength       =  2.708484971587339;
    %%% SEXTUPOLOS
    %  ==========
    sa1_strength       = -123.1722496509632/2;
    sa2_strength       =   49.93065558027325/2;
    sb1_strength       = -221.8397738651525/2;
    sb2_strength       =  114.7544273034517/2;
    sd1_strength       = -346.6761204672601/2;
    sf1_strength       =  374.2717343204316/2;
    sd2_strength       = -129.7749377447802/2;
    sd3_strength       = -278.7913650216647/2;
    sf2_strength       =  317.433316097233/2;


%% Antigo Moga1139-2388
% Um pouco de historia: Rodamos o v403_ac10.4-Moga e obtivemos o resultado 1139.
% Com esse resultado como ponto inicial rodamos o v403_moga1139 e obtivemos o
% resultado 2388. Quando comparamos os dois com o ensemble de erros no
% tracy3 optamos pelo 2388.
elseif strcmpi(mode_version,'AC10.5')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % quando a Liu mudou do 403 para o 500 ela corrigiu a sintonia e esse
    % passou a ser chamado de ac10.5
    %%% QUADRUPOLOS
    %  ===========
    qaf_strength       =  2.536876;
    qad_strength       = -2.730416;
    qbd2_strength      = -3.961194;
    qbf_strength       =  3.902838;
    qbd1_strength      = -2.966239;
    qf1_strength       =  2.367821;
    qf2_strength       =  3.354286;
    qf3_strength       =  3.080632;
    qf4_strength       =  2.707639;
    
    
    %%% SEXTUPOLOS
    %  ==========
    sa1_strength       = -115.7829759411277/2;
    sa2_strength       =   49.50386128829739/2;
    sb1_strength       = -214.5386552515188/2;
    sb2_strength       =  133.1252391065637/2;
    sd1_strength       = -302.6188062085843/2;
    sf1_strength       =  369.5045185071228/2;
    sd2_strength       = -164.3042864671946/2;
    sd3_strength       = -289.9270429064217/2;
    sf2_strength       =  333.7039740852999/2;

    
    % Original:
    %     %%% QUADRUPOLOS
%     %  ===========
%     qaf_strength       =  2.53696119948142;
%     qad_strength       = -2.729804812331968;
%     qbd2_strength      = -3.960473342625189;
%     qbf_strength       =  3.902662679038675;
%     qbd1_strength      = -2.9676529175558;
%     qf1_strength       =  2.367868077341835;
%     qf2_strength       =  3.353792310991718;
%     qf3_strength       =  3.079729385929515;
%     qf4_strength       =  2.708114601216968;
%     
% 
%     %%% SEXTUPOLOS
%     %  ==========
%     sa1_strength       = -115.7829759411277/2;
%     sa2_strength       =   49.50386128829739/2;
%     sb1_strength       = -214.5386552515188/2;
%     sb2_strength       =  133.1252391065637/2;
%     sd1_strength       = -302.6188062085843/2;
%     sf1_strength       =  369.5045185071228/2;
%     sd2_strength       = -164.3042864671946/2;
%     sd3_strength       = -289.9270429064217/2;
%     sf2_strength       =  333.7039740852999/2;


elseif strcmpi(mode_version,'AC10.6')
    
   % Essa rede é um resultado da tentativa de melhorar a injecao com os
   % quatro kicks aumentando a sintonia da maquina. Assim, partindo do 
   % AC10_4, tentei minimizar os tuneshifts e obtive essa configuracão.
   % ela era a antiga test_inject_4k-4ta.]
   
    %% QUADRUPOLOS
    %=========== (os mesmos do AC10_4)
    
    qaf_strength       =  2.53733156985179;
    qad_strength       = -2.729928269122092;
    qbd2_strength      = -3.960473342625189;
    qbf_strength       =  3.902662679038675;
    qbd1_strength      = -2.9676529175558;
    qf1_strength       =  2.368979188452946;
    qf2_strength       =  3.354162681362089;
    qf3_strength       =  3.080099756299886;
    qf4_strength       =  2.708484971587339;

    %% SEXTUPOLOS
    %==========
    sa1_strength       =   -64.5501;
    sa2_strength       =    28.5005;
    sb1_strength       =  -113.8315;
    sb2_strength       =    64.6216;
    sd2_strength       =   -76.9782;
    sd3_strength       =  -142.3458;
    sf2_strength       =   154.1521;
    sd1_strength       =  -161.1970;
    sf1_strength       =   190.8217; 
    

%moga3seeds - 119_235_320_1149-v500-ac10.6
%     %%% QUADRUPOLOS
%     %  =========== 
%    
%     qaf_strength       = 2.536723473173347;
%     qad_strength       =-2.741523290845321;
%     qbd2_strength      =-3.983186842271514;
%     qbf_strength       = 3.904200532908222;
%     qbd1_strength      =-2.960126035504997;
%     qf1_strength       = 2.373088903218954;
%     qf2_strength       = 3.350085889049807;
%     qf3_strength       = 3.080835708218113;
%     qf4_strength       = 2.703962188286038;
%     
%     %%% SEXTUPOLOS
%     %  ==========    
%     sa1_strength       =-63.5598353397126 ;
%     sa2_strength       = 25.9155891776268 ;
%     sb1_strength       =-118.4508900291824;
%     sb2_strength       = 62.5024703279084 ;
%     sd2_strength       = -84.0881196396030;
%     sd3_strength       =-138.5851115500286;
%     sf2_strength       = 161.9377920076308;
%     sd1_strength       =-154.7093218268305;
%     sf1_strength       = 188.2260666144867; 

elseif strncmpi(mode_version,'tests',5)
    
    [path, ~, ~] = fileparts(mfilename('fullpath'));
    cur = pwd;
    cd(fullfile(path,'tests'));
    eval(mode_version(7:end));
    cd(cur);


%% Testes de otimizacao de injecao 02/10/2013
% Apos Montar o script que simula a injecao no anel, notamos que estavamos
% com problemas para injetar tanto com os 4kickers, como com o pmm.
%  - O problema com os 4kickers eh que na segunda volta o feixe estava batendo
%  no septum, entao tinhamos que aumentar a sintonia da maquina e/ou mudar
%  o tuneshift com a amplitude, de forma que a oscilacao do feixe injetado
%  (altas amplitudes) seja mais rapida.
%  - O problema com o pmm eh que nosso espaco de fase horizontal tem um
%  bico muito apertado em angulo no lado negativo de x enquanto o feixe
%  injetado, devido ao kick do pmm, tem uma abertura muito grande, entao
%  devemos tentar aumentar a abertura angular ali (virar a coxinha)

elseif strcmpi(mode_version,'test_inject_4k')

%tentativa de aumentar tune com opa: 1ra
%     %%% QUADRUPOLOS
%     %  =========== (quads obtidos com o opa)
%     qaf_strength       = 2.536961 ;
%     qad_strength       = -2.729805;
%     qbd2_strength      = -3.960473;
%     qbf_strength       = 3.902663 ;
%     qbd1_strength      = -2.967653;
%     qf1_strength       = 2.357389 ;
%     qf2_strength       = 3.363276 ;
%     qf3_strength       = 3.079729 ;
%     qf4_strength       = 2.713552 ;
%     
%     
%     %%% SEXTUPOLOS
%     %  ========== (obtidos com o script do matlab)
%     % boa solucao para injecao 4k
%     sa1_strength       =  -58.9405;
%     sa2_strength       =   25.1813;
%     sb1_strength       = -107.7365;
%     sb2_strength       =   65.8960;
%     sd1_strength       = -155.8518;
%     sf1_strength       =  186.8334;
%     sd2_strength       = -80.1791;
%     sd3_strength       = -143.6776;
%     sf2_strength       =  162.9090;

   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%tentativa de aumentar tune com opa mantendo os mesmos sexts: 2da
%     %%% QUADRUPOLOS
%     %  =========== (quads obtidos com o opa)
%     qaf_strength       = 2.536961 ;
%     qad_strength       = -2.729805;
%     qbd2_strength      = -3.960473;
%     qbf_strength       = 3.902663 ;
%     qbd1_strength      = -2.967653;
%     qf1_strength       = 2.357389 ;
%     qf2_strength       = 3.363276 ;
%     qf3_strength       = 3.079729 ;
%     qf4_strength       = 2.713552 ;
%     
%     
%     %%% SEXTUPOLOS
%     %  ========== (os mesmos do AC10_5)
%     sa1_strength       = -115.7829759411277/2;
%     sa2_strength       =   49.50386128829739/2;
%     sb1_strength       = -214.5386552515188/2;
%     sb2_strength       =  133.1252391065637/2;
%     sd1_strength       = -302.6188062085843/2;
%     sf1_strength       =  369.5045185071228/2;
%     sd2_strength       = -164.3042864671946/2;
%     sd3_strength       = -289.9270429064217/2;
%     sf2_strength       =  333.7039740852999/2;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%tentativa mudar o tuneshift com amplitude mexendo so os sexts: 3ra
%     %%% QUADRUPOLOS
%     %  =========== (os mesmos do AC10_5)
%     qaf_strength       =  2.53696119948142;
%     qad_strength       = -2.729804812331968;
%     qbd2_strength      = -3.960473342625189;
%     qbf_strength       =  3.902662679038675;
%     qbd1_strength      = -2.9676529175558;
%     qf1_strength       =  2.367868077341835;
%     qf2_strength       =  3.353792310991718;
%     qf3_strength       =  3.079729385929515;
%     qf4_strength       =  2.708114601216968;
%     
%     
%     %%% SEXTUPOLOS
%     %  ========== (obtidos com o script do matlab)
%     sa1_strength       =  -58.9405;
%     sa2_strength       =   25.1813;
%     sb1_strength       = -107.7365;
%     sb2_strength       =   65.8960;
%     sd1_strength       = -155.8518;
%     sf1_strength       =  186.8334;
%     sd2_strength       = -80.1791;
%     sd3_strength       = -143.6776;
%     sf2_strength       =  162.9090;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Partindo do AC10_4, tentei minimizar os tuneshifts: 4ta
% Virou o ac10_6
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

%Partindo do AC10_3, tentei minimizar os tuneshifts: 5ta
%     %%% QUADRUPOLOS
%     %  =========== (os mesmos do AC10_3)
%     qaf_strength   =  2.540801;
%     qad_strength   = -2.744679;
%     qbd2_strength  = -3.966318;
%     qbf_strength   =  3.908091;
%     qbd1_strength  = -2.974256;
%     qf1_strength   =  2.371977;
%     qf2_strength   =  3.353143;
%     qf3_strength   =  3.062984;
%     qf4_strength   =  2.729574;
%     
%     
%     %%% SEXTUPOLOS
%     %  ==========
% %     sa1_strength       =   -55.6474;
% %     sa2_strength       =    26.8063;
% %     sb1_strength       =  -100.7684;
% %     sb2_strength       =    62.4106;
% %     sd2_strength       =   -77.6551;
% %     sd3_strength       =  -143.7601;
% %     sf2_strength       =   159.3081;
% %     sd1_strength       =  -158.8997;
% %     sf1_strength       =   188.1567;    
%     sa1_strength       =   -60.9192;
%     sa2_strength       =    26.3203;
%     sb1_strength       =  -105.5614;
%     sb2_strength       =    62.0680;
%     sd2_strength       =   -69.5216;
%     sd3_strength       =  -133.7175;
%     sf2_strength       =   150.2310;
%     sd1_strength       =  -173.2451;
%     sf1_strength       =   191.0667;


%tentativa de aumentar tune com opa: 6ta
%     %%% QUADRUPOLOS
%     %  =========== (quads obtidos com o opa)
%     qaf_strength       = 2.536961 ;
%     qad_strength       = -2.729805;
%     qbd2_strength      = -3.960473;
%     qbf_strength       = 3.902663 ;
%     qbd1_strength      = -2.967653;
%     qf1_strength       = 2.357389 ;
%     qf2_strength       = 3.363276 ;
%     qf3_strength       = 3.079729 ;
%     qf4_strength       = 2.713552 ;
%     
%     
%     %%% SEXTUPOLOS
%     %  ========== (obtidos com o script do matlab)
%     sa1_strength       =   -54.7902;
%     sa2_strength       =    25.8499;
%     sb1_strength       =  -103.2040;
%     sb2_strength       =    68.7064;
%     sd2_strength       =   -83.5312;
%     sd3_strength       =  -152.3963;
%     sf2_strength       =   169.0844;
%     sd1_strength       =  -147.0970;
%     sf1_strength       =   184.4442;

elseif strcmpi(mode_version,'test_inject_pmm')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%lncc_v403_ac10_5-invcox_000093   
% %%% QUADRUPOLOS
% %  ===========
% qaf_strength       =  2.53696119948142 ;
% qad_strength       = -2.729804812331968;
% qbd2_strength      = -3.960473342625189;
% qbf_strength       =  3.902662679038675;
% qbd1_strength      = -2.9676529175558  ;
% qf1_strength       =  2.367868077341835;
% qf2_strength       =  3.353792310991718;
% qf3_strength       =  3.079729385929515;
% qf4_strength       =  2.708114601216968;
% 
% 
% %%% SEXTUPOLOS
% %  ==========
% sa1_strength       =-113.1981086610908/2;
% sa2_strength       = 35.41992724561523/2;
% sb1_strength       =-258.5626331672489/2;
% sb2_strength       = 123.0625698276054/2;
% sd1_strength       =-286.9408026023277/2;
% sf1_strength       = 334.4933257290978/2;
% sd2_strength       =-145.9794373625645/2;
% sd3_strength       =-328.864644424823 /2;
% sf2_strength       = 396.3103030055146/2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% primeira tentativa real de virar a coxinha: 1ra

%     %%% QUADRUPOLOS
%     %  =========== (mesmos quads do AC10_5)
%     qaf_strength       =  2.53696119948142;
%     qad_strength       = -2.729804812331968;
%     qbd2_strength      = -3.960473342625189;
%     qbf_strength       =  3.902662679038675;
%     qbd1_strength      = -2.9676529175558;
%     qf1_strength       =  2.367868077341835;
%     qf2_strength       =  3.353792310991718;
%     qf3_strength       =  3.079729385929515;
%     qf4_strength       =  2.708114601216968;
% 
% 
%     %%% SEXTUPOLOS
% %      ==========
%     sa1_strength       =   -60.2392;
%     sa2_strength       =    19.5175;
%     sb1_strength       =  -134.9419;
%     sb2_strength       =    62.0093;
%     sd2_strength       =   -83.8803;
%     sd3_strength       =  -171.3067;
%     sf2_strength       =   203.2820;
%     sd1_strength       =  -130.4733;
%     sf1_strength       =   167.3688;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% obtido pelo script do matlab, tendo por base o ac10_5: 2da
%     %%% QUADRUPOLOS
%     %  ===========(mesmos quads do AC10_5)
%     qaf_strength       =  2.53696119948142;
%     qad_strength       = -2.729804812331968;
%     qbd2_strength      = -3.960473342625189;
%     qbf_strength       =  3.902662679038675;
%     qbd1_strength      = -2.9676529175558;
%     qf1_strength       =  2.367868077341835;
%     qf2_strength       =  3.353792310991718;
%     qf3_strength       =  3.079729385929515;
%     qf4_strength       =  2.708114601216968;
%     
% 
%     %%% SEXTUPOLOS
%     %  ==========
%     sa1_strength       =   -54.5435;
%     sa2_strength       =    21.6655;
%     sb1_strength       =  -109.6478;
%     sb2_strength       =    64.2882;
%     sd2_strength       =   -85.5324;
%     sd3_strength       =  -159.3166;
%     sf2_strength       =   185.8740;
%     sd1_strength       =  -138.5317;
%     sf1_strength       =   176.3937;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% obtido pelo script do matlab tendo por base o ac10_5 : 3ra
%     %%% QUADRUPOLOS
%     %  ===========(mesmos quads do AC10_5)
%     qaf_strength       =  2.53696119948142;
%     qad_strength       = -2.729804812331968;
%     qbd2_strength      = -3.960473342625189;
%     qbf_strength       =  3.902662679038675;
%     qbd1_strength      = -2.9676529175558;
%     qf1_strength       =  2.367868077341835;
%     qf2_strength       =  3.353792310991718;
%     qf3_strength       =  3.079729385929515;
%     qf4_strength       =  2.708114601216968;
%     
% 
%     %%% SEXTUPOLOS
%     %  ==========
%     sa1_strength       =   -54.2474;
%     sa2_strength       =    20.8925;
%     sb1_strength       =  -116.7513;
%     sb2_strength       =    62.0812;
%     sd2_strength       =   -87.9854;
%     sd3_strength       =  -163.5325;
%     sf2_strength       =   190.5727;
%     sd1_strength       =  -133.2298;
%     sf1_strength       =   174.5513;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% obtido pelo script do matlab tendo por base o ac10_3 : 4ta
%         %%% QUADRUPOLOS
%     %  =========== 
%     qaf_strength   =  2.540801;
%     qad_strength   = -2.744679;
%     qf1_strength   =  2.371977;
%     qf2_strength   =  3.353143;
%     qf3_strength   =  3.062984;
%     qf4_strength   =  2.729574;
%     
%     qbd2_strength  = -3.966318;
%     qbf_strength   =  3.908091;
%     qbd1_strength  = -2.974256;
%     
%     
%     %%% SEXTUPOLOS
%     %  ==========
%     sa1_strength       =   -55.5090;
%     sa2_strength       =    21.3190;
%     sb1_strength       =  -114.5932;
%     sb2_strength       =    66.5853;
%     sd2_strength       =   -91.9588;
%     sd3_strength       =  -167.7603;
%     sf2_strength       =   200.0567;
%     sd1_strength       =  -125.6284;
%     sf1_strength       =   170.1560;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%lncc_v403_ac10_5-first_run-093-000192
%      %%% QUADRUPOLOS
%      %  ===========
%     qaf_strength       = 2.537658457662712 ;
%     qad_strength       = -2.737004985263078;
%     qbd2_strength      = -3.957685119288232;
%     qbf_strength       = 3.904570491969777 ;
%     qbd1_strength      = -2.97399429698993 ;
%     qf1_strength       = 2.364973307077406 ;
%     qf2_strength       = 3.355983567160624 ;
%     qf3_strength       = 3.079012939179151 ;
%     qf4_strength       = 2.707699693838884 ;
% 
% 
%     %%% SEXTUPOLOS
% %      ==========
%     sa1_strength       = -113.5974100248657 /2;
%     sa2_strength       =   42.78834923041808/2;
%     sb1_strength       = -235.0468243136669 /2;
%     sb2_strength       =  135.5637944103351 /2;
%     sd1_strength       = -279.6379565710109 /2;
%     sf1_strength       =  335.4881377724367 /2;
%     sd2_strength       = -156.3218562307578 /2;
%     sd3_strength       = -324.9232501667684 /2;
%     sf2_strength       =  397.6770239380141 /2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%lncc_v403_ac10_5-invcox/first_run-093-002317
% 
%      %%% QUADRUPOLOS
%      %  ===========
%     qaf_strength       =2.538395411920439 ;
%     qad_strength       =-2.730425773575938;
%     qbd2_strength      =-3.961087675946384;
%     qbf_strength       =3.904286725074861 ;
%     qbd1_strength      =-2.967486590803264;
%     qf1_strength       =2.366366769182183 ;
%     qf2_strength       =3.35554866240133  ;
%     qf3_strength       =3.081791185366855 ;
%     qf4_strength       =2.709119000693677 ;
% 
% 
%     %%% SEXTUPOLOS
% %      ==========
%     sa1_strength       = -115.5536463039509/2;
%     sa2_strength       = 45.14111445440238 /2;
%     sb1_strength       = -222.6200572703632/2;
%     sb2_strength       = 117.5671637547091 /2;
%     sd1_strength       = -285.8767865733286/2;
%     sf1_strength       = 337.3466689354    /2;
%     sd2_strength       = -149.7859568990414/2;
%     sd3_strength       = -325.7101885850413/2;
%     sf2_strength       = 391.3521356413207 /2;

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% mudanca de um inteiro para mais no tune que a liu passou
    %% QUADRUPOLOS
%      ===========
    qaf_strength       = 2.571554 ;
    qad_strength       = -2.770773;
    qbd2_strength      = -3.994996;
    qbf_strength       = 3.919818 ;
    qbd1_strength      = -2.930415;
    qf1_strength       = 2.291549 ;
    qf2_strength       = 3.438407 ;
    qf3_strength       = 2.898025 ;
    qf4_strength       = 2.965102 ;
    
    
    %% SEXTUPOLOS
%      ==========
    sa1_strength       = -50.023363;
    sa2_strength       =   4.841264;
    sb1_strength       =-105.796428;
    sb2_strength       =  73.689101;
    sd2_strength       = -86.788827;
    sd3_strength       =-165.018722;
    sf2_strength       = 200.908412;
    sd1_strength       =-122.742366;
    sf1_strength       = 158.447767;
%     sa1_strength       =   -52.1646;
%     sa2_strength       =    24.5206;
%     sb1_strength       =   -78.1061;
%     sb2_strength       =    68.8519;
%     sd2_strength       =  -102.4730;
%     sd3_strength       =  -168.4125;
%     sf2_strength       =   182.5905;
%     sd1_strength       =  -112.7927;
%     sf1_strength       =   172.8375;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% mudanca de um inteiro para menos no tune que a liu passou
%     %%% QUADRUPOLOS
%     %  ===========
%     qaf_strength       = 2.48451802192 ;
%     qad_strength       =-2.598751820425;
%     qbd2_strength      =-3.679841453487;
%     qbf_strength       = 3.763575545619;
%     qbd1_strength      =-2.93621952114 ;
%     qf1_strength       = 2.337001984721;
%     qf2_strength       = 3.390406780499;
%     qf3_strength       = 2.820037149302;
%     qf4_strength       = 2.947351485628;
%     
%     
%     %%% SEXTUPOLOS
%     %  ==========
% %     sa1_strength       = -53.449741;
% %     sa2_strength       =  -9.883158;
% %     sb1_strength       = -96.424016;
% %     sb2_strength       =  69.347669;
% %     sd2_strength       = -68.526248;cd 
% %     sd3_strength       =-155.618775;
% %     sf2_strength       = 190.029012;
% %     sd1_strength       =-149.935098;
% %     sf1_strength       = 167.982983;
%     sa1_strength       =   -54.3993;
%     sa2_strength       =    -9.8822;
%     sb1_strength       =   -92.8923;
%     sb2_strength       =    70.8884;
%     sd2_strength       =   -69.1773;
%     sd3_strength       =  -160.4544;
%     sf2_strength       =   189.8202;
%     sd1_strength       =  -147.6998;
%     sf1_strength       =   168.5641;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%lncc_v403_ac10_5-Moga_000858

%      %%% QUADRUPOLOS
%      %  ===========
%     qaf_strength       = 2.537658457662712 ;
%     qad_strength       = -2.737004985263078;
%     qbd2_strength      = -3.957685119288232;
%     qbf_strength       = 3.904570491969777 ;
%     qbd1_strength      = -2.97399429698993 ;
%     qf1_strength       = 2.364973307077406 ;
%     qf2_strength       = 3.355983567160624 ;
%     qf3_strength       = 3.079012939179151 ;
%     qf4_strength       = 2.707699693838884 ;
% 
% 
%     %%% SEXTUPOLOS
% %      ==========
%     sa1_strength       = -121.8770703095287/2;
%     sa2_strength       = 46.75922686210009 /2;
%     sb1_strength       = -229.2424942716568/2;
%     sb2_strength       = 122.1875937851297 /2;
%     sd1_strength       = -304.7041246102518/2;
%     sf1_strength       = 358.3225430665879 /2;
%     sd2_strength       = -157.3890464079509/2;
%     sd3_strength       = -291.3442333179376/2;
%     sf2_strength       = 353.0546937179435 /2;


else
    error('Mode_version not implemented');
end


