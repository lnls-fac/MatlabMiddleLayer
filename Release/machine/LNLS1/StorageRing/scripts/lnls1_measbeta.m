function r = lnls1_measbeta(varargin)
% LNLS1_MEASBETA medida de função beta
%
%  ALGORITHM
%  betax =  4*pi*Dtunex/D(KL)
%  betaz = -4*pi*Dtunez/D(KL)

delta_shunt = (getenergy / 1.37) * 2; % ampere
r.tune_wait = 5;
shunt_names = family2common('QUADSHUNT');
shunt_devs  = family2dev('QUADSHUNT');
position = getfamilydata('QUADSHUNT', 'Position');


%% inicializações básicas
%if ~strcmpi(getmode('BEND'), 'Online'), switch2online; end

for i=1:length(varargin)
    if ischar(varargin{i}) && strcmpi(varargin{i},'Archive')
        default_filename = varargin{i+1};
    end
end

%% Pede ao usuário, se for o caso, que defina onde os dados da medidas serão gravados
if ~exist('default_filename', 'var')
    default_dir      = fullfile(getfamilydata('Directory', 'DataRoot'), 'Optics', datestr(now, 'yyyy-mm-dd'));
    if ~exist(default_dir, 'dir')
        mkdir(default_dir); 
        dir_created = true;
    end
    default_filename = ['beta_' datestr(now, 'yyyy-mm-dd_HH-MM-SS') '.mat'];
    [FileName,PathName] = uiputfile('*.mat','Arquivo a ser salvo com medidas', fullfile(default_dir, default_filename));
    if FileName==0
        if dir_created, rmdir(default_dir); end
        return; 
    end
    default_filename = fullfile(PathName, FileName);
end


r.initial_time_stamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
fprintf('%s: INÍCIO DE MEDIDAS DAS FUNÇÕES BETA\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
r.initial_machineconfig = getmachineconfig;
r.initial_dcct = getdcct;

lnls1_quad_shunts_on;

for i=1:size(shunt_names, 1)
    fprintf('%s: Quadrupolo %s\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'), shunt_names(i,:));
    % medida
    dtunes = [0 0];
    delta_shunt_in_use = delta_shunt;
    while any(abs(dtunes) < 0.002) && (max(abs(getsp('QUADSHUNT'))) <= max(abs(maxpv('QUADSHUNT'))))
        fprintf('%s: delta shunt de %f amperes\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'), delta_shunt_in_use);
        data.shunt_name  = shunt_names(i,:);
        data.shunt_delta = delta_shunt_in_use;
        fprintf('%s: variando shunt...\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
        stepsp('QUADSHUNT', -delta_shunt_in_use/2, shunt_devs(i,:));
        pause(r.tune_wait);
        fprintf('%s: medindo sintonia...\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
        data.tunes0 = gettune;
        data.K0 = getam(shunt_names(i,:), 'Physics');
        fprintf('%s: variando shunt...\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
        stepsp('QUADSHUNT', delta_shunt_in_use, shunt_devs(i,:));
        pause(r.tune_wait);
        fprintf('%s: medindo sintonia...\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));
        data.tunes1 = gettune;
        data.K1 = getam(shunt_names(i,:), 'Physics');
        stepsp('QUADSHUNT', -delta_shunt_in_use/2, shunt_devs(i,:));
        dtunes = data.tunes1 - data.tunes0;
        delta_shunt_in_use = 1.3 * delta_shunt_in_use;
    end
    % análise
    data.position = position(i);
    data.quadrupole_family = common2family(data.shunt_name);
    data.quadrupole_device = common2dev(data.shunt_name, data.quadrupole_family);
    data.eff_length = getleff(data.quadrupole_family, data.quadrupole_device);
    data.beta = [1;-1] .* (4 * pi * dtunes / (data.eff_length * (data.K1 - data.K0)));
    r.Data(i) = data;
    fprintf('%s: betax = %f m, betay = %f m\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'), data.beta(1), data.beta(2));
    fprintf('\n');
end
r.final_machineconfig = getmachineconfig;
r.final_time_stamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
r.final_dcct = getdcct;

save(default_filename, '-struct', 'r');

fprintf('%s: FIM DE MEDIDAS DAS FUNÇÕES BETA\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'));