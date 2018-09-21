function p = prox_percent(a, b)
p = 1 - abs(a - b) / max(abs(a),abs(b));
p = p*100;

if isnan(p)
    p = 100;
end
end

