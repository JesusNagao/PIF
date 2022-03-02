using Plots

const n = 1000
const z0 = 80.0
const w0 = 0.0
const rho_obj = 1025.5
const dt = 1.0
const g = 9.8
const R = 0.002

function rho(y::Float64)

    r = -0.01*y+1026

    return r

end

function correr()

    z = Array{Float64}(undef, 1, n)
    w = Array{Float64}(undef, 1, n)

    z[1] = z0;
    w[1] = w0;

    for i in range(1, stop=n-1)
        if(z[i]>0.0)
            w[i+1] = (w[i] - dt*g*(rho_obj-rho(z[i]))/rho_obj)/(1+R*dt)
            z[i+1] = z[i] + dt*w[i+1]
        else
            z[i+1] = 0.0
        end

    end

    animate(z)

end

function animate(z)

    
    p = plot()
    ylims!(-10.0, z0+10.0)
    xlims!(-0.1, 0.1)

    @gif for i in range(1, stop=n)

        scatter!(p, [0], [z[i]], legend=false)

    end


end

@time correr()