function galgomin

population1 = create_adam;
population1 = free_expansion(population1, pop_size);


hf1 = figure;
hg1 = figure;

generation = 0;

while true
    
    pause(0);
    drawnow;
    
    best1 = get_member(population1, 1);

    
    all_fitness1    = get_all_fitness(population1);
    all_DNA1        = get_all_DNA(population1);
         
    set(0,'CurrentFigure',hf1)
    plot(all_fitness1);
    
    for i=1:size(all_DNA1,1)
        v(i) = norm(all_DNA1(i,:));
    end
    
    set(0,'CurrentFigure',hg1)
    plot(v);
   
    fprintf('generation #%04i: POP1 best member with fitness %f (generation %f) \n', generation, get_fitness(best1), best1.generation);
    population1 = new_generation(population1, 10);
    %population1 = natural_selection(population1, pop_size);
     
    generation = generation + 1;
    
end

function r = new_generation(population, nr_elite)

r = {};
idx = 0;
pop_size = get_size(population);
for i=1:(pop_size-nr_elite)
    %i1 = randi(size);
    %i2 = randi(size);
    if (idx+1 > pop_size)
        idx = 1;
    else
        idx = 0;
    end 
    i1 = idx;
    i2 = idx + 1;
    parent1 = get_member(population, i1);
    parent2 = get_member(population, i2);
    child   = new_child(parent1, parent2);
    r = add_member(r, child);
end
for i=1:get_size(population)
    r = add_member(r, get_member(population,i));
end
r = hierarchy_sort(r);



function r = free_expansion(population, target_size)

r = population;
gen = max(get_all_generation(r));
size     = get_size(r);
DNA_size = length(get_DNA(get_member(r,1)));
while size < target_size
    child_DNA  = 4 * 2 * (rand(1,DNA_size)-0.5);
    parent     = get_member(r, randi(size));
    %parent_DNA = get_DNA(parent);
    %child_DNA  = (-1)^randi(2) * (1.5*rand(1,DNA_size) + 0.5) .* parent_DNA(randperm(length(parent_DNA)));
    child      = set_DNA(parent, child_DNA);
    fitness    = calc_fitness(child);
    child      = set_fitness(child, fitness);
    child.generation = gen + 1;
    r          = add_member(r, child);
    size       = get_size(r);
end
r = hierarchy_sort(r);

function r = hierarchy_sort(population)

rl = population;
size = get_size(rl);
for i=1:size
    all_fitness(i) = get_fitness(get_member(rl,i));
end
[vs is] = sort(all_fitness, 'descend');
for i=1:size
    r{i} = rl{is(i)};
end


function r = get_all_DNA(population)
size = get_size(population);
for i=1:size
    r(i,:) = get_DNA(get_member(population,i));
end


function r = get_all_generation(population)
size = get_size(population);
for i=1:size
    r(i) = population{i}.generation;
end


function r = get_all_fitness(population)
size = get_size(population);
for i=1:size
    r(i) = get_fitness(get_member(population,i));
end

function r = get_size(population)

r = length(population);


function r = new_child(parent1, parent2)

step = 1;
DNA1 = get_DNA(parent1);
DNA2 = get_DNA(parent2);

%r1 = 1 + 0.05 * 2 * (rand - 0.5);
%r2 = 0.05 * 2 * (rand-0.5);

r1 = 0.5 * 2 * (rand - 0);
r2 = 0.5 * 2 * (rand - 0);


child_DNA = r1 * DNA1 + r2 * DNA2;
r = set_DNA(parent1, child_DNA);
fitness = calc_fitness(r);
r = set_fitness(r, fitness);
r.generation = 1 + mean([parent1.generation parent2.generation]);

function r = get_DNA(member)

r = member.DNA;

function r = set_DNA(member, new_DNA)

r = member;
r.DNA = new_DNA;

function r = get_fitness(member)

r = member.fitness;

function r = set_fitness(member, fitness)

r = member;
r.fitness = fitness;

function r = get_member(population, index)

r = population{index};

function r = add_member(population, member)

r = population;
r{length(r)+1} = member;
r = hierarchy_sort(r);

function r = remove_member(population, index)

r = population;
r(index) = [];


%% specialized functions
%  ---------------------

function r = create_adam

r{1}.generation = 0;
r{1} = set_DNA(r{1}, 4 * 2*(rand(1,6) - 0.5));
fitness = calc_fitness(r{1});
r{1} = set_fitness(r{1}, fitness);

function r = calc_fitness(member)

s1 = [0 0 0 0 0 0];
s2 = [1 -1 1 -1 1 -1]/(sqrt(6));
s3 = [2 -2 2 -2 -2 -2]/(sqrt(6));
s4 = [3 3 3 -3 3 3]/(sqrt(6));

rs = [0.01 0.05 0.05 0.05];
DNA = get_DNA(member);

d1 = sum((DNA - s1).^2);
d2 = sum((DNA - s2).^2);
d3 = sum((DNA - s3).^2);
d4 = sum((DNA - s4).^2);

d12 = sum((s1 - s2).^2);
d13 = sum((s1 - s3).^2);
d14 = sum((s1 - s4).^2);
d23 = sum((s2 - s3).^2);
d24 = sum((s2 - s4).^2);
d34 = sum((s3 - s4).^2);

r = 0.01 + d2*d3*d4;

r = 1/r;


%r = (rs(1) * d2 * d3 * d4 + rs(2) * d1 * d3 * d4 + rs(3) * d1 * d2 * d4 + rs(4) * d1 * d2 * d3) / (d2 * d3 * d4 + d1 * d3 * d4 + d1 * d2 * d4 + d1 * d2 * d3);
%r = 1/r;

%r = 1/(rs(1) + sum(DNA.^2));