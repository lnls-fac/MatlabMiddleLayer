function r = myringpass(RING, p0, nr_turns)

physical_limit = 0.040;

r = [];
p = p0;
for i=1:nr_turns
    p = linepass(RING, p);
    if (any(isnan(p)) || any(abs(p([1 3])) >= physical_limit))
        for j=i:nr_turns
            r = [r NaN*[1 1 1 1 1 1]'];
        end
        break; 
    else
        r = [r p];
    end
    
end