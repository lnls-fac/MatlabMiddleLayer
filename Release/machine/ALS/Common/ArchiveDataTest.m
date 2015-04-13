% need libreadline.so.5


javaaddpath(fullfile(getmmlroot,'applications','EPICS','ArchiveViewer','archiveviewer.jar'))
client = epics.archiveviewer.clients.channelarchiver.ArchiverClient();
client.connect('http://apps1.als.lbl.gov:8080/RPC2', []);
client.getServerInfoText()
 
x = client.getAvailableArchiveDirectories()

x(1).getName

y = client.search(x(1), 'cmm:beam_current', [])

z = client.getAVEInfo(y(1))

start_t = z.getArchivingStartTime()
end_t = z.getArchivingEndTime()

r = client.getRetrievalMethod('linear')

req_obj = epics.archiveviewer.RequestObject(start_t, end_t, r, 1000)

tic
data = client.retrieveData(y, req_obj, [])
toc

data(1).getNumberOfValues()
data(1).getValue(1)
data(1).getValue(2)
data(1).getValue(3)
data(1).getTimestampInMsec(3)



% >> javaaddpath(fullfile(matlabroot,'work','archiveviewer.jar'))
% 
% >> client = epics.archiveviewer.clients.channelarchiver.ArchiverClient();
% 
% >> client.connect('http://ees101/archive/cgi/ArchiveDataServer.cgi', []);
% 
% >> client.getServerInfoText()
% http://ees101/archive/cgi/ArchiveDataServer.cgi
% Server version: 0
% ----------------------------------------
% Description
% Channel Archiver Data Server V0,
% built Dec  7 2005, 10:04:55
% from sources for version 2.6.0
% Config: '/mnt/disk1/www/html/archive/serverconfig.xml'
% ----------------------------------------
% Methods
% average
% linear
% plot-binning
% spreadsheet
% raw
% 
% 
% 
% >> x = client.getAvailableArchiveDirectories()
% epics.archiveviewer.ArchiveDirectory[]:
%     [epics.archiveviewer.clients.channelarchiver.ArchiveInfo]
% 
% 
% >> x(1).getName
% Room128
% 
% >> y = client.search(x(1), 'gun_hv_volt_rdbk', [])
% epics.archiveviewer.AVEntry[]:
%     [epics.archiveviewer.clients.channelarchiver.CAEntry]
% 
% >> z = client.getAVEInfo(y(1))
% epics.archiveviewer.AVEntryInfo@86359
% 
% >> start_t = z.getArchivingStartTime()
% 1.1685e+012
% 
% >> end_t = z.getArchivingEndTime()
% 1.1713e+012
% 
% >> r = client.getRetrievalMethod('linear')
% linear
% 
% >> req_obj = epics.archiveviewer.RequestObject(start_t, end_t, r, 1000)
% epics.archiveviewer.RequestObject@80000003
% 
% >> data = client.retrieveData(y, req_obj, [])
% epics.archiveviewer.ValuesContainer[]:
%     [epics.archiveviewer.clients.channelarchiver.NumericValuesContainer]
% 
% >> data(1).getNumberOfValues()
% 248
% 
% >> data(1).getValue(1)
% [0.0]
% 
% >> data(1).getValue(2)
% [0.0]
% 
% >> data(1).getValue(3)
% [176.269315853876]
% 
% >> data(1).getTimestampInMsec(3)
% 1.1685e+012
