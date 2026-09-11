/// Constructs a presentation-neutral tree node.
///
/// Children may be other tree values or arbitrary content. Set `roof` to draw
/// a roof instead of one connector per child when the value is rendered.
#let tree(
  tag,
  ..children,
  roof: false,
) = (
  label: tag,
  children: children.pos(),
  roof: roof,
)

/// Draws a presentation-neutral tree value as Typst content.
///
/// `terminal` and `nonterminal` are dictionaries of text parameters.
/// `parent-align` accepts `"subtree"` or `"children"`.
#let render(
  value,
  terminal: (:),
  nonterminal: (:),
  child-spacing: 1em,
  layer-spacing: 2.3em,
  stroke: 0.75pt,
  parent-align: "children",
) = {
  assert(
    parent-align in ("subtree", "children"),
    message: "parent-align must be `subtree` or `children`",
  )
  let options = (
    terminal: terminal,
    nonterminal: nonterminal,
    child-spacing: child-spacing,
    layer-spacing: layer-spacing,
    stroke: stroke,
    parent-align: parent-align,
  )

  let normalize(value) = {
    if type(value) == dictionary { value } else { tree(value) }
  }

  // Returns content plus the subtree geometry needed by its parent.
  let render-node(current) = {
    let label = text(current.label)
    label = if current.children.len() == 0 {
      [#set text(..options.terminal); #label]
    } else {
      [#set text(..options.nonterminal); #label]
    }

    let label-size = measure(label)
    let child-spacing = measure(box(width: options.child-spacing)).width
    let layer-spacing = measure(box(height: options.layer-spacing)).height
    let children = current.children.map(value => render-node(normalize(value)))

    if children.len() == 0 {
      return (
        body: block(
          width: label-size.width,
          height: label-size.height,
          above: 0pt,
          below: 0pt,
          label,
        ),
        width: label-size.width,
        height: label-size.height,
        root-x: label-size.width / 2,
      )
    }

    let child-xs = ()
    let x = 0pt
    for child in children {
      child-xs.push(x)
      x += child.width + child-spacing
    }
    let children-width = x - child-spacing
    let child-roots = children.enumerate().map(pair => {
      let (i, child) = pair
      child-xs.at(i) + child.root-x
    })
    let parent-x = if options.parent-align == "children" {
      (child-roots.first() + child-roots.last()) / 2
    } else {
      children-width / 2
    }

    let left-edge = calc.min(0pt, parent-x - label-size.width / 2)
    let right-edge = calc.max(children-width, parent-x + label-size.width / 2)
    let shift = -left-edge
    let width = right-edge - left-edge
    let children-y = label-size.height + layer-spacing
    let height = children-y + calc.max(..children.map(child => child.height))

    let body = block(width: width, height: height, above: 0pt, below: 0pt)[
      #if current.roof {
        // Syntree emits the same roof once per child. Preserve that behavior:
        // overlapping strokes rasterize slightly differently from one polygon.
        for _ in children {
          place(top + left, polygon(
            stroke: options.stroke,
            (shift + parent-x, label-size.height + 0.3em),
            (shift + children-width, children-y - 0.3em),
            (shift, children-y - 0.3em),
          ))
        }
      } else {
        for child-x in child-roots {
          place(top + left, line(
            stroke: options.stroke,
            start: (shift + parent-x, label-size.height + 0.3em),
            end: (shift + child-x, children-y - 0.3em),
          ))
        }
      }
      #place(top + left, dx: shift + parent-x - label-size.width / 2, label)
      #for pair in children.enumerate() {
        let (i, child) = pair
        place(top + left, dx: shift + child-xs.at(i), dy: children-y, child.body)
      }
    ]

    (body: body, width: width, height: height, root-x: shift + parent-x)
  }

  context block(render-node(value).body)
}

/// Parses syntree-compatible bracket notation and draws the resulting trees.
///
/// Prefix a node label with `^` to draw a roof over its children.
#let syntree(
  terminal: (:),
  nonterminal: (:),
  child-spacing: 1em,
  layer-spacing: 2.3em,
  stroke: 0.75pt,
  parent-align: "children",
  it,
) = {
  let whitespace = ([], [ ], parbreak())
  let parse(body) = {
    if body in whitespace {
      return ()
    }
    assert(body.has("children"), message: "must be provided a tree")

    let stack = ((children: ()),)
    for token in body.children.filter(x => x not in whitespace) {
      if token.at("text", default: false) == "[" {
        stack.push((head: none, children: (), roof: false))
      } else if token.at("text", default: false) == "]" {
        assert(stack.len() > 1, message: "extra closing `]`")
        let current = stack.pop()
        stack.last().children.push(tree(
          current.head,
          ..current.children,
          roof: current.roof,
        ))
      } else {
        let current = stack.last()
        if token.has("text") and current.head == none and current.children == () and not current.roof {
          let parts = token.text.split(" ")
          let tag = parts.first()
          let rest = parts.slice(1).join(" ")
          if tag.starts-with("^") {
            stack.last().roof = true
            tag = if tag == "^" { none } else { tag.slice(1) }
          }
          stack.last().head = tag
          if rest != none {
            stack.last().children.push(tree(rest))
          }
        } else if not token.has("text") and current.head == none and current.children == () {
          stack.last().head = token
        } else {
          stack.last().children.push(tree(token))
        }
      }
    }

    assert(stack.len() == 1, message: "extra opening `[`")
    stack.first().children
  }

  for root in parse(it) {
    render(
      root,
      terminal: terminal,
      nonterminal: nonterminal,
      child-spacing: child-spacing,
      layer-spacing: layer-spacing,
      stroke: stroke,
      parent-align: parent-align,
    )
  }
}

/// Parses nested list notation and draws the resulting trees.
///
/// Prefix a list-item label with `^` to draw a roof over its children.
#let listtree(
  terminal: (:),
  nonterminal: (:),
  child-spacing: 1em,
  layer-spacing: 2.3em,
  stroke: 0.75pt,
  parent-align: "children",
  it,
) = {
  let whitespace = ([], [ ], parbreak())
  let is-list-item(item) = type(item) == content and item.func() == std.list.item
  let parse-item(item) = {
    if not is-list-item(item) {
      return tree(item)
    }

    let head = item.body
    let children = ()
    if item.body.has("children") and item.body.children.len() > 1 {
      let parts = item.body.children
      let split = parts.position(is-list-item)
      if split != none {
        head = parts.slice(0, split).join()
        children = parts.slice(split).filter(x => x not in whitespace)
      }
    }

    let roof = false
    if head.has("text") and head.text.starts-with("^") {
      roof = true
      head = head.text.slice(1)
    } else if head.has("children") and head.children.len() > 0 {
      let first = head.children.first()
      if first.has("text") and first.text.starts-with("^") {
        roof = true
        head = first.text.slice(1) + head.children.slice(1).join()
      }
    }

    tree(head, ..children.map(parse-item), roof: roof)
  }

  let roots = it.at("children", default: (it,)).filter(x => x not in whitespace)
  for root in roots.map(parse-item) {
    render(
      root,
      terminal: terminal,
      nonterminal: nonterminal,
      child-spacing: child-spacing,
      layer-spacing: layer-spacing,
      stroke: stroke,
      parent-align: parent-align,
    )
  }
}
