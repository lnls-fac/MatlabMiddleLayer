%lnls_lifetime_plot: calculates the total lifetime as a function of current
%per bunch and creates a file .txt useful for plotting graphics.
%
%INPUT  data_at   : struct with ring parameters (atsummary)
%       I         : Current per bunch vector    [A]
%       phase: set the operational phase (0, 1 or 2)
%
%OUTPUT lifetime  : total lifetime [h]
%========================================================================== 
%May 24, 2018 - Murilo Barbosa Alves
%==========================================================================
function lifetime = lnls_lifetime_plot(ring,I,phase)

%generate logspaced current vector
%Imax = 3e-4; %Maximum bunch current
%Imin = 5e-5; %Minimum bunch current
%I = logspace(log10(5)-5,log10(3)-3);

%For each j, assigns a value of current to the function that calculates the
%effect of ibs on final emittances
lifetime = zeros(length(I),1);

for j=1:length(I)
    if ~mod(j, 20)
        fprintf('.\n');
    else
        fprintf('.');
    end
    [~,lifetime(j)] = lnls_lifetime_calc(ring,phase,I(j));
end

file_lifetime = fopen('lifetime.txt','w');
fprintf(file_lifetime,'%6s \t\t %6s \r\n','I [mA]','Total lifetime [h]');
fprintf(file_lifetime,'%-6.6f \t %-6.6f \r\n',[I.*1e3,lifetime(:)].');
fclose(file_lifetime);

