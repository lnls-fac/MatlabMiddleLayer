function G = calc_G_from_B(B, Period, IDTech)

b = log(B / IDTech.Coeff);

if (IDTech.a2 == 0)
    G = Period * b / IDTech.a1;
else
    D = IDTech.a1^2 + 4 * b * IDTech.a2;
    r1 = (-IDTech.a1 + sqrt(D)) / 2 / IDTech.a2;
    r2 = (-IDTech.a1 - sqrt(D)) / 2 / IDTech.a2;
    G1 = Period * r1;
    G2 = Period * r2;
    G1((imag(G1) ~= 0)) = Inf;
    G2((imag(G2) ~= 0)) = Inf;
    G1((G1 <= 0)) = Inf;
    G2((G2 <= 0)) = Inf;
    G1((r1 <= IDTech.Limits(1))) = Inf; G1((r1 >= IDTech.Limits(2))) = Inf;
    G2((r2 <= IDTech.Limits(1))) = Inf; G2((r2 >= IDTech.Limits(2))) = Inf;
    G = min([G1; G2], [], 1);
    G((G == Inf)) = NaN; % Gaps inválidos
end