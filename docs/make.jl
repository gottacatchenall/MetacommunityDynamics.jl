using Documenter, MetacommunityDynamics
using DynamicGrids 
using DynamicGrids: CellRule, SetCellRule, applyrule,Rule,Ruleset;
    
makedocs(
    sitename="MetacommunityDynamics.jl",
    authors="Michael Catchen",
    modules=[MetacommunityDynamics],
    pages=[
        "Index" => "index.md",
        "Library" => [
            "Internal" => "lib/internal.md",
            "Public API" => "lib/public.md",
        ],
        ]
)

deploydocs(
    deps=Deps.pip("pygments", "python-markdown-math"),
    repo="github.com/gottacatchenall/MetacommunityDynamics.jl.git",
    devbranch="main",
    push_preview=true
)
