push!(LOAD_PATH, "../src/")

using Documenter
using DocumenterCitations
using DocumenterVitepress
using MetacommunityDynamics

bib = CitationBibliography(joinpath(@__DIR__, "MetacommunityDynamics.bib")) 

makedocs(
    sitename = "MetacommunityDynamics.jl",
    authors = "Michael D. Catchen",
    modules = [MetacommunityDynamics],
    #=format = DocumenterVitepress.MarkdownVitepress(
        repo="https://github.com/gottacatchenall/MetacommunityDynamics.jl",
        devurl="dev",
    ),=#
    format = Documenter.HTML(
        ansicolor=true, 
        collapselevel=1,
        size_threshold = 600_000),
    warnonly = true,
    plugins = [bib], 
)

deploydocs(;
    repo = "github.com/gottacatchenall/MetacommunityDynamics.jl.git",
    push_preview = true,
)

