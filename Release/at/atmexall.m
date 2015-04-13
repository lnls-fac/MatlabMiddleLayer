%ATMEXALL builds all AT platform deendent mex-files from C-sources
% On UNIX platform, the GNU gcc compiler must be installed and
% properly configured.
% On Windows, Microsoft Visual C++ is required


StartDir = pwd;
ATROOT = atroot;
disp(['ATROOT Directory: ',ATROOT]);


% Navigate to the directory that contains pass-methods 
cd(ATROOT)
cd simulator
cd element
PASSMETHODDIR = pwd;
disp(['Current directory: ',PASSMETHODDIR]);
mexpassmethod('all');


% Navigate to the directory that contains tracking functions
cd(ATROOT)
cd simulator
cd track
disp(['Current directory:', pwd]);
switch computer
    case 'GLNXA64'
        MEXCOMMAND = 'mex -DGLNXA64 atpass.c -ldl';
    case 'GLNXA32'
        MEXCOMMAND = 'mex -DGLNXA32 atpass.c -ldl';
    otherwise
        MEXCOMMAND = ['mex -D',computer,' atpass.c'];
end
disp(MEXCOMMAND);
eval(MEXCOMMAND);

% Navigate to the directory that contains some accelerator physics functions
cd(ATROOT)
cd atphysics
disp(['Current directory:', pwd]);

% findmpoleraddiffmatrix.c
disp('mex findmpoleraddiffmatrix.c')
eval(['mex findmpoleraddiffmatrix.c -I''',PASSMETHODDIR,'''']);


% User passmethods
cd(ATROOT)
cd simulator
cd element
cd user
disp(['Current directory: ', pwd]);
mexuserpassmethod('all');


disp('ALL mex-files created successfully')
clear ATROOT PASSMETHODDIR WARNMSG PLATFORMOPTION MEXCOMMAND

cd(StartDir);


