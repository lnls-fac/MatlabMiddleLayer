function gera_matriz_resposta

%bpms_to_insert(1) = struct('index', 20, 'name', 'AMP11A');
%bpms_to_insert(2) = struct('index', 23, 'name', 'AMP11B');
bpms_to_insert = [];

if isempty(which('getao')), evalin('base', 'lnls1'); end
default_dir = fullfile(getfamilydata('Directory', 'DataRoot'), 'Optics');

[FileName,PathName,FilterIndex] = uigetfile({'BPMRespMat*.mat'}, 'Matriz resposta medida do MML', default_dir);
if FileName==0, return; end
file_name = fullfile(PathName, FileName);
mresp_mml  = getbpmresp(gethbpmfamily, getvbpmfamily, gethcmfamily, getvcmfamily,  file_name, 'Struct', 'Physics');

time_stamp = datestr(mresp_mml(1,1).TimeStamp, 'yyyy-mm-dd_HH-MM-SS');
energy     = mresp_mml(1,1).GeV;
dcct       = mresp_mml(1,1).DCCT;
units      = mresp_mml(1,1).UnitsString;
bpms       = dev2common(gethbpmfamily, mresp_mml(1,1).Monitor.DeviceList);
hcms       = dev2common(gethcmfamily, mresp_mml(1,1).Actuator.DeviceList);
vcms       = dev2common(getvcmfamily, mresp_mml(2,2).Actuator.DeviceList);

mresp_hbpm_hcm = mresp_mml(1,1).Data;
mresp_hbpm_vcm = mresp_mml(1,2).Data;
mresp_vbpm_hcm = mresp_mml(2,1).Data;
mresp_vbpm_vcm = mresp_mml(2,2).Data;


mrespH = [mresp_hbpm_hcm mresp_hbpm_vcm];
mrespV = [mresp_vbpm_hcm mresp_vbpm_vcm];

% insere bpms que faltam
mh = [];
mv = [];
bpmst = [];
if ~isempty(bpms_to_insert)
    c = 1;
    for i=1:size(mrespH,1)
        if c <= length(bpms_to_insert)
            if (size(mh,1)+1 == bpms_to_insert(c).index)
                mh = [mh; zeros(1,size(mrespH,2))];
                mv = [mv; zeros(1,size(mrespV,2))];
                bpmst = [bpmst; bpms_to_insert(c).name];
                c = c + 1;
            end
        end
        mh = [mh; mrespH(i,:)];
        mv = [mv; mrespV(i,:)];
        bpmst = [bpmst; bpms(i,:)];
    end
end
%mrespH = mh;
%mrespV = mv;
%bpms = bpmst;


mresp_opr1 = [mrespH; mrespV];


for i=1:length(bpms)
    bpmshv(i,:) = [bpms(i,:) 'H'];
    bpmshv(size(bpms,1)+i,:) = [bpms(i,:) 'V'];
end

[FileName,PathName,FilterIndex] = uiputfile({'*.resp'}, 'Gravar matriz resposta', strrep(file_name, '.mat', '.resp'));
if FileName==0, return; end
file_name = fullfile(PathName, FileName);

fid = fopen(file_name, 'w');
comment = ['Matriz Resposta do Anel. TimeStamp:' time_stamp ', Energia:'  num2str(energy) ', DCCT:' num2str(dcct) ', Unidades:', units];
fprintf(fid, [comment '\r\n']);

for j=1:size(hcms,1)
    fprintf(fid, '\t%s', hcms(j,:));
end
for j=1:size(vcms,1)
    fprintf(fid, '\t%s', vcms(j,:));
end
fprintf(fid, '\r\n');

for i=1:size(mresp_opr1,1)
    fprintf(fid, '%s', bpmshv(i,:));
    for j=1:size(mresp_opr1,2)
        fprintf(fid, '\t%f', mresp_opr1(i,j));
    end
    fprintf(fid, '\r\n');
end
fclose(fid);



 