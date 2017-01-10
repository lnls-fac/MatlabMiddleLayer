function trackcpp_submit_jobs(description, path, inpfile, exec_scpt, possible_hosts, priority)
cur_dir = pwd;

if ~exist('path','var'), path = pwd; end
if ~exist('inpfile','var'), inpfile = 'input.py'; end
if ~exist('exec_scpt','var'), exec_scpt = '../runjob.sh'; end
if ~exist('description','var'), description = ''; end
if ~exist('possible_hosts','var'), possible_hosts = 'all'; end
if ~exist('priority','var'), priority = '0'; end

pyjob = 'pyjob_qsub.py ';

SCRIPT = '#!/bin/bash\n\nsource ~/.bashrc\n\n%s\n';

cd(path);

[~, result] = system('ls | grep rms | wc -l');
nfolder = str2double(result);

for ii = 1:nfolder
    cd(sprintf('rms%02d',ii));
    if ~exist(inpfile,'file'), error('input file does not exist');end
    comm = [pyjob, ' --description ', sprintf('"rms%02d: ',ii), description,'"'];
    comm = [comm, ' --exec ', exec_scpt, ' --possibleHosts ', possible_hosts, ' --priority ', priority];
   
    fnames = dir();
    strf = [' --inputFiles ', inpfile];
    for i=1:length(fnames)
        if ~isempty(strfind(fnames(i).name, 'kicktable')) || ~isempty(strfind(fnames(i).name, 'flatfile'))
            strf = [strf, ',', fnames(i).name];
        end
    end
    comm = [comm, strf];
    
%     [~, res] = system('ls | grep "flatfile\|kicktable"');
%     comm = [comm, ' --inputFiles ', inpfile, ',',res];
    
    fh = fopen('tjoaieh.sh','w');
    fprintf(fh,SCRIPT,comm);
    fclose(fh);
    system('chmod gu+x tjoaieh.sh');
    unix('./tjoaieh.sh');
    system('rm tjoaieh.sh');
    cd('..');
end
cd(cur_dir);
