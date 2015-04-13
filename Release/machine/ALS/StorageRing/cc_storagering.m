function cc_storagering
% CC_STORAGERING - "Compiles" all the storage ring applications to run standalone

DirStart = pwd;
gotocompile('StorageRing');
cc_standalone('plotfamily');
cc_standalone('srcontrol');
cc_standalone('locogui');
cc_standalone('archive_sr');
cc_standalone('mysqldatalogger');
cc_standalone('alslaunchpad');
cd(DirStart);
