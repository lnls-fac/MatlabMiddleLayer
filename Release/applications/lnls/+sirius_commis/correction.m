bc = the_ring(fam_data.BC.ATIndex(1, :));
polyB = getcellstruct(bc, 'PolynomB', 1:length(bc));
polyB_new = polyB;
delta_new = 0.5e-2;
delta_old = 1.0e-2;
for j = 1:length(polyB_new)
    polyB_new{j} = polyB_new{j} * (1 + delta_new) / (1 + delta_old);
end

for j = 1:length(polyB_new)
    pb = polyB_new{j}; 
    pb_old = polyB{j};
    dtheta(j) = theta0(j) ./ len(j) * (1 / (1 + delta_new) - 1 / (1 + delta_old)); 
    pb(1,1) = pb(1,1) - dtheta(j);
    polyB_new{j} = pb;
    theta_new(j) = pb(1,1) * len(j);
end

x0 = zeros(6, 1); x0(5) = 1e-2;
xf = linepass(bc, x0, 1:length(bc)+1);
bc2 = setcellstruct(bc, 'PolynomB', 1:length(bc), polyB_new);
x02 = zeros(6, 1);
xf2 = linepass(bc2, x02, 1:length(bc2)+1);
difx = xf2(:,end) - xf(:,end);
xf3 = linepass(bc2, x0, 1:length(bc2) + 1);
xf4 = linepass(bc, x02, 1:length(bc) + 1);
delta = theta_old ./ (theta_old + theta_new) - 1;
difx2 = xf3(:, end) - xf4(:, end);
figure; plot(xf(1,:), '-o'); hold on, plot(xf2(1,:));
legend('Delta = 0.01', 'Delta = 0')
figure; plot(abs(xf2(1, :) - xf(1,:)));
figure; plot(xf3(1,:), '-o'); hold on, plot(xf4(1,:));
legend('Delta = 0.01', 'Delta = 0')

    