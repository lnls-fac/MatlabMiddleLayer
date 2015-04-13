function kickmap_save_plots

% grava figuras
hds = get(0, 'Children');
for i=1:length(hds);
    name = get(hds(i), 'Name');
    if isempty(name), name = ['Fig ' num2str(hds(i))]; end;
    saveas(hds(i), [name '.fig']);
end