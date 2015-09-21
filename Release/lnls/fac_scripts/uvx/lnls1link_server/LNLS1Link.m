function LNLS1Link
% Emulador MATLAB do dervidor LNLS1LinkS
%
% Esta fun��o emula o servidor LNLS1LinkS dando acesso a seus clientes
% conectados via TCP/IP sockets �s leituras e ajustes da m�quina, que � um
% modelo AT/MML (simulator).
%
% Hist�rico
% 
% 2011-04-06: modificada rotina que retorna Fam�lia a partir do ChannelName
% 2010-09-16: coment�rios iniciais no c�digo (Ximenes R. Resende)

import java.io.*;
import java.net.*;

default_IP_port = '53131';

% loads MML structure
%PVServer.server.type = '';
%PVServer.server.ip_address = '';
%PVServer.server.ip_port    = '53131';
%setappdata(0, 'PVServer', PVServer);
%evalin('base', 'lnls1');
%rmappdata(0, 'PVServer');
% inicializa estruturas do MML
cdir = pwd;

pos = strfind(computer, 'PCWIN'); % check whether we are in Windows
if isempty(pos)
    cd('/home/fac_files/code/MatlabMiddleLayer/Release/mml/');
else
    try
        cd('C:\Arq\MatlabMiddleLayer\Release\mml\');
    catch
        cd('C:\Arq\fac_files\code\MatlabMiddleLayer\Release\mml');
    end
end

setpathlnls('LNLS1', 'StorageRing', 'lnls1_link');
cd(cdir);
clear cdir;

% LOOPS SERVER
while true
    
    % listens for clients
    server = getappdata(0, 'LNLS1LinkServerSocket');
    if ~isempty(server),  server.close(); end;
    server = ServerSocket(str2num(default_IP_port),10);
    setappdata(0, 'LNLS1LinkServerSocket', server);
            
    fprintf('%s: waiting for connection requests...\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS')); 
    server.setSoTimeout(200);
    listen_again = true;
    while listen_again;
        try
            client       = server.accept();
            listen_again = false;
        catch
            pause(0);
            drawnow;
        end
    end
    server.setSoTimeout(0);
         
    % client has connected
    fprintf('%s: client %s connected.\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'), char(client.getInetAddress().getHostName()));
    in = BufferedReader(InputStreamReader(client.getInputStream()));
    out = PrintWriter(client.getOutputStream(), true);
    
    % communication loop
    disconnect_request = false;
    while ~disconnect_request
        
        client_message = char(in.readLine());
        
        if isempty(client_message)
            fprintf('%s: client %s disconnected.\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'), char(client.getInetAddress().getHostName()));
            disconnect_request = true;
        else
            fprintf('%s: %s\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'), client_message);
            server_message = LNLS1LinkProcessMessage(client_message);
            out.println(server_message);
        end
    end
    
    % client disconnect
    if exist('in'), in.close(); end
    if exist('out'), out.close(); end
    if exist('client'), client.close(); end
    if exist('client'), server.close(); end
    
end


function server_message = LNLS1LinkProcessMessage(client_message)

comma_pos = findstr(client_message, ',');
for i=1:length(comma_pos)-1
    fields{i} = client_message(comma_pos(i)+1:comma_pos(i+1)-1);
end

command = fields{1};

server_message = ',';
server_message = [server_message datestr(now, 'yyyy-mm-dd_HH-MM-SS') ','];

model.orbitx = [];
model.orbity = [];
model.tunes  = [];

if strcmpi(command, 'READ')
    for i=2:length(fields)
        try
            
            ChannelName = fields{i};
            [Family, Field, DeviceList, ErrorFlag] = channel2family(ChannelName);
            if ErrorFlag ~= 0, continue; end;
            ElementList = dev2elem(Family, DeviceList);           
            
            % 2015-09-17 Luana
            AllElements = dev2elem(Family);
            List = [];
            for j=1:size(ElementList,1)
                List = [List; find(AllElements == ElementList(j))];
            end
            
            if any(strcmpi(Family, {'BPMx'}))
                if isempty(model.orbitx), model.orbitx = getx; end;
                
                % 2015 -09-17 Luana
                pv_value = model.orbitx(List);
                %pv_value = model.orbitx(ElementList);
            
            elseif any(strcmpi(Family, {'BPMy'}))
                if isempty(model.orbity), model.orbity = gety; end;
                
                % 2015 -09-17 Luana
                pv_value = model.orbity(List);
                %pv_value = model.orbity(ElementList);
                
            elseif any(strcmpi(Family, {'TUNE'}))
                if isempty(model.tunes), model.tunes = gettune; end;
                pv_value = model.tunes(ElementList);
                pv_value = lnls1_tune2freq(pv_value, 1000*getsp('RF'));
            else
                pv_value = getpv(Family, Field, DeviceList);
            end
            server_message = [server_message ChannelName ',' num2str(pv_value) ','];
        catch
            laste = lasterror;
            fprintf('%s: <!!! LNLS1LINK ERROR !!!> "%s"\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'), laste.message);
        end
    end
end

if strcmpi(command, 'WRITE')
    for i=1:(length(fields)-1)/2
        ChannelName = fields{2*i};
        pv_value    = str2double(fields{2*i+1});
        %[Family, Field, DeviceList, ErrorFlag] = channel2family(ChannelName);
        try
            [Family, Field, DeviceList, ErrorFlag] = my_channel2dev(ChannelName);
            if ~ErrorFlag
                setpv(Family, Field, pv_value, DeviceList);
            end
        catch
            laste = lasterror;
            fprintf('%s: <!!! LNLS1LINK ERROR !!!> "%s"\n', datestr(now, 'yyyy-mm-dd_HH-MM-SS'), laste.message);
        end
    end
end


function [Family, Field, DeviceList, ErrorFlag] = my_channel2dev(ChannelName)

% esta fun��o foi escrita para retornar a familia correta a partir do
% ChannelName. Mais de uma fam�lia pode ter o mesmo ChannelName (mesmo harware controlado
% por mais de uma familia). Para um dado ChannelName a familia selecionada
% � aquela em que o n�mero de elementos � menor. Por exemplo, para o
% ChannelName 'A2QF01_SP' h� duas fam�lias 'QF' e 'A2QF01'. Esta fun��o
% retorna os par�metros da 'A2QF01' que tem apenas dois elementos e n�o 6,
% como no caso do 'QF'. Este algoritmo funciona para ajustes de quadrupolos
% quando os shunts s�o levados em considera��o...

Family = {};
Field = {};
DeviceList = {};
ao = getao;
familyList = fieldnames(ao);
for i=1:length(familyList);
    tFamily = familyList{i};
    fieldList = fieldnames(ao.(tFamily));
    for j=1:length(fieldList)
        tField = fieldList{j};
        try
            tChannelName = deblank(family2channel(tFamily, tField));
        catch
            tChannelName = {};
        end
        comparision = strcmpi(ChannelName, mat2cell(tChannelName, ones(1,size(tChannelName,1)), size(tChannelName,2)));
        if find(comparision)
            Family{end+1} = tFamily;
            Field{end+1} = tField;
            tDeviceList = family2dev(tFamily, tField);
            DeviceList{end+1} = tDeviceList(comparision, :);
        end
    end
end

smallest_family = 1;
for i=1:length(Family)
    if length(family2elem(Family{i})) < length(family2elem(Family{smallest_family}))
        smallest_family = i;
    end
end
Family = Family{smallest_family};
Field  = Field{smallest_family};
DeviceList = DeviceList{smallest_family};

ErrorFlag = false;

