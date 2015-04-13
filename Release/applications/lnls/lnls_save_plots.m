function lnls_save_plots

% apaga figuras antigas
delete('*.fig');

% grava figuras
hds = get(0, 'Children');
for i=1:length(hds);
    name = get(hds(i), 'Name');
    name = ['fig' num2str(i, '%02i') ' ' name];
    %if isempty(name), name = ['Fig ' num2str(hds(i))]; end;
    saveas(hds(i), [name '.fig']);
end