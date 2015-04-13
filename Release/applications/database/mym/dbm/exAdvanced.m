
con_img = ImageDB('USER', 'root', 'PASSWORD', 'sql123', 'SCHEMA', 'test');
con_img = tableNew(con_img, 'bal');
id      = itemNew(con_img, [], [], 'DIRECTORY', 'D:\images\bal');
img     = itemGet(con_img, id(10));

% base filters
con_filter = FilterDB('USER', 'root', 'PASSWORD', 'sql123', 'SCHEMA', 'test');
con_filter = tableNew(con_filter, 'base_filters');
id_grey    = itemNew(con_filter, @rgb2gray, 'grey');
id_gnoise  = itemNew(con_filter, @(I, par)imnoise(I, 'gaussian', par(1), par(2)), 'gnoise');
id_spnoise = itemNew(con_filter, @(I, par)imnoise(I, 'salt & pepper', par), 'spnoise');

% parametric filters
con_parfilter = ParFilterDB('USER', 'root', 'PASSWORD', 'sql123', 'SCHEMA', 'test');
con_parfilter = tableNew(con_parfilter, 'par_filters', con_filter);
id_gnoise_1   = itemNew(con_parfilter, [0 0.01], [], 'gnoise');
id_gnoise_2   = itemNew(con_parfilter, [-0.5 0.02], [], 'gnoise');
id_spnoise_1  = itemNew(con_parfilter, 0.1, [], 'spnoise');
fct_noise     = itemGet(con_parfilter, [id_gnoise_1 id_gnoise_2 id_spnoise_1]);

for i = 1:numel(fct_noise)
  figure(i), imshow(fct_noise{i}(img{1}))
end

con_parfilter
con_parfilter = tableDrop(con_parfilter, 'par_filters');
con_parfilter = close(con_parfilter);
con_filter    = tableDrop(con_filter, 'base_filters');
con_filter    = close(con_filter);
con_img       = tableDrop(con_img, 'bal');
con_img       = close(con_img);

