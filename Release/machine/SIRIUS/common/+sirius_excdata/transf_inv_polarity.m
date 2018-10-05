function transf_inv_polarity(mag_field)
% polarity inversion
rotcoil = getappdata(0, 'rotcoil');
for i=1:length(rotcoil.(mag_field).currents)
    rotcoil.(mag_field).nmpoles{i} = - rotcoil.(mag_field).nmpoles{i};
    rotcoil.(mag_field).smpoles{i} = - rotcoil.(mag_field).smpoles{i};
end
setappdata(0, 'rotcoil', rotcoil);
