function [model, model_length] = sirius_si_bc_segmented_model(passmethod, m_accep_fam_name)

types = {};
bc_hf   = 1; types{end+1} = struct('fam_name', 'bc_hf', 'passmethod', passmethod);
bc_lf   = 2; types{end+1} = struct('fam_name', 'bc_lf', 'passmethod', passmethod);
bc_edge = 3; types{end+1} = struct('fam_name', 'bc_edge', 'passmethod', 'IdentityPass');
m_accep = 4; types{end+1} = struct('fam_name', m_accep_fam_name, 'passmethod', 'IdentityPass');

% dipole model 2015-10-27
% =======================
% this (half) model is based on fieldmap
% /home/fac_files/data/sirius/si/magnet_modelling/si-bc/bc-model5
% '2015-10-26_Dipolo_Anel_BC_B3_Modelo5_gap_lateral_0.25mm_peca_3.5mm_-90_12mm_-2000_2000mm.txt'

monomials = [0,1,2,3,4,5,6,7,8,10];
segmodel = [ ...
%type    len[m]    angle[deg]               PolynomB(n=0)            PolynomB(n=1)            PolynomB(n=2)            PolynomB(n=3)            PolynomB(n=4)           PolynomB(n=5)           PolynomB(n=6)           PolynomB(n=7)           PolynomB(n=8)          PolynomB(n=10)      
bc_hf,   0.00500,  +9.0422547934608036e-02, +0.0000000000000000e+00, +1.6561279928435787e-03, -3.8635102770266840e+01, +1.9799838007583221e+00, +5.9142930617311067e+04, -2.3305532644109009e+06, -1.3307147432627836e+10, +1.7359198612372101e+10, +1.0252680450327594e+14, -3.5093500128006522e+17;... 
bc_hf,   0.00500,  +8.0758431643953799e-02, +0.0000000000000000e+00, -2.0903676504604431e-02, -2.2702568070088319e+01, +1.4458119648419139e+02, -2.6646305391284678e+05, -3.6857518202011138e+06, -2.3106186377990789e+09, +2.6921474787375134e+10, +2.6620270071919512e+13, -1.5513808575817158e+17;... 
bc_hf,   0.00500,  +6.8945936554505274e-02, +0.0000000000000000e+00, -2.3783484246212603e-02, -1.4656043218180633e+01, -1.6540736507600374e+02, -8.5192774826686655e+04, +3.5314984296880653e+06, -2.1773195650338092e+09, -1.8854035837515739e+10, +2.6361796741709301e+13, -1.1722681242408355e+17;... 
bc_hf,   0.00500,  +5.9638111977626050e-02, +0.0000000000000000e+00, -2.7327097383913031e-02, -9.9166707084254302e+00, +2.4429667067945029e+01, -7.0084006027048628e+04, +1.3445919048467744e+04, -4.1702366841366008e+07, +2.1265425230801362e+08, +2.6338328064194175e+12, -2.1107080596575184e+16;... 
bc_hf,   0.01000,  +9.8158051792883727e-02, +0.0000000000000000e+00, -2.6534257289669964e-02, -6.4387824972092691e+00, +2.6348399196444120e+01, -5.0916075692931183e+04, -2.3188712883498441e+05, +5.6004196191402411e+08, +1.1637591856594622e+09, -5.2978932516412520e+12, +1.7147670705566452e+16;... 
bc_hf,   0.01000,  +7.5633667090819492e-02, +0.0000000000000000e+00, -2.6409656954669659e-02, -4.6438801732611275e+00, -9.1067244808440861e-01, +2.4617675782323390e+03, +1.2719147568578293e+05, -2.6880190906564468e+08, -6.7552679229492307e+08, +2.6444000230142295e+12, -9.3558861138943840e+15;... 
bc_hf,   0.01000,  +5.6667191990155803e-02, +0.0000000000000000e+00, -2.5758769525181791e-02, -3.1417659494792733e+00, -2.1984432707591490e+00, +2.8204152736840158e+04, +9.6021653622038182e+04, -7.9585436517169988e+08, -4.9875968852969640e+08, +8.4330130753745986e+12, -3.1547100791949620e+16;... 
bc_hf,   0.01000,  +4.2518183670394671e-02, +0.0000000000000000e+00, -1.7901519850398690e-02, -1.6068666179296018e+00, +1.5749332075496348e+01, +2.2249629396559372e+04, -2.2799932382150227e+05, -5.1151276780732208e+08, +1.3033731927250462e+09, +4.7794425389891797e+12, -1.6060237462297156e+16;... 
m_accep, 0,0,0,0,0,0,0,0,0,0,0,0;...
bc_lf,   0.06400,  +2.1926765559733227e-01, +0.0000000000000000e+00, -6.3575058971078000e-02, +5.7552096864411206e-02, -6.1029870852386248e-01, +6.3916159115248693e+03, +1.1541752602750805e+05, -1.7052182891828227e+08, -6.3818038047387326e+08, +1.8345588994951411e+12, -6.9669856612719380e+15;... 
m_accep, 0,0,0,0,0,0,0,0,0,0,0,0;...
bc_lf,   0.16000,  +6.2740395177249542e-01, +0.0000000000000000e+00, -9.2106552053603707e-01, +3.7647151209247032e-01, +2.3040612235933114e+01, +3.7489709435214905e+02, -4.3028586111107048e+04, -3.9564097394172037e+06, +2.9250143761053407e+08, +7.9113730235646133e+10, -4.0789959301350775e+14;... 
m_accep, 0,0,0,0,0,0,0,0,0,0,0,0;...
bc_lf,   0.16000,  +6.2785342551080536e-01, +0.0000000000000000e+00, -9.3283631421853341e-01, +1.9939285149027961e-02, +1.6088661085707052e+01, -6.7782512676166402e+02, +9.6831520405249539e+03, +3.0342076799674477e+07, +1.2629537257322352e+07, -3.5182321602417853e+11, +1.4392589157007770e+15;... 
bc_lf,   0.01200,  +3.7433423366223684e-02, +0.0000000000000000e+00, -4.8446877432302532e-01, -6.2904784695128635e+00, -2.6448770987803265e+01, +1.5099630249097117e+04, +3.2041042214380478e+05, -3.2151790795382023e+08, -1.7296198998471317e+09, +2.9683186337765649e+12, -9.6872876048203320e+15;... 
bc_edge, 0,0,0,0,0,0,0,0,0,0,0,0;...
bc_lf,   0.01400,  +2.7735002654968963e-02, +0.0000000000000000e+00, -1.4114654416046352e-01, -4.1872290260829699e+00, -5.3964210249114615e+01, +2.8115430232918284e+03, +1.6760442725036910e+05, -1.1300511931505170e+08, -9.8905066298100698e+08, +1.5724686164790283e+12, -7.2638745935471830e+15;... 
bc_lf,   0.01600,  +1.6858462139756988e-02, +0.0000000000000000e+00, -4.3915793851809062e-02, -1.7249251586261864e+00, -1.3797673428608025e+01, -6.9074423403550873e+03, +4.8507983042934757e+04, +1.6330701912266961e+08, -4.2935521064516783e+08, -1.6924523966197566e+12, +6.1627050288660720e+15;... 
bc_lf,   0.03500,  +1.9005956303470142e-02, -2.8911543418873900e-04, -1.2111051363762683e-02, -8.4000797435596442e-01, +2.8602281278739254e+00, +1.2362305859215139e+03, -4.4648734696774685e+04, -3.3848435935284138e+07, +2.1947381750349617e+08, +3.8525756521465143e+11, -1.5642868102512230e+15;... 
];

% builds half of the magnet model
d2r = pi/180.0;
b = zeros(1,size(segmodel,1));
maxorder = 1+max(monomials);
for i=1:size(segmodel,1)
    type = types{segmodel(i,1)};
    if strcmpi(type.passmethod, 'IdentityPass')
        b(i) = marker(type.fam_name, 'IdentityPass');
    else
        PolyB = zeros(1,maxorder); PolyA = zeros(1,maxorder);
        PolyB(monomials+1) = segmodel(i,4:end); 
        b(i) = rbend_sirius(type.fam_name, segmodel(i,2), d2r * segmodel(i,3), 0, 0, 0, 0, 0, PolyA, PolyB, passmethod);
    end
end

% builds entire magnet model, inserting additional markers
model_length = 2*sum(segmodel(:,2));
mc = marker('mc', 'IdentityPass');
m_accep = marker(types{m_accep}.fam_name, 'IdentityPass');
model = [fliplr(b), mc, m_accep, b];