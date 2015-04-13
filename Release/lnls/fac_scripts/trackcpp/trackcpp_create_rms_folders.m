function trackcpp_create_rms_folders(nfolder, path, inpfile)
cur_dir = pwd;

if ~exist('path','var'), path = pwd; end
if ~exist('inpfile','var'), inpfile = 'input.py'; end
if ~exist(fullfile(path,inpfile),'file')
    [inpfile,path,~] = uigetfile('*.py','Select input file for pytrack', 'input.py');
    if isnumeric(inpfile)
        return
    end
end
    
cd(path);
fh = fopen('runjob.sh','w');
fprintf(fh,['#!/bin/bash\n\nsource ~/.bashrc\n\npytrack.py ' inpfile ' > run.log']);
fclose(fh);
system('chmod gu+wx runjob.sh');
for ii = 1:nfolder
    folder = sprintf('rms%02d',ii);
    flat_name = sprintf('flatfile_rms%02d\\.txt',ii);
    mkdir(folder);
    system(['sed -e ''s/^flat_filename.*=.*//'' ', inpfile, ...
               ' -e "1s/^/flat_filename   = \''', flat_name,'\''\n/" > ', ...
               fullfile(folder, 'input.py')]);
    system(['chmod gu+w -R ', folder]);
end
cd(cur_dir);