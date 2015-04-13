function IDS = lnls1_get_id_gaps(init_IDS)
%Lê gaps dos dispositivos de inserção do anel.
%
%History: 
%
%2010-09-13: comentários iniciais no código.

IDS = init_IDS;

mm = 1e-3;
default_tolerance = 1 * mm;

% le valores de gap dos dispositivos
for i=1:length(IDS)
    if ~isfield(IDS{i}, 'tolerance'), ID{i}.tolerance = default_tolerance; end
    IDS{i}.gap = getpv([IDS{i}.channel_name '_AM']);
end
