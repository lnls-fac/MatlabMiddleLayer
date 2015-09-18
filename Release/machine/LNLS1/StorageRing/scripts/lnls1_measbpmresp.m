function lnls1_measbpmresp(varargin)
%Faz medida de matriz resposta do anel.
%
%Hist�ria:
%
%2010-09-13: coment�rios iniciais no c�digo.

nr_points = 5;
reading_interval = 0.5;

if ~strcmpi(getmode('BEND'), 'Online'), switch2online; end
if strcmpi(getmode('BEND'), 'Online')
    lnls1_slow_orbcorr_off;
    lnls1_fast_orbcorr_off;
end
setbpmaverages(reading_interval,nr_points);


% calcula varia��o de excita��o das corretoras para gerar kicks de 0.1 mrad

DeltaHCM = 0.0001 / 1.5; % rad  % dividido por fator de forma a gerar COD que n�o acionam intertravamento de �rbita do AWG09...
DeltaVCM = 0.0001 / 1.5; % rad

DeltaHCM = 0.0001 / 1.5 / 2; % rad  % dividido por fator de forma a gerar COD que n�o acionam intertravamento de �rbita do AWG09...
DeltaVCM = 0.0001 / 1.5 / 2; % rad

HCMValuesHW = getsp('HCM');
HCMValuesPH = hw2physics('HCM', 'Setpoint', HCMValuesHW, family2dev('HCM'), getenergy);
HCMValuesHWDelta = physics2hw('HCM', 'Setpoint', HCMValuesPH + DeltaHCM, family2dev('HCM'), getenergy);
HCMDelta = abs(HCMValuesHWDelta - HCMValuesHW);

VCMValuesHW = getsp('VCM');
VCMValuesPH = hw2physics('VCM', 'Setpoint', VCMValuesHW, family2dev('VCM'), getenergy);
VCMValuesHWDelta = physics2hw('VCM', 'Setpoint', VCMValuesPH + DeltaVCM, family2dev('VCM'), getenergy);
VCMDelta = abs(VCMValuesHWDelta - VCMValuesHW);

setfamilydata(HCMDelta, 'HCM', 'Setpoint', 'DeltaRespMat');
setfamilydata(VCMDelta, 'VCM', 'Setpoint', 'DeltaRespMat');


disp([get_date_str ': in�cio da medida de matriz resposta']);

if isempty(varargin),
    measbpmresp;
else
    measbpmresp(varargin{:});
end

disp([get_date_str ': fim da medida de matriz resposta']);
