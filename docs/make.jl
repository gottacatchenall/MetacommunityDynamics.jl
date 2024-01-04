push!(LOAD_PATH, "../src/")

using Documenter
using DocumenterCitations
using DocumenterMarkdown
using MetacommunityDynamics

bibliography = CitationBibliography(joinpath(@__DIR__, "EcoDynamics.bib"))

makedocs(
    bibliography;
    sitename = "EcoDynamics",
    authors = "Michael D. Catchen",
    modules = [MetacommunityDynamics],
    format = Markdown(),
)

deploydocs(;
    deps = Deps.pip("mkdocs", "pygments", "python-markdown-math", "mkdocs-material"),
    repo = "github.com/gottacatchenall/MetacommunityDynamics.jl.git",
    devbranch = "main",
    make = () -> run(`mkdocs build`),
    target = "site",
    push_preview = true,
)
