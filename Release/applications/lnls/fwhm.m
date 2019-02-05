function [sigma, ymax] = fwhm(x, y)

halfmax = max(y)/ 2; 
ind1 = find(y >= halfmax, 1, 'first'); 
ind2 = find(y >= halfmax, 1, 'last'); 
sigma = x(ind2) - x(ind1);

ymax = x(y == max(y));

end