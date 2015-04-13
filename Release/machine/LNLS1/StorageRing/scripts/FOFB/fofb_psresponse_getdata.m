function r = fofb_psresponse_getdata(ip_address)
% r = fofb_psresponse_getdata(ip_address)

if nargin < 2
    normalized = 1;
end

ftp_username = 'admin';
ftp_password = 'boo500mev';

try
    % Establishes FTP connection with FOFB controller
    ftp_connection = ftp(ip_address, ftp_username, ftp_password);
    cd(ftp_connection, 'fofb');
    cd(ftp_connection, 'Power Supplies');
    
    % Retrieves files from FTP connection
    temp_dir = fileparts(mfilename('fullpath'));
    dir_info = dir(ftp_connection, '*.dat');
    filenames = {dir_info.name};
    mget(ftp_connection, '*.dat', temp_dir);
end

% Closes FTP connection
close(ftp_connection);

% Load FA files
r = fofb_psresponse_loaddata(temp_dir);

% Deletes local copy of data files
for i=1:length(dir_info)       
    delete(filenames{i});
end