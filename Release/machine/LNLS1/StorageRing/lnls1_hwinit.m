function lnls1_hwinit(varargin)
%LNLS1_HWINIT - Hardware initialization script
%
%História
%
%2010-09-13: código fonte com comentários iniciais.


DisplayFlag = 1;
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    end
end

