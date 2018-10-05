function [currents2, n_avg2, s_avg2, n_std2, s_std2] = transf_add_negative_currents(currents, n_avg, s_avg, n_std, s_std)

currents2 = [-fliplr(currents(2:end)), currents];
n_avg2 = [-flipud(n_avg(2:end,:)); n_avg];
s_avg2 = [-flipud(s_avg(2:end,:)); s_avg];
n_std2 = [-flipud(n_std(2:end,:)); n_std];
s_std2 = [-flipud(s_std(2:end,:)); s_std];
