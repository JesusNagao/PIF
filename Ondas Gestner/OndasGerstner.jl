using Plots
using Random
using Distributions
using LinearAlgebra

function meshgrid(x, y)
    X = [i for i in x, j in 1:length(y)]
    Y = [j for i in 1:length(x), j in y]
    return X, Y
end


default(legend = false)
x = y = range(-20, 20, length = 80)
zs = zeros(0, 40)
n = 200
global m=10

kx0=rand(Normal(0, 0.5), 1)
kx0 = dot(kx0[:,1], kx0[:, 1])
ky0=rand(Normal(0, 0.5), 1)
ky0 = dot(ky0[:,1], ky0[:, 1])
A0 = rand(Gamma(0.7,0.025),1)
A0 = dot(A0[:,1], A0[:, 1])
g = 9.8
D=0.1
k0 = sqrt(kx0^2+ky0^2)
w0 = sqrt(g*k0)

kx = rand(Normal(kx0, 0.5), m)
ky = rand(Normal(kx0, 0.5), m)
A = rand(Gamma(0.7,0.025),m)


k = Array{Float64, 1}(UndefInitializer(), m)
w = Array{Float64, 1}(UndefInitializer(), m)

for i=1:length(kx)
    k[i] = sqrt(kx[i]^2+ky[i]^2)
    w[i] = sqrt(g*k[i])
end


X,Y = meshgrid(x,y)

z=0
t=0

z = A0*sin.(X*kx0 .+ Y*ky0 .- w0*t)

@gif for t in range(0, stop = 20, length = n)
    for i = 1:length(kx)
        global z = z
        z += A[i]*sin.(X*kx[i] .+ Y*ky[i] .- w[i]*t)
    end

    p = surface(x,y,z)
end




