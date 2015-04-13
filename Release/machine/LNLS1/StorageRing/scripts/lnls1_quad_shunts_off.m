function lnls1_quad_shunts_off(varargin)
%Desliga os shunts dos quadrupolos.
%
%História: 
%
%2010-09-13: comentários iniciais no código.
%

r.timeout = 2.0;

if (nargin == 0)
    DeviceList = getfamilydata('QUADSHUNT', 'DeviceList');
else
    quads = varargin{1};
    for i=1:size(quads,1)
        DeviceList(i,:) = common2dev(quads(i,:), 'QUADSHUNT');
    end
end
nr_shunts = size(DeviceList,1);

setpv('QUADSHUNT', 'OnOffSP', 0, DeviceList);

t0 = clock;
timeout = (etime(clock, t0) >= r.timeout);
nr_shunts_on = sum(getpv('QUADSHUNT', 'OnOffSP', DeviceList));
while ~(nr_shunts_on == 0) && ~timeout
    timeout = (etime(clock, t0) >= r.timeout);
    nr_shunts_on = sum(getpv('QUADSHUNT', 'OnOffSP', DeviceList));
    sleep(r.timeout/20);
    drawnow;
end
if timeout
    error('lnls1_quad_shunts_off: not all quad shunts were turned off before timeout.');
end