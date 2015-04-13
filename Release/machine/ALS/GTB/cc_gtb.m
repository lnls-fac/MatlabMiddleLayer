function cc_gtb
% CC_GTB - "Compiles" all the GTB applications to run standalone

DirStart = pwd;
gotocompile('GTB');
cc_standalone('plotfamily');
cc_standalone('gtbcontrol');
cd(DirStart);
