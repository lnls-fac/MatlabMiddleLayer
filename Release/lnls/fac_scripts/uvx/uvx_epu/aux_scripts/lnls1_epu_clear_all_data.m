function lnls1_epu_clear_all_data

try
    rmappdata(0, 'EPU_FIELD_DATA');
catch
end