function naff_cc
% cc_all - Compile nafflibrary for Matlab
%

% Modified by Laurent S. Nadolski
% April 6th, 2007

cd_old = pwd;
cd(fileparts(which('naff_cc')))

disp(['Compiling NAFF routines on ', computer,'.'])

% Object files
disp('Compiling: modnaff.c');
mex -I/usr/local/matlab/extern/include -O -c modnaff.c

disp('Compiling: example.c');
mex -I/usr/local/matlab/extern/include -O -c complexe.c

disp('Compiling: nafflib.c');

internal_cc('nafflib.c modnaff.o complexe.o');

cd(cd_old);

function internal_cc(fn)
% cc(filename)
%
%  Version 5, Solaris compiling function
%

disp(['Compiling: ',fn]);

cmdstr = [ 'mex -I/usr/local/matlab/extern/include -O ', fn ];
disp(cmdstr);
eval(cmdstr);
