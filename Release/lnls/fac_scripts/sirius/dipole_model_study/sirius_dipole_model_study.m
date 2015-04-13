function sirius_dipole_model_study

btype = 'b2';

if (strcmpi(btype,'b1'))
    data = importdata('b1_field_on_trajectory.txt');
    b_length = 828.080;  % [mm]
    b_angle  = 2.76654;  % [deg]
elseif strcmpi(btype, 'b2')
    data = importdata('b2_field_on_trajectory.txt');
    b_length = 1228.262; % [mm]
    b_angle  = 4.10351;  % [deg]
elseif strcmpi(btype, 'b3')
    data = importdata('b3_field_on_trajectory.txt');
    b_length =  428.011; % [mm]
    b_angle  =  1.42995; % [ang]
end
    
%data = importdata('field_on_trajectory.txt');

s    = data.data(:,1);
by   = data.data(:,6);

plot(s, by);
[beta,gamma,b_rho] = lnls_beta_gamma(3.0);

nrpts     = 10;
len       = (b_length/nrpts/2) * ones(1,nrpts); 
sseg      = [0, cumsum(len)];

len = zeros(1,length(sseg)-1);
ang = zeros(1,length(sseg)-1);
for i=1:length(sseg)-1
    s1 = sseg(i); s2 = sseg(i+1);
    by1 = interp1(s,by,s1);
    by2 = interp1(s,by,s2);
    sel = (s >= s1) & (s <= s2);
    s_sel  = [s1; s(sel); s2];
    by_sel = [by1; by(sel); by2];
    len(i) = s2 - s1;
    ang(i) = trapz(s_sel/1000, by_sel)/b_rho;
    %ang(i) = trapz(s(sel)/1000, by(sel))/b_rho;
end

int_ang = abs(sum(ang) * 2 * 180/pi);
fprintf('(%f/%f) * \n', b_angle, int_ang);

%ang = ang * (b_angle / int_ang);

int_ang = sum(ang) * 2 * 180/pi;
ang = ang / sum(ang) / 2;


fprintf(['dip_nam = ''', upper(btype), ''';\n']);
fprintf(['dip_len = ', num2str(b_length/1000, '%.6f'), ';\n']);
fprintf(['dip_ang = ', num2str(b_angle, '%.6f'), ' * (pi/180);\n']);
fprintf(['dip_K   = -0.78;\n','']);
fprintf(['dip_S   =  0.0;\n','']);
fprintf(['h', num2str(1, '%02i'), ' = rbend_sirius(dip_nam, dip_len/', num2str(2*length(len)), ', ', num2str(ang(end), '%.10f'), ' * dip_ang, 1*dip_ang/2, 0*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);\n']);
for i=2:length(len)
    fprintf(['h', num2str(i, '%02i'), ' = rbend_sirius(dip_nam, dip_len/', num2str(2*length(len)), ', ', num2str(ang(length(len)+1-i), '%.10f'), ' * dip_ang, 0*dip_ang/2, 0*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);\n']);
end
for i=1:length(len)-1
    fprintf(['h', num2str(length(len)+i, '%02i'), ' = rbend_sirius(dip_nam, dip_len/', num2str(2*length(len)), ', ', num2str(ang(i), '%.10f'), ' * dip_ang, 0*dip_ang/2, 0*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);\n']);
end
fprintf(['h', num2str(2*length(len), '%02i'), ' = rbend_sirius(dip_nam, dip_len/', num2str(2*length(len)), ', ', num2str(ang(end), '%.10f'), ' * dip_ang, 0*dip_ang/2, 1*dip_ang/2, 0, 0, 0, [0 0 0], [0 dip_K dip_S], bend_pass_method);\n']);

str = [upper(btype), '      =  ['];
for i=1:length(len)
    str = [str, ['h', num2str(i, '%02i'), ', ']];
end
str = [str, 'm', btype, ', '];
for i=1:length(len)
    str = [str, ['h', num2str(length(len)+i, '%02i'), ', ']];
end
str = [str, '];\n'];
fprintf(str);


