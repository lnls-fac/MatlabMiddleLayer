function lnls1_bumpgen(direction, bpm1, bpm2, delta_pos, delta_angle)
%
% lnls1_bumpgen(direction, bpm1, bpm2, delta_pos, delta_angle)
%
% Função que gera bump em dois monitores a partir de uma arquivo *.orb
% gerando um novo arquivo de órbita com o bump.
%
% Input
%
% direction   : plano do bump ('H' horizontal ou 'V' vertical)
% bpm1        : nome do primeiro monitor (upstream)
% bpm2        : nome do segundo monitor (downstream)
% delta_pos   : vetor com deslocamento [mm] da órbita nos dois monitores.
% delta_angle : ângulo [rad] do bump.
%
% Exemplo:
%
% lnls1_set_server('','','');
% lnls1;
% lnls1_bumpgen('H', 'AMP01B', 'AMP02A', [0.1 0.1], 0);
%
% History
%
% 2011-02-16    script created. (Ximenes R. Resende)


global THERING;



% reads original orb file
[FileName,PathName] = uigetfile('.orb', 'Selecione o arquivo com a órbita a ser perturbada');
fname = fullfile(PathName, FileName);
if ~exist(fname, 'file'), return; end;
orb = import_orb(fname);

if strcmpi('H',direction), plane = 1; else plane = 2; end;

% gathers info about bpms
bpm1_dev = common2dev(bpm1, 'BPMx');
bpm2_dev = common2dev(bpm2, 'BPMx');
idx1     = dev2elem('BPMx', bpm1_dev);
idx2     = dev2elem('BPMx', bpm2_dev);
pos1     = getfamilydata('BPMx', 'Position', idx1);
pos2     = getfamilydata('BPMx', 'Position', idx2);
leng     = pos2 - pos1;
sign     = -1;
if (leng < 0)
    circ = findspos(THERING, length(THERING)+1);
    leng = leng + circ;
    sign = - sign;
end

orb([idx1 idx2],plane) = orb([idx1 idx2],plane) + delta_pos(:) + sign * tan(delta_angle) * leng * [-1; 1] / 2;

% saves new orbit file
APX = ['_' upper(direction) '_' bpm1 '_' bpm2 '_P' num2str(delta_pos(1), '%+06.3f') '_' num2str(delta_pos(2), '%+06.3f') '_A' num2str(delta_angle, '%+06.3f')];
[pathstr, name, ext] = fileparts(fname); 
new_fname = fullfile(pathstr, [name APX ext]);
[FileName,PathName] = uiputfile('*.orb','Escolha arquivo a ser gravado', new_fname);
new_fname = fullfile(PathName, FileName);
fid = fopen(new_fname, 'w');
for i=1:size(orb,1)
    fprintf(fid, '%+18.15f\t%+18.15f\t%s\n', orb(i,1), orb(i,2), dev2common('BPMx',  elem2dev('BPMx', i)));
end
fprintf(fid, '\n\n');
fprintf(fid, '%s\n', datestr(now));
fprintf(fid, 'Arquivo gerado automaticamente por %s\n', mfilename('fullpath'));
fprintf(fid, 'órbita original: %s\n', fname);
fprintf(fid, 'bump em %s e %s\n', bpm1, bpm2);
fprintf(fid, 'DeltaX[mm], DeltaY[mm]: %+18.15f %+18.15f\n', delta_pos);
fprintf(fid, 'Ângulo[rad]: %+18.15f\n', delta_angle);
fclose(fid);



function r = import_orb(fname)


fid = fopen(fname, 'r');
nr_bpms = length(getfamilydata('BPMx', 'ElementList'));
r = zeros(nr_bpms,2);
for i=1:nr_bpms
    line = fgetl(fid);
    pos = sscanf(line, '%f %f');
    if ~isempty(pos), r(i,:) = pos; end;
end
fclose(fid);








