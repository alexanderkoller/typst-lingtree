/// [max-deviations: 6]
///
/// The neutral layout model changes six isolated antialiasing pixels while
/// preserving Syntree's dimensions and geometry.
#import "../../lib.typ": syntree
#set document(date: none)
#set page(width: auto, height: auto, margin: 0.5cm, fill: white)

#syntree(parent-align: "subtree")[
  [S
    [NP This]
    [VP
      [V is]
      [^NP
        a
        [NP gross]
        wug]]]
]
