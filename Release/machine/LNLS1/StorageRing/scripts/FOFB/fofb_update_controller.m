function fofb_update_controller(ip_address)
% fofb_update_controller(ip_address)

import java.net.Socket;
import java.io.*;

% Default TCP port
tcp_port = '3600';

% Builds acquition command string
msg = ',UPDATE_CONTROLLER,';

% Establishes socket connection with FOFB controller
skt = java.net.Socket(ip_address, str2double(tcp_port));
socket.connection = skt;
socket.link.in = BufferedReader(InputStreamReader(skt.getInputStream()));
socket.link.out = PrintWriter(skt.getOutputStream(), true);
    
% Sends command to update FOFB controller
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
    error(['FOFB controller error: ' fields{3}]);
elseif strcmpi(fields{2}, 'CONTROLLER_UPDATED')
    fprintf('FOFB controller has been updated successfully.\n');
end

% Closes socket connection
socket.connection.close();