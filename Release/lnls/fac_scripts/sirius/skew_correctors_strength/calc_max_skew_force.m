function r = calc_max_skew_force

global THERING;

% carrega mode de operação
r.mode = 3; 
try
    setoperationalmode(r.mode);
catch
    sirius;
    setoperationalmode(r.mode);
end

sexts_fams = { ...
    'SL2'; ...
    'SM2'; ...
    'SS2'; ...
    'SSA2'; ...
    'SSB2'; ...
    };

coupling = 1; % in percentage

for i=1:length(sexts_fams)
    idx = findcells(THERING, 'FamName', sexts_fams{i});
    idx = reshape(idx, 2,[])';
    idx = idx(1,:);
    k1 = 0.0;
    k2 = 0.1;
    THERING = setcellstruct(THERING, 'PolynomA', idx, k1, 1, 2);
    [Tilt, Eta, EpsX, EpsY, er1, ENV, DP, DL, BeamSize] = calccoupling;
    if (er1 >= coupling/100), error('decrease k1!'); end;
    THERING = setcellstruct(THERING, 'PolynomA', idx, k2, 1, 2);
    [Tilt, Eta, EpsX, EpsY, er2, ENV, DP, DL, BeamSize] = calccoupling;
    if (er2 <= coupling/100), error('increase k2!'); end;
    while (k2 - k1 > 1e-3)
        km = (k1 + k2)/2;
        THERING = setcellstruct(THERING, 'PolynomA', idx, km, 1, 2);
        [Tilt, Eta, EpsX, EpsY, erm, ENV, DP, DL, BeamSize] = calccoupling;
        if (erm < coupling/100)
            k1 = km;
        else
            k2 = km;
        end
    end
    fprintf('%s -> %5.3f\n', sexts_fams{i}, (k1+k2)/2);
    THERING = setcellstruct(THERING, 'PolynomA', idx, 0, 1, 2);
end
