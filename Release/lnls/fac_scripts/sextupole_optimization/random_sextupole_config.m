function r = random_sextupole_config(p)

r = p;
parents = randi(length(r.configs),1,2);
gene    = randi(r.nr_parms,1,1);
coefs   = 2 * 2 * (rand(1,2)-0.5);
values1  = r.configs{parents(1)}.values;
values2  = r.configs{parents(2)}.values;
values   = values1;
values(gene) = coefs(1) * values1(gene) + coefs(2) * values2(gene);
r.values = values;
r.spread = calc_tune_spread(r);