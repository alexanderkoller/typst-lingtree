# lingtree

`lingtree` draws ordered syntax trees in Typst. It supports the bracket and
list notations used by [`syntree` 0.3.1](https://typst.app/universe/package/syntree),
and also provides a presentation-neutral tree value for programs that need to
construct or transform a tree before drawing it.

## Quick start

Import `syntree` and write a tree in bracket notation:

```typ
#import "@preview/lingtree:0.1.0": syntree

#syntree[
  [S [NP Alice] [VP [V saw] [NP Bob]]]
]
```

Every pair of brackets creates one node. The first item is its label and the
remaining items are its children. A caret before a label replaces the branches
to that node's children with a roof:

```typ
#syntree[[NP [Det the] [^Nom little bear]]]
```

## Choose an input form

Use `syntree` for compact trees written inline. Use `listtree` when indentation
makes a larger tree easier to edit:

```typ
#import "@preview/lingtree:0.1.0": listtree

#listtree[
  - S
    - NP
      - Alice
    - VP
      - V
        - left
]
```

Both functions draw immediately. If your Typst code generates, inspects, or
rewrites trees, use `tree` to build neutral data and call `render` only after
the structure is complete:

```typ
#import "@preview/lingtree:0.1.0": tree, render

#let subject = tree([NP], tree([Alice]))
#let predicate = tree([VP], tree([left]))
#let sentence = tree([S], subject, predicate)

#render(sentence)
```

`tree` does not produce visible content. It returns a dictionary containing a
label, an ordered sequence of children, and the roof setting. This separation
lets a program transform the tree without depending on its eventual spacing or
style.

## Style and space a tree

The three drawing functions share the same layout options:

```typ
#syntree(
  terminal: (fill: blue),
  nonterminal: (style: "italic"),
  child-spacing: 1.5em,
  layer-spacing: 2em,
  stroke: 0.6pt + gray,
)[
  [S [NP Alice] [VP left]]
]
```

`terminal` styles leaf labels and `nonterminal` styles labels with children.
Each is a dictionary of parameters accepted by Typst's `text` function.
`child-spacing` controls the horizontal gap between sibling subtrees;
`layer-spacing` controls the vertical gap between a label and the next layer.

By default, a parent is centered over the complete bounding box of its child
subtrees. This matches `syntree`. For asymmetric trees, set
`parent-align: "children"` to center the parent between the root positions of
its outermost immediate children instead:

```typ
#syntree(parent-align: "children")[
  [Top [Wide [A a] [B b] [C c]] [Right r]]
]
```

## Documentation

- [API reference](docs/reference.md) lists every public function, option,
  default, return value, and relevant error.
- [Feature tour](examples/demo.typ) contains a complete document covering rich
  labels, roofs, programmatic construction, movement arrows, and alignment.
- [Rendered feature tour](output/pdf/lingtree-demo.pdf) shows its output.

The public API consists of `syntree`, `listtree`, `tree`, and `render`.
Implementation helpers are not exported.
