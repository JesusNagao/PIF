using Plots;
using Base.Threads;


mutable struct Layer
    y::Array{Float64}
    u::Array{Float64}
    h::Array{Float64}
end


function gaussian(x::Array{Float64}, y::Array{Float64}, h::Array{Float64}, mu::Float64, s::Float64, n::Int64)

    for i in range(1,stop=length(x))
            
        y[i] = exp(-((x[i]-mu)^2)/s);
        h[i] = exp(-((x[i]-mu)^2)/s);

    end

end

function init_Layers(l::Array{Layer}, y::Array{Float64}, u::Array{Float64}, h::Array{Float64})

    for i in range(1, stop=length(l))
        l[i] = Layer((i-1)*y .+ 10.0*(i-1), u, h .+ 10.0*(i-2))
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
        
        p1 = plot()
        for k in range(1, stop = n)
            scatter!(x,l[k].y, title="Position", legend=false)
            ylims!(-10.0, 100.0)
            xlims!(0.0, 1000.0)

            @threads for i in range(3, stop=length(y)-2)
                
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

            l[k].h = height(l[k].h, l[k].y, h0)
            
            
        end
    end

end

function animate_pared(x::Array{Float64}, l::Array{Layer}, it::Int64, g::Float64, dx::Float64, dt::Float64, eps::Float64, h0::Float64, n::Int64)

    @gif for j in range(1, stop=it)
        p1 = plot()
        for k in range(1, stop = n)
            scatter!(x,l[k].y, title="Position", legend=false)
            ylims!(-10.0, 100.0)
            xlims!(0.0, 1000.0)

            @threads for i in range(3, stop=length(y)-2)
                if i > 2*length(x)/3
                    l[k].u[i] = 0.0;
                    l[k].y[i] = 10.0*(k-1);


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


function animate_playa(x::Array{Float64}, l::Array{Layer}, it::Int64, g::Float64, dx::Float64, dt::Float64, eps::Float64, h0::Float64, n::Int64)

    @gif for j in range(1, stop=it)
        p1 = plot()
        for k in range(1, stop = n)
            scatter!(x,l[k].y, title="Position", legend=false)
            ylims!(-10.0, 100.0)
            xlims!(0.0, 1000.0)

            @threads for i in range(3, stop=length(y)-2)
                if k<n-2
                    if i < (2*length(x)/3 + ((k-1)*length(x))/30)
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



function animate_playa2(x::Array{Float64}, l::Array{Layer}, it::Int64, g::Float64, dx::Float64, dt::Float64, eps::Float64, h0::Float64, n::Int64)

    @gif for j in range(1, stop=it)
        p1 = plot()
        for k in range(1, stop = n)
            scatter!(x,l[k].y, title="Position", legend=false)
            ylims!(-10.0, 100.0)
            xlims!(0.0, 1000.0)

            @threads for i in range(3, stop=length(y)-2)
                if k<n
                    if i < (2*length(x)/3 + ((k-1)*length(x))/60)
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

            l[k].u[length(x)-2] = l[k].u[length(x)-3]
            l[k].u[length(x)-1] = l[k].u[length(x)-2]
            l[k].u[length(x)] = l[k].u[length(x)-1]

            l[k].h = height(l[k].h, l[k].y, h0)
            
            
        end


    end


end
