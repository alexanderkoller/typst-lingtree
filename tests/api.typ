#import "../lib.typ": tree, render, syntree, listtree
#import "../lib.typ" as lingtree
#import "../src/parse.typ": parse-syntree, parse-listtree

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

// The parsers return neutral data, never rendered content.
#let bracket-roots = parse-syntree[[S [NP Ada] [VP left]]]
#assert(bracket-roots.len() == 1)
#assert(bracket-roots.first().label == "S")
#assert(bracket-roots.first().children.len() == 2)

#let list-roots = parse-listtree[
  - S
    - NP
      - Ada
]
#assert(list-roots.len() == 1)

// The model can be built directly and passed to the only layout engine.
#let data = tree([S], tree([NP], tree([Ada])), tree([VP], tree([left])))
#assert(type(data) == dictionary)
#let rendered = render(
  data,
  terminal: (fill: blue),
  nonterminal: (style: "italic"),
  parent-align: "children",
)
#assert(type(rendered) == content)
#rendered

// Shorthand front ends continue to render content directly.
#syntree(nonterminal: (fill: purple))[[NP [N composition]]]
#listtree(terminal: (fill: green))[
  - VP
    - works
]
