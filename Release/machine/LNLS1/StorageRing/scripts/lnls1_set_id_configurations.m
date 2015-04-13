function r = lnls1_set_id_configurations(IDS)
%Ajusta configurações dos dispositivos de inserção do anel.
%
%Exemplo:
%           IDS(1).channel_name = 'AON11GAP';
%           IDS(1).value        = 300;
%           IDS(1).tolerance    = 0.5;
%           IDS(2).channel_name = 'AON11FASE';
%           IDS(2).value        = 25;
%           IDS(2).tolerance    = 0.2;
%           IDS(3).channel_name = 'AWG01GAP';
%           IDS(3).value        = 180;
%           IDS(3).tolerance    = 0.2;
%           lnls1_set_id_configuration(IDS);
%
%History: 
%
%2010-10-14: generalizada a função.
%2010-09-13: comentários iniciais no código.

pause_time = 1.0;
nr         = length(IDS);

if strcmpi(getmode('BEND'), 'Simulator')
    r = [];
    return;
end

if iscell(IDS)
    for i=1:length(IDS)
        r(i).channel_name = IDS{i};
        r(i).value = getpv([r(i).channel_name '_AM']);
        r(i).tolerance = 0.5;
    end
    return;
end

% loop que espera todos os IDs chegaram a config final
any_not_ready = true;
keep_sending = true;
while any_not_ready
    if keep_sending
        for i=1:nr
            setpv([IDS(i).channel_name '_SP'], IDS(i).value);
        end
        keep_sending = false;
    end
    pause(pause_time);
    drawnow;
    any_not_ready = false;
    for i=1:nr
        param = getpv([IDS(i).channel_name '_AM']);
        any_not_ready = any_not_ready || (abs(param - IDS(i).value) > IDS(i).tolerance);
        if any_not_ready; break; end;
    end
end



