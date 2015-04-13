function [ctrl_num, ctrl_den] = generate_contoller(controller_config, Ts)

if strcmp(controller_config.selected_controller, 'pid')
    Kp = controller_config.pid_Kp;
    Ki = controller_config.pid_Ki;
    Kd = controller_config.pid_Kd;
    ctrl_num = [(Kp+Ki*Ts+Kd/Ts) (-Kp-2*Kd/Ts) Kd/Ts];
    if ctrl_num(3) == 0
        ctrl_num = ctrl_num(1:2);
        ctrl_den = [1 -1];
    else
        ctrl_den = [1 -1 0];
    end
else
    ctrl_num = controller_config.tf_num;
    ctrl_den = controller_config.tf_den;
end
