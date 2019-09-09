function p = prox_percent(a, b)
p = zeros(length(a), 1);
dif = length(a) - length(b);

if dif ~= 0
    error('Vectors must be the same size');
end

erro_percent = (a - b) ./ max(abs(a), abs(b));

p = (1 - abs(erro_percent))*100;

if isnan(p)
    p = 100;
end
end

