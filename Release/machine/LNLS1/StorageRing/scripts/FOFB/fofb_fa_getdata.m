function fa_data = fofb_fa_getdata(ip_address, filename)
%FOFB_FA_GETDATA  Gets acquisition data from FOFB controller.
%
%   fa_data = FOFB_FA_GETDATA(ip_address, filename)
%
%   ip_address: string of IP address of the FOFB controller.
%
%   filename: acquisition file name at FOFB controller, specified at the
%       moment of acquisition with fofb_fa_start. Default: 'fa_data.dat'
%
%   fa_data: struct containing aquisition data of BPMs (beam position) and
%       correctors' power supplies (magnet current).
%
%   Examples:
%       fofb_fa_start('10.0.5.31');
%       pause(1); % wait for acquisition
%       fa_data = fofb_fa_getdata('10.0.5.31');
%       figure;
%       plot(fa_data.time, fa_data.bpm_readings);
%   
%   See also  FOFB_FA_START, FOFB_FA_STOP, FOFB_FA_LOADDATA.

%   Copyright (C) 2013 CNPEM
%   Licensed under GNU LGPL v3.0 or later
%
%   Revisions:
%       2013-04     Initial realease            Daniel O. Tavares (LNLS/DIG) 

if (nargin < 2) || isempty(filename)
    filename = 'fa_data.dat';
end

ftp_username = 'admin';
ftp_password = 'boo500mev';

try
    % Establishes FTP connection with FOFB controller
    ftp_connection = ftp(ip_address, ftp_username, ftp_password);
    cd(ftp_connection, 'fofb');
    cd(ftp_connection, 'FA Data');
    
    % Retrieves file from FTP connection
    temp_dir = fileparts(mfilename('fullpath'));
    mget(ftp_connection, filename, temp_dir);
end

% Closes FTP connection
close(ftp_connection);
    
% Loads FA file
fname = fullfile(temp_dir, filename);
fa_data = fofb_fa_loaddata(fname);

% Deletes local copy of data file
delete(fname);
