function  fofb_test(nr_samples,reading)
% r = fofb_acquire_data(nr_samples)
%
% Script de comunicação com servidor FOFB para aquisição de dados de órbita
%
% Input
%
% period:       período de aquisição [us].
% nr_samples:   número de amostras a serem adquiridas.
% reading:      Dado de leitura. Pode ser escolhido entre BPM, Corretoras
% ou ambos.Este parâmetro deve ser configurado como BPM,PS ou BOTH.
%
% Histórico
%
% 2011-05-24: versão inicial
% 2011-05-27: versão Beta

import java.net.Socket;
import java.io.*;

% processes input parameters
r.acquisition_config.period     = 150;
r.acquisition_config.nr_samples = nr_samples;

if nargin < 2
    reading = 'BPM';
end
 if (strcmpi('BPM',reading)==1) || (strcmpi('PS',reading)==1) ||...
         (strcmpi('BOTH',reading))  
% builds acquition command string
msg = [',ACQUISITION_PERIOD,', ...
       num2str(r.acquisition_config.period), ',' ...
       ',N_SAMPLES,', ...
       num2str(r.acquisition_config.nr_samples), ',Reading,' ...
       reading,',']
   
else
    error('The input parameter "reading" is invalid. This parameter must be:''BPM'',''PS'' or ''BOTH''.');
end