function sirius_b1(varargin)
% Inicializa as estruturas do MML-LNLS e conecta com servidor LNLS1LinkS
%
% Hist�rico
% 
% 2011-06-02: c�pia modificada da vers�o do LNLS1
% 2011-04-28: nova vers�o. script transformado em fun��o.
% 2010-09-16: coment�rios iniciais no c�digo

Disconnect = false;


for i=length(varargin):-1:1
    if ischar(varargin{i})
        if any(strcmpi(varargin{i}, {'SelectServer'})), SelectServer = true; end;
        if any(strcmpi(varargin{i}, {'NoServer'})), NoServer = true; end;
        if any(strcmpi(varargin{i}, {'Disconnect'})), Disconnect = true; end;
    end
end

if Disconnect
    try
        lnls1_comm_disconnect;
        rmappdata(0, 'PVServer');
        switch2sim;
    catch
    end
    return;
end

% inicializa estruturas do MML
cdir = pwd;
try
    cd('C:\Arq\MatlabMiddleLayer\Release\mml\');
catch
    cd('/opt/MatlabMiddleLayer/Release/mml/');
end

setpathsirius('SIRIUS_B1', 'StorageRing', 'sirius_link');
cd(cdir);
clear cdir;

return;