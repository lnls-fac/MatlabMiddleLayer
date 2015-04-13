function surfstairs(axis, X,Y,Z)

if nargin == 2
    Z = X;
    X = 1:size(Z,2);
    Y = 1:size(Z,1);    
end

X_ = zeros(2*length(X),1);
Y_ = zeros(2*length(Y),1);

if length(X) > 1
    diff_X = [(X(2:end)-X(1:end-1)) (X(end)-X(end-1))];
else
    diff_X = X;
end
X_(1:2:end-1) = X - diff_X + diff_X/100;
X_(2:2:end) = X;

if length(Y) > 1
    diff_Y = [(Y(2:end)-Y(1:end-1)) (Y(end)-Y(end-1))];
else
    diff_Y = Y;
end
Y_(1:2:end-1) = Y - diff_Y + diff_Y/100;
Y_(2:2:end) = Y;

Z_ = zeros(2*size(Z));
Z_(1:2:end-1, 1:2:end-1) = Z;
Z_(2:2:end, 1:2:end-1) = Z;
Z_(1:2:end-1, 2:2:end) = Z;
Z_(2:2:end, 2:2:end) = Z;

surf(axis, X_,Y_,Z_);