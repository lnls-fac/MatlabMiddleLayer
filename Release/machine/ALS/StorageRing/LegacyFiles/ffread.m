function ffread(Sector)
%  ffread(Sector)
%
%  This function forces a table read on the feed forward compensation
%  the next time feed forward is turned on.  Sector is the insertion device 
%  list.
%


alsglobe


% Check input
if nargin < 1
   Sector = IDlist(:,1);
end


% Column vector
if size(Sector, 2) == 1
   % input OK
elseif size(Sector, 2) == 2
   Sector = dev2elem('IDpos', Sector);
else
   error('Input must be an element list [one column] or device list [two columns]');
end


% CA calls
for i = 1:length(Sector)
   if Sector(i) == 5
      ChannelName = sprintf('sr%02dw:FFRead:bo', Sector(i));
      
   else
      ChannelName = sprintf('sr%02du:FFRead:bo', Sector(i));
   end
   
   scaput(ChannelName, 1);
end
