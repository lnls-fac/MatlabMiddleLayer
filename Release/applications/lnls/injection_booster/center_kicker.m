function param = center_kicker(machine, param, a)
    xl_inicial = param.xl_sept_init;
    injkckr = findcells(machine, 'FamName', 'InjKckr');
    injkckr_struct = machine(injkckr(1));
    injkckr_struct = injkckr_struct{1};
    L_kckr = injkckr_struct.Length;
    
    s = findspos(machine, 1:length(machine));
    
    d = s(injkckr) + L_kckr;
    
    dtheta = - a / d;
    
    param.offset_xl_sist = param.offset_xl_sist + dtheta;
    
%     fprintf('=================================================\n');    
%     erro = abs(xl_inicial - param.offset_xl_sist); 
%     fprintf('SEPTUM ANGLE ADJUSTED TO %f mrad, THE ERROR WAS %f mrad \n', param.offset_xl_sist*1e3, erro*1e3);
%     agr = (1-abs(erro - param.xl_error_sist)/param.xl_error_sist)*100;
%     fprintf('THE GENERATED ERROR WAS %f mrad, EFF %f %% \n', param.xl_error_sist*1e3, agr);
%     fprintf('=================================================\n');
end

