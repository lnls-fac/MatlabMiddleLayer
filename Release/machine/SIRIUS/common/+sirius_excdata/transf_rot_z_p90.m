function transf_rot_z_p90(mag_field)
% +90 degrees rotation around z axis
rotcoil = getappdata(0, 'rotcoil');
for i=1:length(rotcoil.(mag_field).currents)
    for j=1:size(rotcoil.(mag_field).nmpoles{i}, 1)
        for k=1:size(rotcoil.(mag_field).nmpoles{i}, 2)
            n = rotcoil.(mag_field).harms(k);
            nm = rotcoil.(mag_field).nmpoles{i}(j,k);
            sm = rotcoil.(mag_field).smpoles{i}(j,k);
            zi = (nm + 1j*sm);
            zf = (-1j)^(n+1) * zi;
            rotcoil.(mag_field).nmpoles{i}(j,k) = real(zf);
            rotcoil.(mag_field).smpoles{i}(j,k) = imag(zf);
        end
    end
end
setappdata(0, 'rotcoil', rotcoil);
