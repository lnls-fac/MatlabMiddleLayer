function test

global MR;
global THERING;

lnls1;

corretor_family = 'HCM';
device_list = getfamilydata(corretor_family, 'DeviceList');
setpv(corretor_family,0);

setcavity('on');
setradiation('off');

clear global MR;

if exist('MR', 'var') && ~isempty(MR)
    mr = MR;
else
for i=1:size(device_list,1)
    setpv(corretor_family, 0.0001, device_list(i,:));
    %orbit = findorbit6(THERING, 1:length(THERING));
    %mr(:,i) = orbit(1,:)'/0.0001;
    orbit = getx;
    %orbit(6) = [];
    mr(:,i) = orbit / 0.1;
    setpv(corretor_family, 0, device_list(i,:));
end
MR = mr;
end


%mr = [1 2; 4 5; 1 3];

[u s v] = svd(mr, 'econ');

mc = v * inv(s) * u';
mc(:,6) = 0;

A = mr * mc;
R = eye(size(A,1)) - A;

plot(sqrt(sum(R'.^2)))

