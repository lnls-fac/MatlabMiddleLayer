function plotfamilystartup(handles)
% plotfamilystartup(handles)


Menu0 = handles.('LatticeConfiguration');

%MenuAdd = uimenu(Menu0, 'Label','Add an Injection Bump - bumpinj');
%set(MenuAdd,'Callback', 'bumpinj');
%set(MenuAdd, 'Separator','Off');

Menu0 = handles.figure1;
Menu0 = uimenu(Menu0, 'Label', 'LNLS1');
set(Menu0, 'Separator', 'On');
 
Menu1 = uimenu(Menu0, 'Label', 'Medir Matriz Resposta de Órbita');
set(Menu1,'Callback', 'lnls1_measbpmresp');
Menu1 = uimenu(Menu0, 'Label', 'Medir Offsets de BPMs');
set(Menu1,'Callback', 'lnls1_bba');
Menu1 = uimenu(Menu0, 'Label', 'Monitoramento de Fontes');
set(Menu1,'Callback', 'lnls1_monmags');
Menu1 = uimenu(Menu0, 'Label', 'Medir Função Dispersão');
set(Menu1,'Callback', 'lnls1_measdisp');
Menu1 = uimenu(Menu0, 'Label', 'Medir Matriz Resposta de Sintonia');
set(Menu1,'Callback', 'lnls1_meastuneresp');
Menu1 = uimenu(Menu0, 'Label', 'Monitoramento de Órbita');
set(Menu1,'Callback', 'lnls1_monbpm');





% Add a sector menu
% Using a [Arc Straight] nomenclature
Sectors = 6;
L = getfamilydata('Circumference');
if ~isempty(L)
    Menu0 = handles.figure1;
    Menu0 = uimenu(Menu0, 'Label', 'Sector');
    set(Menu0, 'Position', 3);
    set(Menu0, 'Separator', 'On');

    Menu1 = uimenu(Menu0, 'Label',sprintf('Anel'));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0 L]),'],guidata(gcbo))']);
    
    % Arc sector
    Extra = 0*4;
    i = 1;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Arco Cromático TR%02i',2*i));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0 Extra+L/Sectors]+(i-1)*L/Sectors),'],guidata(gcbo))']);
    for i = 2:Sectors-1
        Menu1 = uimenu(Menu0, 'Label',sprintf('Arco Cromático TR%02i',2*i));
        set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0-Extra Extra+L/Sectors]+(i-1)*L/Sectors),'],guidata(gcbo))']);
    end
    i = Sectors;
    Menu1 = uimenu(Menu0, 'Label',sprintf('Arco Cromático TR%02i',2*i));
    set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[L-L/Sectors-Extra L]),'],guidata(gcbo))']);

    % Straight section
    Extra = 8;
    %i = 1;
    %Menu1 = uimenu(Menu0, 'Label',sprintf('Trecho Reto TR%02i',2*i-1));
    %set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[0 L/Sectors]),'],guidata(gcbo))']);
    for i = 2:Sectors
        Menu1 = uimenu(Menu0, 'Label',sprintf('Trecho Reto TR%02i',2*i-1));
        set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[-Extra Extra]+(i-1)*L/Sectors),'],guidata(gcbo))']);
    end
    
    
end


drawnow;
