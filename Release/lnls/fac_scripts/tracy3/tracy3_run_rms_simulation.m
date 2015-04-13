function tracy3_run_rms_simulation

tracy_input_file    = 'input.prm';
tracy_chamber_file  = 'Chamber_Sirius_v200.dat';
lattice_errors_file = 'lattice_errors_input.m';


% escolhe dir com dados
folder_name = uigetdir('','Choose directory with tracy data');
if isnumeric(folder_name)
    return
else
    cd(folder_name)
end

% edita 'input.prm'
answer = questdlg('Edit Tracy Input File?');
if strcmpi(answer, 'Yes')
    system(['gedit ' tracy_input_file]);
elseif strcmpi(answer, 'Cancel')
    return
end

% edita 'Chamber_chamber.dat'
answer = questdlg('Edit Tracy Chamber File?');
if strcmpi(answer, 'Yes')
    system(['gedit ' tracy_chamber_file]);
elseif strcmpi(answer, 'Cancel')
    return
end

% edita 'lattice_errors_input.m'
answer = questdlg('Edit Lattice-Errors Input File?');
if strcmpi(answer, 'Yes')
    system(['gedit ' lattice_errors_file]);
elseif strcmpi(answer, 'Cancel')
    return
end

% gera máquina com erros
r = lattice_errors;

nr_machines = length(r.machine);
if (nr_machines ~= 10) && (nr_machines ~= 50)
    error('invalid nr_machines in config file');
end
nr_machines_str = num2str(nr_machines);

% começando do zero
rmdir('rms*', 's');
[status result] = system(['correct_input_tracy ' nr_machines_str]);

% gera e copia flat files para dentro das pastas rms...
tracy3_read_machines_generate_flat_file;

return;

% rodar GERENCIADOR de PROCESSOS
cd('~/rodar_tracy');

% editar arquivos 'comandos' e 'maquina'
%
% 'comandos':
% # Caminho absoluto até a pasta com os arquivos de input do tracy.
% # CUIDADO, esse arquivo não pode ter espaços após o fim da definição do caminho da pasta, mas linhas em branco
% # ou comentadas, começando com #, são permitidas.


% disparar calculo
system(['gerenciador_disparos > output_' datestr(now, 'yyyy-mm-dd-HH-MM') ' 2>&1 &'])







