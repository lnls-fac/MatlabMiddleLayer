function [the_ring, ATCavityIndex] = setcavity(InputString, the_ring0)
%SETCAVITY - Set the RF cavity state
%  ATCavityIndex = setcavity(InputString)
%  [ the_ring, ATCavityIndex] = setcavity(InputString, the_ring0)
%
%  INPUTS
%  1. 'On', 'Off', or PassMethod {Default: no change}
%  2. the_ring ring where the cavity state must be set.
%
%  OUTPUTS
%  1. ATCavityIndex - AT Index of the RF cavities
%  2. the_ring - ring with the cavity set
%
%  NOTES
%  1. For more than one cavity, the InputString can have more than one row.
%
%  See also getcavity, setradiation

%  Written by Greg Portmann
%  modified by Ximenes (2013-04-17) so that user may specify a AT model
%  modified by Fernando (2015-01-29 so that the_ring is the first output
%  other than THERING

global THERING

if nargin == 0
    InputString = '';
end

if ~exist('the_ring0', 'var')
    the_ring = THERING; 
else
    the_ring = the_ring0;
end;

ATCavityIndex = findcells(the_ring, 'Frequency');

if isempty(InputString)
    return;
end

if isempty(ATCavityIndex)
    %fprintf('   No cavities were found in the lattice (setcavity).\');
    return
end


ATCavityIndex =ATCavityIndex(:)';
for iCavity = 1:length(ATCavityIndex)

    if size(InputString,1) == 1
        CavityString = deblank(InputString);
    elseif size(InputString,1) == length(ATCavityIndex)
        CavityString = deblank(InputString(iCavity,:));
    else
        error('Number of rows in the input string must be 1 row or equal to the number of cavities.');
    end        
    
    if strcmpi(CavityString,'off')
            if the_ring{ATCavityIndex(iCavity)}.Length == 0;
                the_ring{ATCavityIndex(iCavity)}.PassMethod = 'IdentityPass';
            else
                the_ring{ATCavityIndex(iCavity)}.PassMethod = 'DriftPass';
            end

    elseif strcmpi(CavityString,'on')

            %if the_ring{ATCavityIndex(iCavity)}.Length == 0;
            %    the_ring{ATCavityIndex(iCavity)}.PassMethod = 'ThinCavityPass';
            %else
                the_ring{ATCavityIndex(iCavity)}.PassMethod = 'CavityPass';
            %end
            
    else
        the_ring{ATCavityIndex(iCavity)}.PassMethod = CavityString;
    end
end

if ~exist('the_ring0', 'var')
    THERING = the_ring;
end;