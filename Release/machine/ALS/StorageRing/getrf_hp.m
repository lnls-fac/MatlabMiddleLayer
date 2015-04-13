function [RFam, RFac] = getrf2(varargin)
% [RFam, RFac] = getrf2
%
%   RFac = RF frequency FM modulation voltage on the user synthesizer
%   RFam = RF frequency as measured by the HP counter [MHz]
%
%   EG_HQMOFM is the voltage that modulates the user synthesizer frequency (which is set by hand)
%   The scaling factor is 1V = 4.988 kHz, and the range is -2<->2 V
%
%   Note:  The RF must be connected to the user synthesizer for outputs to be correct
%          

if nargout == 0
    fprintf('\n  RF Frequency Information:\n');
    fprintf('  HP Counter = %.6f MHz\n', getam('SR01C___FREQB__AM00'));
    fprintf('  EG_HQMOFM = %.6f V\n\n', getsp('EG______HQMOFM_AC01'));
end
if nargout >= 1
    RFam  = getam('SR01C___FREQB__AM00');
end
if nargout >= 2
    RFac  = getsp('EG______HQMOFM_AC01');
end