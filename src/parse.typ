#import "model.typ": node

#let whitespace = ([], [ ], parbreak())
#let is-list-item(item) = type(item) == content and item.func() == std.list.item

// Parse syntree's bracket notation without making any layout decisions.
#let parse-syntree(body) = {
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
      stack.last().children.push(node(
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
          stack.last().children.push(node(rest))
        }
      } else if not token.has("text") and current.head == none and current.children == () {
        stack.last().head = token
      } else {
        stack.last().children.push(node(token))
      }
    }
  }

  assert(stack.len() == 1, message: "extra opening `[`")
  stack.first().children
}

#let parse-list-item(item) = {
  if not is-list-item(item) {
    return node(item)
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

  node(head, ..children.map(parse-list-item), roof: roof)
}

// Parse Typst list notation into one or more neutral roots.
#let parse-listtree(body) = {
  let roots = body.at("children", default: (body,)).filter(x => x not in whitespace)
  roots.map(parse-list-item)
}
