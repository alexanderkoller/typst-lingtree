#import "../lib.typ": syntree, listtree, tree, render

#set page(width: auto, height: auto, margin: 10pt)

// README bracket examples.
#syntree[
  [S [NP Alice] [VP [V saw] [NP Bob]]]
]
#pagebreak()

#syntree[[NP [Det the] [^Nom little bear]]]
#pagebreak()

// README list example.
#listtree[
  - S
    - NP
      - Alice
    - VP
      - V
        - left
]
#pagebreak()

// README neutral-model example.
#let subject = tree([NP], tree([Alice]))
#let predicate = tree([VP], tree([left]))
#let sentence = tree([S], subject, predicate)
#render(sentence)
#pagebreak()

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
#pagebreak()

// README immediate-child alignment example.
#syntree(parent-align: "children")[
  [Top [Wide [A a] [B b] [C c] [D d] [E e] [F f] [G g]] [Right r]]
]
#pagebreak()

// README subtree alignment example.
#syntree(parent-align: "subtree")[
  [Top [Wide [A a] [B b] [C c] [D d] [E e] [F f] [G g]] [Right r]]
]
#pagebreak()

// Reference examples that add behavior not exercised above.
#listtree[
  - NP
    - Det
      - the
    - ^Nom
      - small cat
]
#render(tree([NP], [the small cat], roof: true))
