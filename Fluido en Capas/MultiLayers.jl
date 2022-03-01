using Plots;
include("MultiLayerOperation.jl")

n = 5 #Number of Layers

x = Array{Float64}([i for i in range(0.0, stop=1000.0, step=10)]);
y = Array{Float64}(undef, length(x));
u = Array{Float64}(undef, length(x));
h = Array{Float64}(undef, length(x));
layer = Array{Layer}(undef, n)

u[1] = 0;
u[length(x)] = 0;

const dx = 10.0;
const g = 9.8;
const h0 = 10.0;
const dt = 0.01;
it = 500;

gaussian(x, y, h, 500.0, 750.0)
init_Layers(layer, y, u, h)
@time animate(x, layer, it, g, dx, dt, 0.05, h0, n)
