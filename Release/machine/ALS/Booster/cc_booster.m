function cc_booster
% CC_BOOSTER - "Compiles" all the booster ring applications to run standalone

DirStart = pwd;
gotocompile('Booster');
if ~ispc
    cc_standalone('brcontrol');
end
cc_standalone('plotfamily');
cd(DirStart);
