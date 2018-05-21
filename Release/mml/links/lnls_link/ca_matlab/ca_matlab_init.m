function ca_matlab_init

    import ch.psi.jcae.*;
    ca_context = Context();
  
    pvname = 'SI-Fam:PS-B1B2-1:Current-Mon';
    
    
    disp(ch.psi.jcae.ChannelBeanFactory)
%     ch.psi.jcae.ChannelBeanFactory.timeout = 10;
%     
%     ca_matlab_channels = containers.Map;
%     ca_matlab_channels(pvname) = Channels.create(ca_context, ChannelDescriptor('double', pvname, true));
%   
%     setappdata(0, 'ca_matlab_channels', ca_matlab_channels)