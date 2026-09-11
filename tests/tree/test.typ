#import "../../lib.typ": tree, render
#set document(date: none)
#set page(width: auto, height: auto, margin: 0.5cm, fill: white)

#let bx(col) = box(fill: col, width: 1em, height: 1em)
#render(
  tree("colors",
    tree("warm", bx(red), bx(orange)),
    tree("cool", bx(blue), bx(teal))),
  parent-align: "subtree",
)
