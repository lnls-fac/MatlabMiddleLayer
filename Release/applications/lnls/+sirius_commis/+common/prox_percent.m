function p = prox_percent(a, b)
p = zeros(length(a), 1);

for j = 1:length(a)
    p(j) = 1 - abs(a(j) - b(j)) / max(abs(a(j)),abs(b(j)));
end
p = abs(p)*100;

if isnan(p)
    p = 100;
end
end

