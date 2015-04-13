function r = fofb_load_fadata(filename)
% r = fofb_load_fadata(filename)
%
% Lê arquivo binário contendo dados de órbita adquiridos com o sistema FOFB
%
% Input
%
% filename:     nome do arquivo.
%
% Histórico
%
% 2011-05-27: versão Beta

try
    file_id = fopen(filename);
    period = fread(file_id,1,'uint32','l');
    header_bpm = strread(fgetl(file_id), '%s', 'delimiter', '\t');
    length_bpm = length(header_bpm);
    header_ps = strread(fgetl(file_id), '%s', 'delimiter', '\t');
    length_ps = length(header_ps);
    data = fread(file_id,'double','l');
    length_data = length(data);
    time = (0:period*0.001:period*0.001*((length_data/(length_ps+length_bpm))-1))';
    
catch err
    fclose(file_id);
    retrhow(err);
end

fclose(file_id);

data = reshape(data,(length_ps+length_bpm),length(data)/(length_ps+length_bpm))';

r = struct('time',time,'orb',data(:,1:length_bpm),'bpm_names',{header_bpm(1:end)},'ps',data(:,length_bpm+1:length_bpm+length_ps/2),'ps_setpoint',data(:,1+length_bpm+length_ps/2:length_bpm+length_ps),...
    'ps_names',{header_ps(1:length_ps/2)},'ps_setpoint_names',{header_ps(1+length_ps/2:length_ps)});