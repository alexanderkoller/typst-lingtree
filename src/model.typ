#let node(label, ..children, roof: false) = (
  label: label,
  children: children.pos(),
  roof: roof,
)
