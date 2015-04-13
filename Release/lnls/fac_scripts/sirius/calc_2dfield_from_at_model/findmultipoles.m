function findmultipoles(config)

clc;

len_at_model = findspos(config.dipole_model, 1:length(config.dipole_model)+1);
if len_at_model > config.traj_len
    error('o modelo at é maior que o comprimento da trajetória');
end


[config.beta, config.gamma, config.b_rho] = lnls_beta_gamma(config.energy);
config.runge_kutta_flags.RelTol  = 1e-10;                         % RK tolerance                        
config.runge_kutta_flags.AbsTol  = 1e-10;                         % RK tolerance                        
config.runge_kutta_flags.MaxStep = 0.001; % [m] 

setappdata(0, 'P_CONFIG', config);

config.idx_zero = find(config.x == 0, 1);

residue = calc_residue(config);
figure; plot_residue(config); drawnow; hold all;
iter = 0;
fprintf('%i: residue = %f, (B,G,S) = (', iter, residue);
for i=1:length(config.coeffs)
    fprintf('%f ', config.coeffs(i));
end; fprintf(') \n');
while true
    new_config  = change_coeffs(config);
    iter = iter + 1;
    new_residue = calc_residue(new_config);
    if (new_residue < residue)
        config = new_config;
        residue = new_residue;
        fprintf('%i: residue = %f, (B,G,S) = (', iter, residue);
        for i=1:length(config.coeffs)
            fprintf('%f ', config.coeffs(i));
        end; fprintf(') \n');
        plot_residue(config); drawnow;
        save('config.mat', 'config');
    end
end
    

function plot_residue(config)

[residue, dang, dkick] = calc_residue(config);
plot(1000*config.x, 1e6*dkick);
xlabel('Pos[mm]');
ylabel('dKick[urad]');
title(['dAngle = ' num2str(100 * dang / (config.dipole_angle)) ' %']);


function config = change_coeffs(config_old)

config      = config_old;
rand_change = 0.01 .* 2 .* (rand(size(config.coeffs)) - 0.5);
config.coeffs = config.coeffs .* (1.0 + rand_change);


function [residue, dang, dkick] = calc_residue(config)

setappdata(0, 'P_CONFIG', config);

% calcs transfer maps of AT and RK
%figure; hold all;
xl_at = zeros(size(config.x));
xl_rk = zeros(size(config.x));
for i=1:length(config.x)
    %disp(i);
    p = linepass(config.dipole_model, [config.x(i);0;0;0;0;0]);
    xl_at(i) = p(2);
    s_max = config.traj_len;
    rk_traj = calc_trajectory(s_max, [(config.dipole_sagitta/2)+config.x(i),0,0,0,0,1.0]', config.runge_kutta_flags);
    xl_rk(i) = rk_traj.beta_x(end);
    if (i == config.idx_zero)
        angle = rk_traj.angle_x(end);
    end
    %plot(rk_traj.z, rk_traj.x);
end
xl_rk = xl_rk - xl_rk(config.idx_zero);

%figure; plot(1000*x, [xl_at' xl_rk']);
%figure; plot(1000*x, xl_at-xl_rk);

dkick = xl_rk - xl_at;
dang  = abs(2*angle) - config.dipole_angle;

% figure; plot(1000 * config.x, 1e6 * dkick);
% xlabel('pos   [mm]');
% ylabel('dKick [urad]');

dkick_scale = 1e-6; % [1 urad]
dang_scale  = (config.dipole_angle) * (0.2/100);

res1 = sqrt(sum((dkick / dkick_scale).^2)/length(dkick));
res2 = abs(dang / dang_scale);
residue = (1 * res1 + 1 * res2)/2;
