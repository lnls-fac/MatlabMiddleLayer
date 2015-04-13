function the_ring = load_lattice_model(flags)

global THERING;
sirius;
if any(strcmpi(flags, 'cod6d'))
    setcavity('on'); setradiation('on');
else
    setcavity('off'); setradiation('off');
end
the_ring = THERING;