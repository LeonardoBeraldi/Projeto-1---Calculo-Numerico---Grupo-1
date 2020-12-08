using Plots
gr(size=(600,400))



a = [1996:2018]
b = [80300000, 83329500, 86285000, 89582710, 90906000, 91291000, 92855000, 92465000, 91093000, 
     93626554, 92588000, 93744250, NaN, 100011080, 103528800, 106171400, 108047380, 108479780, 
     110984100, 106830880, 107527420, 198129700, 198084400]
layout = grid(2, 2)
p = plot(layout=layout)
scatter!(p[1], a, b, leg=false)
bar!(p[2], a, b, leg=false)
plot!(p[3], a, b, leg=false)



n = 20
x = [1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016]
y = [80300000, 83329500, 86285000, 89582710, 90906000, 91291000, 92855000, 92465000, 
     91093000, 93626554, 92588000, 93744250,100011080, 103528800, 106171400, 108047380,
     108479780, 110984100, 106830880, 107527420]
M11 = n
M12 = M21 = sum(x)
M22 = sum(x .^ 2)
c1 = sum(y)
c2 = sum(x .* y)
M = [M11 M12; M21 M22]
c = [c1; c2]
sol = M \ c

b0, b1 = sol[1], sol[2]
scatter(x, y, leg=false, c=:blue, ms=4, xlim = (1996,2017))
#plot!(x -> b0 + b1 * x, c=:red, lw=2, xlim = (1996,2016))
#E(b0, b1) = sum((y[i] - b0 - b1 * x[i]) ^ 2 for i =1:n)/2


E(b0, b1) = sum((y[i] - b0 - b1 * x[i]) ^ 2 for i =1:n)/2
scatter(x, y, leg=false, c=:blue, ms=4, xlim = (1996,2017))
f(x) = b0 + b1*x
y_pred = f.(x)
y_med = mean(y)
R2 = 1 - norm(y_pred - y)^2 / norm(y_med .- y)^2
plot!(x -> b0 + b1 * x, c=:red, lw=2, xlim = (1996,2017))
title!("R2 = $R2")

f(x) = b0 + b1*x

using LinearAlgebra
F = [x->1, x -> x, x->-x^2, x->x^3, x-> sin(2π/12 *x), x->cos(2π/12*x)]
p = length(F)
M = zeros(p, p)
c = zeros(p)
for j = 1:p
    for k = 1:p
        M[j,k] = sum(F[j](x[i]) * F[k](x[i]) for i = 1:n)
    end
    c[j] = sum(y[i] * F[j](x[i]) for i = 1:n)
end
β = M \ c
h(x) = sum(F[j](x) * β[j] for j = 1:p)
r = y - h.(x)
SQR = norm(r)^2

scatter(x, y, c=:blue, ms=3, leg=false)
plot!(h, c=:red, lw=2, xlim = (1996,2050))
title!("SQR=$SQR")

function quadmin(x, y, F)         #####  Usar sempreeeee  #####
    n = length(x)
    p = length(F)
    M = zeros(p, p)
    c = zeros(p)
    for j = 1:p
        for k = 1:p
            M[j,k] = sum(F[j](x[i]) * F[k](x[i]) for i = 1:n)
        end
        c[j] = sum(y[i] * F[j](x[i]) for i = 1:n)
    end
    β = M \ c
    h(x) = sum(F[j](x) * β[j] for j = 1:p)
    return β, h
end

using LinearAlgebra     ## Anos X Consumo de água ##

x = [1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016]
y = [80300000, 83329500, 86285000, 89582710, 90906000, 91291000, 92855000, 92465000, 
     91093000, 93626554, 92588000, 93744250,100011080, 103528800, 106171400, 108047380,
     108479780, 110984100, 106830880, 107527420] 
F = [x->1, x -> x, x->-x^2, x->x^3, x-> sin(2π/12 *x), x->cos(2π/12*x)]   ### Meu modelo ###

β, modelo = quadmin(x, y, F)
y_pred = modelo.(x)
y_med = mean(y)
R2 = 1 - norm(y_pred - y)^2 / norm(y_med .- y)^2

scatter(x, y, c=:blue, ms=3, leg=false)
plot!(modelo, c=:red, lw=2, xlim = (1996,2020))
title!("R2 = $R2")

using Random, Statistics    ## Anos X reservatórios ##
x = 2009:2020
y = [89.45, 99.1, 99.28, 93.48, 94.9, 90.05, 99.6, 101.49, 97.41, 90.58, 92.77, 53.72]
F = [x -> 1, x-> x^2, x-> sin(2π/4*x), x->cos(2π/3*x), x-> sin(2π/6*x), x->cos(2π/6*x), x-> exp(x/1000), x-> exp(-x/10)]  

β, modelo = quadmin(x, y, F)
r = y - modelo.(x)
SQR = norm(r)^2
y_pred = modelo.(x)
y_med = mean(y)
R2 = 1 - norm(y_pred - y)^2 / norm(y_med .- y)^2

scatter(x, y, c=:blue, ms=3, leg=false) 
plot!(modelo, c=:red, lw=2, xlim = (2009,2020))
title!("R2 = $R2")

using Random, Statistics        ## Tirando 2020 ##
x = 2009:2019
y = [89.45, 99.1, 99.28, 93.48, 94.9, 90.05, 99.6, 101.49, 97.41, 90.58, 92.77]
F = [x -> 1, x-> x^2, x-> sin(2π/4*x), x->cos(2π/3*x), x-> sin(2π/6*x), x->cos(2π/6*x), x-> exp(x/1000), x-> exp(-x/10)]   ### Meu modelo ###

β, modelo = quadmin(x, y, F)
r = y - modelo.(x)
SQR = norm(r)^2
y_pred = modelo.(x)
y_med = mean(y)
R2 = 1 - norm(y_pred - y)^2 / norm(y_med .- y)^2

scatter(x, y, c=:blue, ms=3, leg=false) 
plot!(modelo, c=:red, lw=2, xlim = (2009,2020))
title!("R2 = $R2")

using Random, Statistics     ## Quadrados mínimos sem 2020 mais acertivo##
x = 2009:2019
y = [89.45, 99.1, 99.28, 93.48, 94.9, 90.05, 99.6, 101.49, 97.41, 90.58, 92.77]
F = [x -> 1, x-> x^2, x-> sin(2π/4*x), x->cos(2π/4*x), x-> sin(2π/5*x), x->cos(2π/5*x), x-> sin(2π/3*x), x->cos(2π/3*x), x-> sin(2π/7*x), x->cos(2π/7*x)]   ### Meu modelo ###

β, modelo = quadmin(x, y, F)
r = y - modelo.(x)
SQR = norm(r)^2
y_pred = modelo.(x)
y_med = mean(y)
R2 = 1 - norm(y_pred - y)^2 / norm(y_med .- y)^2

scatter(x, y, c=:blue, ms=3, leg=false) 
plot!(modelo, c=:red, lw=2, xlim = (2009,2020))
title!("R2 = $R2")








