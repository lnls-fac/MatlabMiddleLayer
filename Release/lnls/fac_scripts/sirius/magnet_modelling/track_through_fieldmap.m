function r = track_through_fieldmap(ref_traj, track, runge_kutta_flags)

% initial conditions
pts0 = zeros(length(track.px)*length(track.rx),6);
for i=1:length(track.px)
    for j=1:length(track.rx)
       pts0((i-1)*length(track.rx)+j,:) = [track.rx(j) track.px(i) 0 0 0 0];
    end
end

% entrance and exit reference systems
sf_in  = get_local_SerretFrenet_coord_system(ref_traj, ref_traj.s(1));
sf_out = get_local_SerretFrenet_coord_system(ref_traj, ref_traj.s(end));

s_length = ref_traj.s(end) + 0.1; % 100 mm should be enough
pts1 = zeros(size(pts0));
for i=1:size(pts0,1)
    pos = sf_in.r + sf_in.n * pts0(i,1);
    beta_x = sf_in.t(1) + pts0(i,2);
    beta_z = sqrt(1-beta_x^2); % beta = constant
    p = [beta_x; 0; beta_z];
    traj = calc_trajectory(s_length, [pos; p], runge_kutta_flags);
    [s_intersection x_perp] = find_intersection_point(traj, sf_out);

%     beta_x1 = interp1q(traj.s, traj.beta_x, s_intersection);
%     dbeta_x = beta_x1 - sf_out.p(1);
%     pts1(i,:) = [x_perp dbeta_x 0 0 0 s_intersection - ref_traj.s(end)];
    p1(1,1) = interp1q(traj.s, traj.beta_x, s_intersection);
    p1(2,1) = interp1q(traj.s, traj.beta_y, s_intersection);
    p1(3,1) = interp1q(traj.s, traj.beta_z, s_intersection);
    dp = (p1 - sf_out.t)'*sf_out.n;
    pts1(i,:) = [x_perp dp 0 0 0 s_intersection - ref_traj.s(end)];

    fprintf('rx = %+7.2f [mm] -> px = %+7.4f [mrad] \n', 1e3*pts0(i,1), 1e3*pts1(i,2));
    
end
r.rx = track.rx;
r.px = track.px;
r.in_pts  = pts0;
r.out_pts = pts1;

