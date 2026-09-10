# lingtree API reference

Import only the interface you need:

```typ
#import "@preview/lingtree:0.1.0": syntree, listtree, tree, render
```

## Drawing functions

### `syntree`

```typ
syntree(
  terminal: (:),
  nonterminal: (:),
  child-spacing: 1em,
  layer-spacing: 2.3em,
  stroke: 0.75pt,
  parent-align: "subtree",
  it,
) -> content
```

Parses bracket notation and draws every top-level tree in `it`.

```typ
#syntree[[S [NP Alice] [VP [V likes] [NP syntax]]]]
```

Within each bracketed node, the first item is the label and subsequent items
are children. Prefix the label with `^` to draw a roof from the label to the
outer edges of its children instead of drawing one connector per child:

```typ
#syntree[[NP [Det the] [^Nom small cat]]]
```

Unbalanced brackets produce an assertion error. A body that does not contain a
tree produces `must be provided a tree`.

### `listtree`

```typ
listtree(
  terminal: (:),
  nonterminal: (:),
  child-spacing: 1em,
  layer-spacing: 2.3em,
  stroke: 0.75pt,
  parent-align: "subtree",
  it,
) -> content
```

Parses nested Typst list items and draws every top-level item as a tree. Each
item's body is its label and its nested list items are its children.

```typ
#listtree[
  - S
    - NP
      - Alice
    - VP
      - left
]
```

As in bracket notation, prefix a label with `^` to draw a roof:

```typ
#listtree[
  - NP
    - Det
      - the
    - ^Nom
      - small cat
]
```

### `render`

```typ
render(
  tree,
  terminal: (:),
  nonterminal: (:),
  child-spacing: 1em,
  layer-spacing: 2.3em,
  stroke: 0.75pt,
  parent-align: "subtree",
) -> content
```

Draws one neutral tree produced by `tree`. Use this lower-level interface when
the tree structure is computed independently of its presentation.

All three drawing functions accept these options:

| Option | Default | Meaning |
| --- | --- | --- |
| `terminal` | `(:)` | Parameters passed to `text` for leaf labels. |
| `nonterminal` | `(:)` | Parameters passed to `text` for labels that have children. |
| `child-spacing` | `1em` | Horizontal gap between adjacent child subtrees. |
| `layer-spacing` | `2.3em` | Vertical gap from a parent label to its children. |
| `stroke` | `0.75pt` | Stroke used for branch lines and roof outlines. |
| `parent-align` | `"subtree"` | Rule used to choose a parent's horizontal position. |

`parent-align` accepts exactly two values:

- `"subtree"` centers the parent over the combined width of its child
  subtrees. This is the default and matches `syntree` 0.3.1.
- `"children"` centers the parent between the root positions of its first and
  last immediate children. Descendant widths therefore do not pull the parent
  away from its immediate children.

Any other value produces an assertion error identifying the two accepted
values.

## Constructing neutral trees

### `tree`

```typ
tree(label, ..children, roof: false) -> dictionary
```

Constructs a presentation-neutral node. `label` is Typst content. Each child
may be another value returned by `tree` or arbitrary content; `render` treats
arbitrary content as a leaf node. Children retain their input order.

```typ
#let value = tree(
  [S],
  tree([NP], [Alice]),
  tree([VP], [left]),
)
```

The returned dictionary has this shape:

```typ
(
  label: content,
  children: array,
  roof: bool,
)
```

Set `roof: true` to replace the node's individual child connectors with a roof:

```typ
#render(tree([NP], [the small cat], roof: true))
```

The `roof` setting has no visible effect on a leaf because a leaf has no child
connectors.

## Labels and geometry

Labels may contain text, equations, boxes, styled content, and labels used by
other packages. `lingtree` measures each rendered label and subtree, then lays
out siblings from left to right. It does not reorder, balance, or otherwise
rewrite the input tree.

Connectors are straight lines. The public API does not currently provide edge
labels, curved connectors, per-edge styling, or per-node spacing overrides.

