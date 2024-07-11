#set page(numbering: "1")
#set heading(numbering: "1.1")
#set text(size: 12pt, font: ("New Computer Modern", "Harano Aji Mincho"))

#[
  #align(center + horizon)[
    #text(2em)[第10回Unixゼミ\ Cプログラム(デバッグ編)]

    #text(1.3em)[高木 空]

    #datetime(year: 2024, month: 7, day: 1).display("[year]年[month]月[day]日")
  ]
  #pagebreak()
]

#outline(title: "目次", indent: 1em)
#pagebreak()

#include "./gdb/main.typ"
#include "./lldb/main.typ"
#include "./perf/main.typ"
