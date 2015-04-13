function sirius_booster(versao, varargin)
% Inicializa as estruturas do MML-LNLS e conecta com servidor LNLS1LinkS
%
% Historico
% 
% 2011-06-02: copia modificada da versao do LNLS1
% 2011-04-28: nova versao. script transformado em funcao.
% 2010-09-16: comentarios iniciais no codigo

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

mml_path = fullfile(lnls_get_root_folder(), 'code', 'MatlabMiddleLayer','Release');
cd(fullfile(mml_path,'mml'));

if ~exist('versao', 'var')
    versao = 'V810';
end
setpathlnls(['BOOSTER_' versao],'StorageRing', 'sirius_link');
cd(cdir);
clear cdir;


addpath(genpath(fullfile(mml_path, 'lnls','fac_scripts','sirius','lattice_errors')));
addpath(fullfile(mml_path, 'lnls', 'fac_scripts', 'tracy3'), '-begin');
addpath(fullfile(mml_path, 'lnls', 'fac_scripts', 'trackcpp'), '-begin');
addpath(genpath(fullfile(mml_path, 'machine','LTLB_V200')));
addpath(genpath(fullfile(mml_path, 'machine', 'LTBA_V200')));

return;
