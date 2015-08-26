function lnls_plot_cod_coup_optics(default_path)

prompt = {'machine (si/bo)','symmetry', '# of machines', 'units (mm/um)'};
defaultanswer = {'si','10', '2','um'};
answer = inputdlg(prompt,'Select',1,defaultanswer);
if isempty(answer), return; end;
if strcmpi(answer{1}, 'bo'), submachine = 'bo'; else submachine = 'si'; end
symmetry   = str2double(answer{2});
num_mac = str2double(answer{3});
if strcmpi(answer{4}, 'mm'), factor = 1e3; else factor = 1e6; end

size_font = 16;

STRFTM = ' %12s';
DBLFTM = ' %12.2f';
fprintf(['\n%-20s',STRFTM,STRFTM,STRFTM,STRFTM,STRFTM,STRFTM,STRFTM,STRFTM,STRFTM, '\n'],...
        'Configuração', 'codx [um]', 'kickx [urad]','cody [um]', 'kicky [urad]',...
        'dbetax [%]', 'dbetay [%]','qn [1/km]','Ey/Ex [%]','qs [1/km]');
for ii=1:num_mac
    % selects file with random machines and loads it
    if ~exist('default_path','var')
        default_path = fullfile(lnls_get_root_folder(), 'data','sirius',submachine);
    end
    [FileName,PathName,~] = uigetfile('*.mat','select matlab file with random machines', default_path);
    if isnumeric(FileName)
        return
    end
    r = load(fullfile(PathName, FileName)); machine = r.machine;
    r = load(fullfile(PathName, 'CONFIG_the_ring.mat')); the_ring = r.the_ring;
    
    na       = regexp(PathName,'/','split');
    leg_text = inputdlg('Digite a legenda','Legenda',1,na(end-3));
    
    % selects section of the lattice for the plot.
    s = findspos(machine{1}, 1:length(machine{1}));
    s_max = s(end)/symmetry;
    
    codrx = zeros(length(machine), length(machine{1}));
    codry = zeros(length(machine), length(machine{1}));
    dbetax = zeros(length(machine), length(machine{1}));
    dbetay = zeros(length(machine), length(machine{1}));
    EmitRto = zeros(1,length(machine));
    
    if strcmp(submachine,'si')
        fam_data = sirius_si_family_data(machine{1});
        ch = 'chs';cv = 'cvs';
    elseif strcmp(submachine,'bo')
        fam_data = sirius_bo_family_data(machine{1});
        ch = 'ch';cv = 'cv';
    end
    hcms = fam_data.(ch).ATIndex;
    vcms = fam_data.(cv).ATIndex;
    qn_idx  = fam_data.qn.ATIndex;
    qs_idx = fam_data.qs.ATIndex;
    kickx = zeros(length(machine), size(hcms,1));
    kicky = zeros(length(machine), size(vcms,1));
    qn    = zeros(length(machine), size(qn_idx,1));
    qs    = zeros(length(machine), size(qs_idx,1));
    
    
    qn_init = getcellstruct(the_ring, 'PolynomB', qn_idx(:), 1, 2);
    twiss0  = calctwiss(the_ring);
    for i=1:length(machine)
        orb = findorbit4(machine{i}, 0, 1:length(machine{i}));
        codrx(i,:) = factor * orb(1,:);
        codry(i,:) = factor * orb(3,:);
        kickx(i,:) = factor * lnls_get_kickangle(machine{i}, hcms,'x');
        kicky(i,:) = factor * lnls_get_kickangle(machine{i}, vcms,'y');
        
        twiss      = calctwiss(machine{i});
        dbetax(i,:) = 100*(abs(twiss.betax - twiss0.betax))./twiss0.betax;
        dbetay(i,:) = 100*(abs(twiss.betay - twiss0.betay))./twiss0.betay;
        qnstr = getcellstruct(machine{i}, 'PolynomB', qn_idx(:), 1, 2);
        qnstr = (qnstr-qn_init).*getcellstruct(machine{i}, 'Length', qn_idx(:));
        qn(1,:) = 1e3*sum(reshape(qnstr, size(qn_idx,1), []), 2)';
        
        [~, ~, ~, ~, EmitRto(i), ~, ~, ~, ~] = calccoupling(machine{i});
%         EmitRto(i) = mean(lnls_calc_emittance_coupling(machine{i}));
        qsstr = getcellstruct(machine{i}, 'PolynomA', qs_idx(:), 1, 2);
        qsstr = qsstr.*getcellstruct(machine{i}, 'Length', qs_idx(:));
        qs(i,:) = 1e3*sum(reshape(qsstr, size(qs_idx,1), []), 2)';
    end
    fprintf(['%-20s',DBLFTM,DBLFTM,DBLFTM,DBLFTM,DBLFTM,DBLFTM,DBLFTM,DBLFTM,DBLFTM,'\n'],...
        upper(leg_text{1}),...
        std(codrx(:)), std(kickx(:)),...
        std(codry(:)), std(kicky(:)), ...
        std(dbetax(:)), std(dbetay(:)), std(qn(:)),...
        std(EmitRto*100), std(qs(:)));
end
