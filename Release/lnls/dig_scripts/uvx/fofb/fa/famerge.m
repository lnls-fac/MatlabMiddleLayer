function fadata = famerge(varargin)

fadata = varargin{1};

for i=2:length(varargin)
   fadata_ = varargin{i};
   fadata.bpm_readings = [fadata.bpm_readings; fadata_.bpm_readings];
   fadata.corr_readings = [fadata.corr_readings; fadata_.corr_readings];
   fadata.corr_setpoints = [fadata.corr_setpoints; fadata_.corr_setpoints];
   fadata.time = [fadata.time; (fadata_.time - fadata_.time(1) + 2*fadata.time(end) - fadata.time(end-1) )];
end
