function [data, r] = fofb_acquire_data(nr_samples,data_source)
% r = fofb_acquire_data(nr_samples,data_source)
%
% Script de comunicação com servidor FOFB para aquisição de dados de órbita
%
% Input
%
% nr_samples: número de amostras a serem adquiridas (taxa de aquisição de 3 kHz).
% data_source: 'both' (default): adquire dados de BPMs e fontes de corretora
%              'bpm': adquire apenas dados de BPMs
%              'ps': adquire apenas dados de fontes de corretora
% Histórico
%
% 2011-05-24: versão inicial
% 2011-09-22: versão Beta
import java.net.Socket;
import java.io.*;

% processes input parameters
r.acquisition_config.period     = 333; % us
r.acquisition_config.nr_samples = nr_samples;

% default FOFB server parameters
r.fofb_server.ip_address   = '10.0.5.31';
r.fofb_server.ip_port      = '3600';
r.fofb_server.ftp.username = 'admin';
r.fofb_server.ftp.password = 'boo500mev';
r.fofb_server.ftp.data_dir = {'fofb'};

% default value for data_source parameter
if nargin < 2
    data_source = 'both';
end

if (strcmpi('bpm',data_source)==1) || (strcmpi('ps',data_source)==1) ||...
         (strcmpi('both',data_source))  

% builds acquition command string
msg = [',ACQUISITION_PERIOD,', ...
       num2str(r.acquisition_config.period), ',' ...
       ',N_SAMPLES,', ...
       num2str(r.acquisition_config.nr_samples), ',READING,' ...
       data_source,','];

% establishes socket connection with FOFB server
skt = java.net.Socket(r.fofb_server.ip_address, str2double(r.fofb_server.ip_port));
r.fofb_server.socket.connection = skt;
r.fofb_server.socket.link.in = BufferedReader(InputStreamReader(skt.getInputStream()));
r.fofb_server.socket.link.out = PrintWriter(skt.getOutputStream(), true);
    
% sends acquisition command to FOFB server
r.fofb_server.socket.msg_out = msg;
r.fofb_server.socket.link.out.println(msg);
r.fofb_server.socket.link.out.flush();

% waits for repply
r.fofb_server.socket.nr_trials = 1;
while (r.fofb_server.socket.link.in.ready() == 0) 
    r.fofb_server.socket.nr_trials = r.fofb_server.socket.nr_trials + 1;
end;

% gets message from server
r.fofb_server.socket.link.msg_in = char(r.fofb_server.socket.link.in.readLine());

% processes server response
comma_pos = strfind(r.fofb_server.socket.link.msg_in, ',');
for i=1:length(comma_pos)-1
    fields{i} = r.fofb_server.socket.link.msg_in(comma_pos(i)+1:comma_pos(i+1)-1);
end

% takes action accordingly
if strcmpi(fields{2}, 'ERROR')

    error(['FOFB acquisition error: ' fields{3}]);
    % HALTS!
    
elseif strcmpi(fields{2}, 'FILE_NAME')
    
    r.fofb_server.ftp.file_name = fields{3};

    try
        % establishes FTP connection with FOFB server
        r.fofb_server.ftp.connection = ftp(r.fofb_server.ip_address, r.fofb_server.ftp.username, r.fofb_server.ftp.password);
        for i=1:length(r.fofb_server.ftp.data_dir) % goes to remote data directory
            cd(r.fofb_server.ftp.connection, r.fofb_server.ftp.data_dir{i});
        end

        % retrieves file from FOFB server
        r.fofb_server.ftp.local_data_dir = fileparts(mfilename('fullpath'));
        mget(r.fofb_server.ftp.connection, r.fofb_server.ftp.file_name, r.fofb_server.ftp.local_data_dir);
    end
    % closes ftp connection
    close(r.fofb_server.ftp.connection);
    
    % loads data from file
    fname = fullfile(r.fofb_server.ftp.local_data_dir, r.fofb_server.ftp.file_name);
    data = fofb_load_fadata(fname);
    
    % sends delete command to FOFB server
    msg = [',DELETE_FILE,', ...
        r.fofb_server.ftp.file_name, ',' ...
       ]; % builds command string to delete original file at the FOFB server
    r.fofb_server.socket.link.out.println(msg);
    r.fofb_server.socket.link.out.flush();
    
    % deletes local copy of data file.
    delete(fname);
end

% closes socket connection
 r.fofb_server.socket.connection.close();
else
    error('The input parameter "data_source" is invalid. This parameter must be:''BPM'',''PS'' or ''BOTH''.');
end