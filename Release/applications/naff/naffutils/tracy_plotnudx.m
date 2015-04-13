function tracy_plotnudx(file1, file2)
% tracy_plotnudxT(file) - plot tuneshift with amplitude from tracy output file
%
%  INPUTS
%  1. file: filename to read

if nargin == 0
    data = tracy_readnudx;
else
    data = tracy_readnudx(file1, file2);
end

%% amplitude
x = data.x;
z = data.z;

%% fractional tunes
nux1 = data.nuxx;
nuz1 = data.nuzx;

nux2 = data.nuxz;
nuz2 = data.nuzz;

%% Set default properties
set(0,'DefaultAxesXgrid','on');
set(0,'DefaultAxesYgrid','on');

%% Plot
%figure(43)
figure
clf('reset');
subplot(2,2,1)
plot(x,nux1,'.')
xlabel('x (mm)')
ylabel('\nu_x')

subplot(2,2,3)
plot(x,nuz1,'.')
xlabel('x (mm)')
ylabel('\nu_z')

subplot(2,2,2)
plot(z,nux2,'.')
xlabel('z (mm)')
ylabel('\nu_x')

subplot(2,2,4)
plot(z,nuz2,'.')
xlabel('z (mm)')
ylabel('\nu_z')

addlabel(0,0,datestr(now))
