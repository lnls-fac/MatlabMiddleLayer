function obj = signal_analyzer_fsv_create_object(ip_number)

if ~exist('ip_number','var'), ip_number = '10.0.5.76'; end;

% Find a VISA-TCPIP object.
obj = instrfind('Type', 'visa-tcpip', 'RsrcName', ['TCPIP0::' ip_number '::inst0::INSTR'], 'Tag', '');

% Create the VISA-TCPIP object if it does not exist otherwise use the object that was found.
if isempty(obj)
    obj = visa('NI', 'TCPIP0::10.0.5.76::inst0::INSTR');
else
    fclose(obj);
    obj = obj(1);
end