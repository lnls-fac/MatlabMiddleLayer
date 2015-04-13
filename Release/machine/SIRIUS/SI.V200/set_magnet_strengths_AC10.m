% set_magnet_strengths_V200_AC10
% ==============================
% 2012-09-21 Vinculos para AC20 explicitos (ximenes)
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

if strcmpi(mode_version,'AC10_2')
%     %% ac10_2 (antigo moga328)
%     %%% QUADRUPOLOS
%     %  ===========
%     
    qaf_strength   =  2.537296184268377;
    qad_strength   = -2.73415324178606;
    qf1_strength   =  2.371727588481388;
    qf2_strength   =  3.353138936660851;
    qf3_strength   =  3.062693827255291;
    qf4_strength   =  2.72911516713545;
    
    qbd2_strength  = -3.954309719796702;
    qbf_strength   =  3.910203239069909;
    qbd1_strength  = -2.99072488074151;
%     
%     %%% SEXTUPOLOS
%     %  ==========
%     
    sa2_strength   =    25.873;
    sa1_strength   =   -65.972;
    sd1_strength   =  -181.89875;
    sf1_strength   =   190.221;
    sd2_strength   =  -60.293;
    sd3_strength   =  -133.453;
    sf2_strength   =   150.920;
    
    sb1_strength   =  -96.6447;
    sb2_strength   =   50.622;
    
%     %% ac10_2-moga1579)
%     %%% QUADRUPOLOS
%     %  ===========
%     
%     qaf_strength   =  2.5424898971;
%     qad_strength   = -2.7137623709;
%     qf1_strength   =  2.3682152925;
%     qf2_strength   =  3.3517023078;
%     qf3_strength   =  3.0504177994;
%     qf4_strength   =  2.7183152026;
%     
%     qbd2_strength  = -3.9577677802;
%     qbf_strength   =  3.9131394938;
%     qbd1_strength  = -2.9715366141;
%     
%     %%% SEXTUPOLOS
%     %  ==========
%     
%     sa2_strength   =    26.4450;
%     sa1_strength   =   -71.2362;
%     sd1_strength   =  -176.1557;
%     sf1_strength   =   184.6163;
%     sd2_strength   =   -60.6587;
%     sd3_strength   =  -137.8693;
%     sf2_strength   =   157.9973;
%     
%     sb1_strength   =  -109.2116;
%     sb2_strength   =    55.8300;

%     %% ac10_2-moga1018)
%     %%% QUADRUPOLOS
%     %  ===========
%     
%     qaf_strength   =  2.5379703067;
%     qad_strength   = -2.7127019245;
%     qf1_strength   =  2.3698958242;
%     qf2_strength   =  3.3524955525;
%     qf3_strength   =  3.0502041929;
%     qf4_strength   =  2.7304323632;
%     
%     qbd2_strength  = -3.9584199513;
%     qbf_strength   =  3.9113390405;
%     qbd1_strength  = -2.9829515041;
%     
%     %%% SEXTUPOLOS
%     %  ==========
%     
%     sa2_strength   =    25.7884;
%     sa1_strength   =   -67.4966;
%     sd1_strength   =  -175.5561;
%     sf1_strength   =   188.0767;
%     sd2_strength   =   -64.1986;
%     sd3_strength   =  -135.3997;
%     sf2_strength   =   154.2471;
%     
%     sb1_strength   =  -100.6407;
%     sb2_strength   =    52.6611;

    %% ac10_2-moga863)
    %%% QUADRUPOLOS
    %  ===========
    
%     qaf_strength   =  2.536343104638999;
%     qad_strength   = -2.734699336329038;
%     qf1_strength   =  2.371578768636431;
%     qf2_strength   =  3.355446899887369;
%     qf3_strength   =  3.060447227927547;
%     qf4_strength   =  2.738285574623644;
%     
%     qbd2_strength  = -3.955516486869687;
%     qbf_strength   =  3.903450245180885;
%     qbd1_strength  = -2.993073295490823;
    
    %%% SEXTUPOLOS
    %  ==========
    
%     sa2_strength   =    25.2877;
%     sa1_strength   =   -66.324737;
%     sd1_strength   =  -177.41546;
%     sf1_strength   =   187.41883;
%     sd2_strength   =   -62.427;
%     sd3_strength   =  -135.8627;
%     sf2_strength   =   157.26592;
%     
%     sb1_strength   =  -100.59369;
%     sb2_strength   =    53.988515;
end

%% ac10_1-moga173
% %%% QUADRUPOLOS
% %  ===========
% 
% qaf_strength   =  2.53303123342836;
% qad_strength   = -2.727713109062759;
% qf1_strength   =  2.372359570825172;
% qf2_strength   =  3.352568985929978;
% qf3_strength   =  3.061661288483911;
% qf4_strength   =  2.728963601811993;
% 
% qbd2_strength  = -3.955873450410041;
% qbf_strength   =  3.91025422216448;
% qbd1_strength  = -2.983801946451943;
% 
% %%% SEXTUPOLOS
% %  ==========
% 
% sa2_strength   =    26.585;
% sa1_strength   =   -69.985;
% sd1_strength   =  -186.745;
% sf1_strength   =   189.66;
% sd2_strength   =   -54.425;
% sd3_strength   =  -135.375;
% sf2_strength   =   150.975;
% 
% sb1_strength   =   -94.975;
% sb2_strength   =    52.405;


%% ac10_1-moga186
% %%% QUADRUPOLOS
% %  ===========
% 
% qaf_strength   =  2.540482841414947;
% qad_strength   = -2.732467296263223;
% qf1_strength   =  2.371935660488307;
% qf2_strength   =  3.352382329901055;
% qf3_strength   =  3.061721689600176;
% qf4_strength   =  2.726572517947555;
% 
% qbd2_strength  = -3.956471221376155;
% qbf_strength   =  3.910851993130583;
% qbd1_strength  = -2.980215320655289;
% 
% %%% SEXTUPOLOS
% %  ==========
% 
% sa2_strength   =   22.4261;
% sa1_strength   =  -63.7371;
% sd1_strength   = -195.9474;
% sf1_strength   =  182.6673;
% sd2_strength   =  -44.0376;
% sd3_strength   = -131.6510;
% sf2_strength   =  158.1631;
% 
% sb1_strength   =  -96.1344;
% sb2_strength   =   47.9249;

%% teste1
% %%% QUADRUPOLOS
% %  ===========
% 
% qaf_strength   =  2.537491;
% qad_strength   = -2.729328;
% qf1_strength   =  2.372013;
% qf2_strength   =  3.355252;
% qf3_strength   =  3.061660;
% qf4_strength   =  2.740290;
% 
% qbd2_strength  = -3.956425;
% qbf_strength   =  3.910931;
% qbd1_strength  = -2.980299;
% 
% 
% %%% SEXTUPOLOS
% %  ==========
% 
% sa2_strength   =   20.329951;
% sa1_strength   =  -37.328757;
% sd1_strength   = -169.012939;
% sf1_strength   =  177.940716;
% sd2_strength   =  -59.665560;
% sd3_strength   = -151.625809;
% sf2_strength   =  175.425128;
% 
% sb1_strength   =  -76.352202;
% sb2_strength   =   48.222516;

