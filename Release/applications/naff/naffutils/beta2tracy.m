function beta2tracy
% beta2tracy - Function for convering a beta lattice into a input tracy file

%
%% Written by Laurent S. Nadolski

% TODO
%  tested on Diamond file, need to test on SOLEIL file
%  need to add special flag for soleil or generic (cf. slicing of elements and so on).
%  To do for all elements
%  To do for all parameters of all elements...

fullFlag = 1; % expand the full lattice if periodicity
DebugFlag =0;

fileBeta='DLS713_NLBDWS.str';

% Open beta file in read access only
fid = fopen(fileBeta, 'r');

% Determine the number of line of file
fileLineNumber = 0;
chunksize = 1e6;
while ~feof(fid)
    ch = fread(fid, chunksize, '*uchar');
    if isempty(ch)
        break
    end
    fileLineNumber = fileLineNumber + sum(ch == sprintf('\n'));
end

frewind(fid);


% read BETA file and construct a structure
% create the structure with the right size;
fileStruct(fileLineNumber).tline = 'end of file';

for k=1:fileLineNumber,
    fileStruct(k).tline = fgetl(fid); % read line
end

fclose(fid);

%% 
for k =1:fileLineNumber,
    if ~isempty(regexp(fileStruct(k).tline,'\*\*\* AUTHOR \*\*\*', 'once'))
        authorStr = fileStruct(k+1).tline;
    end
    if ~isempty(regexp(fileStruct(k).tline,'\*\*\* TITRE \*\*\*', 'once'))
        titleStr = fileStruct(k+1).tline;
    end
    if ~isempty(regexp(fileStruct(k).tline,'\*\*\* PERIOD \*\*\*', 'once'))
        periodNumber = str2double(regexp(fileStruct(k+1).tline,'\s*(\d*)', 'match'));
    end
    if ~isempty(regexp(fileStruct(k).tline,'\*\*\* ENERGIE CINETIQUE \(MeV\) \*\*\*', 'once'))
        energy = str2double(regexp(fileStruct(k+1).tline,'\s*[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)', 'match'));       
    end
    if ~isempty(regexp(fileStruct(k).tline,'\*\*\* LIST OF ELEMENTS \*\*\*', 'once'))
        elemNumber = str2double(regexp(fileStruct(k+1).tline,'\s*(\d*)', 'match'));
        elemNumberLine = k + 1;
    end
    if ~isempty(regexp(fileStruct(k).tline,'\*\*\* STRUCTURE \*\*\*', 'once'))
        structureLineNumber = fix(str2double(regexp(fileStruct(k+1).tline,'\s*(\d*)', 'match'))/6);
        structureLine = k+2;
    end
%     if ~isempty(regexp(fileStruct(k).tline,'\*\*\* OPTION \*\*\*', 'once'))
%         optionStr = regexp(fileStruct(k+1).tline,'\s*(\d*)', 'match');
%         optionLine = k+2;
%     end
end


% Numeric expression
%nE = '[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?';

%%
k = 1;

while k <= elemNumber,
    %fileStruct(elemNumberLine+k).tline
    if ~isempty(regexp(fileStruct(elemNumberLine+k).tline, ' SD ', 'once'));
        fileStruct(elemNumberLine+k).elem = regexp(fileStruct(elemNumberLine+k).tline, '\s*(?<name>\w*)\s*(?<type>\w*)\s*(?<length>[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)', 'names');
    elseif ~isempty(regexp(fileStruct(elemNumberLine+k).tline, ' OB', 'once'))
        fileStruct(elemNumberLine+k).elem = regexp(fileStruct(elemNumberLine+k).tline, '\s*(?<name>\w*)\s*(?<type>\w*)', 'names');
    elseif ~isempty(regexp(fileStruct(elemNumberLine+k).tline, ' QP ', 'once'))
        fileStruct(elemNumberLine+k).elem = regexp(fileStruct(elemNumberLine+k).tline, '\s*(?<name>\w*)\s*(?<type>\w*)\s*(?<length>[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)\s*(?<strength>[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)\s*(?<temp1>[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)', 'names');
    elseif ~isempty(regexp(fileStruct(elemNumberLine+k).tline, ' SX ', 'once'))
        fileStruct(elemNumberLine+k).elem = regexp(fileStruct(elemNumberLine+k).tline, '\s*(?<name>\w*)\s*(?<type>\w*)\s*(?<length>[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)\s*(?<strength>[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)\s*(?<temp1>[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)\s*(?<temp2>[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)', 'names');
    elseif ~isempty(regexp(fileStruct(elemNumberLine+k).tline, ' BH ', 'once'))
        fileStruct(elemNumberLine+k).elem = regexp(fileStruct(elemNumberLine+k).tline, '\s*(?<name>\w*)\s*(?<type>\w*)\s*(?<angle>[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)\s*(?<radius>[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)\s*(?<quadStrength>[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)\s*(?<sextuStrength>[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)\s*(?<edgeAngle>[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)', 'names');
        temp = regexp(fileStruct(elemNumberLine+k+1).tline, '\s*(?<fringeField>[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)\s*(?<edgeCurvature>[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)\s*(?<K2>[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)', 'names');
        fileStruct(elemNumberLine+k).elem.fringeField = temp.fringeField;
        fileStruct(elemNumberLine+k).elem.edgeCurvature = temp.edgeCurvature;
        fileStruct(elemNumberLine+k).elem.K2 = temp.K2;
        k = k+1;
    end
%     fileStruct(elemNumberLine+k).elem:
     k = k +1;
end

%% Start writing Tracy II input file

[pathstr, name] = fileparts(fileBeta);

fileTracy= [name '.lat'];

fid = fopen(fileTracy, 'w+');
fprintf(fid,'{*****************************************}\n');
fprintf(fid,'{*                                       *}\n');
fprintf(fid,'{* Lattice generated on %11s    *}\n', date);
fprintf(fid,'{*    using beta2tracy.m       *}\n');
fprintf(fid,'{*                             *}\n');
fprintf(fid,'{* %s *}\n', titleStr);
fprintf(fid,'{*                             *}\n');
fprintf(fid,'{* Author: %s *}\n', authorStr);
fprintf(fid,'{*                                       *}\n');
fprintf(fid,'{*****************************************}\n');
fprintf(fid,'\n');
fprintf(fid,'define lattice; \n\n');
fprintf(fid,'intmeth= 4; \n\n');
fprintf(fid,'{***** System parameters *****}\n\n');
fprintf(fid,'Energy= %f;    { GeV }\n', energy*1e-3);
fprintf(fid,'dP    = 1.0d-10;\n');
fprintf(fid,'CODeps= 1.0d-15;\n');
fprintf(fid,'\n');
fprintf(fid,'Nq=10; {Number of slices for quadrupoles} \n');
fprintf(fid,'NqSx=10; {Number of slices for sextupoles} \n\n');

fprintf(fid,'{*** Element list ***}\n\n');

for k =elemNumberLine+1:elemNumber+elemNumberLine,
    if isfield(fileStruct(k).elem, 'type')
        if DebugFlag
            fileStruct(k).elem
        end
        switch fileStruct(k).elem.type;
            case 'SD'
                fprintf(fid,'%s : drift, L= %f;\n', fileStruct(k).elem.name, ...
                    str2double(fileStruct(k).elem.length));
            case 'QP'
                fprintf(fid,'%s : quadrupole, L= %f, k = %f, method=intmeth, N=Nq;\n', fileStruct(k).elem.name, ...
                    str2double(fileStruct(k).elem.length), str2double(fileStruct(k).elem.strength));
            case 'SX'
                fprintf(fid,'%s : sextupole, L= %f, k = %f, method=intmeth, N=NqSx;\n', fileStruct(k).elem.name, ...
                    str2double(fileStruct(k).elem.length), str2double(fileStruct(k).elem.strength));
            case 'BH'
                length_ = str2double(fileStruct(k).elem.angle)*str2double(fileStruct(k).elem.radius);
                angle = str2double(fileStruct(k).elem.angle) * 180/pi; % Conversion in degrees
                fprintf(fid,'%s : bending, L= %f, T = %f, T1 = %f, T2 = %f, K = %f, N=4, method=intmeth;\n', fileStruct(k).elem.name, ...
                    length_, angle, angle/2, angle/2, str2double(fileStruct(k).elem.quadStrength));
            case 'OB'
                fprintf(fid,'%s : marker;\n', fileStruct(k).elem.name);
        end
    end
end

fprintf(fid,'\n{*** Special markers***} \nSTART : marker;\n');
fprintf(fid,'FIN : marker;\n');


fprintf(fid,'\n\n{*** Superperiods ***}\n\n');

fprintf(fid,'PERIOD: START,\n');
for k = structureLine:structureLine+structureLineNumber-1;
    rep = regexp(fileStruct(k).tline,'\w*','match');
    fprintf(fid,'%s, ', rep{:});
    fprintf(fid,'\n');
end
fprintf(fid,'FIN;\n');

if fullFlag
    fprintf(fid,'\n\nRING: %d*PERIOD;\n', periodNumber);
else
    fprintf(fid,'\n\nRING: PERIOD;\n');
end


fprintf(fid,'\n{***** Define CELL structure ****}\n');
if fullFlag
    fprintf(fid,'CELL:	RING, symmetry = 1;\n\n');
else
    fprintf(fid,'CELL:	RING, symmetry = %d;\n\n', periodNumber);
end
fprintf(fid,'end;\n');

fclose(fid);


system(['nedit ' fileTracy ' &']);

