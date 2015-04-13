function r = build_lattice_model(varargin)
% Gera modelo AT do anel
%
% Gera modelo AT do anel a partir de arquivos textos com especificaçao de
% parametros globais do anel e espeficicação de posiçao dos centros de cada 
% elemento com relaçao ao trecho do anel.
%
% Histórico
%
% 2010-09-16: comentários iniciais do código (Ximenes R. Resende)


if nargin==0
    top_dir = uigetdir;
    if top_dir==0, return; end
    idx = find(top_dir == filesep);
    last_dir = top_dir(idx(end)+1:length(top_dir));
    varargin{1} = last_dir;
end
    

atmodel_name = getfamilydata('ATModel');
dfault_model = which(atmodel_name);
[pathstr, atmodel_name, ext] = fileparts(dfault_model);
lattice_dir = [getfamilydata('Directory','LatticesDef') filesep varargin{1}];
cd(lattice_dir);

%% reads user-defined types and ring definition or reuses structures passed as arguments

    
if length(varargin)==1
    TYPES = DEF_TYPES;
else
    TYPES = varargin{2}.TYPES; 
end

RING = DEF_RING(TYPES);
    
% processes ring cell data
ring_cells = fieldnames(RING.CELLS);
for i=1:size(ring_cells,1)
    cell_name = char(ring_cells(i,:));
    fid = fopen(RING.CELLS.(cell_name).FILE,'r');
    RING.CELLS.(cell_name).DATA = textscan(fid, '%s %s %s');
    fclose(fid);
end
    

%% builds ring lattice vector
ring_cells = fieldnames(RING.CELLS);
for i=1:size(ring_cells,1)
    cell_name = char(ring_cells(i,:));
    RING.CELLS.(cell_name) = insert_drift_spaces(RING.CELLS.(cell_name), TYPES);
end

%% generates cell array of lattice command strings
lattice_cmds = {};
lattice_cmds = [lattice_cmds; {'%%% LATTICE SECTION %%%'}];
lattice_cmds = [lattice_cmds; {''}];
ring_line = '';
ring_cells = fieldnames(RING.CELLS);
for i=1:size(ring_cells,1)
    cell_name = char(ring_cells(i,:));
    tcell = RING.CELLS.(cell_name);
    lattice_cmds = [lattice_cmds; {['% CELL: ' cell_name]}];
    lattice_cmds = [lattice_cmds; {''}];
    cell_line = '';
    for j=1:length(tcell.element_types)
        typ = char(tcell.element_types{j});
        lab = char(tcell.element_labels{j});
        len = tcell.element_lengths{j};
        cell_line = [cell_line lab ' '];
        TYPES.(typ).IN_USE = 'no';
        if ~strcmpi(typ, 'ATR')
            TYPES.(typ).IN_USE = 'yes';
            lattice_cmds = [lattice_cmds; {[lab ' = ' typ '_element;']}];
        else
            TYPES.(typ).LENGTH = num2str(len, 9);
            temp = instantiate_type_template(TYPES.(typ));
            lattice_cmds = [lattice_cmds; {[lab ' = ' temp{1}]}];
        end
    end
    lattice_cmds = [lattice_cmds; {[cell_name ' = [' cell_line '];']}];
    lattice_cmds = [lattice_cmds; {'';''}];
    ring_line = [ring_line cell_name ' '];
end

%% generates cell array of template command strings
template_cmds = {};
template_cmds = [template_cmds; {'%%% TEMPLATE SECTION %%%'}];
template_cmds = [template_cmds; {''}];
types_names = fieldnames(TYPES);
for i=1:size(types_names,1)
    typ = char(types_names(i,:));
    if ~strcmpi(typ, 'ATR') && isfield(TYPES.(typ), 'IN_USE') && strcmpi(TYPES.(typ).IN_USE,'yes')
        template_cmds = [template_cmds; {['% ', typ, ' Template %']}];
        template_cmds = [template_cmds; instantiate_type_template(TYPES.(typ))];
        template_cmds = [template_cmds; {''}];
    end
end


%% generates cell array of header command strings

header_cmds = {};
header_cmds = [header_cmds; {['function r = ' atmodel_name '(energy)']}];
header_cmds = [header_cmds; {'%LNLS1_LATTICE - LNLS1 Lattice Model (automatically created with <build_lattice_model>'}];
header_cmds = [header_cmds; {''}];
header_cmds = [header_cmds; {'%%% HEADER SECTION %%%'}];
header_cmds = [header_cmds; {''}];
header_cmds = [header_cmds; {'global THERING'}];
header_cmds = [header_cmds; {'if ~exist(''energy'', ''var'')'}];
header_cmds = [header_cmds; {['    energy = ' num2str(RING.ENERGY) ';']}];
header_cmds = [header_cmds; {'end'}];
%header_cmds = [header_cmds; {['energy = ' num2str(RING.ENERGY) ';']}];
header_cmds = [header_cmds; {''}];

%% generates cell array of tail command strings
tail_cmds = {};
tail_cmds = [tail_cmds; {'%%% TAIL SECTION %%%'}];
tail_cmds = [tail_cmds; {''}];
tail_cmds = [tail_cmds; {['elist = [' ring_line '];']}];
tail_cmds = [tail_cmds; {'THERING = buildlat(elist);'}];
tail_cmds = [tail_cmds; {'mbegin = findcells(THERING, ''FamName'', ''BEGIN'');'}];
tail_cmds = [tail_cmds; {'if ~isempty(mbegin), THERING = circshift(THERING, [0 -(mbegin(1)-1)]); end'}];
tail_cmds = [tail_cmds; {'THERING{end+1} = struct(''FamName'',''END'',''Length'',0,''PassMethod'',''IdentityPass'');'}];
tail_cmds = [tail_cmds; {'THERING = setcellstruct(THERING, ''Energy'', 1:length(THERING), 1e9*energy);'}];
%tail_cmds = [tail_cmds; {'skquads = findcells(THERING, ''FamName'', ''SKEWQUAD'');'}];
%tail_cmds = [tail_cmds; {'if ~isempty(skquads)'}];
%tail_cmds = [tail_cmds; {'   fprintf(''   Generating %i skew quadrupoles by rotating normal quads.\n'', length(skquads));'}];
%tail_cmds = [tail_cmds; {'   settilt(skquads, (pi/4)*ones(1,length(skquads)));'}];
%tail_cmds = [tail_cmds; {'end'}];
tail_cmds = [tail_cmds; {'r = THERING;'}];
tail_cmds = [tail_cmds; {''}];
tail_cmds = [tail_cmds; {'% Compute total length and RF frequency'}];
tail_cmds = [tail_cmds; {'L0_tot = findspos(THERING, length(THERING)+1);'}];
tail_cmds = [tail_cmds; {['fprintf(''   Length: %.6f m   (design length ' num2str(RING.LENGTH, 6) ' m)\n'', L0_tot);']}];
tail_cmds = [tail_cmds; {''}];
tail_cmds = [tail_cmds; {'% Just in case...'}];
tail_cmds = [tail_cmds; {'not_ready = true;'}];
tail_cmds = [tail_cmds; {'while not_ready'}];
tail_cmds = [tail_cmds; {'    try'}];
tail_cmds = [tail_cmds; {'        atpass(THERING, [0 0 0 0 0 0]'',1,1);'}];
tail_cmds = [tail_cmds; {'        not_ready = false;'}];
tail_cmds = [tail_cmds; {'    catch'}];
tail_cmds = [tail_cmds; {'       if isempty(strfind(lasterr,''Library or function could not be loaded''))'}];
tail_cmds = [tail_cmds; {'            rethrow(lasterror);'}];
tail_cmds = [tail_cmds; {'       end'}];
tail_cmds = [tail_cmds; {'    end'}];
tail_cmds = [tail_cmds; {'end'}];
tail_cmds = [tail_cmds; {''}];

%% resturns data structure
r.TYPES = TYPES;
r.RING  = RING;
r.CMDS  = [header_cmds; template_cmds; lattice_cmds; tail_cmds];


%% save file with lattice

new_at_model_filename = [varargin{1} '_lattice.m'];
save_lattice_cmds(new_at_model_filename, [header_cmds; template_cmds; lattice_cmds; tail_cmds]);


%% copy new lattice file to default lattice file

at_model_name = [pathstr filesep atmodel_name];
dstr = datestr(now, 'yy-mm-dd_HH-MM-SS');
if exist([at_model_name '.m'],'file'), movefile([at_model_name '.m'], [at_model_name '_' dstr '.m']); end
copyfile(new_at_model_filename, [at_model_name '.m']);



%% save command strings to a lattice file
function save_lattice_cmds(file_name, cmds)

fid = fopen(file_name, 'w');
for i=1:length(cmds)
    str = char(cmds{i});
    fprintf(fid, '%s\n', str);
end
fclose(fid);

%% instantiates the template of a type with field values
function r = instantiate_type_template(typ)
    r = typ.TEMPLATE_ELEMENT;
    field_names = fieldnames(typ);
    for i=1:length(r)
        for j=1:size(field_names,1)
            field_name = char(field_names(j,:));
            r{i} = regexprep(r{i},field_name,typ.(field_name));
        end
    end
    
%% builds list of elements with driftspaces in between from list of elements of the cell
function ntcell = insert_drift_spaces(tcell, types_def)

    len_tol = 1e-6;
    
    ntcell = tcell;
    
    labels = {};
    cpos = [];
    types = {};
    
    for i=1:size(tcell.DATA{1})
        if tcell.DATA{1}{i}(1) ~= '%'
            labels{length(labels)+1} = tcell.DATA{1}{i};
            cpos(length(cpos)+1) = eval(tcell.DATA{2}{i}) / 1000;
            types{length(types)+1} = tcell.DATA{3}{i};
        else
            disp('');
        end
    end
    
    %{
    labels = tcell.DATA{1};
    for i=1:size(tcell.DATA{2},1)
        cpos(i) = eval(tcell.DATA{2}{i}) / 1000;
    end
    types  = tcell.DATA{3};
    %}

    [pathstr, tcell_name, ext] = fileparts(tcell.FILE);
    atr_label = [tcell_name '_'];
    
    nr_dspaces = 0;
    lab = {};
    len = {};
    typ = {};
    
    
    % tcell upstream driftspace
    elen = eval(types_def.(char(types{1})).LENGTH);
    atr_length = (cpos(1)-elen/2) + tcell.LENGTH/2;
    if (atr_length>0 && abs(atr_length)>=len_tol)
        nr_dspaces = nr_dspaces + 1;
        lab{length(lab)+1} = [atr_label int2str(nr_dspaces)];
        len{length(len)+1} = atr_length; 
        typ{length(typ)+1} = 'ATR';
    elseif (atr_length < 0 && abs(atr_length)>=len_tol)
        error(['negative drift space length in element ''' labels{1} ''', file ' ntcell.FILE ' !']);
    end
        
        
    % first section element
    lab{length(lab)+1}  = labels{1};
    len{length(len)+1} = eval(types_def.(char(types{1})).LENGTH);
    typ{length(typ)+1} = types{1};
    
    
    % pairs of elements
    for i=1:length(cpos)-1;
        
        e1_len = eval(types_def.(char(types{i})).LENGTH);
        e2_len = eval(types_def.(char(types{i+1})).LENGTH);

        % drift space between pair of elements
        atr_length = (cpos(i+1)-cpos(i)) - (e1_len + e2_len)/2;
        if (atr_length>0 && abs(atr_length)>=len_tol)
            nr_dspaces = nr_dspaces + 1;
            lab{length(lab)+1} = [atr_label int2str(nr_dspaces)];
            len{length(len)+1} = atr_length; 
            typ{length(typ)+1} = 'ATR';
        elseif (atr_length < 0 && abs(atr_length)>=len_tol)
            error(['negative drift space length between elements ''' labels{i} ''' and ''' labels{i+1} '''!']);
        end
        
        % downstream element
        lab{length(lab)+1} = labels{i+1};
        len{length(len)+1} = eval(types_def.(char(types{i+1})).LENGTH);
        typ{length(typ)+1} = types{i+1};
        
    end
    
    % tcell downstream driftspace
    elen = eval(types_def.(char(types{end})).LENGTH);
    atr_length = tcell.LENGTH/2 - (cpos(end)+elen/2);
    if (atr_length>0 && abs(atr_length)>=len_tol)
        nr_dspaces = nr_dspaces + 1;
        lab{length(lab)+1} = [atr_label int2str(nr_dspaces)];
        len{length(len)+1} = atr_length; 
        typ{length(typ)+1} = 'ATR';
    elseif (atr_length < 0 && abs(atr_length)>=len_tol)
        error(['negative drift space length in element ''' labels{end} '''!']);
    end
    
    ntcell.element_labels  = lab;
    ntcell.element_lengths = len;
    ntcell.element_types   = typ;
        
        
     