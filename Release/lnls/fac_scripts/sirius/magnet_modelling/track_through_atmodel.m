function r = track_through_atmodel(at_model, track, s_max)

% initial conditions
pts0 = zeros(length(track.px)*length(track.rx),6);
for i=1:length(track.px)
    for j=1:length(track.rx)
       pts0((i-1)*length(track.rx)+j,:) = [track.rx(j) track.px(i) 0 0 0 0];
    end
end

% adds drift space to model
dl = s_max - sum(getcellstruct(at_model, 'Length', 1:length(at_model)));
if (dl > 0),
    e = drift(at_model{1}.FamName, dl, 'DriftPass');
    lat = buildlat([e]);
end
at_model_tmp = [at_model lat(1)];

pts1 = zeros(size(pts0));
for i=1:size(pts0,1)
    pts1(i,:) = linepass(at_model_tmp, pts0(i,:)');
end

r.rx = track.rx;
r.px = track.px;
r.in_pts  = pts0;
r.out_pts = pts1;