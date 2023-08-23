function J = StaticOptCF(x)

global a p

J = 0;
for i = 1:length(x)
    J = J + (a(i)*x(i))^p;
end

end