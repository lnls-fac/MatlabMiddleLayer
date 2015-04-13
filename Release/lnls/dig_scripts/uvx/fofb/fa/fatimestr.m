function timestampstr = fatimestr(timestamp)

days = floor(timestamp*24*60*60)/60/60/24;
useconds = floor(rem(timestamp*24*60*60, 1)*1e6);
timestampstr = sprintf('%s.%06d', datestr(days, 'yyyy/mm/dd HH:MM:SS'), useconds);