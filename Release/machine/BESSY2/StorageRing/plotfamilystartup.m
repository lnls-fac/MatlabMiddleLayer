function plotfamilystartup(handles)
% plotfamilystartup(handles)


%Menu0 = handles.('LatticeConfiguration');
%MenuAdd = uimenu(Menu0, 'Label','Add a new function here!!!');
%set(MenuAdd,'Callback', 'NewFunctionName');
%set(MenuAdd, 'Separator','Off');


% Add a sector menu
N = getnumberofsectors;
L = getfamilydata('Circumference');

if ~isempty(L)
    Menu0 = handles.figure1;
    Menu0 = uimenu(Menu0, 'Label', 'Sector');
    set(Menu0, 'Position', 3);
    set(Menu0, 'Separator', 'On');

    % Arc
    for i = 1:N
        Menu1 = uimenu(Menu0, 'Label',sprintf('Arc Sector %d',i));
        set(Menu1,'Callback', ['plotfamily(''HorizontalAxisSector_Callback'',gcbo,[',sprintf('%f %f',[(i-1)*L/N i/N]),'],guidata(gcbo))']);
    end
end


drawnow;
