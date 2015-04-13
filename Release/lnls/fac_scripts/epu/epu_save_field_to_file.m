function epu_save_field_to_file(gap, phase, delta_gap)

[FileName,PathName,~] = uiputfile('*.txt','Escolha onde gravar dados do campo');

epu = create_epu_from_file;
epu = set_config(epu, gap, phase, delta_gap); 

period = 50;
p = [epu.csd(:).pos];
y = (min(p(2,:))-2*period):(period/32):(max(p(2,:))+2*period);
p = zeros(3,length(y));
p(2,:) = y;

field = epu_field(epu, p);
data  = [y' field([1 3],:)'];
dlmwrite(fullfile(PathName,FileName), data, 'newline', 'pc', 'delimiter', '\t'); 