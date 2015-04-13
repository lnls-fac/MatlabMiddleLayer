function set_orbit(BPMx_commonnames, BPMy_commonnames, x_orbit_sp, y_orbit_sp, orbit_tol, pause_after_corrector_setpoint)
% Configura corretoras do anel de modo a gerar uma determinada órbita
%
%function set_orbit(BPMx_commonnames, BPMy_commonnames, x_orbit_sp, y_orbit_sp, orbit_tol, pause_after_corrector_setpoint)
%
% example: set_orbit({'AMP01B','AMP02A','AMP02B','AMP03A','AMP03B'},{},[-1,-2,-3,-4,-5],[],0.00001,0);
%
% História:
%
% 2010-09-16: comentários no código.

x_orbit_sp = x_orbit_sp(:);
y_orbit_sp = y_orbit_sp(:);

[BPMx_commonnames,i,j] = unique(BPMx_commonnames);
x_orbit_sp = x_orbit_sp(i);

[BPMy_commonnames,i,j] = unique(BPMy_commonnames);
y_orbit_sp = y_orbit_sp(i);


% RESPONSE MATRIX
rmat = getbpmresp({'BPMx','BPMy'}, {'HCM','VCM'}, 'Struct');
rmat_bpm_elements = dev2elem('BPMx', rmat(1,1).Monitor.DeviceList);

x_elements = [];
x_rmat_idx = [];
x_rmat = [];
if ~isempty(BPMx_commonnames)
for i=1:length(BPMx_commonnames)
    x_elements(i) = dev2elem('BPMx',common2dev(BPMx_commonnames{i}, 'BPMx'));
    x_rmat_idx(i) = find(rmat_bpm_elements == x_elements(i));
    x_rmat(i,:) = rmat(1,1).Data(x_rmat_idx(i), :);
end
end

y_elements = [];
y_rmat_idx = [];
y_rmat = [];
if ~isempty(BPMy_commonnames)
for i=1:length(BPMy_commonnames)
    y_elements(i) = dev2elem('BPMy',common2dev(BPMy_commonnames{i}, 'BPMy'));
    y_rmat_idx(i) = find(rmat_bpm_elements == y_elements(i));
    y_rmat(i,:) = rmat(2,2).Data(y_rmat_idx(i), :);
end
end



% corrects orbit
x_orbit_am = [];
y_orbit_am = [];
x_flag = 0;
y_flag = 0;


if ~isempty(x_elements)
    x_orbit_am = getx; 
    x_flag = (max(abs(x_orbit_am(x_elements) - x_orbit_sp)) > orbit_tol);
end;
if ~isempty(y_elements)
    y_orbit_am = gety; 
    y_flag = (max(abs(y_orbit_am(y_elements) - y_orbit_sp)) > orbit_tol);
end;


while (x_flag || y_flag)
    
    if ~isempty(x_elements)
        Family = 'HCM';
        DeviceList = family2dev(Family);
        x_theta = pinv(x_rmat) * (x_orbit_sp - x_orbit_am(x_elements));
        [LimitFlag, LimitList] = checklimits(Family, getsp(Family, DeviceList)+x_theta, DeviceList);
        if LimitFlag
            error('Setpoint limit in HCM family exceeded');
        else
            stepsp('HCM', x_theta); 
        end
    end
    if ~isempty(y_elements)
        Family = 'VCM';
        DeviceList = family2dev(Family);
        y_theta = pinv(y_rmat) * (y_orbit_sp - y_orbit_am(y_elements));
        [LimitFlag, LimitList] = checklimits(Family, getsp(Family, DeviceList)+y_theta, DeviceList);
        if LimitFlag
            error('Setpoint limit in VCM family exceeded');
        else
            stepsp('VCM', y_theta); 
        end
    end
    
    sleep(pause_after_corrector_setpoint)
    
    if ~isempty(x_elements)
        x_orbit_am = getx; 
        x_flag = (max(abs(x_orbit_am(x_elements) - x_orbit_sp)) > orbit_tol);
    end;
    if ~isempty(y_elements)
        y_orbit_am = gety; 
        y_flag = (max(abs(y_orbit_am(y_elements) - y_orbit_sp)) > orbit_tol);
    end;
    
end

    

