function Results = SpectrumSummary(Spectrum, EnergyRange)

Brightness = [];
for i=1:length(Spectrum.Energy)
    try
        if ~isempty(Spectrum.Energy{i})
            Brightness = [Brightness; interp1(Spectrum.Energy{i}, Spectrum.Brightness{i}, EnergyRange)];
        else
            Brightness = [Brightness; zeros(1,length(EnergyRange))];
        end
    catch
        disp('ok');
    end
end
sel = isnan(Brightness);
Brightness(sel) = 0;
Brightness = max(Brightness);
Results.Spectrum       = Spectrum;
Results.Energy         = EnergyRange;
Results.Brightness     = Brightness;
Results.MaxBrightness  = max(Brightness);
Results.MinBrightness  = min(Brightness);
Results.AvgBrightness  = mean(Brightness);
Results.CmpBrightness  = Results.AvgBrightness;
