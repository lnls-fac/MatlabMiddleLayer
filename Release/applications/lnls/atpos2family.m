function [FamilyName, Devices, ErrorFlag] = atpos2family(pos, varargin)
% [FamilyName, Devices, ErrorFlag] = atpos2family(pos, varargin)
%
% pos : AT Position
%
% Optional Input
%
% N : selects the N-th matching element.

order = [];
if ~isempty(varargin), order = varargin{1}; end;
if isempty(order), order = ones(length(pos),1); end;
if length(order) ~= length(order), order = order * onex(length(pos),1); end;

FamilyName = {};
Devices = [];
ErrorFlag = 0;

AO = getfamilydata;
families = fieldnames(AO);
for i=1:length(pos)
    order_idx = 0;
    for j=1:length(families)
        position = [getfamilydata(families{j}, 'Position'); getfamilydata(families{j}, 'AT', 'Position')];
        position = unique(position(:));
        if isempty(position), continue; end;
        Element = find((position - pos(i)) == 0);
        if ~isempty(Element)
            order_idx = order_idx + 1; 
            if order_idx == order(i)
                FamilyName{i} = families{j};
                DeviceList = AO.(families{j}).DeviceList;
                Devices(i,:) = DeviceList(Element,:);
                break;
            end
        end
    end
end