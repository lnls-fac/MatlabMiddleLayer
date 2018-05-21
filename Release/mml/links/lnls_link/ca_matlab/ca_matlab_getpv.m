function Data = ca_matlab_getpv(ChannelName)

    ca_matlab_channels = getappdata(0, 'ca_matlab_channels');
    Data = ca_matlab_channels(ChannelName).get();
    

    