function initializations()

    fprintf('\n<initializations> [%s]\n\n', datestr(now));

    % seed for random number generator
    seed = 131071;
    % fprintf('-  initializing random number generator with seed = %i ...\n', seed);
    RandStream.setGlobalStream(RandStream('mt19937ar','seed', seed));

end