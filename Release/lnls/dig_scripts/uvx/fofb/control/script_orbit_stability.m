bpmidx=[1:5 7:25];

datarh = 100*data.bpm_readings(:,bpmidx)./repmat(sigmabpmx(bpmidx)', size(data.bpm_readings,1),1);
datarv = 100*data.bpm_readings(:,25+bpmidx)./repmat(sigmabpmy(bpmidx)', size(data.bpm_readings,1),1);

datarh_noise = 100*x(:,bpmidx)./repmat(sigmabpmx(bpmidx)', size(data.bpm_readings,1),1);
datarv_noise = 100*x(:,25+bpmidx)./repmat(sigmabpmy(bpmidx)', size(data.bpm_readings,1),1);


npts = 31250;
[Ah,fh] = psdrms(datarh,3125,0,500,rectwin(npts),0.7*npts,npts,'rms');
[Av,fv] = psdrms(datarv,3125,0,500,rectwin(npts),0.7*npts,npts,'rms');


Ahmin = min(Ah,[],2);
Ahmean = mean(Ah,2);
Ahstd = std(Ah,[],2);
Ahmax = max(Ah,[],2);

Avmin = min(Av,[],2);
Avmean = mean(Av,2);
Avstd = std(Av,[],2);
Avmax = max(Av,[],2);

figure;
loglog(fh,Ahmin,'--')
hold on
loglog(fh,Ahmax,'--')
loglog(fh,Ahmean)
loglog(fv,Avmin,'r--')
loglog(fv,Avmax,'r--')
loglog(fv,Avmean,'r')