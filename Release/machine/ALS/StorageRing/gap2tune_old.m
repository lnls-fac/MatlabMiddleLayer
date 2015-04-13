function [Dnuy, Beff, Bmax, Lambda, IDLength, B10, B30, B50] = gap2tune(Sector, Gap, GeV, FitFlag)
%GAP2TUNE - Computes the vertical tune shift for a insertion device gap change.
%           Harmonic B-contents based on E. Hoyer data and slightly corrected
%           to show the measured tune shifts (beta-function is hardcoded).
%
%  [Dnuy, Beff, Bmax, Lambda, IDLength] = gap2tune(Sector, Gap, GeV, FitFlag)
%
%  INPUTS
%  1. Sector - Insertion device list (i.e. [7 1])
%  2. Gap    - Gap [mm]
%  3. GeV    - Storage ring energy [GeV]
%  4. FitFlag -  0 - use magnet measurements curve fit
%             else - use curve fit to measured tune shift
%
%  OUTPUTS
%  1. Dnuy - Vertical tune shift
%  2. Beff - Effective field in T
%  3. Bmax
%  4. Lambda
%  5. IDLength
%  6. B10
%  7. B30
%  8. B50
%
%  See also shift2tune
%
%  Written by Winni Decking and Greg Portmann 

% Created: Winni Decking 98/10/10
% Added sector 4 and 5:  Greg Portmann 5-4-1999
% Added new middle layer functionality 2005-12-22


if nargin < 1
    Sector = [];
end
if isempty(Sector)
    Sector = family2dev('ID');
end

if nargin < 2
    Gap = [];
end
if isempty(Gap)
    Gap = getam('ID', Sector);
end

if nargin < 3
    GeV = [];
end
if isempty(GeV)
    GeV = getenergy;   % or getfamilydata('Energy'); to assume production energy
    %GeV = getfamilydata('Energy');
end

if nargin < 4
    FitFlag = 1;
end

if size(Sector,2) == 1
    Sector = elem2dev('ID', Sector);
end
if size(Sector,1) ~= size(Gap,1)
    if size(Gap,1) == 1
        Gap = ones(size(Sector,1),1) * Gap;
    else
        error('Rows of Sector & Gap must equal (or Gap must be a scalar or row vector).');
    end
end


BetaX = 13.5;
BetaY = 2.25;


for i = 1:size(Sector,1)

    if Sector(i,:) == [4 1]
        Lambda(i,1) = 50;
        IDLength(i,1) = 1.85;

        if FitFlag
            % B10(i,1) adjusted base on measured tunes (see data in \\Als-filer\physdata\matlab\srdata\gaptrack\tune)
            %      B10(i,1) = 1.9989;
            %      B30(i,1) = 0;
            %      B50(i,1) = 0;
            B10(i,1) = 1.9605;
            B30(i,1) = 4.7452;
            B50(i,1) = -0.0407;
        else
            B10(i,1) = 2.0365;
            B30(i,1) = 0.6677;
            B50(i,1) =-.0407;
        end

    elseif Sector(i,:) == 50     % old hybrid wiggler in sector 5 (1998-2004), W160
        Lambda(i,1) = 160;
        IDLength(i,1) = 3.04;

        if FitFlag
            % Data fit based on feed forward table and SR TUNE MATRIX, Christoph Steier, 2002-07-17
            B10(i,1) = 1.7459;
            B30(i,1) = 3.0735;
            B50(i,1) = -0.0015;
        else
            %B10(i,1) = 1.000;
            %B30(i,1) = 0.1796;
            %B50(i,1) = -0.0008;

            %B10(i,1) = 2.76;
            %B30(i,1) = 0.5;
            %B50(i,1) = -0.0022;

            B10(i,1) = 2.4066;
            B30(i,1) = 0.7352;
            B50(i,1) =-0.0138;
        end

    elseif Sector(i,:) == [5 1] % new W114 in sector 5, May 2004

        Lambda(i,1) = 114;
        IDLength(i,1) = 29*Lambda(i,1)/1000;

        if FitFlag
            % based on tune measurements 2004-06-03 ins srdata/insertiondevices/wiggler/W11
            B10(i,1) = 1.75;
            B30(i,1) = 3.6;
            B50(i,1) = 0;
        else
            %B10(i,1) = 1.000;
            %B30(i,1) = 0.1796;
            %B50(i,1) = -0.0008;

            %B10(i,1) = 2.76;
            %B30(i,1) = 0.5;
            %B50(i,1) = -0.0022;

            %    B10(i,1) = 2.7;
            %    B30(i,1) = 0;
            %    B50(i,1) = 0;

            B10(i,1) = 2.625;
            B30(i,1) = 0.06;
            B50(i,1) = 0.0;
        end

    elseif Sector(i,:) == [6 1]

        % based on Sumitomo measurements of peak field versus gap (11/17/2004)

        Lambda(i,1) = 30;
        IDLength(i,1) = 1.5;
        
        %if FitFlag
        %    % no beam measurement data yet ...
        %else
            B10(i,1) = 2.1257;
            B30(i,1) = 0.7071;
            B50(i,1) = 3.6900;
        %end
        
    elseif Sector(i,:) == [7 1]
        Lambda(i,1) = 50;
        IDLength(i,1) = 4.45;

        % B10(i,1) adjusted base on measured tunes (see data in \\Als-filer\physdata\matlab\srdata\gaptrack\tune)
        if FitFlag
            B10(i,1) = 2.0316;
            B30(i,1) = 3.7192;
            B50(i,1) =-.0407;
        else
            %B10(i,1) = 1.837;
            %B30(i,1) = 0.608;
            %B50(i,1) = -0.036;

            %B10(i,1) = 2.07;
            %B30(i,1) = 0.86;
            %B50(i,1) = -.04;

            B10(i,1) = 2.0365;
            B30(i,1) = 0.6677;
            B50(i,1) =-.0407;
        end

    elseif Sector(i,:) == [8 1]
        Lambda(i,1) = 50;
        IDLength(i,1) = 4.45;
        
        if FitFlag
            % B10(i,1) adjusted base on measured tunes (see data in \\Als-filer\physdata\matlab\srdata\gaptrack\tune)
            B10(i,1) = 1.9605;
            B30(i,1) = 4.7452;
            B50(i,1) = -0.0407;
        else
            B10(i,1) = 2.0365;
            B30(i,1) = 0.6677;
            B50(i,1) =-.0407;
        end

    elseif Sector(i,:) == [9 1]
        Lambda(i,1) = 100;
        IDLength(i,1) = 4.3;

        if FitFlag
            % B10(i,1) adjusted base on measured tunes (see data in \\Als-filer\physdata\matlab\srdata\gaptrack\tune)
            B10(i,1) = 2.0463;
            B30(i,1) = 1.9861;
            B50(i,1) = -0.0642;
        else
            % Better of ID9
            B10(i,1) = 2.0365;
            B30(i,1) = 0.7310;
            B50(i,1) =-0.0642;
        end

    elseif Sector(i,:) == [10 1]
        Lambda(i,1) = 100;
        IDLength(i,1) = 4.3;

        % B10(i,1) adjusted base on measured tunes (see data in \\Als-filer\physdata\matlab\srdata\gaptrack\tune)
        if FitFlag
            B10(i,1) = 1.7079;
            B30(i,1) = 2.2255;
            B50(i,1) = -0.0580;
        else
            % Better of ID10
            B10(i,1) = 1.837;
            B30(i,1) = 0.651;
            B50(i,1) =-0.058;

            %B10(i,1) = 2.02;
            %B30(i,1) = 0.76;
            %B50(i,1) =-0.07;
        end

    elseif Sector(i,:) == [11 1]         % information just copied from sector 4, should be replaced with real measurement data
        Lambda(i,1) = 50;
        IDLength(i,1) = 1.85;

        if FitFlag
            % B10(i,1) adjusted base on measured tunes (see data in \\Als-filer\physdata\matlab\srdata\gaptrack\tune)
            %      B10(i,1) = 1.9989;
            %      B30(i,1) = 0;
            %      B50(i,1) = 0;
            B10(i,1) = 1.9605;
            B30(i,1) = 4.7452;
            B50(i,1) = -0.0407;
        else
            B10(i,1) = 2.0365;
            B30(i,1) = 0.6677;
            B50(i,1) =-.0407;
        end

    elseif Sector(i,:) == [11 2]         % information just copied from sector 4, should be replaced with real measurement data
        Lambda(i,1) = 50;
        IDLength(i,1) = 1.85;

        if FitFlag
            % B10(i,1) adjusted base on measured tunes (see data in \\Als-filer\physdata\matlab\srdata\gaptrack\tune)
            %      B10(i,1) = 1.9989;
            %      B30(i,1) = 0;
            %      B50(i,1) = 0;
            B10(i,1) = 1.9605;
            B30(i,1) = 4.7452;
            B50(i,1) = -0.0407;
        else
            B10(i,1) = 2.0365;
            B30(i,1) = 0.6677;
            B50(i,1) =-.0407;
        end

    elseif Sector(i,:) == [12 1]
        Lambda(i,1) = 80;
        IDLength(i,1) = 4.4;

        % B10(i,1) adjusted base on measured tunes (see data in \\Als-filer\physdata\matlab\srdata\gaptrack\tune)
        if FitFlag
            B10(i,1) = 1.7763;
            B30(i,1) = 3.2908;
            B50(i,1) =-0.1355;
        else
            %B10(i,1) = 1.700;
            %B30(i,1) = 0.450;
            %B50(i,1) =-0.120;

            %B10(i,1) = 2.05;
            %B30(i,1) = 0.71;
            %B50(i,1) =-0.07;

            B10(i,1) = 1.8719;
            B30(i,1) = 0.5134;
            B50(i,1) =-0.1355;
        end

    else

        fprintf('   WARNING:  Unknown insertion, ID(%d,%d) (gap2tune).\n', Sector(i,:));
        Lambda(i,1) = NaN;
        IDLength(i,1) = NaN;
        B10(i,1) = NaN;
        B30(i,1) = NaN;
        B50(i,1) = NaN;
        
        %Dnuy = NaN;
        %Beff = NaN;
        %return
        
    end

    if nargout > 2
        Bmax(i,:) = B10(i)*exp(-pi*Gap(i,:)/Lambda(i)) + B30(i)*exp(-3*pi*Gap(i,:)/Lambda(i)) + B50(i)*exp(-5*pi*Gap(i,:)/Lambda(i));
    end

    Beff(i,:) = sqrt((B10(i)*exp(-pi*Gap(i,:)/Lambda(i))).^2 + (B30(i)*exp(-3*pi*Gap(i,:)/Lambda(i))).^2 + (B50(i)*exp(-5*pi*Gap(i,:)/Lambda(i))).^2);

    Dnuy(i,:) = 1/(8*pi)*BetaY*IDLength(i)*0.2998^2*(Beff(i,:)./GeV).^2;
end
