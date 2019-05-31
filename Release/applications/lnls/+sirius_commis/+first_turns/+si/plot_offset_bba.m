figure; 
plot(1e6*off1(:, 1), '-o'); 
hold all; 
plot(1e6*off1f(:, 1),'-o');
plot(1e6*off2(:, 1),'-o'); 
plot(1e6*off2f(:, 1),'-o'); 
% plot((off1(:, 1) - off1f(:, 1))*1e6, '-o');
legend('Linear', 'Linear Fit', 'Quadratic', 'Quadratic Fit');