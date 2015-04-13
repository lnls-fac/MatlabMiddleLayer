function r = lnlsasciidb_load_default_parameters

r.ascii_db_path             = 'C:\Arq\Controle\LNLSAscIIDB';
r.ascii_db_backup_path      = 'C:\Arq\Controle\LNLSAscIIDB\backup';
r.mat_db_path               = 'C:\Arq\Controle\LNLSAscIIDB\archive';
r.queries_path              = 'C:\Arq\Controle\LNLSAscIIDB\queries';
r.srvcmd_path               = 'C:\Arq\Controle\LNLSAscIIDB\srvcmd';
r.srvlogs_path              = 'C:\Arq\Controle\LNLSAscIIDB\srvlogs';

r.update_archive_interval   = 30;
r.db_ascii_file_ext         = '.txt';
r.cfile_time_interval       = 5;
r.record_period             = 1;
r.small_nr_fields           = 28;
r.value_types               = {'double', 'single', 'uint32', 'int32' , 'uint16', 'int16', 'uint8', 'int8'};
