#import "../lib.typ": *

#set page(width: auto, height: auto, margin: 10pt)
#set text(size: 10pt)

#syntree(
  nonterminal: (style: "italic"),
  terminal: (fill: blue),
  child-spacing: 3em,
  layer-spacing: 2em,
)[
  [S [NP This] [VP [V is] [^NP a wug]]]
]

#listtree(
  nonterminal: (style: "italic"),
  terminal: (fill: red),
)[
  - S
    - NP
      - this
    - VP
      - V
        - works
]

#render(tree("colors",
  tree("warm", box(fill: red, width: 1em, height: 1em), box(fill: orange, width: 1em, height: 1em)),
  tree("cool", box(fill: blue, width: 1em, height: 1em), box(fill: teal, width: 1em, height: 1em)),
), parent-align: "children")
