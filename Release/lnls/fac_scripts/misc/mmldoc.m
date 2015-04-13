% Script que gera documentação automaticamente do MML-LNLS
%
% Histórico
% 
% 2010-09-16: comentários iniciais no código

tic;

m2html_options.mfiles     = 'Release';
m2html_options.htmldir    = 'Release/doc'; 
m2html_options.recursive  = 'on';
m2html_options.global     = 'on';
m2html_options.graph      = 'on';
%m2html_options.template   = 'frame';
%m2html_options.index      = 'menu';
m2html_options.globalHypertextLinks = 'on';
%m2html_options.search = 'on';
%m2html_options.ignoredDir = {'applications', 'mml', 'links', 'at', 'RIP', 'Booster', 'SIRIUS'};
m2html_options.ignoredDir = {'RIP', 'Booster', 'SIRIUS', 'sirius_link', 'EDM', 'lattices_def'};
     

ofn = fieldnames(m2html_options);
for vi=1:length(ofn)
    m2html_arg{2*vi-1} = ofn{vi};
    m2html_arg{2*vi} = m2html_options.(ofn{vi});
end
clear ofn m2html_options vi;

fprintf('[Início] Gerando documentação do MML-LNLS: %s\n', datestr(now));
dr = pwd;
addpath(fullfile('C:\Arq\MatlabMiddleLayer\Release\','applications','m2html'));
cd('C:\Arq\MatlabMiddleLayer\');
m2html(m2html_arg{:});
clear m2html_arg
cd(dr);
clear dr;
fprintf('[Fim] Gerando documentação do MML-LNLS: %s\n', datestr(now));
toc;
