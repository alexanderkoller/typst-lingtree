#import "src/model.typ" as _model
#import "src/parse.typ" as _parse
#import "src/layout.typ" as _layout

#let _layout-all(roots, ..options) = {
  for root in roots { _layout.layout-tree(root, ..options) }
}

/// Constructs a presentation-neutral tree node.
///
/// Children may be other tree values or arbitrary content. Set `roof` to draw
/// a roof instead of one connector per child when the value is rendered.
#let tree(
  tag,
  ..children,
  roof: false,
) = _model.node(tag, ..children.pos(), roof: roof)

/// Draws a presentation-neutral tree value as Typst content.
///
/// `terminal` and `nonterminal` are dictionaries of text parameters.
/// `parent-align` accepts `"subtree"` or `"children"`.
#let render = _layout.layout-tree

/// Parses syntree-compatible bracket notation and draws the resulting trees.
///
/// Prefix a node label with `^` to draw a roof over its children.
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

/// Parses nested list notation and draws the resulting trees.
///
/// Prefix a list-item label with `^` to draw a roof over its children.
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
