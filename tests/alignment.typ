#import "../lib.typ": syntree

#set page(width: auto, height: auto, margin: 10pt)

#table(
  columns: 2,
  column-gutter: 30pt,
  align: center,
  [subtree (compatible mode)], [immediate child nodes (default)],
  syntree(parent-align: "subtree")[[Top [L [A a] [B b] [C c]] [R r]]],
  syntree(parent-align: "children")[[Top [L [A a] [B b] [C c]] [R r]]],
)
