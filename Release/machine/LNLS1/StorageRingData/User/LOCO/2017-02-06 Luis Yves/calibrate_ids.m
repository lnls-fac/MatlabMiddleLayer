function calibrate_ids

fprintf('\n');

[awg01,awg09] = get_data();

% load LOCO calibrated THERING with IDs off.
fprintf('Loading THERING calibrated without IDs\n');
root_folder = lnls_get_root_folder();
r = load(fullfile(root_folder, 'code', 'MatlabMiddleLayer','Release','machine','LNLS1','StorageRingData','User','LOCO','2017-02-06 Luis Yves','IDsOff-Calibration-THERING.mat'));
the_ring0 = r.THERING; clear('r');
print_info_id(the_ring0, 'AWG01');
print_info_id(the_ring0, 'AWG09');
print_info_id(the_ring0, 'AON11');
[nux0, nuy0] = get_model_tunes(the_ring0);
fprintf('\n');

% turn all IDs on and register tunes variation
fprintf('Setting all IDs on\n');
the_ring = the_ring0;
the_ring = set_ids_on(the_ring,'AON11');the_ring = set_ids_on(the_ring,'AWG01');the_ring = set_ids_on(the_ring,'AWG09');
[nux1, nuy1] = get_model_tunes(the_ring);
print_info_id(the_ring, 'AWG01');
print_info_id(the_ring, 'AWG09');
print_info_id(the_ring, 'AON11');
the_ring_IDsOn = the_ring;
fprintf('\n');

% calculate intrinsic AWG09 focusing
the_ring = the_ring_IDsOn; the_ring = set_ids_off(the_ring,'AWG09');
[nux2, nuy2] = get_model_tunes(the_ring);
fprintf('AWG09 dTuneX,dTuneY - meas. : %+.7f %+.7f\n', awg09(1,2)-awg09(end,2), awg09(1,3)-awg09(end,3));
fprintf('AWG09 dTuneX,dTuneY - model : %+.7f %+.7f\n', nux1-nux2, nuy1-nuy2);
fprintf('\n');

% calculate intrinsic AWG01 focusing
the_ring = the_ring_IDsOn; the_ring = set_ids_off(the_ring,'AWG01');
[nux2, nuy2] = get_model_tunes(the_ring);
fprintf('AWG01 dTuneX,dTuneY - meas. : %+.7f %+.7f\n', awg01(1,2)-awg01(end,2), awg01(1,3)-awg01(end,3));
fprintf('AWG01 dTuneX,dTuneY - model : %+.7f %+.7f\n', nux1-nux2, nuy1-nuy2);
fprintf('\n');


% vary AWG09 gradient
k = linspace(0.0068,0.0076,11);
best_k = k(1); best_residue = Inf;
for i=1:length(k)
    the_ring = the_ring_IDsOn;
    the_ring = set_id_gradient(the_ring, 'AWG09', k(i));
    [nux1, nuy1] = get_model_tunes(the_ring);
    the_ring = set_ids_off(the_ring,'AWG09'); 
    the_ring = set_id_gradient(the_ring, 'AWG09', 0); 
    [nux2, nuy2] = get_model_tunes(the_ring);
    dnux_measu = awg09(1,2)-awg09(end,2);
    dnuy_measu = awg09(1,3)-awg09(end,3);
    dnux_model = nux1-nux2;
    dnuy_model = nuy1-nuy2;
    residue = sqrt((dnux_model - dnux_measu)^2 + (dnuy_model - dnuy_measu)^2);
    if (residue < best_residue)
        best_residue = residue;
        best_k = k(i);
    end
    fprintf('k = %+.5f, %+.7f %+.7f\n', k(i), dnux_model, dnuy_model);
    fprintf('            , %+.7f %+.7f\n', dnux_measu, dnuy_measu);
    fprintf('            , residue: %.7f\n', residue);
end
the_ring_IDsOnAWG09Calibrated = set_id_gradient(the_ring_IDsOn, 'AWG09', best_k);
fprintf('best k       : %+.5f\n', best_k);
fprintf('min  residue : %.7f\n', best_residue);
fprintf('\n');

% vary AWG01 gradient
k = linspace(-0.010,+0.010,121);
best_k = k(1); best_residue = Inf;
for i=1:length(k)
    the_ring = the_ring_IDsOnAWG09Calibrated;
    the_ring = set_id_gradient(the_ring, 'AWG01', k(i));
    [nux1, nuy1] = get_model_tunes(the_ring);
    the_ring = set_ids_off(the_ring,'AWG01'); 
    the_ring = set_id_gradient(the_ring, 'AWG01', 0); 
    [nux2, nuy2] = get_model_tunes(the_ring);
    dnux_measu = awg01(1,2)-awg01(end,2);
    dnuy_measu = awg01(1,3)-awg01(end,3);
    dnux_model = nux1-nux2;
    dnuy_model = nuy1-nuy2;
    residue = sqrt((dnux_model - dnux_measu)^2 + (dnuy_model - dnuy_measu)^2);
    if (residue < best_residue)
        best_residue = residue;
        best_k = k(i);
    end
    fprintf('k = %+.5f, %+.7f %+.7f\n', k(i), dnux_model, dnuy_model);
    fprintf('            , %+.7f %+.7f\n', dnux_measu, dnuy_measu);
    fprintf('            , residue: %.7f\n', residue);
end
the_ring_IDsOnIDsCalibrated = set_id_gradient(the_ring_IDsOnAWG09Calibrated, 'AWG01', best_k);
fprintf('best k       : %+.5f\n', best_k);
fprintf('min  residue : %.7f\n', best_residue);
fprintf('\n');


function the_ring_next = set_ids_on(the_ring_prev, id_famname)

global THERING
THERING0 = THERING;
THERING = the_ring_prev;
if strcmp(id_famname, 'AON11')
    lnls1_set_id_field('AON11',0.56);
elseif strcmp(id_famname, 'AWG01')
    lnls1_set_id_field('AWG01',2.00);
elseif strcmp(id_famname, 'AWG09')
    lnls1_set_id_field('AWG09',4.00);
end
the_ring_next = THERING;
THERING = THERING0;

function the_ring_next = set_ids_off(the_ring_prev, id_famname)

global THERING
THERING0 = THERING;
THERING = the_ring_prev;
if strcmp(id_famname, 'AON11')
    lnls1_set_id_field('AON11',0.00);
elseif strcmp(id_famname, 'AWG01')
    lnls1_set_id_field('AWG01',0.00);
elseif strcmp(id_famname, 'AWG09')
    lnls1_set_id_field('AWG09',0.00);
end
the_ring_next = THERING;
THERING = THERING0;


function [nux, nuy] = get_model_tunes(the_ring)

m44 = findm44(the_ring, 0);
nux = acos((m44(1,1)+m44(2,2))/2)/2/pi;
nuy = acos((m44(3,3)+m44(4,4))/2)/2/pi;

function the_ring_next = set_id_gradient(the_ring_prev, id_famname, k)

idx = intersect(findcells(the_ring_prev, 'FamName', id_famname), findcells(the_ring_prev, 'PolynomB'));
if ~isempty(idx)
    new_k = repmat(k,1,length(idx)) .* [0.5, repmat(1,1,length(idx)-2), 0.5];
    the_ring_next = setcellstruct(the_ring_prev, 'PolynomB', idx, new_k, 1, 2);
else
    the_ring_next = the_ring_prev;
end


function print_info_id(the_ring, id_famname)

idx = intersect(findcells(the_ring, 'FamName', id_famname), findcells(the_ring, 'Field'));
if isempty(idx)
    fprintf([id_famname, ' field [T], K[1/m^2]: %f, %f\n'], 0, 0)
else
    fprintf([id_famname, ' field [T], K[1/m^2]: %f, %f\n'], the_ring{idx(5)}.Field, the_ring{idx(5)}.PolynomB(2))
end


function [awg01,awg09] = get_data()

awg01 = [ ...
22	 661.5	556.1; ...
22.5 663.5	554.3; ...
23	 665.3	552.6; ...
23.5 667.1	551.4; ...
24	 668.7	546.7; ...
24.5 670.1	548.2; ...
25	 671.5	546.8; ...
25.5 672.8	545.5; ...
26	 673.9	544.2; ...
27	 676.1	541.5; ...
28	 677.9	539.2; ...
30	 680.8	534.2; ...
32	 682.9	530.3; ...
35	 685.4	524.6; ...
40	 689.0	517.2; ...
45	 692.4	511.1; ...
50	 696.2	506.0; ...
60	 703.8	498.5; ...
70	 710.5	493.7; ...
80	 716.0	490.7; ...
100	 722.9	487.1; ...
120	 726.3	485.4; ...
140	 727.7	484.6; ...
160	 728.3	484.0; ...
180	 728.6	483.9; ...
];

awg09 = [ ...
4	660.4	554.8; ...
3.9	659.7	550.7; ...
3.8	659.1	546.5; ...
3.7	658.3	542.6; ...
3.6	657.6	538.6; ...
3.5	656.9	535.1; ...
3.4	656.1	531.2; ...
3.3	655.1	527.7; ...
3.2	654.4	524.2; ...
3.1	653.6	520.9; ...
3.0	652.7	517.7; ...
2.8	651.0	511.4; ...
2.6	649.4	505.6; ...
2.4	647.7	500.0; ...
2.2	646.1	494.9; ...
2.0	644.4	490.2; ...
1.8	642.7	485.8; ...
1.6	641.1	482.2; ...
1.4	639.4	478.6; ...
1.2	637.7	475.6; ...
1.0	636.6	473.4; ...
0.8	635.9	472.4; ...
0.6	635.6	471.5; ...
0.4	635.8	470.5; ...
0.2	636.1	469.2; ...
];

awg01(:,[2,3]) = awg01(:,[2,3]) * 1e3 / 3.21666e6; 
awg09(:,[2,3]) = awg09(:,[2,3]) * 1e3 / 3.21666e6;

