#import "../lib.typ": tree, render, syntree, listtree
#import "@preview/larrow:1.1.0": label-arrow

#set document(title: "lingtree feature tour", author: "Alexander Koller", date: none)
#set page(paper: "a4", margin: (x: 22mm, y: 15mm), numbering: "1")
#set text(font: "Libertinus Serif", size: 10.5pt)
#set heading(numbering: "1.")
#set par(justify: true, leading: 0.72em)

#let example(title, body) = block(
  width: 100%,
  inset: 10pt,
  radius: 4pt,
  stroke: 0.5pt + luma(185),
  fill: luma(248),
  breakable: false,
)[
  #text(weight: "semibold", title)
  #v(8pt)
  #align(center, body)
]

#align(center)[
  #text(20pt, weight: "bold")[lingtree]
  #linebreak()
  #text(12pt, fill: luma(70))[A syntax-tree package with a neutral tree model]
]

#v(8pt)

This document mirrors the feature tour of `syntree` and demonstrates
`lingtree`'s default `parent-align: "children"` layout. The optional
`parent-align: "subtree"` mode remains compatible with syntree.

= Bracket notation and styling

Terminal and nonterminal labels can be styled independently. Horizontal and
vertical spacing use the same options as syntree.

#example([Bracket syntax], syntree(
  nonterminal: (style: "italic"),
  terminal: (fill: blue),
  child-spacing: 3em,
  layer-spacing: 2em,
)[
  [S [NP This] [VP [V is] [^NP a wug]]]
])

= Formulas and rich content

Node labels are arbitrary Typst content, including equations, subscripts, and
other inline markup.

#example([Mathematical labels], syntree(
  nonterminal: (style: "italic"),
)[
  [CP [DP$zws_i$ this] [C$'$ [C $diameter$] [TP $t_i$ left]]]
])

= Direct construction

The `tree` function supports programmatic construction and non-textual child
content.

#let swatch(color) = box(fill: color, width: 1.2em, height: 1.2em)

#example([Direct `tree` calls], render(tree(
  "colors",
  tree("warm", swatch(red), swatch(orange)),
  tree("cool", swatch(blue), swatch(teal)),
)))

#pagebreak(weak: true)
= List notation

Indented Typst lists provide a convenient notation for larger trees. A leading
caret creates a roof over a phrase.

#example([List syntax], listtree(
  nonterminal: (style: "italic"),
  terminal: (fill: blue),
)[
  - S
    - NP
      - Det
        - the
      - Nom
        - Adj
          - little
        - N
          - bear
    - VP
      - V
        - saw
      - ^NP
        - the trout
])

= Construction and rendering

`tree` only constructs neutral data. This keeps programmatic trees easy to
inspect and transform; an explicit `render` call turns the finished value into
content. The `syntree` and `listtree` shorthand functions still render
directly.

#let composition = tree([S],
  tree([NP], tree([Det], [the]), tree([N], [bear])),
  tree([VP], tree([V], [saw]), tree([NP], [the trout])),
)

#example([Explicit rendering], render(
  composition,
  nonterminal: (style: "italic"),
  terminal: (fill: rgb("#8b2fb5")),
))

#pagebreak(weak: true)
= Movement and external annotations

Labels inside nodes remain queryable, so external packages such as `larrow`
can annotate relationships and movement.

#example([Movement arrow], block(width: 100%, height: 170pt)[
  #align(center, listtree[
    - TP
      - ^NP
        - les feuilles
      - T'
        - T
          - tombaient <move-end>
        - VP#sub[main]
          - V'
            - ^AdvP
              - toujours
            - V'
              - #strike[V]
                - #strike[tombaient] <move-start>
  ])
  #label-arrow(
    <move-start>,
    <move-end>,
    bend: -100,
    from-offset: (-5pt, -5pt),
    to-offset: (20pt, -15pt),
  )
])

= Parent alignment

The default mode centers a parent between the root nodes of its outermost
immediate children, regardless of asymmetric descendant width. The compatible
mode instead centers it over the complete bounding box of its children's
subtrees.

#table(
  columns: (1fr, 1fr),
  column-gutter: 12pt,
  align: center,
  stroke: none,
  inset: 6pt,
  [#text(weight: "semibold")[Over the subtree (compatible)]],
  [#text(weight: "semibold")[Over child nodes (default)]],
  example([`parent-align: "subtree"`], syntree(
    parent-align: "subtree",
    child-spacing: 1.2em,
  )[
    [Top [Left [A a] [B b] [C c]] [Right r]]
  ]),
  example([`parent-align: "children"`], syntree(
    parent-align: "children",
    child-spacing: 1.2em,
  )[
    [Top [Left [A a] [B b] [C c]] [Right r]]
  ]),
)

= Neutral tree API

Custom parsers and builders can produce presentation-neutral values with
`tree`. Only `render` needs to know about visual styling and geometry.

#let data = tree([S],
  tree([NP], tree([Ada])),
  tree([VP], tree([left])),
)

#example([Direct neutral layout], render(
  data,
  nonterminal: (style: "italic"),
  terminal: (fill: rgb("#156f5b")),
))
