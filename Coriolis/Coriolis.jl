include("Animate.jl")

it = 100

u = Array{Float64}(undef, 1, it+1)
v = Array{Float64}(undef, 1, it+1)
x = Array{Float64}(undef, 1, it+1)
y = Array{Float64}(undef, 1, it+1)

u[1] = 1.0
v[1] = 1.0
x[1] = 0.0
y[1] = 0.0


T = 20
phi = -pi/2
omega = 2*pi/T
f = 2*omega*sin(phi)
dt = 0.1
a = dt*f
b = 0.25*a^2


Animate(x, y, u, v, it, a, b, dt)
