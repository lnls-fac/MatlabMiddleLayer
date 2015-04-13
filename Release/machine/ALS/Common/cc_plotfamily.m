function cc_plotfamily
% CC_PLOTFAMILY - "Compiles" the plotfamily application to run standalone

DirStart = pwd;
gotocompile;
cc_standalone('plotfamily');
cd(DirStart);


