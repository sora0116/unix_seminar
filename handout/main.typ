#set page(numbering: "1")
#set heading(numbering: "1.1")
#set text(size: 12pt, font: ("New Computer Modern", "Harano Aji Mincho"))

#outline(title: "目次")

#include "section1.typ"
#include "section2.typ"
#include "section3.typ"
#include "section4.typ"
#include "section5.typ"
#include "section6.typ"
#include "section7.typ"
#include "section8.typ"
= ソースファイルの検証

== リスト
`
	list <linenum>
`
現在のソースコード行を中心に`linenum`行のソースコードを表示します。
`
	list <function>
`
関数の開始点を中心にコードを表示します。
`
	list [+]
`
最後に出力された行の続きを表示する。

== 位置指定
== 編集
== 検索
== ソースパス
== 機械語
== ソース読み込み無効化
