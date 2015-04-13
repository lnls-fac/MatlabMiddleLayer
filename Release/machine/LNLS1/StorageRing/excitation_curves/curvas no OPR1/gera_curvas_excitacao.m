function gera_curvas_excitacao(varargin)
% function gera_curvas_excitacao(varargin)
%
% Exemplos:
% 1. gera_curvas_excitacao
% 2. gera_curvas_excitacao('dipolo')

[filename,PathName,FilterIndex] = uigetfile('*.*');
%filename = 'dipolos.txt';
data = importdata(filename);

% K = CoeffA_I2K + CoeffB_I2K * I
% I = CoeffA_K2I + CoeffB_K2I * K

[Iv Kv] = processa_curva(data, varargin{:});
Iv0 = Iv(1:end-1);
Iv1 = Iv(2:end);
Kv0 = Kv(1:end-1);
Kv1 = Kv(2:end);
CoeffA_I2K = (Kv0.*Iv1 - Kv1.*Iv0) ./ (Iv1 - Iv0);
CoeffB_I2K = (Kv1 - Kv0) ./ (Iv1 - Iv0);
CoeffA_K2I = (Iv0.*Kv1 - Iv1.*Kv0) ./ (Kv1 - Kv0);
CoeffB_K2I = (Iv1 - Iv0) ./ (Kv1 - Kv0);

[pathstr, name, ext, versn] = fileparts(filename); 

fid = fopen([PathName name '.FRC'], 'w');
fprintf(fid, '* Curva de excitação K = K(I)\r\n');
fprintf(fid, ['* Arquivo: ' filename '\r\n']);
fprintf(fid, ['* comentários \r\n']);
fprintf(fid, ['* comentários \r\n']);
fprintf(fid, ['* Data: ' date '\r\n']);
fprintf(fid, ['* Hora: ' datestr(now, 13) '\r\n']);
fprintf(fid, '%i\r\n', length(CoeffA_I2K));
for i=1:length(CoeffA_I2K)
    fprintf(fid, '%23.16E\t%23.16E\r\n', Iv0(i), Iv1(i));
    fprintf(fid, '2\r\n');
    fprintf(fid, '%23.16E\r\n', CoeffA_I2K(i));
    fprintf(fid, '%23.16E\r\n', CoeffB_I2K(i));
end
fclose(fid);

fid = fopen([PathName name '.CRT'], 'w');
fprintf(fid, '* Curva de excitação I = I(K)\r\n');
fprintf(fid, ['* Arquivo: ' filename '\r\n']);
fprintf(fid, ['* comentários \r\n']);
fprintf(fid, ['* comentários \r\n']);
fprintf(fid, ['* Data: ' date '\r\n']);
fprintf(fid, ['* Hora: ' datestr(now, 13) '\r\n']);
fprintf(fid, '%i\r\n', length(CoeffA_K2I));
for i=1:length(CoeffA_K2I)
    fprintf(fid, '%23.16E\t%23.16E\r\n', Kv0(i), Kv1(i));
    fprintf(fid, '2\r\n');
    fprintf(fid, '%23.16E\r\n', CoeffA_K2I(i));
    fprintf(fid, '%23.16E\r\n', CoeffB_K2I(i));
end
fclose(fid);


function [Iv Kv] = processa_curva(data, varargin)
Iv = data(:,1);
Kv = data(:,2);
Tm2MeV = 5.725007600481514e+002;
strargs = [];
tmp = [varargin{:}];
for i=1:length(tmp)
    strargs = [strargs tmp{i}];
end
if ~isempty(strargs) && ~isempty(findstr(strargs, 'positivo'))
    Kv = abs(Kv); 
end
if ~isempty(strargs) && ~isempty(findstr(strargs, 'dipolo'))
    Kv = Kv * Tm2MeV; 
end
