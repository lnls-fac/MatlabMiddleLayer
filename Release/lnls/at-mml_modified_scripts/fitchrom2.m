function the_ring =  fitchrom2(the_ring, newchrom, sextfam1, sextfam2, varargin)
%fitchrom2 fits chromaticity  of the_ring using 2 sextupole families
% the_ring = fitchrom2(the_ring, NEWCHROM,SEXTUPOLEFAMILY1,SEXTUPOLEFAMILY2)

%make a column vector
newchrom = newchrom(:);
deltaS = 1e-3; % step size in Sextupole strength
deltaP = 1e-6;

% find indexes of the 2 quadrupole families use for fitting
S1I = findcells(the_ring,'FamName',sextfam1);
S2I = findcells(the_ring,'FamName',sextfam2);
InitialS1 = getcellstruct(the_ring,'PolynomB',S1I,3);
InitialS2 = getcellstruct(the_ring,'PolynomB',S2I,3);

% Compute initial tunes and chromaticities before fitting 

[ ~, InitialTunes] = linopt(the_ring,0);
[ ~, ITdP] =linopt(the_ring,deltaP);

InitialChrom = (ITdP-InitialTunes)/deltaP;

TempChrom = InitialChrom;
TempS1 = InitialS1; 
TempS2 = InitialS2;

for i=1:5
		
	% Take Derivative
	the_ring = setcellstruct(the_ring,'PolynomB',S1I,TempS1+deltaS,3);
	[~, Tunes_dS1 ] = linopt(the_ring,0);
	[~, Tunes_dS1dP ] = linopt(the_ring,deltaP);

	the_ring = setcellstruct(the_ring,'PolynomB',S1I,TempS1,3);
	the_ring = setcellstruct(the_ring,'PolynomB',S2I,TempS2+deltaS,3);
	[~, Tunes_dS2 ] = linopt(the_ring,0);
	[~, Tunes_dS2dP ] = linopt(the_ring,deltaP);
	the_ring = setcellstruct(the_ring,'PolynomB',S2I,TempS2,3);

	%Construct the Jacobian
	Chrom_dS1 = (Tunes_dS1dP-Tunes_dS1)/deltaP;
	Chrom_dS2 = (Tunes_dS2dP-Tunes_dS2)/deltaP;

	J = ([Chrom_dS1(:) Chrom_dS2(:)] - [TempChrom(:) TempChrom(:)])/deltaS;

	dchrom = (newchrom(:) - TempChrom(:));
	dS = J\dchrom;

	TempS1 = TempS1+dS(1);
	TempS2 = TempS2+dS(2);

	the_ring = setcellstruct(the_ring,'PolynomB',S1I,TempS1,3);
	the_ring = setcellstruct(the_ring,'PolynomB',S2I,TempS2,3);

	[~, TempTunes] = linopt(the_ring,0);
	[~, TempTunesdP] = linopt(the_ring,deltaP);
	TempChrom = (TempTunesdP-TempTunes)/deltaP;
    %disp(TempChrom);

end