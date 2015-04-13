function ID = set_ID(EBeam, IDTech, Period, Length)

ID.Period     = Period;
ID.Length     = Length;
ID.N          = ID.Length / ID.Period;
ID.MinGap     = 2 * (IDTech.ChamberThickness + IDTech.ChamberTolerance) + EBeam.MinGap * sqrt(1+(ID.Length/2/EBeam.BetaY)^2);
ID.Tech       = IDTech;

ID.MinGap = max([ID.MinGap ID.Tech.Limits(1) * ID.Period]); % Gap minimo limitado pela Tech do ID, e não pela aceitancia.

g_L = ID.MinGap / ID.Period;
if (g_L >= ID.Tech.Limits(2))
    ID.BMax = NaN;
else
    ID.BMax = IDTech.Coeff * exp(IDTech.a1 * g_L + ID.Tech.a2 * g_L^2);
end
ID.KMax = calc_K_from_B(ID.BMax,ID.Period);