#import "../lib.typ": syntree, listtree, tree, render

#set page(width: auto, height: auto, margin: 10pt)

// README bracket examples.
#syntree[
  [S [NP Alice] [VP [V saw] [NP Bob]]]
]
#syntree[[NP [Det the] [^Nom little bear]]]

// README list example.
#listtree[
  - S
    - NP
      - Alice
    - VP
      - V
        - left
]

// README neutral-model example.
#let subject = tree([NP], tree([Alice]))
#let predicate = tree([VP], tree([left]))
#let sentence = tree([S], subject, predicate)
#render(sentence)

// README styling example.
#syntree(
  terminal: (fill: blue),
  nonterminal: (style: "italic"),
  child-spacing: 1.5em,
  layer-spacing: 2em,
  stroke: 0.6pt + gray,
)[
  [S [NP Alice] [VP left]]
]

// Reference examples that add behavior not exercised above.
#listtree[
  - NP
    - Det
      - the
    - ^Nom
      - small cat
]
#render(tree([NP], [the small cat], roof: true))
