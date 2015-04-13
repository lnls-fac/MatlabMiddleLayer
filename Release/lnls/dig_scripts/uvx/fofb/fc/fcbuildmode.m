function fcmode = fcbuildmode(mode)

if strcmpi(mode, 'corr_sum')
    fcmode = uint32(2);
elseif strcmpi(mode, 'orb_sum')
    fcmode = bitshift(uint32(2), 16);
else
    fcmode = uint32(0);
end
