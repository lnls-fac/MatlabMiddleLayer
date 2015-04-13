function sirius_ltlb(varargin)
%
% Historico
% 
% 2013-12-02: inicio

Disconnect = false;

default_version_sr   = '_V500';
default_version_ltlb = '_V200';

for i=length(varargin):-1:1
    if ischar(varargin{i})
        if any(strcmpi(varargin{i}, {'SelectServer'})), SelectServer = true; end;
        if any(strcmpi(varargin{i}, {'NoServer'})), NoServer = true; end;
        if any(strcmpi(varargin{i}, {'Disconnect'})), Disconnect = true; end;
        if ~isempty(strfind(varargin{i}, '_V')), default_version = varargin{i}; end;
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

setpathsirius(['SIRIUS' default_version_sr], ['LTLB' default_version_ltlb], 'sirius_link');
cd(cdir);
clear cdir;


