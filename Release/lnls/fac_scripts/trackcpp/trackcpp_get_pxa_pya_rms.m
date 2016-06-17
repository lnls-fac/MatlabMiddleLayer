function [angle_accep] = trackcpp_get_pxa_pya_rms(pathname,nfiles)

for i=1:nfiles
    pathname_file=[pathname, sprintf('/rms%02d',i)];
    
    fnameX = fullfile(pathname_file,'dynap_pxa_out.txt');
    fnameY = fullfile(pathname_file,'dynap_pya_out.txt');

    [spos, PX(i,:), ~, ~] = trackcpp_load_pxa_data(fnameX);
    [~,    PY(i,:), ~, ~] = trackcpp_load_pxa_data(fnameY);
end

angle_accep.pos=spos;
angle_accep.avg_px=mean(PX,1);
angle_accep.rms_px=std(PX,0,1);
angle_accep.avg_py=mean(PY,1);
angle_accep.rms_py=std(PY,0,1);