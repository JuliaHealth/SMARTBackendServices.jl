using SMARTBackendServices
using Documenter

makedocs(;
    modules=[SMARTBackendServices],
    authors="Dilum Aluthge and contributors",
    repo="https://github.com/JuliaHealth/SMARTBackendServices.jl/blob/{commit}{path}#{line}",
    sitename="SMARTBackendServices.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JuliaHealth.github.io/SMARTBackendServices.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "API" => "api.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaHealth/SMARTBackendServices.jl",
)
