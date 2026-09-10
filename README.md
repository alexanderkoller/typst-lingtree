# lingtree

`lingtree` draws linguistics syntax trees. Its `syntree` and `listtree`
front ends are API-compatible with [`syntree` 0.3.1](https://typst.app/universe/package/syntree),
but its programmatic API separates tree construction from rendering.

```typ
#import "@preview/lingtree:0.1.0": syntree

#syntree(parent-align: "children")[
  [S [VeryWideLeftSubtree [N left] [N branch]] [VP right]]
]
```

The rendering functions accept syntree's existing options. They additionally
accept:

- `stroke`: connector stroke (default `0.75pt`);
- `parent-align`: `"subtree"` (the syntree-compatible default) or
  `"children"` (center a parent between the root nodes of its outermost
  immediate children, independent of their subtree widths).

For programmatic construction, `tree` returns neutral data and `render`
converts it to content:

```typ
#import "@preview/lingtree:0.1.0": tree, render

#let value = tree([S],
  tree([NP], tree([Alice])),
  tree([VP], tree([left])),
)

#render(
  value,
  terminal: (fill: blue),
  nonterminal: (style: "italic"),
  parent-align: "children",
)
```

The public API consists of `tree`, `render`, `syntree`, and `listtree`.
