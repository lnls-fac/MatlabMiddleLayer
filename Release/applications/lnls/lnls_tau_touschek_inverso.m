function Resp = lnls_tau_touschek_inverso(params,Accep,optics)


%   Resp =lnls_tau_touschek_inverso(params,Accep,optics) 
%      calcula o inverso do tempo de vida Touschek.
%
%   Saídas:
%       Resp = estrutura com campos:
%           Rate = taxa de perda de elétrons ao longo do anel [1/s]
%           AveRate = Taxa média de perda de elétrons [1/s]
%           Pos  = Posição do anel onde foi calculada a taxa [m]
%           Volume = Volume do feixe ao longo do anel [m^3]
%        
%   Entradas:
%       params = estrutura com campos:
%           emit0 = emitância natural [m rad]
%           E     = energia das partículas [eV] 
%           N     = número de elétrons por bunch
%           sigE  = dispersão de energia relativa sigE, 
%           sigS  = comprimento do bunch [m]
%           K     = fator de acoplamento (emity = K*emitx)
%
%       Accep = estrutura com campos:
%           pos = aceitância positiva para uma seleção de pontos do anel;
%           neg = aceitância negativa para uma seleção de pontos do anel;
%                    (lembrar: min(accep_din, accep_rf))
%           s   = posição longitudinal dos pontos para os quais a
%                    aceitância foi calculada.
%
%       Optics = estrutura com as funções óticas ao longo do trecho 
%               para o qual setá calculado o tempo de vida:
%                    pos,   betax,    betay,  etax,   etay,
%                           alphax,   alphay, etaxl,  etayl
%
%   CUIDADO: os limites de cálculo são definidos pelos pontos
%      inicial e final da Aceitância e não das funções ópticas.

c = 299792458;
me = 9.10938291e-31;
Qe = 1.602176565e-19;
mu0 = 4*pi*1e-7;
ep0 = 1/c^2/mu0;
r0 = Qe^2/(4*pi*ep0*me*c^2);

gamma = params.E/510.998928e3;
N     = params.N;

% Tabela para interpolar d_touschek
dinttable = getappdata(0, 'TouschekDIntegralTable');
if isempty(dinttable)
    load('lnls_tabela_d_touschek.mat');
    dinttable.x_tabela = x_tabela;
    dinttable.y_tabela = y_tabela;
    setappdata(0, 'TouschekDIntegralTable', dinttable);
else
    x_tabela = dinttable.x_tabela;
    y_tabela = dinttable.y_tabela;
end


% calcular o tempo de vida a cada 10 cm do anel:
npoints = ceil((Accep.s(end) - Accep.s(1))/0.1);
s_calc = linspace(Accep.s(1), Accep.s(end), npoints);

d_accp  = interp1(Accep.s, Accep.pos, s_calc);
d_accn  = interp1(Accep.s,-Accep.neg, s_calc);
% if momentum aperture is 0, set it to 1e-4:
d_accp(~d_accp) = 1e-4;
d_accn(~d_accn) = 1e-4;

[~, ind, ~] = unique(optics.pos);

betax  = interp1(optics.pos(ind), optics.betax(ind), s_calc);
alphax = interp1(optics.pos(ind), optics.alphax(ind), s_calc);
etax   = interp1(optics.pos(ind), optics.etax(ind), s_calc);     
etaxl  = interp1(optics.pos(ind), optics.etaxl(ind), s_calc);
betay  = interp1(optics.pos(ind), optics.betay(ind), s_calc);
etay   = interp1(optics.pos(ind), optics.etay(ind), s_calc); 

K    = params.K;        emit0 = params.emit0; 
sigS = params.sigS;     sigE  = params.sigE;

% Volume do bunch
V = sigS * sqrt(betay*(K/(1+K))*emit0 + etay.^2*sigE^2) ...
        .* sqrt(betax*(1/(1+K))*emit0 + etax.^2*sigE^2);


% Tamanho betatron horizontal do bunch
Sx2 = 1/(1+K) * emit0 * betax;

fator = betax.*etaxl + alphax.*etax;
A1 = 1/(4*sigE^2) + (etax.^2 + fator.^2)./(4*Sx2);
B1 = betax.*fator./(2*Sx2);
C1 = betax.^2./(4*Sx2) - B1.^2./(4*A1);

% Limite de integração inferior
ksip = (2*sqrt(C1)/gamma .* d_accp).^2;
ksin = (2*sqrt(C1)/gamma .* d_accn).^2;

% Interpola d_touschek
Dp = interp1(x_tabela,y_tabela,ksip,'linear',0.0);
Dn = interp1(x_tabela,y_tabela,ksin,'linear',0.0);

% Tempo de vida touschek inverso
Ratep = (r0^2*c/8/pi)*N/gamma^2 ./ d_accp.^3 .* Dp ./ V;
Raten = (r0^2*c/8/pi)*N/gamma^2 ./ d_accn.^3 .* Dn ./ V;
Resp.Rate = (Ratep + Raten) / 2;

% Tempo de vida touschek inverso m�dio
Resp.AveRate = trapz(s_calc, Resp.Rate) / ( s_calc(end) - s_calc(1) );
Resp.Volume = V;
Resp.Pos = s_calc;

