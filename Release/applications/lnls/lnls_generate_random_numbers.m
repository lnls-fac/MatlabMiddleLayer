function rndnr = lnls_generate_random_numbers(stdvalue, nrvalues, type, cutoff, avgvalue)
% rndnr = lnls_generate_random_numbers(stdvalue, nrvalues, type, cutoff, avgvalue)
% 
% stdvalue = standard deviation of the distribution;
% nrvalues = number of random numbers to generate;
% type     = type of distribution: 'uniform', 'exponential' or 'normal';
% cutoff   = number of sigmas to cut the numbers (used only for exponential
%            and normal distributions, however, a value must be given;
% avgvalue = average of the distribution (used only for uniform and normal
%            distributions;
%rndnr     = vector of 1xnrvalues with random real numbers.


if ~exist('cutoff', 'var'), cutoff = Inf; end;

if strcmpi(type, 'uniform')
    rndnr = avgvalue + stdvalue * (rand(1, nrvalues) - 0.5);    
elseif strcmpi(type, 'exponential')
    rndnr = zeros(1,nrvalues);
    sel = 1:nrvalues;
    while ~isempty(sel)
        rndnr(sel) = random('exp',2*stdvalue, 1,length(sel));
        sel = find(abs(rndnr) > cutoff*stdvalue);
    end
else
    rndnr = zeros(1,nrvalues);
    sel = 1:nrvalues;
    while ~isempty(sel)
        rndnr(sel) = randn(1,length(sel));
        sel = find(abs(rndnr) > cutoff);
    end
    rndnr = avgvalue + stdvalue * rndnr;
end