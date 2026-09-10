#import "model.typ": node

#let normalize(value) = {
  if type(value) == dictionary {
    value
  } else {
    node(value)
  }
}

// Returns content plus the subtree geometry needed by its parent.
#let render-node(tree, options) = {
  let label = text(tree.label)
  label = if tree.children.len() == 0 {
    [#set text(..options.terminal); #label]
  } else {
    [#set text(..options.nonterminal); #label]
  }

  let label-size = measure(label)
  let child-spacing = measure(box(width: options.child-spacing)).width
  let layer-spacing = measure(box(height: options.layer-spacing)).height
  let children = tree.children.map(value => {
    let child = normalize(value)
    render-node(child, options)
  })

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
    #if tree.roof {
      place(top + left, polygon(
        stroke: options.stroke,
        (shift + parent-x, label-size.height + 0.3em),
        (shift + children-width, children-y - 0.3em),
        (shift, children-y - 0.3em),
      ))
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

#let layout-tree(
  tree,
  terminal: (:),
  nonterminal: (:),
  child-spacing: 1em,
  layer-spacing: 2.3em,
  stroke: 0.75pt,
  parent-align: "subtree",
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
  context block(render-node(tree, options).body)
}
