function calc_dimensoes_feixe_excel

global THERING;

% inicializa MML do LNLS1
%lnls1_set_server('','','')
%lnls1;


% acha indices dos elementos
idx = findcells(THERING, 'FamName', 'RAD4G');
RAD4G_IMPAR = idx(1:2:12);
RAD4G_PAR   = idx(2:2:12);
RAD15G = findcells(THERING, 'FamName', 'RAD15G');
INSERTION = [findcells(THERING, 'FamName', 'AON11') findcells(THERING, 'FamName', 'AWI09')];

% calcula parametros de twiss
calctwiss;

% calcula medias nas saidas de luz
fprintf('\n');
fprintf('SAIDA        BETAX    ALFX     ETAX     ETAXL    BETAY    ALFY\n');
beta  = 0;
alpha = 0;
disp  = 0;
lista = INSERTION;
for i=1:length(lista)
    beta  = beta  + THERING{lista(i)}.Twiss.beta / length(lista);
    alpha = alpha + THERING{lista(i)}.Twiss.alpha / length(lista);
    disp  = disp  + THERING{lista(i)}.Twiss.Dispersion / length(lista);
end
fprintf('INSERTION   %+8.4f %+8.4f %+8.4f %+8.4f %+8.4f %+8.4f\n', beta(1), alpha(1), disp(1), disp(2), beta(2), alpha(2));
beta  = 0;
alpha = 0;
disp  = 0;
lista = RAD15G;
for i=1:length(lista)
    beta  = beta  + THERING{lista(i)}.Twiss.beta / length(lista);
    alpha = alpha + THERING{lista(i)}.Twiss.alpha / length(lista);
    disp  = disp  + THERING{lista(i)}.Twiss.Dispersion / length(lista);
end
fprintf('RAD15G      %+8.4f %+8.4f %+8.4f %+8.4f %+8.4f %+8.4f\n', beta(1), alpha(1), disp(1), disp(2), beta(2), alpha(2));
beta  = 0;
alpha = 0;
disp  = 0;
lista = RAD4G_PAR;
for i=1:length(lista)
    beta  = beta  + THERING{lista(i)}.Twiss.beta / length(lista);
    alpha = alpha + THERING{lista(i)}.Twiss.alpha / length(lista);
    disp  = disp  + THERING{lista(i)}.Twiss.Dispersion / length(lista);
end
fprintf('RAD4G_PAR   %+8.4f %+8.4f %+8.4f %+8.4f %+8.4f %+8.4f\n', beta(1), alpha(1), disp(1), disp(2), beta(2), alpha(2));
beta  = 0;
alpha = 0;
disp  = 0;
lista = RAD4G_IMPAR;
for i=1:length(lista)
    beta  = beta  + THERING{lista(i)}.Twiss.beta / length(lista);
    alpha = alpha + THERING{lista(i)}.Twiss.alpha / length(lista);
    disp  = disp  + THERING{lista(i)}.Twiss.Dispersion / length(lista);
end
fprintf('RAD4G_IMPAR %+8.4f %+8.4f %+8.4f %+8.4f %+8.4f %+8.4f\n', beta(1), alpha(1), disp(1), disp(2), beta(2), alpha(2));


    










