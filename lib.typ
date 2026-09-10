#import "src/model.typ" as _model
#import "src/parse.typ" as _parse
#import "src/layout.typ" as _layout

#let _layout-all(roots, ..options) = {
  for root in roots { _layout.layout-tree(root, ..options) }
}

#let tree(
  tag,
  ..children,
  roof: false,
) = _model.node(tag, ..children.pos(), roof: roof)

// Convert a neutral tree value into Typst content.
#let render = _layout.layout-tree

#let syntree(
  terminal: (:),
  nonterminal: (:),
  child-spacing: 1em,
  layer-spacing: 2.3em,
  stroke: 0.75pt,
  parent-align: "subtree",
  it,
) = _layout-all(
  _parse.parse-syntree(it),
  terminal: terminal,
  nonterminal: nonterminal,
  child-spacing: child-spacing,
  layer-spacing: layer-spacing,
  stroke: stroke,
  parent-align: parent-align,
)

#let listtree(
  terminal: (:),
  nonterminal: (:),
  child-spacing: 1em,
  layer-spacing: 2.3em,
  stroke: 0.75pt,
  parent-align: "subtree",
  it,
) = _layout-all(
  _parse.parse-listtree(it),
  terminal: terminal,
  nonterminal: nonterminal,
  child-spacing: child-spacing,
  layer-spacing: layer-spacing,
  stroke: stroke,
  parent-align: parent-align,
)
