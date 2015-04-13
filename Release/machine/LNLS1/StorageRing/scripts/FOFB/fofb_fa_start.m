function fofb_fa_start(ip_address, nsamples, bpm_selected, ps_selected, filename)
% fofb_fa_start(ip_address, nsamples, bpm_selected, ps_selected, filename)

if (nargin < 2) || isempty(nsamples)
    nsamples = 1000;
end

if (nargin < 3) || isempty(selected)
    bpm_selected = 'all';
end

if (nargin < 4) || isempty(ps_selected)
    ps_selected = 'all';
end

if (nargin < 5) || isempty(filename)
    filename = 'fa_data.dat';
end

import java.net.Socket;
import java.io.*;

% Default TCP port
tcp_port = '3600';

% Builds acquition command string
msg = [',FA_START', ...
       ',N_SAMPLES,', sprintf('%d', nsamples), ...
       ',BPM_SELECTED,', bpm_selected, ...
       ',PS_SELECTED,', ps_selected, ...
       ',FILENAME,', filename, ...
       ','];

% Establishes socket connection with FOFB controller
skt = java.net.Socket(ip_address, str2double(tcp_port));
socket.connection = skt;
socket.link.in = BufferedReader(InputStreamReader(skt.getInputStream()));
socket.link.out = PrintWriter(skt.getOutputStream(), true);
    
% Sends acquisition command to FOFB controller
socket.msg_out = msg;
socket.link.out.println(msg);
socket.link.out.flush();

% Waits for reply
socket.nr_trials = 1;
while (socket.link.in.ready() == 0) 
    socket.nr_trials = socket.nr_trials + 1;
end;

% Gets reply message
socket.link.msg_in = char(socket.link.in.readLine());

% Processes server response. Splits strings at commas
comma_pos = strfind(socket.link.msg_in, ',');
for i=1:length(comma_pos)-1;
    fields{i} = socket.link.msg_in(comma_pos(i)+1:comma_pos(i+1)-1);
end

% Error check
if strcmpi(fields{2}, 'ERROR')
    error(['FOFB acquisition error: ' fields{3}]);
elseif strcmpi(fields{2}, 'FILE_NAME')
    fprintf('Data acquisition has been started successfully.\n');
end

% Closes socket connection
socket.connection.close();
