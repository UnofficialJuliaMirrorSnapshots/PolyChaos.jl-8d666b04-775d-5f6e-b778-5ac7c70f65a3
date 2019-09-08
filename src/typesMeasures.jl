export  Measure,
        ProductMeasure,
        LegendreMeasure,
        JacobiMeasure,
        LaguerreMeasure,
        genLaguerreMeasure,
        HermiteMeasure,
        genHermiteMeasure,
        GaussMeasure,
        Beta01Measure,
        GammaMeasure,
        Uniform01Measure,
        LogisticMeasure,
        MeixnerPollaczekMeasure




struct Measure <: AbstractMeasure
    name::String
    w::Function
    dom::Tuple{<:Real,<:Real}
    symmetric::Bool
    pars::Dict
    function Measure(name::String, w::Function, dom::Tuple{<:Real,<:Real}, symm::Bool, d::Dict=Dict())
        !(dom[1] < dom[2]) && throw(DomainError(dom, "invalid domain bounds specified"))
        new(lowercase(name),w, dom, symm, d)
    end
end

struct ProductMeasure <: AbstractMeasure
    w::Function
    measures::Vector{<:AbstractMeasure}
end

# constructor for classic distributions
struct LegendreMeasure <: AbstractCanonicalMeasure
    w::Function
    dom::Tuple{<:Real,<:Real}
    symmetric::Bool
    function LegendreMeasure()
        new(w_legendre,(-1.,1.),true)
    end
end

struct JacobiMeasure <: AbstractCanonicalMeasure
    w::Function
    dom::Tuple{<:Real,<:Real}
    symmetric::Bool
    ashapeParameter::Real
    bshapeParameter::Real

    function JacobiMeasure(shape_a::Real, shape_b::Real)
        any
        shape_a <= -1 && throw(DomainError(shape_a, "shape parameter a must be > -1"))
        shape_b <= -1 && throw(DomainError(shape_b, "shape parameter b must be > -1"))
        new(build_w_jacobi(shape_a,shape_b), (-1,1), isapprox(shape_a, shape_b), shape_a, shape_b)
    end
end

struct LaguerreMeasure <: AbstractCanonicalMeasure
    w::Function
    dom::Tuple{<:Real,<:Real}
    symmetric::Bool

    function LaguerreMeasure()
        new(w_laguerre, (0,Inf), false)
    end
end

struct genLaguerreMeasure <: AbstractCanonicalMeasure
    w::Function
    dom::Tuple{<:Real,<:Real}
    symmetric::Bool
    shapeParameter::Real

    function genLaguerreMeasure(shape::Real)
        shape <= -1 && throw(DomainError(shape, "invalid shape parameter"))
        new(build_w_genlaguerre(shape), (0,Inf), false, shape)
    end
end

struct HermiteMeasure <: AbstractCanonicalMeasure
    w::Function
    dom::Tuple{<:Real,<:Real}
    symmetric::Bool

    function HermiteMeasure()
        new(w_hermite, (-Inf,Inf), true)
    end
end

struct genHermiteMeasure <: AbstractCanonicalMeasure
    w::Function
    dom::Tuple{<:Real,<:Real}
    symmetric::Bool
    muParameter::Real

    function genHermiteMeasure(mu::Real)
        mu <= -0.5 && throw(DomainError(mu, "invalid parameter value (must be > - 0.5)"))
        new(build_w_genhermite(mu), (-Inf,Inf), true, mu)
    end
end

struct MeixnerPollaczekMeasure <: AbstractCanonicalMeasure
    w::Function
    dom::Tuple{<:Real,<:Real}
    symmetric::Bool
    λParameter::Real
    ϕParameter::Real

    function MeixnerPollaczekMeasure(λ::Real, ϕ::Real)
        λ <= 0 && throw(DomainError(λ, "λ has to be positive"))
        !(0 < ϕ < pi) && throw(DomainError(ϕ, "ϕ has to be between 0 and pi"))
        new(build_w_meixner_pollaczek(λ, ϕ), (-Inf,Inf), false, λ, ϕ)
    end
end

struct GaussMeasure <: AbstractCanonicalMeasure
    w::Function
    dom::Tuple{<:Real,<:Real}
    symmetric::Bool

    function GaussMeasure()
        new(w_gaussian, (-Inf,Inf), true)
    end
end

struct Uniform01Measure <: AbstractCanonicalMeasure
    w::Function
    dom::Tuple{<:Real,<:Real}
    symmetric::Bool

    function Uniform01Measure()
        new(w_uniform01, (0,1), true)
    end
end

struct Beta01Measure <: AbstractCanonicalMeasure
    w::Function
    dom::Tuple{<:Real,<:Real}
    symmetric::Bool
    ashapeParameter::Real
    bshapeParameter::Real

    function Beta01Measure(a::Real, b::Real)
        a <= 0 && throw(DomainError(a, "shape parameter a must be positive"))
        b <= 0 && throw(DomainError(b, "shape parameter b must be positive"))
        new(build_w_beta(a,b), (0,1), isapprox(a,b), a, b)
    end
end

struct GammaMeasure <: AbstractCanonicalMeasure
    w::Function
    dom::Tuple{<:Real,<:Real}
    symmetric::Bool
    shapeParameter::Real
    rateParameter::Real

    function GammaMeasure(shape::Real, rate::Real)
        shape <= 0 && throw(DomainError(shape, "shape parameter needs to be positive"))
        rate != 1 && throw(DomainError(rate, "rate must be unity (currently!)"))
        new(build_w_gamma(shape), (0,Inf), false, shape, rate)
    end
end

struct LogisticMeasure <: AbstractCanonicalMeasure
    w::Function
    dom::Tuple{<:Real,<:Real}
    symmetric::Bool

    function LogisticMeasure()
        new(w_logistic, (-Inf,Inf), true)
    end
end
