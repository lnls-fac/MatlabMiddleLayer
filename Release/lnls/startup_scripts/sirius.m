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

default_li_version = 'LI.V01.01';
default_tb_version = 'TB.V03.01';
default_bo_version = 'BO.V05.03';
default_ts_version = 'TS.V03.04';
default_si_version = 'SI.V24.03';
default_link       = 'LABCA';

default_version = default_si_version;
for i=length(varargin):-1:1
    if ischar(varargin{i})
        if any(strcmpi(varargin{i}, {'SelectServer'})), SelectServer = true; end;
        if any(strcmpi(varargin{i}, {'NoServer'})), NoServer = true; end;
        if any(strcmpi(varargin{i}, {'Disconnect'})), Disconnect = true; end; 
        varargin{i} = upper(varargin{i});
        if isempty(strfind(varargin{i}, 'V')) && isempty(strfind(varargin{i}, 'E'))
            if strfind(varargin{i}, 'BO')
                default_version = default_bo_version;
            elseif strfind(varargin{i}, 'TB')
                default_version = default_tb_version;
            elseif strfind(varargin{i}, 'TS')
                default_version = default_ts_version;
            elseif strfind(varargin{i}, 'SI')
                default_version = default_si_version;
            elseif strfind(varargin{i}, 'LI')
                default_version = default_li_version;
            elseif strcmpi(varargin{i}, 'LABCA')
                default_link = 'LABCA';
            elseif strcmpi(varargin{i}, 'CA_MATLAB')
                default_link = 'CA_MATLAB';
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
folder = fullfile(root_folder, 'MatlabMiddleLayer','Release','mml');
if ~exist(folder, 'dir')
    folder = fullfile(root_folder, 'code', 'MatlabMiddleLayer','Release','mml');
end
cd(folder)

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
elseif strcmpi(default_link, 'CA_MATLAB')
    setpathsirius('SIRIUS', default_version, 'CA_MATLAB');
    ca_matlab_lib = fullfile(root_folder, 'MatlabMiddleLayer','Release','links','ca_matlab','ca_matlab-1.0.0.jar');
    javaaddpath(ca_matlab_lib);
    ca_matlab_config = fullfile(root_folder, 'MatlabMiddleLayer','Release','links','ca_matlab');
    javaaddpath(ca_matlab_config);
    import ch.psi.jcae.*;
    ca_properties = java.util.Properties();
    ca_context = Context(ca_properties);
    setappdata(0, 'ca_context', ca_context);
else
    setpathsirius('SIRIUS', default_version, 'NONE');
end

cd(cdir);
clear cdir;

folder = fullfile(root_folder, 'MatlabMiddleLayer','Release');
if ~exist(folder,'dir')
    folder = fullfile(root_folder, 'code', 'MatlabMiddleLayer','Release');
end
addpath(genpath(fullfile(folder,'applications','lnls','lattice_errors')),'-begin');
addpath(fullfile(folder,'lnls','fac_scripts','trackcpp'), '-begin');
