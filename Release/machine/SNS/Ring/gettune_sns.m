function [Tune, ErrorFlag] = gettune_sns(varargin)
%GETTUNE_SNS - SNS Ring Tune Measurement Program
%
% | Higher Fractional Tune, usually Horizontal |
% |                                            | = gettune_sns
% |  Lower Fractional Tune, usually Vertical   |
%


[Tune, tout, DataTime, ErrorFlag] = getpv('TUNE');