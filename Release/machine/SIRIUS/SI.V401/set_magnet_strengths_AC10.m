% set_magnet_strengths_V401_AC10
% ==============================
% 2012-08-28 Ximenes

 %% Original
% %%% QUADRUPOLOS
% %  ===========
% 
% qaf_strength   =  2.537570;
% qad_strength   = -2.729328;
% qf1_strength   =  2.371968;
% qf2_strength   =  3.352302;
% qf3_strength   =  3.061660;
% qf4_strength   =  2.726685;
% 
% qbd2_strength  = -3.956425;
% qbf_strength   =  3.910931;
% qbd1_strength  = -2.980299;
% 
% 
% %%% SEXTUPOLOS
% %  ==========
% 
% sa2_strength   =   32.425521;
% sa1_strength   =  -79.737134;
% sd1_strength   = -223.259831;
% sf1_strength   =  178.620030;
% sd2_strength   =  -18.265605;
% sd3_strength   = -125.477531;
% sf2_strength   =  156.962838;
% 
% sb1_strength   =  -82.703315;
% sb2_strength   =   54.034149;



if strcmpi(mode_version,'AC10_1')
    %% ac10_1    (antigo moga_191)
    %%% QUADRUPOLOS
    %  ===========
    
    qaf_strength   =  2.537149508081614;
    qad_strength   = -2.72913396292989;
    qf1_strength   =  2.371935660488307;
    qf2_strength   =  3.352382329901055;
    qf3_strength   =  3.061721689600176;
    qf4_strength   =  2.726572517947555;
    
    qbd2_strength  = -3.956471221376155;
    qbf_strength   =  3.910851993130583;
    qbd1_strength  = -2.980215320655289;
    
    
    %%% SEXTUPOLOS
    %  ==========
    
    sa2_strength   =   52.72380076806903/2;
    sa1_strength   =  -143.8844478200684/2;
    sd1_strength   = -417.235066899276/2;
    sf1_strength   =  366.7874776704998/2;
    sd2_strength   =  -65.72359519210869/2;
    sd3_strength   = -258.2261103894817/2;
    sf2_strength   =  306.7833526228504/2;
    
    sb1_strength   =  -184.6185552543126/2;
    sb2_strength   =   97.98683543332642/2;
end

%% ac10_2 (antigo moga328)
if strcmpi(mode_version,'AC10_2')
    %%% QUADRUPOLOS
    %  ===========
    
    qaf_strength   =  2.537296184268377;
    qad_strength   = -2.73415324178606;
    qf1_strength   =  2.371727588481388;
    qf2_strength   =  3.353138936660851;
    qf3_strength   =  3.062693827255291;
    qf4_strength   =  2.72911516713545;
    
    qbd2_strength  = -3.954309719796702;
    qbf_strength   =  3.910203239069909;
    qbd1_strength  = -2.99072488074151;
    
    %%% SEXTUPOLOS
    %  ==========
    
    sa2_strength   =    25.873;
    sa1_strength   =   -65.972;
    sd1_strength   =  -181.89875;
    sf1_strength   =   190.221;
    sd2_strength   =  -60.293;
    sd3_strength   =  -133.453;
    sf2_strength   =   150.920;
    
    sb1_strength   =  -96.6447;
    sb2_strength   =   50.622;
end

%% ac10_3 (é o ac10_2 simetrizado em relação ao BC)
if strcmpi(mode_version,'AC10_3')

    %%% QUADRUPOLOS
    %  ===========
    
    qaf_strength   =  2.540801;
    qad_strength   = -2.744679;
    qf1_strength   =  2.371977;
    qf2_strength   =  3.353143;
    qf3_strength   =  3.062984;
    qf4_strength   =  2.729574;
    
    qbd2_strength  = -3.966318;
    qbf_strength   =  3.908091;
    qbd1_strength  = -2.974256;
    
    %%% SEXTUPOLOS
    %  ==========
    
    sa2_strength   =    25.873;
    sa1_strength   =   -65.972;
    sd1_strength   =  -182.338526;
    sf1_strength   =   190.196570;
    sd2_strength   =  -60.293;
    sd3_strength   =  -133.453;
    sf2_strength   =   150.920;
    
    sb1_strength   =  -96.6447;
    sb2_strength   =   50.622;
    

end

%% Antigo Moga0473modif-0512
% Um pouco de historia: esse modo é o resultado de duas otimizações do
% MOGA. Primeiro, otimizei usando o ac10_3 como ponto inicial e peguei o
% resultado 0473. Mas esse resultado tinha uma sintonia vertical muito
% próxima do inteiro, então aumentei a sintonia com o OPA e usei o
% resultado como ponto inicial para outra otimização, mas coloquei um
% vínculo adicional de que as sintonias deveriam ser maiores que 0.12.
% Peguei o resultado 0512 dessa simulação e vi que ele melhorava tanto o
% tempo de vida, como a abertura dinamica, quando simulado com o conjunto
% padrao de erros, no tracy3.
%
if strcmpi(mode_version,'AC10_4')
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
    
    
%% Resultado do moga para cromaticidades (5,2) ac10_4-0339
    
%     %%% QUADRUPOLOS
%     %  ===========
%     
%     qaf_strength       =  2.53708818752072;
%     qad_strength       = -2.731762340583545;
%     qbd2_strength      = -3.961678492134737;
%     qbf_strength       =  3.903359509756828;
%     qbd1_strength      = -2.9671046260996;
%     qf1_strength       =  2.367562686058391;
%     qf2_strength       =  3.355951928047948;
%     qf3_strength       =  3.057795103974827;
%     qf4_strength       =  2.73349054511057;
% 
%     
%     %%% SEXTUPOLOS
%     %  ==========
%     sa1_strength       = -121.9405084329487/2;
%     sa2_strength       =   52.6550765085403/2;
%     sb1_strength       = -227.8797772036702/2;
%     sb2_strength       =  132.2562234260708/2;
%     sd1_strength       = -361.0429927087931/2;
%     sf1_strength       =  383.626577650561/2;
%     sd2_strength       = -130.2544619160013/2;
%     sd3_strength       = -281.4637800170552/2;
%     sf2_strength       =  331.1292204262333/2;  
    
%% Resultado do moga para cromaticidades (5,2) ac10_4-1270
%     
%     %%% QUADRUPOLOS
%     %  ===========
%     
%     qaf_strength       =  2.538917213927464;
%     qad_strength       = -2.728081309908914;
%     qbd2_strength      = -3.96296693457476;
%     qbf_strength       =  3.914799214845683;
%     qbd1_strength      = -2.978995420678219;
%     qf1_strength       =  2.369711155766487;
%     qf2_strength       =  3.353060888153273;
%     qf3_strength       =  3.078611767930616;
%     qf4_strength       =  2.711555206058496;
% 
%     
%     %%% SEXTUPOLOS
%     %  ==========
%     sa1_strength       = -144.896265805157/2;
%     sa2_strength       =   68.43031966640618/2;
%     sb1_strength       = -229.8914692450523/2;
%     sb2_strength       =  115.3345169070114/2;
%     sd1_strength       = -349.7253274451378/2;
%     sf1_strength       =  371.9802872036199/2;
%     sd2_strength       = -129.5892884141234/2;
%     sd3_strength       = -296.4871370699877/2;
%     sf2_strength       =  354.5741275800037/2;  
%    
%% Resultado do moga para cromaticidades (5,2) ac10_4-1978
    
%     %%% QUADRUPOLOS
%     %  ===========
%     
%     qaf_strength       =  2.538986080567534;
%     qad_strength       = -2.729516459651677;
%     qbd2_strength      = -3.976731037122514;
%     qbf_strength       =  3.911645564896731;
%     qbd1_strength      = -2.968674968015322;
%     qf1_strength       =  2.381301562790952;
%     qf2_strength       =  3.345413193762304;
%     qf3_strength       =  3.066401279173335;
%     qf4_strength       =  2.725896967049218;
% 
% 
%     %%% SEXTUPOLOS
%     %  ==========
%     sa1_strength       = -152.2257030991947/2;
%     sa2_strength       =   78.2390558526264/2;
%     sb1_strength       = -235.8671591306712/2;
%     sb2_strength       =  117.3130033148446/2;
%     sd1_strength       = -341.7468779738909/2;
%     sf1_strength       =  377.6794223388328/2;
%     sd2_strength       = -140.1229357471648/2;
%     sd3_strength       = -297.0191828423302/2;
%     sf2_strength       =  348.1267376653981/2;  

end











%Tentativas de otimizacao do ac10_3

%% Moga0417    
% %     %%% QUADRUPOLOS
% %     %  ===========
% %     
%     qaf_strength   =  2.540782888614921;
%     qad_strength   = -2.732836906757243;
%     qf1_strength   =  2.385978688572151;
%     qf2_strength   =  3.342128130922661;
%     qf3_strength   =  3.064524405009377;
%     qf4_strength   =  2.728405918496526;
%     
%     qbd2_strength  = -3.954303449657729;
%     qbf_strength   =  3.903132432914769;
%     qbd1_strength  = -2.974509358660194;
%     
% %     
% %     %%% SEXTUPOLOS
% %     %  ==========
% %     
%     sa2_strength   =   54.54391580401086/2;
%     sa1_strength   =  -128.5071939844309/2;
%     sd1_strength   =  -362.1874789469475/2;
%     sf1_strength   =   378.1486093336561/2;
%     sd2_strength   =  -119.4217733542561/2;
%     sd3_strength   =  -271.5834596651011/2;
%     sf2_strength   =   305.3934346220345/2;
%     
%     sb1_strength   =  -205.2576332629963/2;
%     sb2_strength   =   99.82236270357961/2;
    
%% Moga0487    
%     %%% QUADRUPOLOS
%     %  ===========
%     
%     qaf_strength   =  2.536089053421956;
%     qad_strength   = -2.720116987433326;
%     qf1_strength   =  2.402764076465204;
%     qf2_strength   =  3.329989603037198;
%     qf3_strength   =  3.066674512795975;
%     qf4_strength   =  2.728604847817039;
%     
%     qbd2_strength  = -3.989794505068176;
%     qbf_strength   =  3.892611384799532;
%     qbd1_strength  = -2.938084832219889;

%     
%     %%% SEXTUPOLOS
%     %  ==========
%     
%     sa2_strength   =   54.55656240167368/2;
%     sa1_strength   =  -139.5413864491179/2;
%     sd1_strength   =  -363.6672834505566/2;
%     sf1_strength   =   379.4292333604049/2;
%     sd2_strength   =  -118.1746452369339/2;
%     sd3_strength   =  -274.8162777606683/2;
%     sf2_strength   =   305.7908859155888/2;
%     
%     sb1_strength   =  -201.6516268231331/2;
%     sb2_strength   =   110.5672176600868/2;


%% Moga1703  
%     %%% QUADRUPOLOS
%     %  ===========
%     
%     qaf_strength   =  2.530338125279905;
%     qad_strength   = -2.702973410596547;
%     qf1_strength   =  2.384511010297454;
%     qf2_strength   =  3.34231551133618;
%     qf3_strength   =  3.053075474421204;
%     qf4_strength   =  2.728260876584326;
%     
%     qbd2_strength  = -3.963295207173091;
%     qbf_strength   =  3.907409016990926;
%     qbd1_strength  = -2.968833090657777;
% 
%     
%     %%% SEXTUPOLOS
%     %  ==========
%     
%     sa2_strength   =   47.22828722777708/2;
%     sa1_strength   =  -129.216877034822/2;
%     sd1_strength   =  -345.0416380978779/2;
%     sf1_strength   =   377.65603977184669/2;
%     sd2_strength   =  -133.9508869966858/2;
%     sd3_strength   =  -277.4549080597796/2;
%     sf2_strength   =   314.119686317207/2;
%     
%     sb1_strength   =  -206.2705396048777/2;
%     sb2_strength   =   110.4153863568466/2;
% 

%% Moga0473    
%     %%% QUADRUPOLOS
%     %  ===========
%     
%     qaf_strength   =  2.540002687310256;
%     qad_strength   = -2.728275667669999;
%     qf1_strength   =  2.409716489131633;
%     qf2_strength   =  3.324134826234893;
%     qf3_strength   =  3.060065657599124;
%     qf4_strength   =  2.728944758635733;
%     
%     qbd2_strength  = -3.961523830795603;
%     qbf_strength   =  3.90505357520659;
%     qbd1_strength  = -2.977122949107544;
%     
%     %%% SEXTUPOLOS
%     %  ==========
%     
%     sa2_strength   =   55.42042239690487/2;
%     sa1_strength   =  -129.5787955356273/2;
%     sd1_strength   =  -354.0047250618239/2;
%     sf1_strength   =   381.323494782296/2;
%     sd2_strength   =  -128.9440865311087/2;
%     sd3_strength   =  -273.7255516338861/2;
%     sf2_strength   =   305.5656635931085/2;
%     
%     sb1_strength   =  -213.9265732955381/2;
%     sb2_strength   =   104.1356566680167/2;
   
