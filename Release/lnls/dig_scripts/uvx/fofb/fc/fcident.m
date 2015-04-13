function varargout = fcident(varargin)

ncols = 50;

if ischar(varargin{1}) && strcmpi(varargin{1}, 'init')
    npts_packet = varargin{2};
    expinfo = varargin{3};
    expout = [];
    
    if strcmpi(expinfo.excitation, 'prbs') || strcmpi(expinfo.excitation, 'prbs2d') || strcmpi(expinfo.excitation, 'multisine')
        nperiods = floor(expinfo.duration*npts_packet/expinfo.period);
    end

    if strcmpi(expinfo.excitation(end-1:end), '2d')
        maxnonzero = 0;
        for i=1:size(expinfo.profiles,1)
            nonzero = length(find(expinfo.profiles(i,:) ~= 0));
            if nonzero > maxnonzero
                maxnonzero = nonzero;
            end
        end
    end
    
    if strcmpi(expinfo.excitation, 'step')
        step_duration = expinfo.duration/2;
        fcdata = [-ones(npts_packet*floor(step_duration), 1); ones(npts_packet*ceil(step_duration), 1)];
    elseif strcmpi(expinfo.excitation, 'ramp')
        ramp_duration = expinfo.duration/2;
        fcdata = [repmat(linspace(0,1,npts_packet*floor(ramp_duration))', 1, 1); repmat(linspace(1,0,npts_packet*floor(ramp_duration))', 1, 1);];
    elseif strcmpi(expinfo.excitation, 'multisine')
        [fcdata, expout.freqs] = idinput([expinfo.period 1 nperiods], 'sine', expinfo.band, [-1 1], expinfo.sinedata);
    elseif strcmpi(expinfo.excitation, 'prbs')
        fcdata = idinput([expinfo.period 1 nperiods], 'prbs', expinfo.band, [-1 1]);
    elseif strcmpi(expinfo.excitation, 'prbs2d')
        fcdata = idinput([expinfo.period maxnonzero nperiods], 'prbs', expinfo.band, [-1 1]);
    elseif strcmpi(expinfo.excitation, 'sine2d')
        freqs = expinfo.freqs(:)';
        nfreqs = length(expinfo.freqs);
        phases = zeros(1,nfreqs); %linspace(0,1,nfreqs+1)*pi; phases = phases(1:end-1);
        npts = expinfo.duration*npts_packet;
        fcdata = sin(pi*repmat(freqs, npts, 1).*repmat((0:npts-1)', 1, nfreqs) + repmat(phases, npts, 1));
    end
    fcdata = [fcdata; zeros(npts_packet*expinfo.duration - size(fcdata,1), size(fcdata,2))];
    
    varargout = {fcdata, expout};
else
    i = varargin{1};
    npts_packet = varargin{2};
    expinfo = varargin{3};
    
    fprintf('packet #%d: ', i+1);
    
    profile_number = floor(i/(expinfo.duration + expinfo.pauselength)) + 1;

    i_ = rem(i,(expinfo.duration + expinfo.pauselength));

    if i_ < expinfo.pauselength
        packet = zeros(npts_packet, ncols);
        expinterval = true;
        fprintf('pause');
       
    else
        profile = expinfo.profiles(profile_number,:);

        fprintf('profile #%d', profile_number);
        fcdata = varargin{4};
        indices = ((i_ - expinfo.pauselength)*npts_packet+(1:npts_packet));
        cols = 1:size(profile,2);
        
        % Apply amplitude scaling and profile
        if strcmpi(expinfo.excitation(end-1:end), '2d')
            ix = find(profile ~= 0);
            fcdata_ = zeros(length(indices), size(expinfo.profiles,2));
            fcdata_(:, ix) = fcdata(indices,1:length(ix));
            packet = expinfo.amplitude*fcdata_.*repmat(profile,npts_packet,1);
        else
            fcdata_ = fcdata(indices);
            packet = expinfo.amplitude*fcdata_*profile;
        end
        
        % Zero-padding
        packet = [packet zeros(npts_packet, ncols-size(packet,2))];

        expinterval = false;
    end

    % Insert marker
    packet = [packet repmat(typecast(expinfo.marker, 'single'), size(packet,1),1)];
    
    fprintf('\n');
    varargout{1} = packet;
    varargout{2} = expinterval;
end