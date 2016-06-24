function sirius(varargin)
% Inicializa as estruturas do MML-LNLS e conecta com servidor LNLS1LinkS
%
% Historico
%
% 2014-10-31: mais posibilidades de especificar submachines.
% 2011-06-02: copia modificada da versao do LNLS1
% 2011-04-28: nova versao. script transformado em funcao.
% 2010-09-16: comentarios iniciais no codigo

Disconnect = false;

default_tb_version = 'TB.V01' ;
default_bo_version = 'BO.V02.03';
default_ts_version = 'TS.V02' ;
default_si_version = 'SI.V18.01' ;
default_link       = 'NONE';

default_version = default_si_version;
for i=length(varargin):-1:1
    if ischar(varargin{i})
        if any(strcmpi(varargin{i}, {'SelectServer'})), SelectServer = true; end;
        if any(strcmpi(varargin{i}, {'NoServer'})), NoServer = true; end;
        if any(strcmpi(varargin{i}, {'Disconnect'})), Disconnect = true; end; 
        varargin{i} = upper(varargin{i});
        if isempty(strfind(varargin{i}, 'V'))
            if strfind(varargin{i}, 'BO')
                default_version = default_bo_version;
            elseif strfind(varargin{i}, 'TB')
                default_version = default_tb_version;
            elseif strfind(varargin{i}, 'TS')
                default_version = default_ts_version;
            elseif strfind(varargin{i}, 'SI')
                default_version = default_si_version;
            elseif strcmpi(varargin{i}, 'LABCA')
                default_link = 'LABCA';
            end
        else
            default_version = varargin{i};
        end
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
root_folder = lnls_get_root_folder();
cd(fullfile(root_folder, 'code', 'MatlabMiddleLayer','Release','mml'))

% remove toolbox/finance/finsupport/ do path para previnir conflito com
% funcao drift da Financial Toolbox (se pasta est?? no caminho, para evitar warningMessage)
fins = fullfile(matlabroot, 'toolbox', 'finance', 'finsupport');
if ~isempty(strfind(path, fins))
    rmpath(fins);
end
mmlpaths = textscan(path(), '%s', 'delimiter', pathsep); mmlpaths = mmlpaths{1};
for i=1:length(mmlpaths)
    if ~isempty(strfind(mmlpaths{i},'MatlabMiddleLayer')) && isempty(strfind(mmlpaths{i}, 'startup_scripts'))
        rmpath(mmlpaths{i})
    end
end

% Ximenes 2015-09-09
if strcmpi(default_link, 'LABCA')
    % Luana 2015-08-25
    setpathsirius('SIRIUS', default_version, 'LABCA');
    lcaSetTimeout(.01);
else
    setpathsirius('SIRIUS', default_version, 'NONE');
end

cd(cdir);
clear cdir;

addpath(genpath(fullfile(root_folder, 'code', 'MatlabMiddleLayer','Release','applications','lnls','lattice_errors')),'-begin');
addpath(fullfile(root_folder, 'code', 'MatlabMiddleLayer','Release','lnls','fac_scripts','trackcpp'), '-begin');
