#import "@preview/polylux:0.3.1"

#let slide-title = state("slide-title", [])
#let slide-author = state("slide-author", [])
#let slide-date = state("slide-date", datetime.today())

#let lr_margin = 40pt
#let colors = (rgb("#f6f6f6"), rgb("#d6e4f0"), rgb("#1e56a0"), rgb("#163172"))
#let full_block(bg: colors.at(0), body) = block(width: 100%, height: 100%, fill: bg)[#body]
#let debug_box(c) = block(width: 100%, height: 100%, fill: colors.at(c))

#let my-theme(
  title: [title],
  author: [author],
  date: datetime.today(),
  aspect-ratio: "4-3",
  body
) = [
  #set document(
    title: title,
    author: author,
    keywords: (""),
    date: date,
  )
  #set page(
    paper: "presentation-" + aspect-ratio,
    margin: 0pt,
  )
  #set text(size: 25pt, font: "Harano Aji Gothic")
  #slide-title.update(title)
  #slide-author.update(author)
  #slide-date.update(date)
  #counter(page).update(0)
  #body
]

#let title-slide(
  title: none,
  author: none,
  upper-content: (title: none) => [
    #set align(center + bottom)
    #text(size: 1.5em)[
      #if (title != none) {title} else {context slide-title.get()}
    ]
    #v(.5em)
  ],
  lower-content: (author: none) => [
    #set align(right + top)
    #v(.5em)
    #text(size: 1.2em)[
      #if (author != none) {author} else {context slide-author.get()}
    ]#linebreak()
    #context slide-date.get().display("[year]年[month]月[day]日")#linebreak()
  ],
  body
) = [
  #polylux.polylux-slide()[
    #grid(
      columns: (lr_margin, 1fr, lr_margin),
      rows: (1fr, 2%, 1fr),
      [],[
        #upper-content(title: title)
      ],[],grid.cell(colspan: 3)[#debug_box(2)],[],[
        #lower-content(author: author)
      ],[]
    )
  ]
  #body
]

#let slide(
  title: [title],
  body
) = [
  #polylux.polylux-slide()[
    #grid(
      rows: (10%, 1%, 1fr, 3%),
      [
        #full_block(bg: colors.at(0))[
          #grid(
            columns: (2em, 1fr, 2em),
            [],[
              #block(height: 100%)[
                #align(horizon)[#text(size: 1.5em)[#title]]
              ]
            ],[]
          )
        ]
      ],
      [#full_block(bg: colors.at(2))[]],
      [#block(width: 100%, height: 100%, inset: 1em, fill: colors.at(0))[#body]],
      [
        #set text(size: 0.5em)
        #grid(
          columns: (25%, 50%, 25%),
          [
            #full_block(bg: colors.at(2))[
              #align(center+horizon)[
                #text(fill: colors.at(0))[#context slide-author.get()]
              ]
            ]
          ],[
              #full_block(bg: colors.at(1))[
              #align(center+horizon)[#context slide-title.get()]
            ]
          ],[
              #full_block(bg: colors.at(2))[
              #align(center+horizon)[
                #text(fill: colors.at(0))[#counter(page).display("1 / 1", both: true)]
              ]
            ]
          ]
        )
      ],
    )
  ]
]
