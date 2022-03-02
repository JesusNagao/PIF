using Plots

l = 80

function superposition(A0::Int ,lambda1::Int, lambda2::Int, T1::Int, T2::Int, t::Float64, x::StepRangeLen{Float64, Base.TwicePrecision{Float64}, Base.TwicePrecision{Float64}})

    A = A0*(sin.(2*pi*((x/lambda1).-(t/T1)))+sin.(2*pi*((x/lambda2).-(t/T2))))
    return A

end

n = 400

@gif for t in range(0, stop=50*2*pi, length=n)
    l1=100
    l2=50
    T1=60
    T2=-30
    A0 = 1

    x = range(-20, 20, length = l)
    y = range(-20, 20, length = l)
    f = superposition(A0, l1, l2, T1, T2, t, x)
    
    p = plot(x, f, lims=2)
    ylims!((-2,2))
end