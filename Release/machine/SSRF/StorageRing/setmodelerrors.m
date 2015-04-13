function setmodelerrors

global THERING


% AnswerString = questdlg({
%     'Do you want to load THERING from file,', ...
%     'or calculate new errors', ...
%     '', ...
%     'Yes - Load from file', ...
%     'No  - Set new random error'}, ...
%     'SET MODEL ERRORS','Yes','No','No');
% 
% if strcmp(AnswerString,'Yes')
%     FileName = loadthering;
%     fprintf('   THERING set from file %s.mat\n', FileName);
%     return
% end

    
% Add an optics error to the model
Families = {'Q1','Q2','Q3','Q4','Q5','Q1L','Q2L','Q3L','Q4L','Q5L'};
for iFamily = 1:length(Families)
    ATIndex = family2atindex(Families{iFamily});
    for i = 1:size(ATIndex,1)
        k = THERING{ATIndex(i,1)}.K * (1 + .005*rand);
        for j = 1:size(ATIndex,2)
            THERING{ATIndex(i,j)}.K = k;
            THERING{ATIndex(i,j)}.PolynomB(2) = k;
        end
    end
end



% Add quadrupole offsets
RMSDisplacement = 100e-6; % meters
Families = {'Q1','Q2','Q3','Q4','Q5','Q1L','Q2L','Q3L','Q4L','Q5L'};
for iFamily = 1:length(Families)
    ATIndex = family2atindex(Families{iFamily});
    for i = 1:size(ATIndex,1)
        Xshift = RMSDisplacement * randn(1);
        Yshift = RMSDisplacement * randn(1);
        for j = 1:size(ATIndex,2)
            setshift(ATIndex(i,j), Xshift, Yshift);
        end
    end
end


% Add sextupole offsets
RMSDisplacement = 100e-6; % meters
Families = {'SF','SD','S1','S2','S3','S4','S5','S6'};
for iFamily = 1:length(Families)
    ATIndex = family2atindex(Families{iFamily});
    for i = 1:size(ATIndex,1)
        Xshift = RMSDisplacement * randn(1);
        Yshift = RMSDisplacement * randn(1);
        for j = 1:size(ATIndex,2)
            setshift(ATIndex(i,j), Xshift, Yshift);
        end
    end
end


fprintf('   NOTE: use savethering to save this new lattice.\n');


