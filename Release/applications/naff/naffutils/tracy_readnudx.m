function data = tracy_readnudx(file1,file2)
%  tracy_readnudx(file) - Reads tuneshift with amplitude from tracy output file 
% 
%
%  1. data: data read from Tracy output file with subfields
%      data.nuxx, nudxz, nudzz, nudzx tuneshift with amplitude
%      data.x,z horizotal and vertical amplitude
%
%  See Also tracy_plotnudx


%
%% Written by Laurent S. Nadolski

if nargin < 2
    file1 ='nudx.out';
    file2 ='nudz.out';
end

try
    [header data1] = hdrload(file1);
catch
    error('Error while opening filename %s',file1)
end

try
    [header data2] = hdrload(file2);
catch
    error('Error while opening filename %s',file2)
end

%% amplitude
data.x = data1(:,1)*1e3;
data.z = data2(:,2)*1e3;

%% fractional tunes
data.nuxx = data1(:,3);
data.nuzx = data1(:,4);
data.nuxx(data.nuxx==0)=NaN;
data.nuzx(data.nuzx==0)=NaN;

data.nuxz = data2(:,3);
data.nuzz = data2(:,4);
data.nuxz(data.nuxz==0)=NaN;
data.nuzz(data.nuzz==0)=NaN;
