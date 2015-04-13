function fofb_fa_stop(ip_address)
% fofb_fa_stop(ip_address)

import java.net.Socket;
import java.io.*;

% Default TCP port
tcp_port = '3600';

% Builds stop command string
msg = ',FA_STOP,';

% Establishes socket connection with FOFB controller
skt = java.net.Socket(ip_address, str2double(tcp_port));
socket.connection = skt;
socket.link.in = BufferedReader(InputStreamReader(skt.getInputStream()));
socket.link.out = PrintWriter(skt.getOutputStream(), true);

% Sends stop command to FOFB controller
socket.msg_out = msg;
socket.link.out.println(msg);
socket.link.out.flush();

% Waits for repply
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
elseif strcmpi(fields{2}, 'STOPPED')
    fprintf('Data acquisition has been stopped successfully.\n');
end

% Closes socket connection
socket.connection.close();