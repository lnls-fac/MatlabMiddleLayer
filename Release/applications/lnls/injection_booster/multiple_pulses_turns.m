function multiple_pulses_turns(machine, param, n_part, n_pulse, n_turns)
% initializations();

if ~exist('n_turns','var');
    n_turns = 1e5;
end

for i = 1:n_pulse
    fprintf('======================= \n');
    fprintf('Pulse number %i \n', i);
    fprintf('======================= \n');
    booster_turns(machine, 1, param, n_part, n_turns);
end
end

% function initializations()
% 
%     fprintf('\n<initializations> [%s]\n\n', datestr(now));
% 
%     % seed for random number generator
%     seed = 131071;
%     % fprintf('-  initializing random number generator with seed = %i ...\n', seed);
%     RandStream.setGlobalStream(RandStream('mt19937ar','seed', seed));
% 
% end