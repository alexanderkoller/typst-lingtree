#import "../lib.typ": tree, render, syntree, listtree
#import "../lib.typ" as lingtree

#set page(width: auto, height: auto, margin: 5pt)

// Keep implementation details out of the package's public surface.
#assert("tree" in lingtree)
#assert("render" in lingtree)
#assert("syntree" in lingtree)
#assert("listtree" in lingtree)
#assert("node" not in lingtree)
#assert("layout-tree" not in lingtree)
#assert("parse-syntree" not in lingtree)
#assert("parse-listtree" not in lingtree)

// The model can be built directly and passed to the only layout engine.
#let data = tree([S], tree([NP], tree([Ada])), tree([VP], tree([left])))
#assert(type(data) == dictionary)
#let rendered = render(
  data,
  terminal: (fill: blue),
  nonterminal: (style: "italic"),
)
#assert(type(rendered) == content)
#rendered

// Shorthand front ends continue to render content directly.
#syntree(nonterminal: (fill: purple))[[NP [N composition]]]
#listtree(terminal: (fill: green))[
  - VP
    - works
]
