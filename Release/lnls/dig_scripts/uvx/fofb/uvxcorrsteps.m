function corr_steps = uvxcorrsteps

acv = [19, 22, 23, 26, 27, 30, 31, 34, 35, 38, 39, 42];
alv = [20 21 24 25 28 29 32 33 36 37 40 41];
corr_steps = ones(1,42);
corr_steps(acv) = 1.00281;
corr_steps(alv) = 2.83146;