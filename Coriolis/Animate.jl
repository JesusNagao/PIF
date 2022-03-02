using Plots


p = plot()
ylims!(-5.0, 5.0)
xlims!(-5.0, 5.0)


function Animate(x, y, u, v, it, a, b, dt)


    @gif for n in range(1, stop = it)

        #Primer intento
        #u[n+1] = u[n] + dt*f*v[n]
        #v[n+1] = v[n] - dt*f*u[n]

        #Segundo intento
        u[n+1] = ((1-b)*u[n]+a*v[n])/(1+b)
        v[n+1] = ((1-b)*v[n]-a*u[n])/(1+b)

        #u[n+1]=cos(a)*u[n]+sin(a)*v[n]
        #v[n+1]=cos(a)*v[n]-sin(a)*u[n]


        x[n+1] = x[n] + dt*u[n+1]
        y[n+1] = y[n] + dt*v[n+1]


        scatter!(p, [x[n]], [y[n]], legend=false)

    end

end