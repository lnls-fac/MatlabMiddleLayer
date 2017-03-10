function lnls1(varargin)
% Inicializa as estruturas do MML-LNLS e conecta com servidor LNLS1LinkS
%
% Historia
%
% 2011-04-28: nova versao. script transformado em funcaoo.
% 2010-09-16: comenterios iniciais no codigo

default_SERVER_TYPE = '';
default_IP_ADDRESS  = '';
defualt_IP_PORT     = '';

SelectServer = false;
NoServer = false;
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
root_folder = lnls_get_root_folder();
cd(fullfile(root_folder, 'MatlabMiddleLayer','Release','mml'))

% remove toolbox/finance/finsupport/ do path para previnir conflito com
% funcao drift da Financial Toolbox
fname = fullfile(matlabroot, 'toolbox', 'finance', 'finsupport');
if exist(fname, 'file')
    warning('off','MATLAB:rmpath:DirNotFound')
    rmpath(fname);
    warning('on','MATLAB:rmpath:DirNotFound')
end

setpathlnls('LNLS1', 'StorageRing', 'lnls1_link');
cd(cdir);
clear cdir;

% configura par�metros de conex�o
PVServer = getappdata(0, 'PVServer');
if SelectServer
    lnls1_comm_disconnect;
    PVServer = [];
end;
if NoServer
    lnls1_comm_disconnect;
    PVServer.server.ip_address = '';
end


if ~isempty(PVServer)
    setappdata(0, 'PVServer', PVServer);
else
    try
        rmappdata(0, 'PVServer');
    catch
    end
end

% conecta com servidor do anel
lnls1_comm_connect_inputdlg;
