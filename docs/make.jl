using Documenter, MetacommunityDynamics

makedocs(
    sitename="MetacommunityDynamics.jl",
    authors="Michael Catchen",
    modules=[MetacommunityDynamics],
    pages=[
        "Index" => "index.md",
        ]
)

deploydocs(
    deps=Deps.pip("pygments", "python-markdown-math"),
    repo="github.com/gottacatchenall/MetacommunityDynamics.jl.git",
    devbranch="main",
    push_preview=true
)
