using Plots;
using Base.Threads;


mutable struct Layer
    y::Array{Float64}
    u::Array{Float64}
    h::Array{Float64}
end


function gaussian(x::Array{Float64}, y::Array{Float64}, h::Array{Float64}, mu::Float64, s::Float64)

    for i in range(1,stop=length(x))
        
        y[i] = exp(-((x[i]-mu)^2)/s);
        h[i] = exp(-((x[i]-mu)^2)/s);

    end

end

function init_Layers(l::Array{Layer}, y::Array{Float64}, u::Array{Float64}, h::Array{Float64})

    for i in range(1, stop=length(l))
        l[i] = Layer(y .+ 10.0*(i-1), u, h .+ 10.0*(i-2))
    end

end

function height(h::Array{Float64}, y::Array{Float64}, h0::Float64)

    for i in range(1, stop=length(h))

        h[i] = y[i] + h0;

    end

    return h
end

function animate(x::Array{Float64}, l::Array{Layer}, it::Int64, g::Float64, dx::Float64, dt::Float64, eps::Float64, h0::Float64, n::Int64)


    @gif for j in range(1, stop = it)
        

        for k in range(1, stop = n)
            p1 = scatter(x,l[k].y, title="Position")
            ylims!(-20.0, 100.0)
            xlims!(0.0, 1000.0)
            p2 = scatter(x,l[k].u, title="Velocity")
            ylims!(-20.0, 100.0)
            xlims!(0.0, 1000.0)
            p3 = scatter(x, l[k].h, title="Height")
            ylims!(-20.0, 100.0)
            xlims!(0.0, 1000.0)
            plot!(p1, p2, p3, layout=(3,1), legend=false)
            #plot(p1, legend=false)

            @threads for i in range(3, stop=length(y)-2)
                
                if i>49 && i<51
                    l[k].u[i] = 0;
                    up = 0.5*(l[k].u[i]+abs(l[k].u[i]));
                    um = 0.5*(l[k].u[i]-abs(l[k].u[i]));
                    up_ant = 0.5*(l[k].u[i-1]+abs(l[k].u[i-1]));
                    um_ant = 0.5*(l[k].u[i-1]-abs(l[k].u[i-1]));

                    np = l[k].y[i] - (dt/dx)*(up*l[k].h[i]+um*l[k].h[i+1]-up_ant*l[k].h[i-1]-um_ant*l[k].h[i]);
                    np_next = l[k].y[i+1] - (dt/dx)*(up*l[k].h[i+1]+um*l[k].h[i+2]-up_ant*l[k].h[i]-um_ant*l[k].h[i+1]);
                    np_ant = l[k].y[i-1] - (dt/dx)*(up*l[k].h[i-1]+um*l[k].h[i]-up_ant*l[k].h[i-2]-um_ant*l[k].h[i-1]);

                    l[k].y[i] = 0;

                else
                    l[k].u[i] = l[k].u[i]-(g*dt/dx)*(l[k].y[i+1]-l[k].y[i]);

                    up = 0.5*(l[k].u[i]+abs(l[1].u[i]));
                    um = 0.5*(l[k].u[i]-abs(l[1].u[i]));
                    up_ant = 0.5*(l[k].u[i-1]+abs(l[k].u[i-1]));
                    um_ant = 0.5*(l[k].u[i-1]-abs(l[k].u[i-1]));

                    np = l[k].y[i] - (dt/dx)*(up*l[k].h[i]+um*l[k].h[i+1]-up_ant*l[k].h[i-1]-um_ant*l[k].h[i]);
                    np_next = l[k].y[i+1] - (dt/dx)*(up*l[k].h[i+1]+um*l[k].h[i+2]-up_ant*l[k].h[i]-um_ant*l[k].h[i+1]);
                    np_ant = l[k].y[i-1] - (dt/dx)*(up*l[k].h[i-1]+um*l[k].h[i]-up_ant*l[k].h[i-2]-um_ant*l[k].h[i-1]);

                    l[k].y[i] = (1-eps)*np+0.5*eps*(np_ant+np_next);
                end
            end

            l[k].h = height(l[k].h, l[k].y, h0)
            
            
        end
    end

end