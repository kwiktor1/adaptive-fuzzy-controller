function Rc = commonregion(Ri)   

% find common region

t1 = array2table(Ri{1});

for k = 1:size(Ri,2)-1
    t2 = array2table(Ri{k+1});
    t1 = intersect(t1,t2);
end

Rc = table2array(t1);
