function lnls1_quad_shunts_on(varargin)
%Liga os shunts dos quadrupolos.
%
%História: 
%
%2010-09-13: comentários iniciais no código.
%


r.timeout = 2.0; % segundos

if (nargin == 0)
    DeviceList = getfamilydata('QUADSHUNT', 'DeviceList');
else
    quads = varargin{1};
    for i=1:size(quads,1)
        DeviceList(i,:) = common2dev(quads(i,:), 'QUADSHUNT');
    end
end
nr_shunts = size(DeviceList,1);


setpv('QUADSHUNT', 'OnOffSP', 1, DeviceList);

t0 = clock;
timeout = (etime(clock, t0) >= r.timeout);
nr_shunts_on = sum(getpv('QUADSHUNT', 'OnOffSP', DeviceList));
while ~(nr_shunts_on == nr_shunts) && ~timeout
    timeout = (etime(clock, t0) >= r.timeout);
    nr_shunts_on = sum(getpv('QUADSHUNT', 'OnOffSP', DeviceList));
    sleep(r.timeout/20);
    drawnow;
end
if timeout
    error('lnls1_quad_shunts_on: not all quad shunts were turned on before timeout.');
end